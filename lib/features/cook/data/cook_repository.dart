import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/ids.dart';
import 'package:shared_plates_app/core/utils/result.dart';

abstract interface class CookRepository {
  Future<int> cooksThisMonth(String uid);

  Future<Result<String>> logCook({
    required String uid,
    required String recipeId,
    required int servings,
    required bool toldCreator,
  });
}

class CookRepositoryImpl implements CookRepository {
  new({
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
  Future<int> cooksThisMonth(String uid) async {
    final now = _now();
    final start = DateTime(now.year, now.month);
    final count = _db.cooks.id.count();
    final query = _db.selectOnly(_db.cooks)
      ..addColumns([count])
      ..where(
        _db.cooks.userId.equals(uid) &
            _db.cooks.cookedAt.isBiggerOrEqualValue(start),
      );
    final row = await query.getSingle();
    final total = row.read(count);
    return total ?? 0;
  }

  @override
  Future<Result<String>> logCook({
    required String uid,
    required String recipeId,
    required int servings,
    required bool toldCreator,
  }) async {
    final id = Ids.next();
    final at = _now().toUtc();
    try {
      await _db.transaction(() async {
        await _db
            .into(_db.cooks)
            .insert(
              CooksCompanion.insert(
                id: id,
                userId: uid,
                recipeId: recipeId,
                servings: Value(servings),
                toldCreator: Value(toldCreator),
                cookedAt: at,
              ),
            );
        await _outbox.enqueue(
          OutboxOperation.insertIgnoringDuplicates(
            'cooks',
            {
              'id': id,
              'user_id': uid,
              'recipe_id': recipeId,
              'servings': servings,
              'told_creator': toldCreator,
              'cooked_at': at.toIso8601String(),
            },
            conflictColumns: 'id',
            dedupeKey: 'cooks:$id',
          ),
        );
      });
      _sync.requestSync();
      return Result.ok(id);
    } on Exception catch (e, s) {
      ErrorReporter.report('CookRepository.logCook', e, s);
      return Result.error(Exception("Couldn't log that cook."));
    }
  }
}
