import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/recipe/data/cover_cache.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';
import 'package:shared_plates_app/features/recipe/domain/recipe_detail.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_detail_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/recipe_share.dart';

import '../../helpers/fake_browse_api.dart';
import '../../helpers/fake_remote_store.dart';
import '../../helpers/recipe_seed.dart';

class _MockRepo extends Mock implements RecipeDetailRepository {}

RecipeIngredient _ing(String id, double? q, String? unit, String raw) =>
    RecipeIngredient(
      id: id,
      recipeId: seedRecipeId,
      position: 0,
      rawText: raw,
      quantity: q,
      unit: unit,
      updatedAt: DateTime.utc(2026),
    );

final _card = RecipeCard(
  id: seedRecipeId,
  authorId: 'author',
  title: 'Cape Malay chicken curry',
  updatedAt: DateTime.utc(2026),
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('RecipeDetailRepository', () {
    late AppDatabase db;
    late OutboxStore outbox;
    late FakeRemoteStore remote;
    late SyncService sync;
    late RecipeDetailRepositoryImpl repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      outbox = OutboxStore(db);
      remote = FakeRemoteStore(userId: 'u1');
      sync = SyncService(
        db: db,
        outbox: outbox,
        remote: remote,
        debounce: const Duration(days: 1),
      );
      final api = FakeBrowseApi();
      repo = RecipeDetailRepositoryImpl(
        db: db,
        outbox: outbox,
        remote: remote,
        sync: sync,
        api: api,
        covers: CoverCache(db: db, api: api),
        clock: () => DateTime.utc(2026, 11, 14, 9),
      );
    });

    tearDown(() async {
      await sync.dispose();
      await db.close();
    });

    test('refresh caches the recipe with ordered children', () async {
      seedRecipe(remote);

      expect(await repo.refresh(seedRecipeId), isA<Ok<void>>());
      final detail = await repo.watch(seedRecipeId, viewerId: 'u1').first;

      expect(detail!.card.title, 'Cape Malay chicken curry');
      expect(detail.ingredients.map((i) => i.id), ['i1', 'i2', 'i3', 'i4']);
      expect(detail.steps.map((s) => s.id), ['s1', 's2']);
      expect(
        detail.ingredientsForStep('s1').map((i) => i.id),
        unorderedEquals(['i2', 'i3']),
      );
    });

    test('refresh offline reports a friendly error', () async {
      remote.failures.add(const RemoteFailure('down', isTransient: true));

      final result = await repo.refresh(seedRecipeId);

      expect((result as Error).error.toString(), contains('No signal'));
    });

    test('ticks are local first and queued', () async {
      seedRecipe(remote);
      await repo.refresh(seedRecipeId);

      await repo.setTick(
        uid: 'u1',
        recipeId: seedRecipeId,
        ingredientId: 'i2',
        ticked: true,
      );
      final detail = await repo.watch(seedRecipeId, viewerId: 'u1').first;

      expect(detail!.ticks, {'i2'});
      final queued = await outbox.due();
      expect(queued.single.target, 'shopping_ticks');
    });

    test('viewing records recently viewed once per recipe', () async {
      await repo.markViewed('u1', seedRecipeId);
      await repo.markViewed('u1', seedRecipeId);

      final rows = await db.select(db.recentlyViewed).get();
      expect(rows, hasLength(1));
      final queued = await outbox.due();
      expect(queued, hasLength(1));
      expect(
        (jsonDecode(queued.single.payload)
            as Map<String, dynamic>)['recipe_id'],
        seedRecipeId,
      );
    });

    test('save my version pulls the new copy', () async {
      seedRecipe(remote, authorId: 'u1');
      remote.rpcResults['fork_recipe'] = seedRecipeId;
      remote.seed('recipes', [
        {
          ...seedCard(authorId: 'u1'),
          'source': 'typed',
          'created_at': '2026-11-13T21:00:00Z',
        },
      ]);

      final result = await repo.fork('original');

      expect((result as Ok<String>).value, seedRecipeId);
      expect(await db.select(db.recipes).get(), hasLength(1));
    });

    test('units merge the server table over defaults', () async {
      await db
          .into(db.measureUnits)
          .insert(
            MeasureUnitsCompanion.insert(
              code: 'cup',
              label: 'cup',
              kind: UnitKind.volume,
              scope: UnitScope.both,
              toBase: 240,
              updatedAt: DateTime.utc(2026),
            ),
          );

      final units = await repo.units();

      expect(units['cup']!.toBase, 240);
      expect(units['g'], isNotNull);
    });
  });

  group('RecipeDetailCubit', () {
    late _MockRepo repo;
    final detail = RecipeDetail(
      card: _card.copyWith(baseServings: 4),
      ingredients: [_ing('i1', 400, 'g', '400 g tomatoes')],
    );

    setUp(() {
      repo = _MockRepo();
      when(() => repo.units()).thenAnswer((_) async => Measure.defaults);
      when(() => repo.watch(seedRecipeId, viewerId: any(named: 'viewerId')))
          .thenAnswer((_) => Stream.value(detail));
      when(() => repo.refresh(seedRecipeId))
          .thenAnswer((_) async => const Result.ok(null));
      when(() => repo.coverUrl(any())).thenAnswer((_) async => null);
    });

    RecipeDetailCubit build({String? viewer}) => RecipeDetailCubit(
      repository: repo,
      recipeId: seedRecipeId,
      viewerId: viewer,
    );

    blocTest<RecipeDetailCubit, RecipeDetailState>(
      'servings rescale every amount',
      build: build,
      act: (c) async {
        await c.start();
        c
          ..changeServings(2)
          ..changeServings(-10);
      },
      verify: (c) {
        expect(c.state.currentServings, 1);
        expect(c.state.amountFor(detail.ingredients.single), '100 g');
        expect(c.state.changeTick, 2);
      },
    );

    blocTest<RecipeDetailCubit, RecipeDetailState>(
      'switching units converts amounts',
      build: build,
      act: (c) async {
        await c.start();
        c.setUnits(UnitSystem.imperial);
      },
      verify: (c) =>
          expect(c.state.amountFor(detail.ingredients.single), '14 oz'),
    );

    blocTest<RecipeDetailCubit, RecipeDetailState>(
      'guests tick items on the phone only',
      build: build,
      act: (c) async {
        await c.start();
        await c.toggleTick('i1');
      },
      verify: (c) {
        expect(c.state.ticks, {'i1'});
        verifyNever(
          () => repo.setTick(
            uid: any(named: 'uid'),
            recipeId: any(named: 'recipeId'),
            ingredientId: any(named: 'ingredientId'),
            ticked: any(named: 'ticked'),
          ),
        );
      },
    );

    blocTest<RecipeDetailCubit, RecipeDetailState>(
      'a recipe that never loads shows an error',
      setUp: () {
        when(() => repo.watch(seedRecipeId, viewerId: any(named: 'viewerId')))
            .thenAnswer((_) => Stream.value(null));
        when(() => repo.refresh(seedRecipeId)).thenAnswer(
          (_) async => Result.error(Exception(RecipeMessages.offline)),
        );
      },
      build: build,
      act: (c) => c.start(),
      verify: (c) => expect(c.state.detail.error, RecipeMessages.offline),
    );

    blocTest<RecipeDetailCubit, RecipeDetailState>(
      'save my version reports a connection problem',
      setUp: () => when(() => repo.fork(seedRecipeId)).thenAnswer(
        (_) async => Result.error(Exception(RecipeMessages.forkOffline)),
      ),
      build: build,
      act: (c) => c.saveMyVersion(),
      verify: (c) => expect(c.state.fork.error, RecipeMessages.forkOffline),
    );
  });

  test('shopping list leaves out ticked items and scales amounts', () {
    final text = RecipeShare.shoppingList(
      card: _card,
      ingredients: [
        _ing('a', 2, null, '2 onions'),
        _ing('b', 1000, 'g', '1 kg chicken thighs'),
        _ing('c', null, null, 'Salt, to taste'),
      ],
      ticked: {'a'},
      amountFor: (i) => Measure.format(
        quantity: i.quantity,
        unit: i.unit,
        scale: 0.5,
        system: UnitSystem.metric,
      ),
      servings: 2,
    );

    expect(text, contains('(serves 2)'));
    expect(text, isNot(contains('onions')));
    expect(text, contains('• 500 g chicken thighs'));
    expect(text, contains('• Salt, to taste'));
    expect(text, contains('/r/$seedRecipeId'));
  });
}
