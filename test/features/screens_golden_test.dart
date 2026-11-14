import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/theme/app_theme.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/auth/presentation/pages/email_sign_in_page.dart';
import 'package:shared_plates_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/discover/presentation/pages/discover_page.dart';
import 'package:shared_plates_app/features/home/data/checklist_repository.dart';
import 'package:shared_plates_app/features/home/presentation/pages/home_page.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';
import 'package:shared_plates_app/features/search/presentation/pages/search_page.dart';

import '../helpers/fake_browse_api.dart';
import '../helpers/mocks.dart';

class _MockSession extends MockCubit<SessionState> implements SessionCubit;

class _MockProfile extends MockCubit<Profile?> implements CurrentProfileCubit;

final List<Tag> _tags = [
  for (final (i, t) in const [
    ('curry', 'Curries'),
    ('braai', 'Braai'),
    ('baking', 'Baking'),
  ].indexed)
    Tag(
      id: i + 1,
      slug: t.$1,
      label: t.$2,
      kind: TagKind.meal,
      updatedAt: DateTime.utc(2026),
    ),
];

JsonRow _rich(String id, String title, {int minutes = 40, int cents = 3700}) =>
    {
      ...cardRow(id, title: title),
      'total_minutes': minutes,
      'cost_per_plate': cents,
      'like_count': 284,
      'save_count': 1200,
      'note': 'Feeds 4 for R148!',
      'cover_style': id.hashCode.isEven ? 'stew' : 'meat',
    };

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late FakeBrowseApi api;
  late _MockSession session;
  late _MockProfile profile;
  late RecipeActionsCubit actions;

  setUp(() async {
    await sl.reset();
    db = AppDatabase(NativeDatabase.memory());
    api = FakeBrowseApi()
      ..collectionRows = [
        for (final (i, c) in const [
          ('under-r100', 'Under R100', 'Feeds four, honest'),
          ('ready-in-20', 'Ready in 20', 'Weeknight savers'),
          ('braai-night', 'Braai night', "Fire's on"),
          ('something-sweet', 'Something sweet', 'For after'),
        ].indexed)
          {
            'id': 'c$i',
            'slug': c.$1,
            'title': c.$2,
            'subtitle': c.$3,
            'kind': 'mood',
            'position': i,
          },
      ]
      ..trendingRows = [
        _rich('t1', 'Cape Malay chicken curry', minutes: 55),
        _rich('t2', 'Sticky braai chops'),
      ]
      ..searchRows = [
        _rich('s1', 'Creamy chicken penne', minutes: 25, cents: 2200),
        _rich('s2', 'Peri-peri chicken livers', minutes: 20, cents: 1900),
        _rich('s3', 'Chicken and butter bean curry', cents: 2400),
      ];
    final profiles = MockProfileRepository();
    when(profiles.watchTags).thenAnswer((_) => Stream.value(_tags));
    final outbox = OutboxStore(db);
    sl
      ..registerSingleton<BrowseRepository>(
        BrowseRepositoryImpl(
          api: api,
          db: db,
          outbox: outbox,
          currentUserId: () => null,
        ),
      )
      ..registerSingleton<ProfileRepository>(profiles)
      ..registerSingleton<AuthRepository>(MockAuthRepository())
      ..registerSingleton<ChecklistRepository>(
        ChecklistRepositoryImpl(db, AppSettingsStore(db)),
      );
    session = _MockSession();
    when(() => session.state)
        .thenReturn(const SessionState(status: SessionStatus.guest));
    profile = _MockProfile();
    when(() => profile.state).thenReturn(null);
    final actionsRepo = MockRecipeActionsRepository();
    actions = RecipeActionsCubit(actions: actionsRepo, session: session);
  });

  tearDown(() async {
    await actions.close();
    await db.close();
    await sl.reset();
  });

  Future<void> pumpScreen(
    WidgetTester tester,
    Widget page, {
    double height = 1200,
    bool wrap = true,
  }) async {
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: wrap ? Scaffold(body: DotGridBackground(child: page)) : page,
        ),
      ),
    );
    final context = tester.element(find.byType(MaterialApp));
    await tester.runAsync(() async {
      for (final mood in PaprikaMood.values) {
        await precacheImage(AssetImage(mood.asset), context);
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('home', (tester) async {
    await pumpScreen(tester, const HomePage(), height: 1320);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home.png'),
    );
  });

  testWidgets('discover', (tester) async {
    await pumpScreen(tester, const DiscoverPage(), height: 1180);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/discover.png'),
    );
  });

  testWidgets('search results', (tester) async {
    await pumpScreen(
      tester,
      const SearchPage(
        initial: SearchFilters(query: 'chicken', cost: CostLimit.r100),
      ),
      height: 844,
      wrap: false,
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/search_results.png'),
    );
  });

  testWidgets('search with no results', (tester) async {
    api.searchRows = [];
    await pumpScreen(
      tester,
      const SearchPage(initial: SearchFilters(query: 'umngqusho')),
      height: 844,
      wrap: false,
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/search_empty.png'),
    );
  });

  testWidgets('home offline with nothing cached', (tester) async {
    api.failure = const RemoteFailure('down', isTransient: true);
    await pumpScreen(tester, const HomePage(), height: 900);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home_offline.png'),
    );
  });

  testWidgets('welcome', (tester) async {
    await pumpScreen(tester, const WelcomePage(), height: 844, wrap: false);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/welcome.png'),
    );
  });

  testWidgets('email sign-in', (tester) async {
    await pumpScreen(tester, const EmailSignInPage(), height: 844, wrap: false);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/email_sign_in.png'),
    );
  });
}
