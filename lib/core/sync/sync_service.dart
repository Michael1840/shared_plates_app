import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/db/mappers.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';

class SyncReport extends Equatable {
  const new({
    this.pushed = 0,
    this.failed = 0,
    this.blocked = false,
    this.pulled = false,
  });

  final int pushed;
  final int failed;
  final bool blocked;
  final bool pulled;

  @override
  List<Object?> get props => [pushed, failed, blocked, pulled];
}

class SyncService {
  new({
    required this._db,
    required this._outbox,
    required this._remote,
    this._online,
    this.pageSize = 500,
    this.maxPages = 20,
    this.maxPushBatches = 10,
    this.chunkSize = 100,
    this._debounce = const Duration(milliseconds: 800),
    this._interval = const Duration(minutes: 5),
  });

  final AppDatabase _db;
  final OutboxStore _outbox;
  final RemoteStore _remote;
  final Stream<bool>? _online;
  final Duration _debounce;
  final Duration _interval;
  final int pageSize;
  final int maxPages;
  final int maxPushBatches;
  final int chunkSize;

  Future<SyncReport>? _running;
  StreamSubscription<bool>? _onlineSub;
  Timer? _debounceTimer;
  Timer? _periodic;

  void start() {
    _onlineSub ??= _online?.listen((isOnline) {
      if (isOnline) unawaited(syncNow(force: true));
    });
    _periodic ??= Timer.periodic(_interval, (_) => unawaited(syncNow()));
    unawaited(syncNow());
  }

