import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late DateTime now;
  late OutboxStore outbox;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime.utc(2026, 11, 14, 12);
    outbox = OutboxStore(db, clock: () => now);
  });

  tearDown(() => db.close());

  OutboxOperation like(String id) => OutboxOperation.insertIgnoringDuplicates(
    'likes',
    {'recipe_id': id},
    conflictColumns: 'user_id,recipe_id',
    dedupeKey: 'likes:$id',
  );

  OutboxOperation unlike(String id) => OutboxOperation.delete('likes', {
    'recipe_id': id,
  }, dedupeKey: 'likes:$id');

  test('returns entries first in, first out', () async {
    await outbox.enqueue(OutboxOperation.upsert('recipes', {'id': 'r1'}));
    await outbox.enqueue(like('r1'));
    await outbox.enqueue(OutboxOperation.rpc('mark_notifications_read', {}));

    final due = await outbox.due();

    expect(due.map((e) => e.target), [
      'recipes',
      'likes',
      'mark_notifications_read',
    ]);
  });

  test('a newer op with the same key replaces the old one in place', () async {
    await outbox.enqueue(like('r1'));
    await outbox.enqueue(OutboxOperation.upsert('recipes', {'id': 'r2'}));
    await outbox.enqueue(unlike('r1'));

    final due = await outbox.due();

    expect(due, hasLength(2));
    expect(due.first.target, 'likes');
    expect(due.first.kind, OutboxKind.delete);
    expect(due.last.target, 'recipes');
  });

  test('a blocked head holds the whole queue until it is due', () async {
    await outbox.enqueue(OutboxOperation.upsert('recipes', {'id': 'r1'}));
    await outbox.enqueue(like('r1'));
    final head = (await outbox.due()).first;

    await outbox.retryLater(head, 'offline');

    expect(await outbox.due(), isEmpty);
    expect(await outbox.due(ignoreBackoff: true), hasLength(2));
    now = now.add(OutboxStore.baseBackoff);
    expect(await outbox.due(), hasLength(2));
  });

  test('backoff doubles and is capped', () async {
    await outbox.enqueue(like('r1'));
    for (var i = 0; i < 12; i++) {
      await outbox.retryLater(
        (await outbox.due(ignoreBackoff: true)).first,
        'x',
      );
    }
    final entry = (await outbox.due(ignoreBackoff: true)).first;

    expect(entry.attempts, 12);
    expect(entry.nextAttemptAt?.toUtc(), now.add(OutboxStore.maxBackoff));
  });

  test('completing keeps an entry that changed while in flight', () async {
    await outbox.enqueue(like('r1'));
    final inFlight = (await outbox.due()).single;
    await outbox.enqueue(unlike('r1'));

    await outbox.complete(inFlight);

    final left = await outbox.due();
    expect(left.single.kind, OutboxKind.delete);
  });

  test('failed entries leave the queue and the pending count', () async {
    await outbox.enqueue(like('r1'));
    await outbox.markFailed((await outbox.due()).single, 'rejected');

    expect(await outbox.due(), isEmpty);
    expect(await outbox.watchPendingCount().first, 0);
  });

  test('pending keys include every queued dedupe key', () async {
    await outbox.enqueue(like('r1'));
    await outbox.enqueue(OutboxOperation.upsert('recipes', {'id': 'r9'}));

    expect(await outbox.pendingKeys(), {'likes:r1'});
  });
}
