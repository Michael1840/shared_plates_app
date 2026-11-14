import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/data/photo_store.dart';
import 'package:shared_plates_app/features/create/domain/food_matcher.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';
import 'package:shared_plates_app/features/create/domain/recipe_parser.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/paste_cubit.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/recipe_editor_cubit.dart';

import '../../helpers/create_seed.dart';
import '../../helpers/fake_remote_store.dart';

class _FakePhotos implements PhotoStore {
  String? next;

  @override
  Future<String?> pick(PhotoSource source, {required String recipeId}) async =>
      next;
}

const _chakalaka = '''
Gran's chakalaka
Serves 6
Takes 35 min
Ingredients
2 tbsp sunflower oil
1 onion, diced
3 carrots, grated
Method
1. Heat the oil and fry the onion for 5 minutes.
2. Add the carrots and simmer for 10 min.
Mom always adds a spoon of chutney at the end''';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late OutboxStore outbox;
  late FakeRemoteStore remote;
  late SyncService sync;
  late CreateRepositoryImpl repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    outbox = OutboxStore(db);
    remote = FakeRemoteStore(userId: 'u1');
    sync = SyncService(
      db: db,
      outbox: outbox,
      remote: remote,
      debounce: const Duration(days: 1),
    );
    repo = CreateRepositoryImpl(
      db: db,
      outbox: outbox,
      sync: sync,
      clock: () => DateTime.utc(2026, 11, 14, 10),
    );
    await seedFoodLibrary(db);
  });

  tearDown(() async {
    await sync.dispose();
    await db.close();
  });

  RecipeDraft draftWith(FoodLibrary library, {String id = 'r1'}) => RecipeDraft(
    id: id,
    title: "Gran's chakalaka",
    servings: 6,
    ingredients: [
      DraftIngredient.fromLine(
        'i1',
        '2 tbsp sunflower oil',
        library: library,
        costCents: 200,
      ),
      DraftIngredient.fromLine('i2', '1 onion, diced', library: library),
      DraftIngredient.fromLine(
        'i3',
        '3 carrots, grated',
        library: library,
        costCents: 600,
      ),
    ],
    steps: const [
      DraftStep(id: 's1', body: 'Fry the onion in the oil for 5 minutes.'),
      DraftStep(id: 's2', body: 'Add the carrots.'),
      DraftStep(id: 's3', body: '   '),
    ],
    tagIds: const {15},
  );

  group('FoodLibrary', () {
    test('matches by name or alias and prefers the specific food', () async {
      final library = await repo.library();

      expect(library.match('sunflower oil')?.food.id, 'f-oil');
      expect(library.match('oil')?.food.id, 'f-oil');
      expect(library.match('bone-in chicken thighs')?.food.id, 'f-chicken');
      expect(library.match('Rajah mild & spicy'), isNull);
    });

    test('suggests a near miss without matching it', () async {
      final library = await repo.library();

      expect(library.match('mild curry'), isNull);
      expect(library.suggest('mild curry')?.food.id, 'f-curry');
    });

    test('works out grams by unit, density and portion', () async {
      final library = await repo.library();

      expect(
        library.gramsFor(
          foodId: 'f-oil',
          quantity: 2,
          unit: 'tbsp',
          portion: null,
        ),
        closeTo(27.6, 0.01),
      );
      expect(
        library.gramsFor(
          foodId: 'f-onion',
          quantity: 2,
          unit: null,
          portion: null,
        ),
        300,
      );
    });
  });

  group('CreateRepository', () {
    test('saves locally and queues one snapshot per recipe', () async {
      final library = await repo.library();
      final draft = draftWith(library);

      await repo.save('u1', draft, library);
      await repo.save('u1', draft.copyWith(title: 'Chakalaka'), library);

      final row = await db.select(db.recipes).getSingle();
      expect(row.title, 'Chakalaka');
      expect(row.costCents, 800);
      expect(row.kcalPerServing, isNotNull);
      expect(await db.select(db.recipeSteps).get(), hasLength(2));
      final links = await db.select(db.stepIngredients).get();
      expect(
        links.map((l) => '${l.stepId}:${l.ingredientId}'),
        unorderedEquals(['s1:i1', 's1:i2', 's2:i3']),
      );
      final queued = await outbox.due();
      expect(queued, hasLength(1));
      final snapshot =
          jsonDecode(queued.single.payload) as Map<String, dynamic>;
      expect((snapshot['recipe'] as Map)['title'], 'Chakalaka');
      expect(snapshot['tags'], [15]);
    });

    test('loads a draft back as it was written', () async {
      final library = await repo.library();
      await repo.save('u1', draftWith(library), library);

      final loaded = await repo.load('r1');

      expect(loaded!.ingredients.map((i) => i.id), ['i1', 'i2', 'i3']);
      expect(loaded.ingredients.first.foodId, 'f-oil');
      expect(loaded.ingredients.first.costCents, 200);
      expect(loaded.steps.map((s) => s.body).first, startsWith('Fry'));
      expect(loaded.tagIds, {15});
    });

    test('lists drafts with how much is left to do', () async {
      final library = await repo.library();
      await repo.save(
        'u1',
        const RecipeDraft(id: 'blank-ish', title: 'Soup'),
        library,
      );
      await repo.save('u1', draftWith(library), library);

      final drafts = await repo.watchDrafts('u1').first;

      final soup = drafts.firstWhere((d) => d.card.id == 'blank-ish');
      expect(soup.stepsToGo, 2);
      expect(drafts.firstWhere((d) => d.card.id == 'r1').stepsToGo, 0);
    });

    test('discarding a draft drops its pending sync and deletes it', () async {
      final library = await repo.library();
      await repo.save('u1', draftWith(library), library);

      await repo.discard('r1');

      expect(await db.select(db.recipes).get(), isEmpty);
      final queued = await outbox.due();
      expect(queued.single.kind, OutboxKind.delete);
    });
  });

  group('SyncService recipe snapshot', () {
    test('creates the recipe and its children', () async {
      final library = await repo.library();
      await repo.save('u1', draftWith(library), library);

      final report = await sync.pushOutbox();

      expect(report.pushed, 1);
      expect(remote.tables['recipes']!.single['title'], "Gran's chakalaka");
      expect(remote.tables['recipe_ingredients'], hasLength(3));
      expect(remote.tables['recipe_steps'], hasLength(2));
      expect(remote.tables['step_ingredients'], hasLength(3));
      expect(remote.tables['recipe_tags']!.single['tag_id'], 15);
    });

    test('removes children that were deleted in the editor', () async {
      final library = await repo.library();
      final draft = draftWith(library);
      await repo.save('u1', draft, library);
      await sync.pushOutbox();

      await repo.save(
        'u1',
        draft.copyWith(
          ingredients: draft.ingredients.take(2).toList(),
          steps: [draft.steps.first],
          tagIds: const {},
        ),
        library,
      );
      await sync.pushOutbox();

      expect(remote.tables['recipe_ingredients'], hasLength(2));
      expect(remote.tables['recipe_steps'], hasLength(1));
      expect(
        remote.tables['step_ingredients']!.where((l) => l['step_id'] == 's1'),
        hasLength(2),
      );
      expect(remote.tables['recipe_tags'], isEmpty);
    });

    test('uploads the photo after the recipe exists', () async {
      final dir = await Directory.systemTemp.createTemp('sp-cover');
      addTearDown(() => dir.delete(recursive: true));
      final photo = File('${dir.path}/r1-123.jpg')..writeAsBytesSync([1, 2, 3]);
      final library = await repo.library();
      await repo.save(
        'u1',
        draftWith(library).copyWith(localCoverPath: photo.path),
        library,
      );

      await sync.pushOutbox();

      const path = 'u1/r1/cover-r1-123.jpg';
      expect(remote.uploads['recipe-photos/$path'], 3);
      expect(remote.tables['recipes']!.single['cover_path'], path);
      expect((await db.select(db.recipes).getSingle()).coverPath, path);
      final order = [
        for (final c in remote.calls)
          if (c.method == 'upload' ||
              (c.method == 'upsert' && c.target == 'recipes'))
            c.method,
      ];
      expect(order, ['upsert', 'upload']);
    });
  });

  group('PasteCubit', () {
    PasteCubit build() => PasteCubit(repository: repo, userId: 'u1');

    blocTest<PasteCubit, PasteState>(
      'asks for text before splitting',
      build: build,
      act: (c) => c.split(),
      verify: (c) => expect(c.state.error, PasteMessages.empty),
    );

    blocTest<PasteCubit, PasteState>(
      'splits a paste and holds back the unsure line',
      build: build,
      act: (c) => c
        ..setText(_chakalaka)
        ..split(),
      verify: (c) {
        expect(c.state.stage, PasteStage.review);
        expect(c.state.unsure.single.text, startsWith('Mom'));
        expect(c.state.recipe.steps, hasLength(2));
        expect(c.state.recipe.servings, 6);
      },
    );

    blocTest<PasteCubit, PasteState>(
      'relabels lines and keeps the unsure one when asked',
      build: build,
      act: (c) {
        c
          ..setText(_chakalaka)
          ..split();
        final carrots = c.state.lines.firstWhere(
          (l) => l.text.startsWith('3 carrots'),
        );
        c
          ..relabel(carrots.index)
          ..relabel(carrots.index)
          ..decide(c.state.unsure.single.index, include: true);
      },
      verify: (c) {
        expect(c.state.recipe.ingredients, hasLength(2));
        expect(c.state.recipe.steps, hasLength(3));
        expect(
          c.state.reviewed.where((l) => l.kind == LineKind.skip),
          hasLength(1),
        );
      },
    );

    blocTest<PasteCubit, PasteState>(
      'builds a pasted draft with matched foods',
      build: build,
      act: (c) async {
        c
          ..setText(_chakalaka)
          ..split();
        await c.build();
      },
      verify: (c) async {
        final id = c.state.build.value!;
        final draft = await repo.load(id);
        expect(draft!.title, "Gran's chakalaka");
        expect(draft.source, RecipeSource.pasted);
        expect(draft.totalMinutes, 35);
        expect(draft.ingredients.map((i) => i.foodId), [
          'f-oil',
          'f-onion',
          'f-carrot',
        ]);
      },
    );
  });

  group('RecipeEditorCubit', () {
    late _FakePhotos photos;

    setUp(() => photos = _FakePhotos());

    RecipeEditorCubit build() => RecipeEditorCubit(
      repository: repo,
      photos: photos,
      userId: 'u1',
      recipeId: 'new-1',
      debounce: Duration.zero,
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'a blank recipe is not saved',
      build: build,
      act: (c) async {
        await c.start();
        await c.flush(push: true);
      },
      verify: (_) async => expect(await db.select(db.recipes).get(), isEmpty),
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'typing autosaves the draft',
      build: build,
      act: (c) async {
        await c.start();
        c
          ..setTitle('Quick chakalaka')
          ..addIngredients('2 tbsp oil\n1 onion\nFor the topping:\n1 carrot');
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await c.flush();
      },
      verify: (c) async {
        expect(c.state.save, SaveStatus.saved);
        final draft = await repo.load('new-1');
        expect(draft!.title, 'Quick chakalaka');
        expect(draft.ingredients, hasLength(3));
        expect(draft.ingredients.last.section, 'For the topping');
      },
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'costs add up and split by serving',
      build: build,
      act: (c) async {
        await c.start();
        c
          ..addIngredients('2 tbsp oil\n1 onion')
          ..changeServings(-2);
        final ids = c.state.draft.ingredients.map((i) => i.id).toList();
        c
          ..setCost(ids[0], '12.50')
          ..setCost(ids[1], '7');
      },
      verify: (c) {
        expect(c.state.draft.costCents, 1950);
        expect(c.state.draft.costPerServing, 975);
        expect(c.state.nutrition.matched, 2);
      },
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'reorders, edits and removes ingredients',
      build: build,
      act: (c) async {
        await c.start();
        c.addIngredients('1 onion\n2 carrots\nsalt');
        final ids = c.state.draft.ingredients.map((i) => i.id).toList();
        c
          ..reorderIngredient(2, 0)
          ..updateIngredient(ids[1], '4 carrots, grated')
          ..updateIngredient(ids[0], '  ');
      },
      verify: (c) {
        final ings = c.state.draft.ingredients;
        expect(ings.map((i) => i.rawText), ['salt', '4 carrots, grated']);
        expect(ings.last.quantity, 4);
        expect(ings.last.prepNote, 'grated');
      },
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'pasting a method adds numbered steps',
      build: build,
      act: (c) async {
        await c.start();
        c.pasteMethod('1. Fry the onion for 5 min.\n2. Serve.');
      },
      verify: (c) {
        expect(c.state.draft.steps.map((s) => s.body), [
          'Fry the onion for 5 min.',
          'Serve.',
        ]);
        expect(c.state.draft.steps.first.timerSeconds, 300);
      },
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'publishing explains what is missing',
      build: build,
      act: (c) async {
        await c.start();
        c.setTitle('Soup');
        await c.publish();
      },
      verify: (c) {
        expect(c.state.showProblems, isTrue);
        expect(
          c.state.publish.error,
          EditorMessages.problem(DraftProblem.ingredients),
        );
      },
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'publishing marks the recipe shared and queues it',
      build: build,
      act: (c) async {
        await c.start();
        c
          ..setTitle('Soup')
          ..addIngredients('1 onion');
        final step = c.addStep();
        c.updateStep(step, 'Boil the onion.');
        await c.publish();
      },
      verify: (c) async {
        expect(c.state.publish.value, 'new-1');
        final row = await db.select(db.recipes).getSingle();
        expect(row.status, RecipeStatus.published);
        expect(row.publishedAt, isNotNull);
        expect(await repo.publishedCount('u1'), 1);
      },
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'a chosen photo replaces the uploaded one',
      build: build,
      act: (c) async {
        await c.start();
        photos.next = '/tmp/new.jpg';
        await c.pickPhoto(PhotoSource.gallery);
      },
      verify: (c) {
        expect(c.state.draft.localCoverPath, '/tmp/new.jpg');
        expect(c.state.draft.coverPath, isNull);
      },
    );

    blocTest<RecipeEditorCubit, EditorState>(
      'guesses vegetarian when nothing is meat',
      build: build,
      act: (c) async {
        await c.start();
        c.addIngredients('1 onion\n2 carrots');
      },
      verify: (c) => expect(c.state.guesses, {15}),
    );
  });
}