  void requestSync() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => unawaited(pushOutbox()));
  }

  Future<void> dispose() async {
    _debounceTimer?.cancel();
    _periodic?.cancel();
    await _onlineSub?.cancel();
  }

  Future<SyncReport> syncNow({bool force = false}) =>
      _running ??= _run(force: force).whenComplete(() => _running = null);

  Future<SyncReport> _run({required bool force}) async {
    final push = await pushOutbox(ignoreBackoff: force);
    if (push.blocked) return push;
    try {
      await pull();
      return SyncReport(pushed: push.pushed, failed: push.failed, pulled: true);
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('SyncService.pull', e, s);
      return SyncReport(
        pushed: push.pushed,
        failed: push.failed,
        blocked: e.isTransient,
      );
    }
  }

  Future<SyncReport> pushOutbox({bool ignoreBackoff = false}) async {
    var pushed = 0;
    var failed = 0;
    for (var batch = 0; batch < maxPushBatches; batch++) {
      final entries = await _outbox.due(ignoreBackoff: ignoreBackoff);
      if (entries.isEmpty) break;
      for (final entry in entries) {
        try {
          await _apply(entry);
          await _outbox.complete(entry);
          pushed++;
        } on RemoteFailure catch (e) {
          if (e.isTransient) {
            await _outbox.retryLater(entry, e.message);
            return SyncReport(pushed: pushed, failed: failed, blocked: true);
          }
          ErrorReporter.report('SyncService.push', e);
          await _outbox.markFailed(entry, e.message);
          failed++;
        }
      }
    }
    return SyncReport(pushed: pushed, failed: failed);
  }

  Future<void> _apply(OutboxEntry entry) async {
    final payload = jsonDecode(entry.payload) as JsonRow;
    switch (entry.kind) {
      case OutboxKind.upsert:
        final conflict = entry.onConflict;
        await _remote.upsert(
          entry.target,
          payload,
          onConflict: conflict,
          ignoreDuplicates: conflict != null,
        );
      case OutboxKind.delete:
        await _remote.delete(entry.target, payload.cast<String, Object>());
      case OutboxKind.rpc:
        await _remote.rpc(entry.target, payload);
    }
  }

  Future<void> pull() async {
    await _pullTable(
      scope: 'ref:tags',
      table: 'tags',
      orderKeys: const ['id'],
      write: (rows) =>
          _upsertAll(_db.tags, rows.map((r) => Tag.fromJson(r).toCompanion())),
    );
    await _pullTable(
      scope: 'ref:units',
      table: 'units',
      orderKeys: const ['code'],
      write: (rows) => _upsertAll(
        _db.measureUnits,
        rows.map((r) => MeasureUnit.fromJson(r).toCompanion()),
      ),
    );
    await _pullTable(
      scope: 'ref:foods',
      table: 'foods',
      orderKeys: const ['id'],
      write: (rows) => _upsertAll(
        _db.foods,
        rows.map((r) => Food.fromJson(r).toCompanion()),
      ),
    );
    await _pullTable(
      scope: 'ref:food_portions',
      table: 'food_portions',
      orderKeys: const ['food_id', 'label'],
      write: (rows) => _upsertAll(
        _db.foodPortions,
        rows.map((r) => FoodPortion.fromJson(r).toCompanion()),
      ),
    );
    final uid = _remote.userId;
    if (uid == null) return;
    await _pullProfile(uid);
    await _pullOwnRecipes(uid);
    await _pullActivity(uid);
  }

  Future<void> _pullTable({
    required String scope,
    required String table,
    required List<String> orderKeys,
    required Future<void> Function(List<JsonRow> rows) write,
    Map<String, Object> match = const {},
  }) async {
    final since = await _db.cursorFor(scope);
    var newest = since;
    for (var page = 0; page < maxPages; page++) {
      final rows = await _remote.fetchChanged(
        table,
        orderKeys: orderKeys,
        from: page * pageSize,
        to: (page + 1) * pageSize - 1,
        since: since,
        match: match,
      );
      if (rows.isEmpty) break;
      await write(rows);
      final last = DateTime.parse(rows.last['updated_at'] as String);
      if (newest == null || last.isAfter(newest)) newest = last;
      if (rows.length < pageSize) break;
    }
    if (newest != null && newest != since) {
      await _db.setCursor(scope, newest);
    }
  }

  Future<void> _upsertAll<T extends Table, D>(
    TableInfo<T, D> table,
    Iterable<Insertable<D>> rows,
  ) => _db.batch((b) => b.insertAllOnConflictUpdate(table, rows.toList()));

  Future<void> _pullProfile(String uid) async {
    final rows = await _remote.fetchIn('profiles', column: 'id', values: [uid]);
    if (rows.isEmpty) return;
    final pending = await _outbox.pendingKeys();
    if (pending.contains('profiles:$uid')) return;
    final tastes = await _remote.fetchIn(
      'profile_tastes',
      column: 'user_id',
      values: [uid],
    );
    await _db.transaction(() async {
      await _db
          .into(_db.profiles)
          .insertOnConflictUpdate(Profile.fromJson(rows.first).toCompanion());
      if (pending.contains('profile_tastes:$uid')) return;
      await (_db.delete(
        _db.profileTastes,
      )..where((t) => t.userId.equals(uid))).go();
      await _db.batch(
        (b) => b.insertAll(_db.profileTastes, [
          for (final t in tastes)
            ProfileTastesCompanion.insert(
              userId: uid,
              tagId: (t['tag_id'] as num).toInt(),
            ),
        ]),
      );
    });
  }

  Future<void> _pullOwnRecipes(String uid) => _pullTable(
    scope: 'user:$uid:recipes',
    table: 'recipes',
    orderKeys: const ['id'],
    match: {'author_id': uid},
    write: (rows) async {
      final pending = await _outbox.pendingKeys();
      final recipes = [
        for (final r in rows)
          if (!pending.contains('recipes:${r['id']}')) Recipe.fromJson(r),
      ];
      await _upsertAll(_db.recipes, recipes.map((r) => r.toCompanion()));
      await _replaceChildren(recipes.map((r) => r.id).toList());
    },
  );

  Future<void> _pullActivity(String uid) async {
    final pending = await _outbox.pendingKeys();
    final saves = await _remote.fetchIn(
      'saves',
      column: 'user_id',
      values: [uid],
    );
    final likes = await _remote.fetchIn(
      'likes',
      column: 'user_id',
      values: [uid],
    );
    await _db.transaction(() async {
      await _reconcileUserRecipeRows(
        table: _db.saves,
        uid: uid,
        rows: saves,
        keyPrefix: 'saves',
        pending: pending,
        build: (rid, at) =>
            SavesCompanion.insert(userId: uid, recipeId: rid, createdAt: at),
      );
      await _reconcileUserRecipeRows(
        table: _db.likes,
        uid: uid,
        rows: likes,
        keyPrefix: 'likes',
        pending: pending,
        build: (rid, at) =>
            LikesCompanion.insert(userId: uid, recipeId: rid, createdAt: at),
      );
    });
    await _pullSavedRecipes(uid, [
      for (final s in saves) s['recipe_id'] as String,
    ]);
  }

  Future<void> _reconcileUserRecipeRows<T extends Table, D>({
    required TableInfo<T, D> table,
    required String uid,
    required List<JsonRow> rows,
    required String keyPrefix,
    required Set<String> pending,
    required Insertable<D> Function(String recipeId, DateTime at) build,
  }) async {
    final remoteIds = {for (final r in rows) r['recipe_id'] as String};
    final local = await _db
        .customSelect(
          'SELECT recipe_id FROM ${table.actualTableName} WHERE user_id = ?',
          variables: [Variable.withString(uid)],
          readsFrom: {table},
        )
        .get();
    for (final row in local) {
      final rid = row.read<String>('recipe_id');
      if (remoteIds.contains(rid) || pending.contains('$keyPrefix:$rid')) {
        continue;
      }
      await _db.customStatement(
        'DELETE FROM ${table.actualTableName} '
        'WHERE user_id = ? AND recipe_id = ?',
        [uid, rid],
      );
    }
    await _db.batch(
      (b) => b.insertAllOnConflictUpdate(table, [
        for (final r in rows)
          if (!pending.contains('$keyPrefix:${r['recipe_id']}'))
            build(
              r['recipe_id'] as String,
              DateTime.parse(r['created_at'] as String),
            ),
      ]),
    );
  }

  Future<void> _pullSavedRecipes(String uid, List<String> savedIds) async {
    if (savedIds.isEmpty) return;
    final known = {
      for (final r in await (_db.select(
        _db.recipes,
      )..where((t) => t.id.isIn(savedIds))).get())
        r.id: r.updatedAt,
    };
    for (var i = 0; i < savedIds.length; i += chunkSize) {
      final chunk = savedIds.sublist(
        i,
        i + chunkSize > savedIds.length ? savedIds.length : i + chunkSize,
      );
      final rows = await _remote.fetchIn(
        'recipe_cards',
        column: 'id',
        values: chunk,
      );
      final cards = [
        for (final r in rows)
          if (r['author_id'] != uid) RecipeCard.fromJson(r),
      ];
      final changed = [
        for (final c in cards)
          if (known[c.id] == null || c.updatedAt.isAfter(known[c.id]!)) c,
      ];
      await _upsertAll(_db.recipes, changed.map((c) => c.toCompanion()));
      await _replaceChildren(changed.map((c) => c.id).toList());
    }
  }

  Future<void> _replaceChildren(List<String> recipeIds) async {
    if (recipeIds.isEmpty) return;
    final ingredients = await _remote.fetchIn(
      'recipe_ingredients',
      column: 'recipe_id',
      values: recipeIds,
    );
    final steps = await _remote.fetchIn(
      'recipe_steps',
      column: 'recipe_id',
      values: recipeIds,
    );
    final tags = await _remote.fetchIn(
      'recipe_tags',
      column: 'recipe_id',
      values: recipeIds,
    );
    final stepRecipe = {
      for (final s in steps) s['id'] as String: s['recipe_id'] as String,
    };
    final links = await _remote.fetchIn(
      'step_ingredients',
      column: 'step_id',
      values: stepRecipe.keys.toList(),
    );
    await _db.transaction(() async {
      await (_db.delete(
        _db.recipeIngredients,
      )..where((t) => t.recipeId.isIn(recipeIds))).go();
      await (_db.delete(
        _db.recipeSteps,
      )..where((t) => t.recipeId.isIn(recipeIds))).go();
      await (_db.delete(
        _db.recipeTags,
      )..where((t) => t.recipeId.isIn(recipeIds))).go();
      await (_db.delete(
        _db.stepIngredients,
      )..where((t) => t.recipeId.isIn(recipeIds))).go();
      await _db.batch((b) {
        b
          ..insertAll(_db.recipeIngredients, [
            for (final r in ingredients)
              RecipeIngredient.fromJson(r).toCompanion(),
          ])
          ..insertAll(_db.recipeSteps, [
            for (final r in steps) RecipeStep.fromJson(r).toCompanion(),
          ])
          ..insertAll(_db.recipeTags, [
            for (final r in tags)
              RecipeTagsCompanion.insert(
                recipeId: r['recipe_id'] as String,
                tagId: (r['tag_id'] as num).toInt(),
              ),
          ])
          ..insertAll(_db.stepIngredients, [
            for (final r in links)
              StepIngredientsCompanion.insert(
                stepId: r['step_id'] as String,
                ingredientId: r['ingredient_id'] as String,
                recipeId: stepRecipe[r['step_id']]!,
              ),
          ]);
      });
    });
  }
}
