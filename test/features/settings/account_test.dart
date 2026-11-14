import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/domain/avoid_option.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:shared_plates_app/features/recipes/data/library_repository.dart';
import 'package:shared_plates_app/features/recipes/presentation/bloc/recipes_cubit.dart';

import '../../helpers/fake_remote_store.dart';
import '../../helpers/mocks.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late OutboxStore outbox;
  late SyncService sync;
  late ProfileRepositoryImpl profiles;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    outbox = OutboxStore(db);
    final remote = FakeRemoteStore(userId: 'u1');
    sync = SyncService(
      db: db,
      outbox: outbox,
      remote: remote,
      debounce: const Duration(days: 1),
    );
    profiles = ProfileRepositoryImpl(
      db: db,
      outbox: outbox,
      remote: remote,
      sync: sync,
      settings: AppSettingsStore(db),
      clock: () => DateTime.utc(2026, 11, 14, 9),
    );
    final at = DateTime.utc(2026, 11);
    await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            id: 'u1',
            username: 'thandi',
            displayName: 'Thandi Nkosi',
            units: UnitSystem.metric,
            defaultVisibility: RecipeVisibility.friends,
            createdAt: at,
            updatedAt: at,
          ),
        );
    await db.batch((b) {
      b
        ..insertAll(db.foods, [
          FoodsCompanion.insert(id: 'f-bacon', name: 'Bacon', updatedAt: at),
          FoodsCompanion.insert(id: 'f-hake', name: 'Hake', updatedAt: at),
          FoodsCompanion.insert(id: 'f-onion', name: 'Onion', updatedAt: at),
        ])
        ..insertAll(db.tags, [
          TagsCompanion.insert(
            id: const Value(15),
            slug: 'veggie',
            label: 'Vegetarian',
            kind: TagKind.diet,
            coverStyle: CoverStyle.veg,
            updatedAt: at,
          ),
        ]);
    });
  });

  tearDown(() async {
    await sync.dispose();
    await db.close();
  });

  group('ProfileRepository settings', () {
    test('preferences save locally and queue one update per field', () async {
      await profiles.updatePreferences(
        'u1',
        const ProfilePreferences(
          units: UnitSystem.imperial,
          keepScreenOn: false,
        ),
      );

      final row = await db.select(db.profiles).getSingle();
      expect(row.units, UnitSystem.imperial);
      expect(row.keepScreenOn, isFalse);
      final queued = await outbox.due();
      expect(
        queued.map((e) => (jsonDecode(e.payload) as Map)['values']),
        unorderedEquals([
          {'units': 'imperial'},
          {'keep_screen_on': false},
        ]),
      );
    });

    test('details are trimmed and clipped', () async {
      await profiles.updateDetails(
        uid: 'u1',
        displayName: '  Thandi N  ',
        bio: '   ',
        city: 'Cape Town',
        username: 'thandi.cooks',
      );

      final row = await db.select(db.profiles).getSingle();
      expect(row.displayName, 'Thandi N');
      expect(row.bio, isNull);
      expect(row.city, 'Cape Town');
      expect(row.username, 'thandi.cooks');
    });

    test('avoid options round trip through hidden foods', () async {
      await profiles.saveAvoid('u1', {AvoidOption.pork, AvoidOption.seafood});

      final hidden = await db.select(db.hiddenFoods).get();
      expect(
        hidden.map((h) => h.foodId),
        unorderedEquals(['f-bacon', 'f-hake']),
      );
      expect(await profiles.watchAvoid('u1').first, {
        AvoidOption.pork,
        AvoidOption.seafood,
      });
    });
  });

  group('EditProfileCubit', () {
    late MockProfileRepository repo;

    setUp(() {
      repo = MockProfileRepository();
      when(() => repo.isUsernameAvailable(any())).thenAnswer(
        (i) async => Result.ok(i.positionalArguments.first != 'taken'),
      );
    });

    EditProfileCubit build() => EditProfileCubit(
      profiles: repo,
      profile: Profile(
        id: 'u1',
        username: 'thandi',
        displayName: 'Thandi',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
      debounce: Duration.zero,
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'blocks bad and taken usernames',
      build: build,
      act: (c) async {
        c.setUsername('No Spaces');
        expect(c.state.check, UsernameCheck.invalid);
        expect(c.state.canSave, isFalse);
        c.setUsername('taken');
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      verify: (c) {
        expect(c.state.check, UsernameCheck.taken);
        expect(c.state.canSave, isFalse);
      },
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'saves a free username',
      setUp: () => when(
        () => repo.updateDetails(
          uid: any(named: 'uid'),
          displayName: any(named: 'displayName'),
          bio: any(named: 'bio'),
          city: any(named: 'city'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async => const Result.ok(null)),
      build: build,
      act: (c) async {
        c.setUsername('Thandi.Cooks');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await c.save();
      },
      verify: (c) {
        expect(c.state.save.value, isTrue);
        verify(
          () => repo.updateDetails(
            uid: 'u1',
            displayName: 'Thandi',
            bio: '',
            city: '',
            username: 'thandi.cooks',
          ),
        ).called(1);
      },
    );
  });

  group('Library', () {
    Future<void> addRecipe(
      String id, {
      required String author,
      RecipeStatus status = RecipeStatus.published,
      int? cents,
      int? minutes,
      String title = 'Recipe',
    }) => db
        .into(db.recipes)
        .insert(
          RecipesCompanion.insert(
            id: id,
            authorId: author,
            title: Value(title),
            coverStyle: CoverStyle.any,
            visibility: RecipeVisibility.friends,
            status: status,
            source: RecipeSource.typed,
            costCents: Value(cents),
            baseServings: const Value(4),
            totalMinutes: Value(minutes),
            createdAt: DateTime.utc(2026, 11, 10),
            updatedAt: DateTime.utc(2026, 11, 10),
          ),
        );

    setUp(() async {
      await addRecipe('mine', author: 'u1', title: 'Chakalaka', cents: 4400);
      await addRecipe(
        'draft',
        author: 'u1',
        status: RecipeStatus.draft,
        title: '',
      );
      await addRecipe(
        'saved',
        author: 'lerato',
        title: 'Bobotie',
        cents: 80000,
        minutes: 20,
      );
      await addRecipe('stranger', author: 'someone', title: 'Not mine');
      await db
          .into(db.saves)
          .insert(
            SavesCompanion.insert(
              userId: 'u1',
              recipeId: 'saved',
              createdAt: DateTime.utc(2026, 11, 12),
            ),
          );
      await db
          .into(db.recipeTags)
          .insert(RecipeTagsCompanion.insert(recipeId: 'mine', tagId: 15));
    });

    test('lists your recipes and saves, never strangers', () async {
      final entries = await LibraryRepositoryImpl(db).watch('u1').first;

      expect(
        entries.map((e) => e.card.id),
        unorderedEquals(['mine', 'draft', 'saved']),
      );
      final draft = entries.firstWhere((e) => e.card.id == 'draft');
      expect(draft.isDraft, isTrue);
      expect(draft.stepsToGo, 3);
    });

    blocTest<RecipesCubit, RecipesState>(
      'tabs, quick filters and drafts first',
      build: () => RecipesCubit(
        library: LibraryRepositoryImpl(db),
        profiles: profiles,
        userId: 'u1',
      ),
      act: (c) async {
        c.start();
        await Future<void>.delayed(const Duration(milliseconds: 50));
      },
      verify: (c) {
        final s = c.state;
        expect(s.countFor(LibraryTab.all), 3);
        expect(s.countFor(LibraryTab.saved), 1);
        expect(s.countFor(LibraryTab.created), 2);
        expect(s.visible.first.card.id, 'draft');
        expect(
          s
              .copyWith(filters: {QuickFilter.veggie})
              .visible
              .map((e) => e.card.id),
          ['mine'],
        );
        expect(
          s
              .copyWith(filters: {QuickFilter.quick})
              .visible
              .map((e) => e.card.id),
          ['saved'],
        );
        expect(
          s
              .copyWith(filters: {QuickFilter.underR100})
              .visible
              .map((e) => e.card.id),
          ['mine'],
        );
        expect(s.copyWith(query: 'bobo').visible.single.card.id, 'saved');
      },
    );
  });

  group('SessionCubit.deleteAccount', () {
    late MockAuthRepository auth;
    late MockAppDatabase mockDb;
    late MockSettingsStore settings;

    setUpAll(() => registerFallbackValue(SettingKey.guest));

    setUp(() {
      auth = MockAuthRepository();
      mockDb = MockAppDatabase();
      settings = MockSettingsStore();
      when(() => mockDb.clearUserData()).thenAnswer((_) async {});
      when(() => settings.setFlag(any(), value: any(named: 'value')))
          .thenAnswer((_) async {});
    });

    SessionCubit build() => SessionCubit(
      auth: auth,
      profiles: MockProfileRepository(),
      settings: settings,
      sync: MockSyncService(),
      db: mockDb,
    );

    blocTest<SessionCubit, SessionState>(
      'clears the phone and signs out when the server agrees',
      setUp: () =>
          when(() => auth.deleteAccount())
              .thenAnswer((_) async => const Result.ok(null)),
      build: build,
      act: (c) => c.deleteAccount(),
      expect: () => [const SessionState(status: SessionStatus.signedOut)],
      verify: (_) => verify(() => mockDb.clearUserData()).called(1),
    );

    blocTest<SessionCubit, SessionState>(
      'keeps everything when the server says no',
      setUp: () =>
          when(() => auth.deleteAccount())
              .thenAnswer((_) async => Result.error(Exception('No signal.'))),
      build: build,
      act: (c) async => expect(await c.deleteAccount(), 'No signal.'),
      expect: () => <SessionState>[],
      verify: (_) => verifyNever(() => mockDb.clearUserData()),
    );
  });
}
