import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/db/mappers.dart';
import 'package:shared_plates_app/core/domain/feed.dart';
import 'package:shared_plates_app/core/domain/models/collection.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_api.dart';
import 'package:shared_plates_app/features/profile/domain/popular_cook.dart';

abstract final class BrowseMessages {
  static const offline = 'No signal. Pull down to try again.';
  static const generic = "Couldn't load this. Pull down to try again.";
  static const noBackend = "This build isn't connected to SharedPlates.";

  static String titleFor(String? error) =>
      error == offline ? 'No signal' : "Couldn't load this";

  static String forFailure(RemoteFailure e) {
    if (e.code == RemoteFailure.noBackend) return noBackend;
    return e.isTransient ? offline : generic;
  }
}

class RecentRecipe extends Equatable {
  const new({required this.card, required this.viewedAt});

  final RecipeCard card;
  final DateTime viewedAt;

  @override
  List<Object?> get props => [card, viewedAt];
}

abstract interface class BrowseRepository {
  Future<Result<Feed<List<RecipeCollection>>>> collections();

  Future<Result<Feed<List<RecipeCard>>>> trending({int limit = 10});

  Future<Result<Feed<List<RecipeCard>>>> collectionRecipes(
    String slug, {
    int limit = 10,
  });

  Future<Result<Feed<List<RecipeCard>>>> search(
    SearchFilters filters, {
    int limit = 20,
    int offset = 0,
  });

  Future<Result<List<PopularCook>>> people(String query);

  Stream<List<RecentRecipe>> watchRecentlyViewed(String uid, {int limit = 3});
}

class BrowseRepositoryImpl implements BrowseRepository {
  new({
    required this._api,
    required this._db,
    required this._outbox,
    required this._currentUserId,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final BrowseApi _api;
  final AppDatabase _db;
  final OutboxStore _outbox;
  final String? Function() _currentUserId;
  final DateTime Function() _now;

  @override
  Future<Result<Feed<List<RecipeCollection>>>> collections() => _load(
    key: 'collections',
    fetch: () async => [
      for (final r in await _api.collections()) RecipeCollection.fromJson(r),
    ],
    encode: (items) => [for (final c in items) c.toJson()],
    decode: (rows) => [for (final r in rows) RecipeCollection.fromJson(r)],
  );

  @override
  Future<Result<Feed<List<RecipeCard>>>> trending({int limit = 10}) =>
      _cards('trending', () => _api.trending(limit: limit));

  @override
  Future<Result<Feed<List<RecipeCard>>>> collectionRecipes(
    String slug, {
    int limit = 10,
  }) => _cards(
    'collection:$slug',
    () => _api.collectionRecipes(slug, limit: limit, offset: 0),
  );

  @override
  Future<Result<Feed<List<RecipeCard>>>> search(
    SearchFilters filters, {
    int limit = 20,
    int offset = 0,
  }) => _cards(
    offset == 0 ? 'search:${filters.cacheKey}' : null,
    () => _api.search(filters, limit: limit, offset: offset),
  );

  @override
  Future<Result<List<PopularCook>>> people(String query) async {
    try {
      final rows = await _api.people(query, limit: 20);
      return Result.ok([for (final r in rows) PopularCook.fromJson(r)]);
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('BrowseRepository.people', e, s);
      return Result.error(Exception(BrowseMessages.forFailure(e)));
    } on FormatException {
      return const Result.castError();
    }
  }

  @override
  Stream<List<RecentRecipe>> watchRecentlyViewed(String uid, {int limit = 3}) {
    final query =
        _db.select(_db.recentlyViewed).join([
            innerJoin(
              _db.recipes,
              _db.recipes.id.equalsExp(_db.recentlyViewed.recipeId),
            ),
          ])
          ..where(
            _db.recentlyViewed.userId.equals(uid) &
                _db.recipes.deletedAt.isNull(),
          )
          ..orderBy([OrderingTerm.desc(_db.recentlyViewed.viewedAt)])
          ..limit(limit);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          RecentRecipe(
            card: row.readTable(_db.recipes).toCard(viewerId: uid),
            viewedAt: row.readTable(_db.recentlyViewed).viewedAt,
          ),
      ],
    );
  }

