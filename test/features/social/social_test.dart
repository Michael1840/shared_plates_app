import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/feed.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/activity/data/activity_repository.dart';
import 'package:shared_plates_app/features/activity/presentation/bloc/activity_cubit.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';
import 'package:shared_plates_app/features/friends/domain/person.dart';
import 'package:shared_plates_app/features/friends/presentation/bloc/friends_cubit.dart';
import 'package:shared_plates_app/features/friends/presentation/bloc/person_cubit.dart';

import '../../helpers/fake_browse_api.dart';
import '../../helpers/fake_remote_store.dart';
import '../../helpers/social_seed.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late FakeRemoteStore remote;
  late FakeBrowseApi api;
  late FriendsRepositoryImpl friends;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    remote = FakeRemoteStore(userId: 'u1');
    api = FakeBrowseApi();
    friends = FriendsRepositoryImpl(
      remote: remote,
      api: api,
      db: db,
      clock: () => DateTime.utc(2026, 11, 14, 9),
    );
    seedFriends(remote);
    await db
        .into(db.tags)
        .insert(
          TagsCompanion.insert(
            id: const Value(13),
            slug: 'dessert',
            label: 'Desserts',
            kind: TagKind.meal,
            coverStyle: CoverStyle.sweet,
            updatedAt: DateTime.utc(2026),
          ),
        );
  });

  tearDown(() => db.close());

  group('FriendsRepository', () {
    test('sorts friendships into friends, requests and sent', () async {
      final result = await friends.overview('u1');
      final overview = (result as Ok<Feed<FriendsOverview>>).value.value;

      expect(overview.friends.map((f) => f.person.id), ['lerato', 'aisha']);
      expect(overview.incoming.single.person.displayName, 'Sipho Dlamini');
      expect(overview.outgoing.single.person.id, 'megan');
      expect(overview.feed.single.title, 'Mom’s bobotie');
    });

    test('falls back to the last copy when offline', () async {
      await friends.overview('u1');
      remote.failures.add(const RemoteFailure('down', isTransient: true));

      final result = await friends.overview('u1');
      final feed = (result as Ok<Feed<FriendsOverview>>).value;

      expect(feed.isStale, isTrue);
      expect(feed.value.friends, hasLength(2));
    });

    test('says no signal when offline with nothing saved', () async {
      remote.failures.add(const RemoteFailure('down', isTransient: true));

      final result = await friends.overview('u1');

      expect(
        (result as Error<Feed<FriendsOverview>>).error.toString(),
        contains(BrowseMessages.offline),
      );
    });

    test('loads a person with their recipes and tags', () async {
      final result = await friends.person('u1', 'lerato');
      final p = (result as Ok<PersonProfile>).value;

      expect(p.link, FriendLink.friends);
      expect(p.recipes.map((r) => r.id), ['f1', 'f2']);
      expect(p.totalSaves, 331);
      expect(p.tags.single.label, 'Desserts');
    });

    test('accept and remove change the friendship rows', () async {
      await friends.accept('u1', 'sipho');
      await friends.remove('u1', 'megan');

      final rows = remote.tables['friendships']!;
      expect(
        rows.firstWhere((r) => r['requester_id'] == 'sipho')['status'],
        'accepted',
      );
      expect(rows.where((r) => r['addressee_id'] == 'megan'), isEmpty);
    });
  });

  group('FriendsCubit', () {
    FriendsCubit build() => FriendsCubit(
      friends: friends,
      browse: BrowseRepositoryImpl(
        api: api
          ..peopleRows = [
            {'id': 'nadia', 'username': 'nadia', 'display_name': 'Nadia S'},
          ],
        db: db,
        outbox: OutboxStore(db),
        currentUserId: () => 'u1',
      ),
      userId: 'u1',
      debounce: Duration.zero,
    );

    blocTest<FriendsCubit, FriendsState>(
      'loads and accepts a request',
      build: build,
      act: (c) async {
        await c.load();
        await c.accept('sipho');
      },
      verify: (c) {
        expect(c.state.data!.incoming, isEmpty);
        expect(
          c.state.data!.friends.map((f) => f.person.id),
          contains('sipho'),
        );
      },
    );

    blocTest<FriendsCubit, FriendsState>(
      'searches people and marks a sent request',
      build: build,
      act: (c) async {
        await c.load();
        c.search('nad');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await c.request('nadia');
      },
      verify: (c) {
        expect(c.state.results.value!.single.displayName, 'Nadia S');
        expect(c.state.linkTo('nadia'), FriendLink.outgoing);
        expect(c.state.linkTo('lerato'), FriendLink.friends);
      },
    );

    blocTest<FriendsCubit, FriendsState>(
      'reports a failed action',
      build: build,
      act: (c) async {
        await c.load();
        remote.failures.add(
          const RemoteFailure('nope', isTransient: false, code: '42501'),
        );
        await c.accept('sipho');
      },
      verify: (c) {
        expect(c.state.error, FriendsMessages.actionFailed);
        expect(c.state.busy, isEmpty);
      },
    );
  });

  group('PersonCubit', () {
    PersonCubit build(String id) =>
        PersonCubit(friends: friends, userId: 'u1', personId: id);

    blocTest<PersonCubit, PersonState>(
      'filters recipes by tag',
      build: () => build('lerato'),
      act: (c) async {
        await c.load();
        c.filterTag(13);
      },
      verify: (c) => expect(c.state.recipes.map((r) => r.id), ['f2']),
    );

    blocTest<PersonCubit, PersonState>(
      'adding a friend shows the request as sent',
      build: () => build('aisha'),
      act: (c) async {
        remote.tables['friendships']!.removeWhere(
          (r) => r['requester_id'] == 'aisha',
        );
        await c.load();
        await c.addFriend();
      },
      verify: (c) {
        expect(c.state.profile.value!.link, FriendLink.outgoing);
        expect(c.state.done, PersonAction.added);
      },
    );
  });

  group('Activity', () {
    late ActivityRepositoryImpl activity;

    setUp(() {
      activity = ActivityRepositoryImpl(remote: remote, api: api, db: db);
      remote.seed('notifications', [
        {
          'id': 'n1',
          'recipient_id': 'u1',
          'actor_id': 'sipho',
          'kind': 'friend_request',
          'recipe_id': null,
          'data': <String, dynamic>{},
          'read_at': null,
          'created_at': '2026-11-14T08:00:00Z',
        },
        {
          'id': 'n2',
          'recipient_id': 'u1',
          'actor_id': 'lerato',
          'kind': 'recipe_saved',
          'recipe_id': 'f1',
          'data': <String, dynamic>{},
          'read_at': '2026-11-13T08:00:00Z',
          'created_at': '2026-11-13T07:00:00Z',
        },
        {
          'id': 'n3',
          'recipient_id': 'u1',
          'actor_id': null,
          'kind': 'weekly_roundup',
          'recipe_id': null,
          'data': {'saves': 12, 'cooks': 3},
          'read_at': null,
          'created_at': '2026-11-10T07:00:00Z',
        },
      ]);
    });

    test('joins people and recipes, newest first', () async {
      final result = await activity.load('u1');
      final items = (result as Ok<Feed<List<ActivityItem>>>).value.value;

      expect(items.map((i) => i.id), ['n1', 'n2', 'n3']);
      expect(items.first.actor!.displayName, 'Sipho Dlamini');
      expect(items[1].recipe!.title, 'Mom’s bobotie');
      expect(items.last.kind, NotificationKind.weeklyRoundup);
      expect(await activity.unreadCount('u1'), 2);
    });

    blocTest<ActivityCubit, ActivityState>(
      'opening marks things read and requests can be answered',
      build: () =>
          ActivityCubit(activity: activity, friends: friends, userId: 'u1'),
      act: (c) async {
        await c.load();
        await c.answer('sipho', accept: true);
      },
      verify: (c) {
        expect(c.state.fresh.map((i) => i.id), ['n1', 'n3']);
        expect(c.state.answered, {'sipho': true});
        expect(
          remote.calls.where(
            (call) => call.target == 'mark_notifications_read',
          ),
          hasLength(1),
        );
      },
    );
  });
}
