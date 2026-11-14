import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/feed.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';

import '../../helpers/fake_browse_api.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late OutboxStore outbox;
  late FakeBrowseApi api;
  late BrowseRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    outbox = OutboxStore(db);
    api = FakeBrowseApi();
    repo = BrowseRepositoryImpl(
      api: api,
      db: db,
      outbox: outbox,
      currentUserId: () => 'u1',
      clock: () => DateTime.utc(2026, 11, 14, 9),
    );
  });

  tearDown(() => db.close());

  Feed<List<RecipeCard>> feedOf(Result<Feed<List<RecipeCard>>> r) =>
      (r as Ok<Feed<List<RecipeCard>>>).value;

  test('signs cover photos for cards that have one', () async {
    api.trendingRows = [cardRow('r1', cover: 'a/r1/cover.jpg'), cardRow('r2')];

    final feed = feedOf(await repo.trending());

    expect(feed.value.first.coverUrl, 'https://img/a/r1/cover.jpg');
    expect(feed.value.last.coverUrl, isNull);
    expect(feed.isStale, isFalse);
  });

  test('offline falls back to the last loaded page', () async {
    api.trendingRows = [cardRow('r1', title: 'Bobotie')];
    await repo.trending();
    api.failure = const RemoteFailure('down', isTransient: true);

    final feed = feedOf(await repo.trending());

    expect(feed.isStale, isTrue);
    expect(feed.value.single.title, 'Bobotie');
    expect(feed.fetchedAt.toUtc(), DateTime.utc(2026, 11, 14, 9));
  });

  test('offline with nothing cached returns a friendly error', () async {
    api.failure = const RemoteFailure('down', isTransient: true);

    final result = await repo.trending();

    expect(
      (result as Error).error.toString(),
      contains(BrowseMessages.offline),
    );
  });

  test('only the first search page is cached', () async {
    api.searchRows = [for (var i = 0; i < 25; i++) cardRow('r$i')];
    const filters = SearchFilters(query: 'curry');
    await repo.search(filters);
    await repo.search(filters, offset: 20);
    api.failure = const RemoteFailure('down', isTransient: true);

    final cached = feedOf(await repo.search(filters));
    final page2 = await repo.search(filters, offset: 20);

    expect(cached.value, hasLength(20));
    expect(page2, isA<Error<Feed<List<RecipeCard>>>>());
  });

  test('server save and like state lands in the local tables', () async {
    api.trendingRows = [cardRow('r1', saved: true, liked: true), cardRow('r2')];
    await db
        .into(db.saves)
        .insert(
          SavesCompanion.insert(
            userId: 'u1',
            recipeId: 'r2',
            createdAt: DateTime.utc(2026, 11),
          ),
        );

    await repo.trending();

    final saves = await db.select(db.saves).get();
    final likes = await db.select(db.likes).get();
    expect(saves.map((s) => s.recipeId), ['r1']);
    expect(likes.map((l) => l.recipeId), ['r1']);
  });

  test('a pending local unsave is not undone by a stale card', () async {
    await outbox.enqueue(
      OutboxOperation.delete('saves', {
        'recipe_id': 'r1',
      }, dedupeKey: 'saves:r1'),
    );
    api.trendingRows = [cardRow('r1', saved: true)];

    await repo.trending();

    expect(await db.select(db.saves).get(), isEmpty);
  });

  test('people search maps profile rows', () async {
    api.peopleRows = [
      {'id': 'p1', 'username': 'aisha', 'display_name': 'Aisha Patel'},
    ];

    final result = await repo.people('ais');

    final people = (result as Ok).value as List;
    expect(people, hasLength(1));
  });
}
