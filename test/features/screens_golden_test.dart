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
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/theme/app_theme.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/core/utils/screen_awake.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/auth/presentation/pages/email_sign_in_page.dart';
import 'package:shared_plates_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/cook/data/cook_repository.dart';
import 'package:shared_plates_app/features/cook/domain/cook_args.dart';
import 'package:shared_plates_app/features/cook/presentation/pages/cook_done_page.dart';
import 'package:shared_plates_app/features/cook/presentation/pages/cook_mode_page.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/data/photo_store.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';
import 'package:shared_plates_app/features/create/presentation/pages/create_start_page.dart';
import 'package:shared_plates_app/features/create/presentation/pages/paste_page.dart';
import 'package:shared_plates_app/features/create/presentation/pages/recipe_editor_page.dart';
import 'package:shared_plates_app/features/create/presentation/pages/recipe_shared_page.dart';
import 'package:shared_plates_app/features/discover/presentation/pages/discover_page.dart';
import 'package:shared_plates_app/features/home/data/checklist_repository.dart';
import 'package:shared_plates_app/features/home/presentation/pages/home_page.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/recipe/data/cover_cache.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/pages/recipe_page.dart';
import 'package:shared_plates_app/features/search/presentation/pages/search_page.dart';

import '../helpers/create_seed.dart';
import '../helpers/fake_browse_api.dart';
import '../helpers/fake_remote_store.dart';
import '../helpers/mocks.dart';
import '../helpers/recipe_seed.dart';

class _MockSession extends MockCubit<SessionState> implements SessionCubit {}

class _MockProfile extends MockCubit<Profile?> implements CurrentProfileCubit {}

class _MockCooks extends Mock implements CookRepository {}

const _paste = '''
Gran's chakalaka
serves 6 as a side
Ingredients
2 tbsp sunflower oil
1 large onion, diced
2 green peppers, diced
3 carrots, grated
Method
1. Heat the oil in a big pan and fry the onion until soft, about 5 minutes.
2. Add the peppers and carrots. Cook for 5 minutes, stirring now and then.
3. Stir in the beans and tomatoes and simmer for 10 min.
Mom always adds a spoon of chutney at the end''';

class _NoPhotos implements PhotoStore {
  @override
  Future<String?> pick(PhotoSource source, {required String recipeId}) async =>
      null;
}

class _StillScreen implements ScreenAwake {
  @override
  Future<void> keepOn() async {}

