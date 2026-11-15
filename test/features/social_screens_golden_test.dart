@Tags(['golden'])
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/core/db/app_database.dart' hide Tags;
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/theme/app_theme.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/features/activity/data/activity_repository.dart';
import 'package:shared_plates_app/features/activity/presentation/bloc/activity_cubit.dart';
import 'package:shared_plates_app/features/activity/presentation/pages/activity_page.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';
import 'package:shared_plates_app/features/friends/presentation/pages/friends_page.dart';
import 'package:shared_plates_app/features/friends/presentation/pages/person_page.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/profile/presentation/pages/profile_page.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';
import 'package:shared_plates_app/features/recipes/data/library_repository.dart';
import 'package:shared_plates_app/features/recipes/presentation/pages/recipes_page.dart';
import 'package:shared_plates_app/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:shared_plates_app/features/settings/presentation/pages/settings_page.dart';

import '../helpers/fake_browse_api.dart';
import '../helpers/fake_remote_store.dart';
import '../helpers/mocks.dart';
import '../helpers/social_seed.dart';

class _MockSession extends MockCubit<SessionState> implements SessionCubit;

class _MockProfile extends MockCubit<Profile?> implements CurrentProfileCubit;

final _me = Profile(
  id: 'u1',
  username: 'thandi.cooks',
  displayName: 'Thandi Nkosi',
  city: 'Cape Town',
  bio: 'Budget suppers + anything my gran made',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late _MockSession session;
  late _MockProfile profile;
  late RecipeActionsCubit actions;
  late ThemeModeCubit theme;
  late ActivityBadgeCubit badge;
  late SyncService sync;

  Future<void> seedLibrary() async {
    Future<void> add(
      String id,
      String title, {
      String author = 'u1',
      RecipeStatus status = RecipeStatus.published,
      CoverStyle style = CoverStyle.stew,
      int saves = 0,
      int cooks = 0,
      int? cents,
      String? authorName,
    }) => db
        .into(db.recipes)
        .insert(
          RecipesCompanion.insert(
            id: id,
            authorId: author,
            title: Value(title),
            coverStyle: style,
            visibility: RecipeVisibility.friends,
            status: status,
            source: RecipeSource.typed,
            saveCount: Value(saves),
            cookCount: Value(cooks),
            costCents: Value(cents),
            authorName: Value(authorName),
            createdAt: DateTime.utc(2026, 11, 10),
            updatedAt: DateTime.utc(2026, 11, 10, saves),
          ),
        );
    await add('d1', "Gran's malva pudding", status: RecipeStatus.draft);
    await add(
      'm1',
      "Gran's chakalaka",
      style: CoverStyle.veg,
      saves: 32,
      cooks: 5,
      cents: 6600,
    );
    await add(
      's1',
      'Cape Malay chicken curry',
      author: 'lerato',
      authorName: 'Lerato Mokoena',
      cents: 14800,
    );
    await add(
      'm2',
      'Pantry tomato pasta',
      style: CoverStyle.any,
      saves: 9,
      cooks: 1,
      cents: 5600,
    );
    await db
        .into(db.saves)
        .insert(
          SavesCompanion.insert(
            userId: 'u1',
            recipeId: 's1',
            createdAt: DateTime.utc(2026, 11, 12),
          ),
        );
  }

  setUp(() async {
    await sl.reset();
    db = AppDatabase(NativeDatabase.memory());
    final remote = FakeRemoteStore(userId: 'u1');
    seedFriends(remote);
    remote.seed('notifications', [
      {
        'id': 'n1',
        'recipient_id': 'u1',
        'actor_id': 'sipho',
        'kind': 'recipe_saved',
        'recipe_id': 'f1',
        'data': <String, dynamic>{},
        'read_at': null,
        'created_at': DateTime.now()
            .toUtc()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
      },
      {
        'id': 'n2',
        'recipient_id': 'u1',
        'actor_id': null,
        'kind': 'weekly_roundup',
        'recipe_id': null,
        'data': {'saves': 12, 'cooks': 3},
        'read_at': null,
        'created_at': DateTime.now()
            .toUtc()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      },
      {
        'id': 'n3',
        'recipient_id': 'u1',
        'actor_id': 'sipho',
        'kind': 'friend_request',
        'recipe_id': null,
        'data': <String, dynamic>{},
        'read_at': DateTime.now()
            .toUtc()
            .subtract(const Duration(days: 10))
            .toIso8601String(),
        'created_at': DateTime.now()
            .toUtc()
            .subtract(const Duration(days: 10))
            .toIso8601String(),
      },
    ]);
    final api = FakeBrowseApi();
    final outbox = OutboxStore(db);
    final settings = AppSettingsStore(db);
    sync = SyncService(
      db: db,
      outbox: outbox,
      remote: remote,
      debounce: const Duration(days: 1),
    );
    final profiles = ProfileRepositoryImpl(
      db: db,
      outbox: outbox,
      remote: remote,
      sync: sync,
      settings: settings,
    );
    sl
      ..registerSingleton<AppSettingsStore>(settings)
      ..registerSingleton<ProfileRepository>(profiles)
      ..registerSingleton<LibraryRepository>(LibraryRepositoryImpl(db))
      ..registerSingleton<FriendsRepository>(
        FriendsRepositoryImpl(remote: remote, api: api, db: db),
      )
      ..registerSingleton<ActivityRepository>(
        ActivityRepositoryImpl(remote: remote, api: api, db: db),
      )
      ..registerSingleton<BrowseRepository>(
        BrowseRepositoryImpl(
          api: api,
          db: db,
          outbox: outbox,
          currentUserId: () => 'u1',
        ),
      );
    await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            id: 'u1',
            username: _me.username,
            displayName: _me.displayName,
            units: UnitSystem.metric,
            defaultVisibility: RecipeVisibility.friends,
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
          ),
        );
    await seedLibrary();
    session = _MockSession();
    when(() => session.state).thenReturn(
      const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
    );
    profile = _MockProfile();
    when(() => profile.state).thenReturn(_me);
    final actionsRepo = MockRecipeActionsRepository();
    when(() => actionsRepo.watchSavedIds(any()))
        .thenAnswer((_) => Stream.value({'s1'}));
    when(() => actionsRepo.watchLikedIds(any()))
        .thenAnswer((_) => Stream.value(const <String>{}));
    actions = RecipeActionsCubit(actions: actionsRepo, session: session);
    theme = ThemeModeCubit(settings);
    badge = ActivityBadgeCubit(activity: sl<ActivityRepository>());
  });

  tearDown(() async {
    await actions.close();
    await theme.close();
    await badge.close();
    await sync.dispose();
    await db.close();
    await sl.reset();
  });

  Future<void> pump(WidgetTester tester, Widget page, double height) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = Size(390, height);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<SessionCubit>.value(value: session),
          BlocProvider<CurrentProfileCubit>.value(value: profile),
          BlocProvider.value(value: actions),
          BlocProvider.value(value: theme),
          BlocProvider.value(value: badge),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: page,
        ),
      ),
    );
    final context = tester.element(find.byType(MaterialApp));
    await tester.runAsync(() async {
      for (final mood in PaprikaMood.values) {
        await precacheImage(AssetImage(mood.asset), context);
      }
      for (final style in CoverStyle.values) {
        await vg.loadPicture(SvgAssetLoader(style.asset), null);
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  final screens = <String, (Widget, double)>{
    'recipes_tab': (const RecipesPage(), 1080),
    'friends_tab': (const FriendsPage(), 1240),
    'person': (const PersonPage(personId: 'lerato'), 960),
    'activity': (const ActivityPage(), 844),
    'profile': (const ProfilePage(), 1000),
  };

  for (final MapEntry(key: name, value: (page, height)) in screens.entries) {
    testWidgets(name, (tester) async {
      await pump(tester, page, height);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/$name.png'),
      );
      await finish(tester);
    });
  }

  testWidgets('settings', (tester) async {
    late SettingsCubit cubit;
    await tester.runAsync(() async {
      cubit = SettingsCubit(
        profiles: sl<ProfileRepository>(),
        settings: sl<AppSettingsStore>(),
        userId: 'u1',
      )..start();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await pump(
      tester,
      BlocProvider.value(value: cubit, child: const SettingsView()),
      1780,
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/settings.png'),
    );
    await finish(tester);
    await tester.runAsync(cubit.close);
  });
}
