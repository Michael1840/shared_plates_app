import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/feed.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_api.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/friends/domain/person.dart';

class ActivityItem extends Equatable {
  const ActivityItem({
    required this.id,
    required this.kind,
    required this.createdAt,
    this.actor,
    this.recipe,
    this.data = const {},
    this.readAt,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    final actor = json['actor'] as Map<String, dynamic>?;
    final recipe = json['recipe'] as Map<String, dynamic>?;
    final read = json['read_at'] as String?;
    return ActivityItem(
      id: json['id'] as String,
      kind: NotificationKind.values.byName(json['kind'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      actor: actor == null ? null : Person.fromJson(actor),
      recipe: recipe == null ? null : RecipeCard.fromJson(recipe),
      data: (json['data'] as Map<String, dynamic>?) ?? const {},
      readAt: read == null ? null : DateTime.parse(read),
    );
  }

  final String id;
  final NotificationKind kind;
  final DateTime createdAt;
  final Person? actor;
  final RecipeCard? recipe;
  final Map<String, dynamic> data;
  final DateTime? readAt;

  bool get unread => readAt == null;

  ActivityItem read(DateTime at) => ActivityItem(
    id: id,
    kind: kind,
    createdAt: createdAt,
    actor: actor,
    recipe: recipe,
    data: data,
    readAt: readAt ?? at,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'created_at': createdAt.toIso8601String(),
    'actor': actor?.toJson(),
    'recipe': recipe?.toJson(),
    'data': data,
    'read_at': readAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, kind, createdAt, actor, recipe, data, readAt];
}

abstract interface class ActivityRepository {
  Future<Result<Feed<List<ActivityItem>>>> load(String uid);

  Future<int> unreadCount(String uid);

  Future<void> markAllRead();
}

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl({
    required this._remote,
    required this._api,
    required this._db,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  static const pageSize = 60;
  static const Map<String, NotificationKind> _kinds = {
    'recipe_saved': NotificationKind.recipeSaved,
    'recipe_cooked': NotificationKind.recipeCooked,
    'friend_request': NotificationKind.friendRequest,
    'friend_accepted': NotificationKind.friendAccepted,
    'weekly_roundup': NotificationKind.weeklyRoundup,
  };

  final RemoteStore _remote;
  final BrowseApi _api;
  final AppDatabase _db;
  final DateTime Function() _now;

  @override
  Future<Result<Feed<List<ActivityItem>>>> load(String uid) async {
    final key = 'activity:$uid';
    try {
      final rows = await _remote.select(
        'notifications',
        match: {'recipient_id': uid},
        orderBy: 'created_at',
        limit: pageSize,
      );
      final actorIds = {
        for (final r in rows)
          if (r['actor_id'] case final String id) id,
      };
      final recipeIds = {
        for (final r in rows)
          if (r['recipe_id'] case final String id) id,
      };
      final actors = {
        for (final p in await _remote.fetchIn(
          'profiles',
          column: 'id',
          values: actorIds.toList(),
        ))
          p['id'] as String: Person.fromJson(p),
      };
      final recipes = {
        for (final c in await _withCovers([
          for (final r in await _remote.fetchIn(
            'recipe_cards',
            column: 'id',
            values: recipeIds.toList(),
          ))
            RecipeCard.fromJson(r),
        ]))
          c.id: c,
      };
      final items = [
        for (final r in rows)
          if (_kinds[r['kind']] case final NotificationKind kind)
            ActivityItem(
              id: r['id'] as String,
              kind: kind,
              createdAt: DateTime.parse(r['created_at'] as String),
              actor: actors[r['actor_id']],
              recipe: recipes[r['recipe_id']],
              data: (r['data'] as Map<String, dynamic>?) ?? const {},
              readAt: r['read_at'] == null
                  ? null
                  : DateTime.parse(r['read_at'] as String),
            ),
      ];
      final at = _now();
      await _db
          .into(_db.feedCache)
          .insertOnConflictUpdate(
            FeedCacheCompanion.insert(
              key: key,
              json: jsonEncode([for (final i in items) i.toJson()]),
              fetchedAt: at,
            ),
          );
      return Result.ok(Feed(items, fetchedAt: at));
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('ActivityRepository.load', e, s);
      final cached = await (_db.select(
        _db.feedCache,
      )..where((t) => t.key.equals(key))).getSingleOrNull();
      if (cached != null) {
        return Result.ok(
          Feed(
            [
              for (final r in jsonDecode(cached.json) as List<dynamic>)
                ActivityItem.fromJson(r as Map<String, dynamic>),
            ],
            fetchedAt: cached.fetchedAt,
            isStale: true,
          ),
        );
      }
      return Result.error(Exception(BrowseMessages.forFailure(e)));
      // ignore: avoid_catching_errors, json_serializable reports bad payloads as TypeError
    } on TypeError catch (e, s) {
      ErrorReporter.report('ActivityRepository.load', e, s);
      return const Result.castError();
    }
  }

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
    } on RemoteFailure {
      return cards;
    }
  }

  @override
  Future<int> unreadCount(String uid) async {
    try {
      final rows = await _remote.select(
        'notifications',
        match: {'recipient_id': uid},
        orderBy: 'created_at',
        limit: pageSize,
      );
      return rows.where((r) => r['read_at'] == null).length;
    } on RemoteFailure {
      return 0;
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      await _remote.rpc('mark_notifications_read', const {});
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('ActivityRepository.markAllRead', e, s);
    }
  }
}
