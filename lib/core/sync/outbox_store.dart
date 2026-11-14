import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';

class OutboxOperation {
  const new _({
    required this.kind,
    required this.target,
    required this.payload,
    this.onConflict,
    this.dedupeKey,
  });

  factory upsert(String table, JsonRow row, {String? dedupeKey}) =>
      OutboxOperation._(
        kind: OutboxKind.upsert,
        target: table,
        payload: row,
        dedupeKey: dedupeKey,
      );

  factory insertIgnoringDuplicates(
    String table,
    JsonRow row, {
    required String conflictColumns,
    String? dedupeKey,
  }) => OutboxOperation._(
    kind: OutboxKind.upsert,
    target: table,
    payload: row,
    onConflict: conflictColumns,
    dedupeKey: dedupeKey,
  );

  factory update(
    String table,
    JsonRow values, {
    required Map<String, Object> match,
    String? dedupeKey,
  }) => OutboxOperation._(
    kind: OutboxKind.update,
    target: table,
    payload: {'values': values, 'match': match},
    dedupeKey: dedupeKey,
  );

  factory delete(
    String table,
    Map<String, Object> match, {
    String? dedupeKey,
  }) => OutboxOperation._(
    kind: OutboxKind.delete,
    target: table,
    payload: match,
    dedupeKey: dedupeKey,
  );

  factory rpc(String function, JsonRow params, {String? dedupeKey}) =>
      OutboxOperation._(
        kind: OutboxKind.rpc,
        target: function,
        payload: params,
        dedupeKey: dedupeKey,
      );

  final OutboxKind kind;
  final String target;
  final JsonRow payload;
  final String? onConflict;
  final String? dedupeKey;
}

class OutboxStore {
  new(this._db, {DateTime Function()? clock}) : _now = clock ?? DateTime.now;

  static const maxBackoff = Duration(minutes: 10);
  static const baseBackoff = Duration(seconds: 5);

  final AppDatabase _db;
  final DateTime Function() _now;

  Future<int> enqueue(OutboxOperation op) => _db.transaction(() async {
    final key = op.dedupeKey;
    final row = OutboxCompanion(
      kind: Value(op.kind),
      target: Value(op.target),
      payload: Value(jsonEncode(op.payload)),
      onConflict: Value(op.onConflict),
      dedupeKey: Value(key),
      attempts: const Value(0),
      lastError: const Value(null),
      failed: const Value(false),
      nextAttemptAt: const Value(null),
    );
    if (key != null) {
      final existing =
          await (_db.select(_db.outbox)
                ..where((t) => t.dedupeKey.equals(key))
                ..orderBy([(t) => OrderingTerm.asc(t.id)])
                ..limit(1))
              .getSingleOrNull();
      if (existing != null) {
        await (_db.update(
          _db.outbox,
        )..where((t) => t.id.equals(existing.id))).write(row);
        return existing.id;
      }
    }
    return await _db
        .into(_db.outbox)
        .insert(row.copyWith(createdAt: Value(_now())));
  });

  Future<List<OutboxEntry>> due({
    int limit = 50,
    bool ignoreBackoff = false,
  }) async {
    final entries =
        await (_db.select(_db.outbox)
              ..where((t) => t.failed.equals(false))
              ..orderBy([(t) => OrderingTerm.asc(t.id)])
              ..limit(limit))
            .get();
    final head = entries.isEmpty ? null : entries.first.nextAttemptAt;
    if (!ignoreBackoff && head != null && head.isAfter(_now())) return [];
    return entries;
  }

  Future<void> complete(OutboxEntry entry) =>
      (_db.delete(_db.outbox)..where(
            (t) =>
                t.id.equals(entry.id) &
                t.kind.equalsValue(entry.kind) &
                t.payload.equals(entry.payload),
          ))
          .go();

  Future<void> retryLater(OutboxEntry entry, String error) {
    final attempts = entry.attempts + 1;
    final factor = math.pow(2, math.min(attempts - 1, 8)).toInt();
    final wait = baseBackoff * factor;
    final delay = wait > maxBackoff ? maxBackoff : wait;
    return (_db.update(_db.outbox)..where((t) => t.id.equals(entry.id))).write(
      OutboxCompanion(
        attempts: Value(attempts),
        lastError: Value(error),
        nextAttemptAt: Value(_now().add(delay)),
      ),
    );
  }

  Future<void> markFailed(OutboxEntry entry, String error) =>
      (_db.update(_db.outbox)..where((t) => t.id.equals(entry.id))).write(
        OutboxCompanion(
          attempts: Value(entry.attempts + 1),
          lastError: Value(error),
          failed: const Value(true),
        ),
      );

  Future<Set<String>> pendingKeys() async {
    final rows =
        await (_db.selectOnly(_db.outbox)
              ..addColumns([_db.outbox.dedupeKey])
              ..where(_db.outbox.failed.equals(false)))
            .get();
    return {for (final r in rows) ?r.read(_db.outbox.dedupeKey)};
  }

  Future<void> discardPending(String keyPrefix) async {
    final keys = await pendingKeys();
    final matching = [
      for (final k in keys)
        if (hasPendingWithPrefix({k}, keyPrefix)) k,
    ];
    if (matching.isEmpty) return;
    await (_db.delete(
      _db.outbox,
    )..where((t) => t.failed.equals(false) & t.dedupeKey.isIn(matching))).go();
  }

  bool hasPendingWithPrefix(Set<String> keys, String prefix) =>
      keys.any((k) => k == prefix || k.startsWith('$prefix:'));

  Stream<int> watchPendingCount() {
    final count = _db.outbox.id.count();
    return (_db.selectOnly(_db.outbox)
          ..addColumns([count])
          ..where(_db.outbox.failed.equals(false)))
        .map((row) => row.read(count) ?? 0)
        .watchSingle();
  }
}
