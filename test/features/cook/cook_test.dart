import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/core/utils/screen_awake.dart';
import 'package:shared_plates_app/features/cook/data/cook_repository.dart';
import 'package:shared_plates_app/features/cook/domain/step_text.dart';
import 'package:shared_plates_app/features/cook/presentation/bloc/cook_done_cubit.dart';
import 'package:shared_plates_app/features/cook/presentation/bloc/cook_mode_cubit.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';
import 'package:shared_plates_app/features/recipe/domain/recipe_detail.dart';

import '../../helpers/fake_remote_store.dart';

class _MockDetailRepo extends Mock implements RecipeDetailRepository {}

class _MockCookRepo extends Mock implements CookRepository {}

class _MockScreen extends Mock implements ScreenAwake {}

final _card = RecipeCard(
  id: 'r1',
  authorId: 'author',
  authorName: 'Lerato Mokoena',
  title: 'Cape Malay chicken curry',
  updatedAt: DateTime.utc(2026),
);

RecipeStep _step(String id, int position, String body, {int? timer}) =>
    RecipeStep(
      id: id,
      recipeId: 'r1',
      position: position,
      body: body,
      timerSeconds: timer,
      updatedAt: DateTime.utc(2026),
    );

final _detail = RecipeDetail(
  card: _card,
  ingredients: [
    RecipeIngredient(
      id: 'i1',
      recipeId: 'r1',
      position: 0,
      rawText: '2 onions, sliced',
      quantity: 2,
      updatedAt: DateTime.utc(2026),
    ),
    RecipeIngredient(
      id: 'i2',
      recipeId: 'r1',
      position: 1,
      rawText: '30 ml sunflower oil',
      quantity: 30,
      unit: 'ml',
      updatedAt: DateTime.utc(2026),
    ),
  ],
  steps: [
    _step('s1', 0, 'Heat the oil and soften the onions for 8 minutes.'),
    _step('s2', 1, 'Add the chicken.', timer: 90),
    _step('s3', 2, 'Season and serve.'),
  ],
  stepIngredients: const {
    's1': ['i1', 'i2'],
  },
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('StepText.highlight', () {
    test('marks ingredient names in the step', () {
      final parts = StepText.highlight('Heat the oil and soften the onions.', [
        '30 ml sunflower oil',
        '2 onions, sliced',
      ]);

      expect(parts.where((p) => p.$2).map((p) => p.$1), ['oil', 'onions']);
      expect(
        parts.map((p) => p.$1).join(),
        'Heat the oil and soften the onions.',
      );
    });

    test('prefers the longest phrase, then words and plurals', () {
      final thighs = StepText.highlight('Brown the chicken thighs well.', [
        '1 kg bone-in chicken thighs',
      ]);
      final tomato = StepText.highlight('Add a tomato.', ['3 tomatoes']);

      expect(thighs.where((p) => p.$2).single.$1, 'chicken thighs');
      expect(tomato.where((p) => p.$2).single.$1, 'tomato');
    });

    test('leaves plain steps untouched', () {
      expect(StepText.highlight('Serve hot.', ['Salt']), [
        ('Serve hot.', false),
      ]);
    });
  });

  group('CookModeCubit', () {
    late _MockDetailRepo repo;
    late _MockScreen screen;
    late DateTime now;

    setUp(() {
      repo = _MockDetailRepo();
      screen = _MockScreen();
      now = DateTime.utc(2026, 11, 14, 18);
      when(() => repo.units()).thenAnswer((_) async => Measure.defaults);
      when(() => repo.watch('r1', viewerId: any(named: 'viewerId')))
          .thenAnswer((_) => Stream.value(_detail));
      when(() => screen.keepOn()).thenAnswer((_) async {});
      when(() => screen.release()).thenAnswer((_) async {});
    });

    CookModeCubit build({bool keepOn = true, int? servings}) => CookModeCubit(
      repository: repo,
      recipeId: 'r1',
      screen: screen,
      keepScreenOn: keepOn,
      servings: servings,
      clock: () => now,
      tickEvery: const Duration(days: 1),
    );

    blocTest<CookModeCubit, CookModeState>(
      'keeps the screen on while open and lets go on close',
      build: build,
      act: (c) => c.start(),
      verify: (_) {
        verify(() => screen.keepOn()).called(1);
        verify(() => screen.release()).called(1);
      },
    );

    blocTest<CookModeCubit, CookModeState>(
      'respects the keep screen on setting',
      build: () => build(keepOn: false),
      act: (c) => c.start(),
      verify: (_) {
        verifyNever(() => screen.keepOn());
        verifyNever(() => screen.release());
      },
    );

    blocTest<CookModeCubit, CookModeState>(
      'moves between steps and stays in bounds',
      build: build,
      act: (c) async {
        await c.start();
        c
          ..back()
          ..next()
          ..next()
          ..next()
          ..back();
      },
      verify: (c) {
        expect(c.state.step, 1);
        expect(c.state.direction, -1);
        expect(c.state.isLast, isFalse);
      },
    );

    blocTest<CookModeCubit, CookModeState>(
      'reads timers from the step text or the explicit value',
      build: build,
      act: (c) => c.start(),
      verify: (c) {
        expect(c.state.timerFor(0)!.total, 480);
        expect(c.state.timerFor(1)!.total, 90);
        expect(c.state.timerFor(2), isNull);
      },
    );

    blocTest<CookModeCubit, CookModeState>(
      'scales what you need for each step',
      build: () => build(servings: 8),
      act: (c) => c.start(),
      verify: (c) {
        final needs = c.state.needsFor(0).map(c.state.labelFor);
        expect(needs, ['4 onions, sliced', '60 ml sunflower oil']);
      },
    );

    blocTest<CookModeCubit, CookModeState>(
      'a timer counts down, pauses, and rings when done',
      build: build,
      act: (c) async {
        await c.start();
        c.toggleTimer();
        now = now.add(const Duration(seconds: 100));
        c
          ..tick()
          ..toggleTimer();
        now = now.add(const Duration(minutes: 30));
        c
          ..tick()
          ..toggleTimer();
        now = now.add(const Duration(seconds: 380));
        c.tick();
      },
      verify: (c) {
        final timer = c.state.timers[0]!;
        expect(timer.finished, isTrue);
        expect(timer.running, isFalse);
        expect(c.state.alarmTick, 1);
        expect(c.state.alarmStep, 0);
      },
    );

    blocTest<CookModeCubit, CookModeState>(
      'timers keep running on other steps',
      build: build,
      act: (c) async {
        await c.start();
        c
          ..toggleTimer()
          ..next();
        now = now.add(const Duration(seconds: 60));
        c.tick();
      },
      verify: (c) {
        expect(c.state.runningElsewhere, [0]);
        expect(c.state.timers[0]!.remaining, 420);
      },
    );

    blocTest<CookModeCubit, CookModeState>(
      'a recipe with no steps cannot be cooked',
      setUp: () =>
          when(() => repo.watch('r1', viewerId: any(named: 'viewerId')))
              .thenAnswer((_) => Stream.value(RecipeDetail(card: _card))),
      build: build,
      act: (c) => c.start(),
      verify: (c) => expect(c.state.detail.error, CookModeCubit.missing),
    );
  });

  group('CookRepository', () {
    late AppDatabase db;
    late OutboxStore outbox;
    late SyncService sync;
    late CookRepositoryImpl repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      outbox = OutboxStore(db);
      sync = SyncService(
        db: db,
        outbox: outbox,
        remote: FakeRemoteStore(userId: 'u1'),
        debounce: const Duration(days: 1),
      );
      repo = CookRepositoryImpl(
        db: db,
        outbox: outbox,
        sync: sync,
        clock: () => DateTime(2026, 11, 14, 19),
      );
    });

    tearDown(() async {
      await sync.dispose();
      await db.close();
    });

    test('logs a cook locally and queues it once', () async {
      final result = await repo.logCook(
        uid: 'u1',
        recipeId: 'r1',
        servings: 6,
        toldCreator: true,
      );

      final id = (result as Ok<String>).value;
      final row = await db.select(db.cooks).getSingle();
      expect(row.id, id);
      expect(row.toldCreator, isTrue);
      final queued = await outbox.due();
      expect(queued.single.target, 'cooks');
      final payload = jsonDecode(queued.single.payload) as Map<String, dynamic>;
      expect(payload['told_creator'], isTrue);
      expect(payload['servings'], 6);
    });

    test('counts only this month', () async {
      await db
          .into(db.cooks)
          .insert(
            CooksCompanion.insert(
              id: 'old',
              userId: 'u1',
              recipeId: 'r1',
              cookedAt: DateTime(2026, 10, 30),
            ),
          );
      await repo.logCook(
        uid: 'u1',
        recipeId: 'r1',
        servings: 4,
        toldCreator: false,
      );

      expect(await repo.cooksThisMonth('u1'), 1);
    });
  });

  group('CookDoneCubit', () {
    late _MockCookRepo cooks;
    late _MockDetailRepo recipes;

    setUp(() {
      cooks = _MockCookRepo();
      recipes = _MockDetailRepo();
      when(() => cooks.cooksThisMonth('u1')).thenAnswer((_) async => 2);
      when(
        () => cooks.logCook(
          uid: any(named: 'uid'),
          recipeId: any(named: 'recipeId'),
          servings: any(named: 'servings'),
          toldCreator: any(named: 'toldCreator'),
        ),
      ).thenAnswer((_) async => const Result.ok('c1'));
    });

    CookDoneCubit build({String? uid = 'u1', RecipeCard? card}) =>
        CookDoneCubit(
          cooks: cooks,
          recipes: recipes,
          card: card ?? _card,
          servings: 6,
          userId: uid,
        );

    blocTest<CookDoneCubit, CookDoneState>(
      'counts this cook in the month total',
      build: build,
      act: (c) => c.load(),
      verify: (c) => expect(c.state.monthCount, 3),
    );

    blocTest<CookDoneCubit, CookDoneState>(
      'logs once with the creator choice',
      build: build,
      act: (c) async {
        c.setToldCreator(value: false);
        await c.finish();
        c.setToldCreator(value: true);
        await c.finish();
      },
      verify: (c) {
        expect(c.state.logged, isTrue);
        expect(c.state.toldCreator, isFalse);
        verify(
          () => cooks.logCook(
            uid: 'u1',
            recipeId: 'r1',
            servings: 6,
            toldCreator: false,
          ),
        ).called(1);
      },
    );

    blocTest<CookDoneCubit, CookDoneState>(
      'never tells yourself about your own recipe',
      build: () => build(card: _card.copyWith(isMine: true)),
      act: (c) => c.finish(),
      verify: (_) => verify(
        () => cooks.logCook(
          uid: 'u1',
          recipeId: 'r1',
          servings: 6,
          toldCreator: false,
        ),
      ).called(1),
    );

    blocTest<CookDoneCubit, CookDoneState>(
      'guests are not logged',
      build: () => build(uid: null),
      act: (c) async {
        await c.load();
        await c.finish();
      },
      verify: (c) {
        expect(c.state.monthCount, isNull);
        verifyNever(
          () => cooks.logCook(
            uid: any(named: 'uid'),
            recipeId: any(named: 'recipeId'),
            servings: any(named: 'servings'),
            toldCreator: any(named: 'toldCreator'),
          ),
        );
      },
    );

    blocTest<CookDoneCubit, CookDoneState>(
      'save my version logs the cook first',
      setUp: () =>
          when(() => recipes.fork('r1'))
              .thenAnswer((_) async => const Result.ok('r2')),
      build: build,
      act: (c) => c.saveMyVersion(),
      verify: (c) {
        expect(c.state.fork.value, 'r2');
        expect(c.state.logged, isTrue);
      },
    );
  });
}
