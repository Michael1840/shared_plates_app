import 'dart:convert';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/domain/avoid_option.dart';
import 'package:shared_plates_app/features/profile/domain/popular_cook.dart';

import '../../helpers/fake_remote_store.dart';

const _uid = 'u1';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late OutboxStore outbox;
  late FakeRemoteStore remote;
  late SyncService sync;
  late ProfileRepositoryImpl repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    outbox = OutboxStore(db);
    remote = FakeRemoteStore(userId: _uid);
    sync = SyncService(
      db: db,
      outbox: outbox,
      remote: remote,
      debounce: const Duration(days: 1),
    );
    repo = ProfileRepositoryImpl(
      db: db,
      outbox: outbox,
      remote: remote,
      sync: sync,
      settings: AppSettingsStore(db),
      clock: () => DateTime.utc(2026, 11, 14, 9),
    );
    await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            id: _uid,
            username: 'thandi',
            displayName: 'thandi',
            units: UnitSystem.metric,
            defaultVisibility: RecipeVisibility.friends,
            createdAt: DateTime.utc(2026, 11),
            updatedAt: DateTime.utc(2026, 11),
          ),
        );
    await db.batch(
      (b) => b.insertAll(db.foods, [
        FoodsCompanion.insert(
          id: 'f-bacon',
          name: 'Streaky bacon',
          updatedAt: DateTime.utc(2026, 11),
        ),
        FoodsCompanion.insert(
          id: 'f-onion',
          name: 'Onion',
          updatedAt: DateTime.utc(2026, 11),
        ),
        FoodsCompanion.insert(
          id: 'f-gammon',
          name: 'Smoked joint',
          aliases: const Value(['gammon']),
          updatedAt: DateTime.utc(2026, 11),
        ),
      ]),
    );
  });

  tearDown(() async {
    await sync.dispose();
    await db.close();
  });

  Future<List<OutboxEntry>> queued() => outbox.due(ignoreBackoff: true);

  test('basics update locally and queue a profile update', () async {
    final result = await repo.saveBasics(
      uid: _uid,
      displayName: 'Thandi Nkosi',
      units: UnitSystem.imperial,
      username: 'thandi.cooks',
    );

    expect(result, isA<Ok<void>>());
    final local = await repo.localProfile(_uid);
    expect(local?.displayName, 'Thandi Nkosi');
    expect(local?.units, UnitSystem.imperial);
    expect(local?.username, 'thandi.cooks');
    final entry = (await queued()).single;
    expect(entry.kind, OutboxKind.update);
    expect(jsonDecode(entry.payload), {
      'values': {
        'display_name': 'Thandi Nkosi',
        'units': 'imperial',
        'username': 'thandi.cooks',
      },
      'match': {'id': _uid},
    });
  });

  test('tastes replace the previous selection, also in the queue', () async {
    await repo.saveTastes(uid: _uid, tagIds: {1, 2}, avoid: {});
    await repo.saveTastes(uid: _uid, tagIds: {2, 5}, avoid: {AvoidOption.pork});

    final tastes = await db.select(db.profileTastes).get();
    expect(tastes.map((t) => t.tagId), unorderedEquals([2, 5]));
    final hidden = await db.select(db.hiddenFoods).get();
    expect(
      hidden.map((h) => h.foodId),
      unorderedEquals(['f-bacon', 'f-gammon']),
    );

    await sync.pushOutbox();
    expect(
      remote.tables['profile_tastes']!.map((r) => r['tag_id']),
      unorderedEquals([2, 5]),
    );
    expect(
      remote.tables['hidden_foods']!.map((r) => r['food_id']),
      unorderedEquals(['f-bacon', 'f-gammon']),
    );
  });

  test('marking onboarded sets the local timestamp', () async {
    await repo.markOnboarded(_uid);

    final local = await repo.localProfile(_uid);
    expect(local?.onboardedAt?.toUtc(), DateTime.utc(2026, 11, 14, 9));
    final entry = (await queued()).single;
    expect(entry.dedupeKey, 'profiles:$_uid:onboarded');
  });

  test('friend requests are queued once and tick the checklist', () async {
    await repo.requestFriend('c1');
    await repo.requestFriend('c1');

    expect(await queued(), hasLength(1));
    expect(await AppSettingsStore(db).flag(SettingKey.friendRequested), isTrue);
  });

  test('popular cooks map from the rpc rows', () async {
    remote.rpcResults['popular_cooks'] = [
      {
        'id': 'c1',
        'username': 'lerato',
        'display_name': 'Lerato Mokoena',
        'avatar_path': null,
        'recipes': 48,
        'saves': null,
      },
    ];

    final result = await repo.popularCooks();

    final cooks = (result as Ok<List<PopularCook>>).value;
    expect(cooks.single.displayName, 'Lerato Mokoena');
    expect(cooks.single.initials, 'LM');
    expect(cooks.single.saves, 0);
  });

  test('popular cooks report a friendly error offline', () async {
    remote.failures.add(const RemoteFailure('down', isTransient: true));

    final result = await repo.popularCooks();

    expect(
      (result as Error).error.toString(),
      contains(ProfileMessages.offline),
    );
  });
}