  @override
  Future<void> release() async {}
}

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
    final cooks = _MockCooks();
    when(() => cooks.cooksThisMonth(any())).thenAnswer((_) async => 2);
    when(
      () => cooks.logCook(
        uid: any(named: 'uid'),
        recipeId: any(named: 'recipeId'),
        servings: any(named: 'servings'),
        toldCreator: any(named: 'toldCreator'),
      ),
    ).thenAnswer((_) async => const Result.ok('c1'));
    final profiles = MockProfileRepository();
    when(profiles.watchTags).thenAnswer((_) => Stream.value(_tags));
    final outbox = OutboxStore(db);
    final recipeRemote = FakeRemoteStore();
    seedRecipe(recipeRemote);
    await db
        .into(db.tags)
        .insert(
          TagsCompanion.insert(
            id: const Value(1),
            slug: 'curry',
            label: 'Curries',
            kind: TagKind.cuisine,
            coverStyle: CoverStyle.stew,
            updatedAt: DateTime.utc(2026),
          ),
        );
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
      ..registerSingleton<RecipeDetailRepository>(
        RecipeDetailRepositoryImpl(
          db: db,
          outbox: outbox,
          remote: recipeRemote,
          sync: SyncService(db: db, outbox: outbox, remote: recipeRemote),
          api: api,
          covers: CoverCache(db: db, api: api),
        ),
      )
      ..registerSingleton<ChecklistRepository>(
        ChecklistRepositoryImpl(db, AppSettingsStore(db)),
      )
      ..registerSingleton<CookRepository>(cooks)
      ..registerSingleton<ScreenAwake>(_StillScreen())
      ..registerSingleton<CreateRepository>(
        CreateRepositoryImpl(
          db: db,
          outbox: outbox,
          sync: SyncService(db: db, outbox: outbox, remote: recipeRemote),
          clock: () => DateTime.utc(2026, 11, 14, 10),
        ),
      )
      ..registerSingleton<PhotoStore>(_NoPhotos());
    await seedFoodLibrary(db, tags: false);
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
      for (final svg in [
        'assets/brand/logo.svg',
        'assets/brand/apple.svg',
        'assets/brand/google.svg',
        for (final style in CoverStyle.values) style.asset,
      ]) {
        await vg.loadPicture(SvgAssetLoader(svg), null);
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

  testWidgets('cook mode', (tester) async {
    await tester.runAsync(
      () => sl<RecipeDetailRepository>().refresh(seedRecipeId),
    );
    await pumpScreen(
      tester,
      const CookModePage(
        recipeId: seedRecipeId,
        args: CookArgs(servings: 4, units: UnitSystem.metric),
      ),
      height: 844,
      wrap: false,
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/cook_mode.png'),
    );
  });

  testWidgets('cook finished', (tester) async {
    when(() => session.state).thenReturn(
      const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
    );
    await pumpScreen(
      tester,
      CookDonePage(
        args: CookedArgs(card: RecipeCard.fromJson(seedCard()), servings: 4),
      ),
      height: 844,
      wrap: false,
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/cook_done.png'),
    );
  });

  Future<void> seedDrafts() async {
    final repo = sl<CreateRepository>();
    final library = await repo.library();
    RecipeDraft draft(String id, String title, {bool published = false}) =>
        RecipeDraft(
          id: id,
          title: title,
          servings: 6,
          totalMinutes: 35,
          coverStyle: CoverStyle.veg,
          status: published ? RecipeStatus.published : RecipeStatus.draft,
          tagIds: const {1},
          ingredients: [
            DraftIngredient.fromLine(
              '$id-1',
              '2 tbsp sunflower oil',
              library: library,
              costCents: 200,
            ),
            DraftIngredient.fromLine(
              '$id-2',
              '1 large onion, diced',
              library: library,
              costCents: 400,
            ),
            DraftIngredient.fromLine(
              '$id-3',
              '3 carrots, grated',
              library: library,
              costCents: 600,
            ),
            DraftIngredient.fromLine(
              '$id-4',
              '1 tsp mild curry spice',
              library: library,
            ),
          ],
          steps: [
            DraftStep(
              id: '$id-s1',
              body:
                  'Heat the oil in a big pan and fry the onion until soft, '
                  'about 5 minutes.',
            ),
            DraftStep(
              id: '$id-s2',
              body: 'Add the carrots and spice. Simmer for 10 min.',
            ),
          ],
        );
    await repo.save('u1', draft('d1', "Gran's chakalaka"), library);
    await repo.save(
      'u1',
      const RecipeDraft(id: 'd2', title: 'Malva pudding'),
      library,
    );
    await repo.save(
      'u1',
      draft('p1', "Gran's chakalaka", published: true),
      library,
    );
  }

  void signIn() => when(() => session.state).thenReturn(
    const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
  );

  testWidgets('create start', (tester) async {
    signIn();
    await tester.runAsync(seedDrafts);
    await pumpScreen(
      tester,
      const CreateStartPage(),
      height: 1000,
      wrap: false,
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/create_start.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('paste review', (tester) async {
    signIn();
    await pumpScreen(tester, const PastePage(), height: 1300, wrap: false);
    await tester.enterText(find.byType(TextField), _paste);
    await tester.tap(find.text('Split it up'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/create_paste.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('recipe editor', (tester) async {
    signIn();
    await tester.runAsync(seedDrafts);
    await pumpScreen(
      tester,
      const RecipeEditorPage(recipeId: 'd1'),
      height: 2500,
      wrap: false,
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/create_editor.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('recipe shared', (tester) async {
    signIn();
    await tester.runAsync(seedDrafts);
    await pumpScreen(
      tester,
      const RecipeSharedPage(recipeId: 'p1'),
      height: 844,
      wrap: false,
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/create_shared.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('recipe page', (tester) async {
    await pumpScreen(
      tester,
      const RecipePage(recipeId: seedRecipeId),
      height: 2300,
      wrap: false,
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/recipe.png'),
    );
  });
}