  Future<Result<Feed<List<RecipeCard>>>> _cards(
    String? key,
    Future<List<JsonRow>> Function() fetch,
  ) => _load(
    key: key,
    fetch: () async {
      final cards = [for (final r in await fetch()) RecipeCard.fromJson(r)];
      await _reconcileActivity(cards);
      return await _withCovers(cards);
    },
    encode: (items) => [for (final c in items) c.toJson()],
    decode: (rows) => [for (final r in rows) RecipeCard.fromJson(r)],
  );

  Future<List<RecipeCard>> _withCovers(List<RecipeCard> cards) async {
    final paths = [
      for (final c in cards)
        if (c.coverPath case final String path when path.isNotEmpty) path,
    ];
    if (paths.isEmpty) return cards;
    try {
      final urls = await _api.signCovers(paths);
      return [
        for (final c in cards)
          if (c.coverPath == null)
            c
          else
            c.copyWith(coverUrl: urls[c.coverPath]),
      ];
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('BrowseRepository.signCovers', e, s);
      return cards;
    }
  }

  Future<void> _reconcileActivity(List<RecipeCard> cards) async {
    final uid = _currentUserId();
    if (uid == null || cards.isEmpty) return;
    final pending = await _outbox.pendingKeys();
    final now = _now();
    await _db.transaction(() async {
      for (final card in cards) {
        if (!pending.contains('saves:${card.id}')) {
          await _setMembership(
            table: _db.saves,
            present: card.isSaved,
            uid: uid,
            recipeId: card.id,
            insert: SavesCompanion.insert(
              userId: uid,
              recipeId: card.id,
              createdAt: now,
            ),
          );
        }
        if (!pending.contains('likes:${card.id}')) {
          await _setMembership(
            table: _db.likes,
            present: card.isLiked,
            uid: uid,
            recipeId: card.id,
            insert: LikesCompanion.insert(
              userId: uid,
              recipeId: card.id,
              createdAt: now,
            ),
          );
        }
      }
    });
  }

  Future<void> _setMembership<T extends Table, D>({
    required TableInfo<T, D> table,
    required bool present,
    required String uid,
    required String recipeId,
    required Insertable<D> insert,
  }) async {
    if (present) {
      await _db.into(table).insert(insert, mode: InsertMode.insertOrIgnore);
      return;
    }
    await _db.customStatement(
      'DELETE FROM ${table.actualTableName} '
      'WHERE user_id = ? AND recipe_id = ?',
      [uid, recipeId],
    );
  }

  Future<Result<Feed<T>>> _load<T>({
    required String? key,
    required Future<T> Function() fetch,
    required List<Map<String, dynamic>> Function(T value) encode,
    required T Function(List<Map<String, dynamic>> rows) decode,
  }) async {
    try {
      final value = await fetch();
      final at = _now();
      if (key != null) {
        await _db
            .into(_db.feedCache)
            .insertOnConflictUpdate(
              FeedCacheCompanion.insert(
                key: key,
                json: jsonEncode(encode(value)),
                fetchedAt: at,
              ),
            );
      }
      return Result.ok(Feed(value, fetchedAt: at));
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('BrowseRepository.$key', e, s);
      final cached = key == null ? null : await _cached(key, decode);
      if (cached != null) return Result.ok(cached);
      return Result.error(Exception(BrowseMessages.forFailure(e)));
    } on FormatException catch (e, s) {
      ErrorReporter.report('BrowseRepository.$key', e, s);
      return const Result.castError();
      // ignore: avoid_catching_errors, json_serializable reports bad payloads as TypeError
    } on TypeError catch (e, s) {
      ErrorReporter.report('BrowseRepository.$key', e, s);
      return const Result.castError();
    }
  }

  Future<Feed<T>?> _cached<T>(
    String key,
    T Function(List<Map<String, dynamic>> rows) decode,
  ) async {
    final row = await (_db.select(
      _db.feedCache,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    final rows = (jsonDecode(row.json) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    return Feed(decode(rows), fetchedAt: row.fetchedAt, isStale: true);
  }
}
