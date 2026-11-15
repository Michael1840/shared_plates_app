import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/db/mappers.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';

abstract final class RecipeActionMessages {
  static const generic = "That didn't save. Try again.";
}

abstract interface class RecipeActionsRepository {
  Stream<Set<String>> watchSavedIds(String uid);

  Stream<Set<String>> watchLikedIds(String uid);

  Future<Result<bool>> setSaved(
    String uid,
    RecipeCard card, {
    required bool saved,
  });

  Future<Result<bool>> setLiked(
    String uid,
    RecipeCard card, {
    required bool liked,
  });
}

class RecipeActionsRepositoryImpl implements RecipeActionsRepository {
  RecipeActionsRepositoryImpl({
    required this._db,
    required this._outbox,
    required this._sync,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final OutboxStore _outbox;
  final SyncService _sync;
  final DateTime Function() _now;

  @override
  Stream<Set<String>> watchSavedIds(String uid) =>
      (_db.select(_db.saves)..where((t) => t.userId.equals(uid))).watch().map(
        (rows) => {for (final r in rows) r.recipeId},
      );

  @override
  Stream<Set<String>> watchLikedIds(String uid) =>
      (_db.select(_db.likes)..where((t) => t.userId.equals(uid))).watch().map(
        (rows) => {for (final r in rows) r.recipeId},
      );

  @override
  Future<Result<bool>> setSaved(
    String uid,
    RecipeCard card, {
    required bool saved,
  }) => _toggle('setSaved', () async {
    await _db.transaction(() async {
      if (saved) {
        await _db
            .into(_db.saves)
            .insert(
              SavesCompanion.insert(
                userId: uid,
                recipeId: card.id,
                createdAt: _now(),
              ),
              mode: InsertMode.insertOrIgnore,
            );
        await _cacheCard(card);
      } else {
        await (_db.delete(_db.saves)
              ..where((t) => t.userId.equals(uid) & t.recipeId.equals(card.id)))
            .go();
      }
      await _outbox.enqueue(
        _membershipOp('saves', uid, card.id, present: saved),
      );
    });
    return saved;
  });

  @override
  Future<Result<bool>> setLiked(
    String uid,
    RecipeCard card, {
    required bool liked,
  }) => _toggle('setLiked', () async {
    await _db.transaction(() async {
      if (liked) {
        await _db
            .into(_db.likes)
            .insert(
              LikesCompanion.insert(
                userId: uid,
                recipeId: card.id,
                createdAt: _now(),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      } else {
        await (_db.delete(_db.likes)
              ..where((t) => t.userId.equals(uid) & t.recipeId.equals(card.id)))
            .go();
      }
      await _outbox.enqueue(
        _membershipOp('likes', uid, card.id, present: liked),
      );
    });
    return liked;
  });

  OutboxOperation _membershipOp(
    String table,
    String uid,
    String recipeId, {
    required bool present,
  }) => present
      ? OutboxOperation.insertIgnoringDuplicates(
          table,
          {'user_id': uid, 'recipe_id': recipeId},
          conflictColumns: 'user_id,recipe_id',
          dedupeKey: '$table:$recipeId',
        )
      : OutboxOperation.delete(table, {
          'user_id': uid,
          'recipe_id': recipeId,
        }, dedupeKey: '$table:$recipeId');

  Future<void> _cacheCard(RecipeCard card) async {
    final existing = await (_db.select(
      _db.recipes,
    )..where((t) => t.id.equals(card.id))).getSingleOrNull();
    if (existing != null && !card.updatedAt.isAfter(existing.updatedAt)) {
      return;
    }
    await _db.into(_db.recipes).insertOnConflictUpdate(card.toCompanion());
  }

  Future<Result<bool>> _toggle(
    String source,
    Future<bool> Function() write,
  ) async {
    try {
      final value = await write();
      _sync.requestSync();
      return Result.ok(value);
    } on Exception catch (e, s) {
      ErrorReporter.report('RecipeActionsRepository.$source', e, s);
      return Result.error(Exception(RecipeActionMessages.generic));
    }
  }
}
