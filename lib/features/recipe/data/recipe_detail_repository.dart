import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/db/mappers.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_api.dart';
import 'package:shared_plates_app/features/recipe/data/cover_cache.dart';
import 'package:shared_plates_app/features/recipe/domain/recipe_detail.dart';

abstract final class RecipeMessages {
  static const offline = 'No signal. Showing what is saved on this phone.';
  static const missing = "This recipe isn't available right now.";
  static const forkOffline = 'Saving your own version needs a connection.';
  static const generic = 'Something went wrong. Try again.';
}

abstract interface class RecipeDetailRepository {
  Stream<RecipeDetail?> watch(String id, {String? viewerId});

  Future<Map<String, UnitDef>> units();

  Future<Result<void>> refresh(String id);

  Future<void> markViewed(String uid, String recipeId);

  Future<Result<void>> setTick({
    required String uid,
    required String recipeId,
    required String ingredientId,
    required bool ticked,
  });

  Future<Result<String>> fork(String id);

  Future<String?> coverUrl(String path);

  Future<void> cacheCovers(String uid);
}

class RecipeDetailRepositoryImpl implements RecipeDetailRepository {
  new({
    required this._db,
    required this._outbox,
    required this._remote,
    required this._sync,
    required this._api,
    required this._covers,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final OutboxStore _outbox;
  final RemoteStore _remote;
  final SyncService _sync;
  final BrowseApi _api;
  final CoverCache _covers;
  final DateTime Function() _now;

  @override
  Stream<RecipeDetail?> watch(String id, {String? viewerId}) async* {
    yield await _load(id, viewerId);
    final updates = _db.tableUpdates(
      TableUpdateQuery.onAllTables([
        _db.recipes,
        _db.recipeIngredients,
        _db.recipeSteps,
        _db.stepIngredients,
        _db.recipeTags,
        _db.shoppingTicks,
      ]),
    );
    await for (final _ in updates) {
      yield await _load(id, viewerId);
    }
  }

  Future<RecipeDetail?> _load(String id, String? viewerId) async {
    final row = await (_db.select(
      _db.recipes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null || row.deletedAt != null) return null;
    final ingredients =
        await (_db.select(_db.recipeIngredients)
              ..where((t) => t.recipeId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final steps =
        await (_db.select(_db.recipeSteps)
              ..where((t) => t.recipeId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final links = await (_db.select(
      _db.stepIngredients,
    )..where((t) => t.recipeId.equals(id))).get();
    final tagRows = await (_db.select(_db.tags).join([
      innerJoin(_db.recipeTags, _db.recipeTags.tagId.equalsExp(_db.tags.id)),
    ])..where(_db.recipeTags.recipeId.equals(id))).get();
    final ticks = viewerId == null
        ? <ShoppingTickRow>[]
        : await (_db.select(_db.shoppingTicks)..where(
                (t) => t.userId.equals(viewerId) & t.recipeId.equals(id),
              ))
              .get();
    final byStep = <String, List<String>>{};
    for (final link in links) {
      byStep.putIfAbsent(link.stepId, () => []).add(link.ingredientId);
    }
    return RecipeDetail(
      card: row.toCard(viewerId: viewerId),
      ingredients: [for (final i in ingredients) i.toDomain()],
      steps: [for (final s in steps) s.toDomain()],
      stepIngredients: byStep,
      tags: [for (final t in tagRows) t.readTable(_db.tags).toDomain()],
      ticks: {for (final t in ticks) t.ingredientId},
    );
  }

  @override
  Future<Map<String, UnitDef>> units() async {
    final rows = await _db.select(_db.measureUnits).get();
    return {
      ...Measure.defaults,
      for (final u in rows) u.code: UnitDef(u.code, u.kind, u.scope, u.toBase),
    };
  }

  @override
  Future<Result<void>> refresh(String id) async {
    try {
      await _sync.pullRecipe(id);
      return const Result.ok(null);
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('RecipeDetailRepository.refresh', e, s);
      return Result.error(
        Exception(
          e.isTransient ? RecipeMessages.offline : RecipeMessages.missing,
        ),
      );
    }
  }

  @override
  Future<void> markViewed(String uid, String recipeId) async {
    final at = _now().toUtc();
    await _db
        .into(_db.recentlyViewed)
        .insertOnConflictUpdate(
          RecentlyViewedCompanion.insert(
            userId: uid,
            recipeId: recipeId,
            viewedAt: at,
          ),
        );
    await _outbox.enqueue(
      OutboxOperation.upsert('recently_viewed', {
        'user_id': uid,
        'recipe_id': recipeId,
        'viewed_at': at.toIso8601String(),
      }, dedupeKey: 'recently_viewed:$recipeId'),
    );
    _sync.requestSync();
  }

  @override
  Future<Result<void>> setTick({
    required String uid,
    required String recipeId,
    required String ingredientId,
    required bool ticked,
  }) async {
    try {
      await _db.transaction(() async {
        if (ticked) {
          await _db
              .into(_db.shoppingTicks)
              .insertOnConflictUpdate(
                ShoppingTicksCompanion.insert(
                  userId: uid,
                  ingredientId: ingredientId,
                  recipeId: recipeId,
                  tickedAt: _now().toUtc(),
                ),
              );
        } else {
          await (_db.delete(_db.shoppingTicks)..where(
                (t) =>
                    t.userId.equals(uid) & t.ingredientId.equals(ingredientId),
              ))
              .go();
        }
        await _outbox.enqueue(
          ticked
              ? OutboxOperation.insertIgnoringDuplicates(
                  'shopping_ticks',
                  {
                    'user_id': uid,
                    'ingredient_id': ingredientId,
                    'recipe_id': recipeId,
                  },
                  conflictColumns: 'user_id,ingredient_id',
                  dedupeKey: 'shopping_ticks:$ingredientId',
                )
              : OutboxOperation.delete('shopping_ticks', {
                  'user_id': uid,
                  'ingredient_id': ingredientId,
                }, dedupeKey: 'shopping_ticks:$ingredientId'),
        );
      });
      _sync.requestSync();
      return const Result.ok(null);
    } on Exception catch (e, s) {
      ErrorReporter.report('RecipeDetailRepository.setTick', e, s);
      return Result.error(Exception(RecipeMessages.generic));
    }
  }

  @override
  Future<Result<String>> fork(String id) async {
    try {
      final newId = await _remote.rpc('fork_recipe', {'rid': id});
      if (newId is! String) return const Result.castError();
      await _sync.pullRecipe(newId);
      return Result.ok(newId);
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('RecipeDetailRepository.fork', e, s);
      return Result.error(
        Exception(
          e.isTransient ? RecipeMessages.forkOffline : RecipeMessages.generic,
        ),
      );
    }
  }

  @override
  Future<String?> coverUrl(String path) async {
    try {
      return (await _api.signCovers([path]))[path];
    } on RemoteFailure {
      return null;
    }
  }

  @override
  Future<void> cacheCovers(String uid) => _covers.backfill(uid);
}
