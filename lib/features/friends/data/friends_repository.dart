import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/db/mappers.dart';
import 'package:shared_plates_app/core/domain/feed.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_api.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/friends/domain/person.dart';

abstract final class FriendsMessages {
  static const actionFailed = "That didn't go through. Try again.";
  static const blocked = "You can't add this person.";
}

abstract interface class FriendsRepository {
  Future<Result<Feed<FriendsOverview>>> overview(String uid);

  Future<Result<PersonProfile>> person(String uid, String personId);

  Future<Result<void>> request(String personId);

  Future<Result<void>> accept(String uid, String personId);

  Future<Result<void>> remove(String uid, String personId);

  Future<Result<void>> block(String personId);

  Future<Result<void>> report(String personId, String reason);
}

class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl({
    required this._remote,
    required this._api,
    required this._db,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  static const feedSize = 30;

  final RemoteStore _remote;
  final BrowseApi _api;
  final AppDatabase _db;
  final DateTime Function() _now;

  @override
  Future<Result<Feed<FriendsOverview>>> overview(String uid) async {
    final key = 'friends:$uid';
    try {
      final links = await _links(uid);
      final people = await _people(links.keys.toList());
      final feedRows = await _remote.rpc('friends_feed', {'lim': feedSize});
      final cards = await _withCovers([
        for (final r in (feedRows as List<dynamic>? ?? const []))
          RecipeCard.fromJson(r as Map<String, dynamic>),
      ]);
      final overview = _assemble(links, people, cards);
      final at = _now();
      await _db
          .into(_db.feedCache)
          .insertOnConflictUpdate(
            FeedCacheCompanion.insert(
              key: key,
              json: jsonEncode(_encode(overview)),
              fetchedAt: at,
            ),
          );
      return Result.ok(Feed(overview, fetchedAt: at));
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('FriendsRepository.overview', e, s);
      final cached = await (_db.select(
        _db.feedCache,
      )..where((t) => t.key.equals(key))).getSingleOrNull();
      if (cached != null) {
        return Result.ok(
          Feed(
            _decode(jsonDecode(cached.json) as Map<String, dynamic>),
            fetchedAt: cached.fetchedAt,
            isStale: true,
          ),
        );
      }
      return Result.error(Exception(BrowseMessages.forFailure(e)));
    } on FormatException catch (e, s) {
      ErrorReporter.report('FriendsRepository.overview', e, s);
      return const Result.castError();
      // ignore: avoid_catching_errors, json_serializable reports bad payloads as TypeError
    } on TypeError catch (e, s) {
      ErrorReporter.report('FriendsRepository.overview', e, s);
      return const Result.castError();
    }
  }

  Future<Map<String, (FriendLink, DateTime)>> _links(String uid) async {
    final rows = await _remote.select('friendships', limit: 1000);
    return {
      for (final r in rows)
        if (r['requester_id'] == uid || r['addressee_id'] == uid)
          (r['requester_id'] == uid ? r['addressee_id'] : r['requester_id'])
              as String: (
            r['status'] == 'accepted'
                ? FriendLink.friends
                : r['requester_id'] == uid
                ? FriendLink.outgoing
                : FriendLink.incoming,
            DateTime.parse((r['accepted_at'] ?? r['created_at']) as String),
          ),
    };
  }

  Future<Map<String, Person>> _people(List<String> ids) async {
    if (ids.isEmpty) return const {};
    final rows = await _remote.fetchIn('profiles', column: 'id', values: ids);
    return {for (final r in rows) r['id'] as String: Person.fromJson(r)};
  }

  FriendsOverview _assemble(
    Map<String, (FriendLink, DateTime)> links,
    Map<String, Person> people,
    List<RecipeCard> feed,
  ) {
    List<Friendship> of(FriendLink link) => [
      for (final MapEntry(key: id, value: (l, since)) in links.entries)
        if (l == link && people[id] != null)
          Friendship(person: people[id]!, link: l, since: since),
    ]..sort((a, b) => b.since.compareTo(a.since));
    final friends = of(FriendLink.friends);
    final latest = <String, DateTime>{};
    for (final c in feed) {
      final at = c.publishedAt ?? c.updatedAt;
      final seen = latest[c.authorId];
      if (seen == null || at.isAfter(seen)) latest[c.authorId] = at;
    }
    friends.sort((a, b) {
      final la = latest[a.person.id];
      final lb = latest[b.person.id];
      if (la != null && lb != null) return lb.compareTo(la);
      if (la != null) return -1;
      if (lb != null) return 1;
      return a.person.displayName.compareTo(b.person.displayName);
    });
    return FriendsOverview(
      friends: friends,
      incoming: of(FriendLink.incoming),
      outgoing: of(FriendLink.outgoing),
      feed: feed,
    );
  }

  Map<String, dynamic> _encode(FriendsOverview o) {
    List<Map<String, dynamic>> links(List<Friendship> list) => [
      for (final f in list)
        {
          'person': f.person.toJson(),
          'link': f.link.name,
          'since': f.since.toIso8601String(),
        },
    ];
    return {
      'friends': links(o.friends),
      'incoming': links(o.incoming),
      'outgoing': links(o.outgoing),
      'feed': [for (final c in o.feed) c.toJson()],
    };
  }

  FriendsOverview _decode(Map<String, dynamic> json) {
    List<Friendship> links(String key) => [
      for (final raw in json[key] as List<dynamic>)
        Friendship(
          person: Person.fromJson(
            (raw as Map<String, dynamic>)['person'] as Map<String, dynamic>,
          ),
          link: FriendLink.values.byName(raw['link'] as String),
          since: DateTime.parse(raw['since'] as String),
        ),
    ];
    return FriendsOverview(
      friends: links('friends'),
      incoming: links('incoming'),
      outgoing: links('outgoing'),
      feed: [
        for (final r in json['feed'] as List<dynamic>)
          RecipeCard.fromJson(r as Map<String, dynamic>),
      ],
    );
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
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('FriendsRepository.signCovers', e, s);
      return cards;
    }
  }

  @override
  Future<Result<PersonProfile>> person(String uid, String personId) async {
    try {
      final rows = await _remote.fetchIn(
        'profiles',
        column: 'id',
        values: [personId],
      );
      if (rows.isEmpty) {
        return Result.error(Exception(BrowseMessages.generic));
      }
      final links = await _links(uid);
      final cards = await _withCovers(
        [
          for (final r in await _remote.fetchIn(
            'recipe_cards',
            column: 'author_id',
            values: [personId],
          ))
            RecipeCard.fromJson(r),
        ]..sort(
          (a, b) => (b.publishedAt ?? b.updatedAt).compareTo(
            a.publishedAt ?? a.updatedAt,
          ),
        ),
      );
      final tagRows = cards.isEmpty
          ? const <JsonRow>[]
          : await _remote.fetchIn(
              'recipe_tags',
              column: 'recipe_id',
              values: [for (final c in cards) c.id],
            );
      final recipeTags = <String, Set<int>>{};
      for (final r in tagRows) {
        recipeTags
            .putIfAbsent(r['recipe_id'] as String, () => {})
            .add((r['tag_id'] as num).toInt());
      }
      final used = {for (final s in recipeTags.values) ...s};
      final tags = [
        for (final t in await (_db.select(
          _db.tags,
        )..orderBy([(t) => OrderingTerm.asc(t.position)])).get())
          if (used.contains(t.id)) t.toDomain(),
      ];
      return Result.ok(
        PersonProfile(
          person: Person.fromJson(rows.first),
          link: links[personId]?.$1 ?? FriendLink.none,
          recipes: cards,
          tags: tags,
          recipeTags: recipeTags,
        ),
      );
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('FriendsRepository.person', e, s);
      return Result.error(Exception(BrowseMessages.forFailure(e)));
      // ignore: avoid_catching_errors, json_serializable reports bad payloads as TypeError
    } on TypeError catch (e, s) {
      ErrorReporter.report('FriendsRepository.person', e, s);
      return const Result.castError();
    }
  }

  Future<Result<void>> _act(String source, Future<void> Function() call) async {
    try {
      await call();
      return const Result.ok(null);
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('FriendsRepository.$source', e, s);
      return Result.error(
        Exception(
          e.isTransient
              ? BrowseMessages.offline
              : e.message.contains('request to this person')
              ? FriendsMessages.blocked
              : FriendsMessages.actionFailed,
        ),
      );
    }
  }

  @override
  Future<Result<void>> request(String personId) => _act(
    'request',
    () => _remote.upsert(
      'friendships',
      {'addressee_id': personId},
      onConflict: 'requester_id,addressee_id',
      ignoreDuplicates: true,
    ),
  );

  @override
  Future<Result<void>> accept(String uid, String personId) => _act(
    'accept',
    () => _remote.update(
      'friendships',
      {'status': 'accepted'},
      match: {'requester_id': personId, 'addressee_id': uid},
    ),
  );

  @override
  Future<Result<void>> remove(String uid, String personId) =>
      _act('remove', () async {
        await _remote.delete('friendships', {
          'requester_id': uid,
          'addressee_id': personId,
        });
        await _remote.delete('friendships', {
          'requester_id': personId,
          'addressee_id': uid,
        });
      });

  @override
  Future<Result<void>> block(String personId) => _act(
    'block',
    () => _remote.upsert(
      'blocks',
      {'blocked_id': personId},
      onConflict: 'blocker_id,blocked_id',
      ignoreDuplicates: true,
    ),
  );

  @override
  Future<Result<void>> report(String personId, String reason) => _act(
    'report',
    () => _remote.upsert(
      'reports',
      {
        'user_id': personId,
        'reason': reason.length > 500 ? reason.substring(0, 500) : reason,
      },
      onConflict: 'id',
      ignoreDuplicates: true,
    ),
  );
}
