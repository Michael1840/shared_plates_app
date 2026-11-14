import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';

import '../../helpers/fake_remote_store.dart';

const _uid = 'user-1';

JsonRow _recipe(String id, String updatedAt, {String title = 'Curry'}) => {
  'id': id,
  'author_id': _uid,
  'title': title,
  'cover_style': 'stew',
  'base_servings': 4,
  'visibility': 'friends',
  'status': 'published',
  'source': 'typed',
  'created_at': '2026-11-01T10:00:00Z',
  'updated_at': updatedAt,
};

JsonRow _food(int n, String updatedAt) => {
  'id': 'food-${n.toString().padLeft(3, '0')}',
  'name': 'Food $n',
  'aliases': <String>[],
  'kcal_100g': 100,
  'updated_at': updatedAt,
};

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late OutboxStore outbox;
  late FakeRemoteStore remote;
  late SyncService sync;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    outbox = OutboxStore(db);
    remote = FakeRemoteStore(userId: _uid);
    sync = SyncService(db: db, outbox: outbox, remote: remote, pageSize: 2);
  });

  tearDown(() async {
    await sync.dispose();
    await db.close();
  });

  group('push', () {
    test('replays the outbox in order and empties it', () async {
      await outbox.enqueue(
        OutboxOperation.upsert('recipes', {
          'id': 'r1',
        }, dedupeKey: 'recipes:r1'),
      );
      await outbox.enqueue(
        OutboxOperation.upsert('recipe_ingredients', {
          'id': 'i1',
          'recipe_id': 'r1',
        }),
      );

      final report = await sync.pushOutbox();

      expect(report, const SyncReport(pushed: 2));
      expect(remote.calls.map((c) => c.target), [
        'recipes',
        'recipe_ingredients',
      ]);
      expect(await outbox.due(), isEmpty);
    });

    test('stops at a transient failure and keeps order for later', () async {
      await outbox.enqueue(OutboxOperation.upsert('recipes', {'id': 'r1'}));
      await outbox.enqueue(OutboxOperation.upsert('recipes', {'id': 'r2'}));
      remote.failures.add(const RemoteFailure('offline', isTransient: true));

      final first = await sync.pushOutbox();
      final second = await sync.pushOutbox(ignoreBackoff: true);

      expect(first.blocked, isTrue);
      expect(first.pushed, 0);
      expect(second.pushed, 2);
      expect(remote.tables['recipes']!.map((r) => r['id']), ['r1', 'r2']);
    });

    test('a rejected entry is parked and the rest still sync', () async {
      await outbox.enqueue(OutboxOperation.upsert('recipes', {'id': 'bad'}));
      await outbox.enqueue(OutboxOperation.upsert('recipes', {'id': 'ok'}));
      remote.failures.add(
        const RemoteFailure(
          'violates check',
          isTransient: false,
          code: '23514',
        ),
      );

      final report = await sync.pushOutbox();

      expect(report, const SyncReport(pushed: 1, failed: 1));
      expect(remote.tables['recipes']!.single['id'], 'ok');
    });

    test('replaying the same like twice leaves one row', () async {
      final like = OutboxOperation.insertIgnoringDuplicates('likes', {
        'user_id': _uid,
        'recipe_id': 'r1',
      }, conflictColumns: 'user_id,recipe_id');
      await outbox.enqueue(like);
      await sync.pushOutbox();
      await outbox.enqueue(like);
      await sync.pushOutbox();

      expect(remote.tables['likes'], hasLength(1));
    });

    test('like then unlike while offline sends only the delete', () async {
      remote.seed(
        'likes',
        [
          {'user_id': _uid, 'recipe_id': 'r1'},
        ],
        key: ['user_id', 'recipe_id'],
      );
      await outbox.enqueue(
        OutboxOperation.insertIgnoringDuplicates(
          'likes',
          {'user_id': _uid, 'recipe_id': 'r1'},
          conflictColumns: 'user_id,recipe_id',
          dedupeKey: 'likes:r1',
        ),
      );
      await outbox.enqueue(
        OutboxOperation.delete('likes', {
          'user_id': _uid,
          'recipe_id': 'r1',
        }, dedupeKey: 'likes:r1'),
      );

      await sync.pushOutbox();

      expect(remote.calls.single.method, 'delete');
      expect(remote.tables['likes'], isEmpty);
    });
  });

  group('pull', () {
    test('pages through reference data and stores the cursor', () async {
      remote.seed('foods', [
        for (var i = 0; i < 5; i++) _food(i, '2026-11-13T21:00:00Z'),
      ]);

      await sync.pull();

      expect(await db.select(db.foods).get(), hasLength(5));
      expect(
        (await db.cursorFor('ref:foods'))?.toUtc(),
        DateTime.parse('2026-11-13T21:00:00Z'),
      );
    });

    test('only fetches rows changed since the cursor', () async {
      remote.seed('foods', [_food(1, '2026-11-13T21:00:00Z')]);
      await sync.pull();
      remote.calls.clear();
      remote.tables['foods']!.add(_food(2, '2026-11-14T08:00:00Z'));

      await sync.pull();

      final rows = await db.select(db.foods).get();
      expect(rows.map((f) => f.name), containsAll(['Food 1', 'Food 2']));
      expect(
        (await db.cursorFor('ref:foods'))?.toUtc(),
        DateTime.parse('2026-11-14T08:00:00Z'),
      );
    });

    test('pulls own recipes with their ingredients and steps', () async {
      remote
        ..seed('recipes', [_recipe('r1', '2026-11-13T21:00:00Z')])
        ..seed('recipe_ingredients', [
          {
            'id': 'i1',
            'recipe_id': 'r1',
            'position': 0,
            'raw_text': '2 onions',
            'quantity': 2,
            'updated_at': '2026-11-13T21:00:00Z',
          },
        ])
        ..seed('recipe_steps', [
          {
            'id': 's1',
            'recipe_id': 'r1',
            'position': 0,
            'body': 'Fry the onions.',
            'updated_at': '2026-11-13T21:00:00Z',
          },
        ])
        ..seed('step_ingredients', [
          {'step_id': 's1', 'ingredient_id': 'i1'},
        ]);

      await sync.pull();

      final recipe = await db.select(db.recipes).getSingle();
      expect(recipe.title, 'Curry');
      expect(await db.select(db.recipeIngredients).get(), hasLength(1));
      expect(await db.select(db.recipeSteps).get(), hasLength(1));
      expect((await db.select(db.stepIngredients).getSingle()).recipeId, 'r1');
    });

    test('does not overwrite a recipe with unsent local edits', () async {
      await db
          .into(db.recipes)
          .insert(
            RecipesCompanion.insert(
              id: 'r1',
              authorId: _uid,
              title: const Value('My edit'),
              coverStyle: CoverStyle.stew,
              visibility: RecipeVisibility.friends,
              status: RecipeStatus.draft,
              source: RecipeSource.typed,
              createdAt: DateTime.utc(2026, 11),
              updatedAt: DateTime.utc(2026, 11),
            ),
          );
      await outbox.enqueue(
        OutboxOperation.upsert('recipes', {
          'id': 'r1',
        }, dedupeKey: 'recipes:r1'),
      );
      remote.seed('recipes', [
        _recipe('r1', '2026-11-13T21:00:00Z', title: 'Server'),
      ]);

      await sync.pull();

      expect((await db.select(db.recipes).getSingle()).title, 'My edit');
    });

    test('reconciles saves but keeps ones still waiting to send', () async {
      await db.batch(
        (b) => b.insertAll(db.saves, [
          SavesCompanion.insert(
            userId: _uid,
            recipeId: 'gone',
            createdAt: DateTime.utc(2026, 11),
          ),
          SavesCompanion.insert(
            userId: _uid,
            recipeId: 'pending',
            createdAt: DateTime.utc(2026, 11),
          ),
        ]),
      );
      await outbox.enqueue(
        OutboxOperation.insertIgnoringDuplicates(
          'saves',
          {'recipe_id': 'pending'},
          conflictColumns: 'user_id,recipe_id',
          dedupeKey: 'saves:pending',
        ),
      );
      remote.seed('saves', [
        {
          'user_id': _uid,
          'recipe_id': 'kept',
          'created_at': '2026-11-10T10:00:00Z',
        },
      ]);

      await sync.pull();

      final ids = (await db.select(db.saves).get()).map((s) => s.recipeId);
      expect(ids, unorderedEquals(['kept', 'pending']));
    });
  });
}
