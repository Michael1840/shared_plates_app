import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/db/mappers.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/profile/domain/avoid_option.dart';
import 'package:shared_plates_app/features/profile/domain/popular_cook.dart';

abstract final class ProfileMessages {
  static const offline = 'No signal right now. Try again in a bit.';
  static const generic = 'Something went wrong. Try again.';
}

abstract interface class ProfileRepository {
  Stream<Profile?> watchProfile(String uid);

  Future<Profile?> localProfile(String uid);

  Future<Result<Profile?>> refreshProfile(String uid);

  Stream<List<Tag>> watchTags();

  Stream<Set<int>> watchTastes(String uid);

  Future<Result<bool>> isUsernameAvailable(String username);

  Future<Result<void>> saveBasics({
    required String uid,
    required String displayName,
    required UnitSystem units,
    String? username,
  });

  Future<Result<void>> saveTastes({
    required String uid,
    required Set<int> tagIds,
    required Set<AvoidOption> avoid,
  });

  Future<Result<void>> markOnboarded(String uid);

  Future<Result<List<PopularCook>>> popularCooks({int limit = 6});

  Future<Result<void>> requestFriend(String addresseeId);

  Future<Result<void>> updateDetails({
    required String uid,
    required String displayName,
    required String? bio,
    required String? city,
    String? username,
  });

  Future<Result<void>> updatePreferences(
    String uid,
    ProfilePreferences preferences,
  );

  Stream<Set<AvoidOption>> watchAvoid(String uid);

  Future<Result<void>> saveAvoid(String uid, Set<AvoidOption> avoid);
}

class ProfilePreferences {
  const new({
    this.units,
    this.defaultVisibility,
    this.keepScreenOn,
    this.notifySaves,
    this.notifyCooks,
    this.notifyFriends,
    this.weeklyRoundup,
  });

  final UnitSystem? units;
  final RecipeVisibility? defaultVisibility;
  final bool? keepScreenOn;
  final bool? notifySaves;
  final bool? notifyCooks;
  final bool? notifyFriends;
  final bool? weeklyRoundup;

  JsonRow toRemote() => {
    'units': ?units?.name,
    'default_visibility': ?defaultVisibility?.name,
    'keep_screen_on': ?keepScreenOn,
    'notify_saves': ?notifySaves,
    'notify_cooks': ?notifyCooks,
    'notify_friends': ?notifyFriends,
    'weekly_roundup': ?weeklyRoundup,
  };

  ProfilesCompanion toLocal(DateTime at) => ProfilesCompanion(
    units: _value(units),
    defaultVisibility: _value(defaultVisibility),
    keepScreenOn: _value(keepScreenOn),
    notifySaves: _value(notifySaves),
    notifyCooks: _value(notifyCooks),
    notifyFriends: _value(notifyFriends),
    weeklyRoundup: _value(weeklyRoundup),
    updatedAt: Value(at),
  );

  static Value<T> _value<T>(T? v) =>
      v == null ? const Value.absent() : Value(v);
}

class ProfileRepositoryImpl implements ProfileRepository {
  new({
    required this._db,
    required this._outbox,
    required this._remote,
    required this._sync,
    required this._settings,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final OutboxStore _outbox;
  final RemoteStore _remote;
  final SyncService _sync;
  final AppSettingsStore _settings;
  final DateTime Function() _now;

  @override
  Stream<Profile?> watchProfile(String uid) =>
      (_db.select(_db.profiles)..where((t) => t.id.equals(uid)))
          .watchSingleOrNull()
          .map((row) => row?.toDomain());

  @override
  Future<Profile?> localProfile(String uid) async {
    final row = await (_db.select(
      _db.profiles,
    )..where((t) => t.id.equals(uid))).getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<Result<Profile?>> refreshProfile(
    String uid,
  ) => _guard('refreshProfile', () async {
    final rows = await _remote.fetchIn('profiles', column: 'id', values: [uid]);
    final pending = await _outbox.pendingKeys();
    if (rows.isNotEmpty &&
        !_outbox.hasPendingWithPrefix(pending, 'profiles:$uid')) {
      await _db
          .into(_db.profiles)
          .insertOnConflictUpdate(Profile.fromJson(rows.first).toCompanion());
    }
    return await localProfile(uid);
  });

  @override
  Stream<List<Tag>> watchTags() =>
      (_db.select(_db.tags)..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .watch()
          .map((rows) => [for (final r in rows) r.toDomain()]);

  @override
  Stream<Set<int>> watchTastes(String uid) =>
      (_db.select(_db.profileTastes)..where((t) => t.userId.equals(uid)))
          .watch()
          .map((rows) => {for (final r in rows) r.tagId});

  @override
  Future<Result<bool>> isUsernameAvailable(String username) => _guard(
    'isUsernameAvailable',
    () async =>
        await _remote.rpc('username_available', {'name': username}) == true,
  );

  @override
  Future<Result<void>> saveBasics({
    required String uid,
    required String displayName,
    required UnitSystem units,
    String? username,
  }) => _local('saveBasics', () async {
    final name = username;
    await _db.transaction(() async {
      await (_db.update(_db.profiles)..where((t) => t.id.equals(uid))).write(
        ProfilesCompanion(
          displayName: Value(displayName),
          units: Value(units),
          username: name == null ? const Value.absent() : Value(name),
          updatedAt: Value(_now()),
        ),
      );
      await _outbox.enqueue(
        OutboxOperation.update(
          'profiles',
          {'display_name': displayName, 'units': units.name, 'username': ?name},
          match: {'id': uid},
          dedupeKey: 'profiles:$uid:basics',
        ),
      );
    });
  });

  @override
  Future<Result<void>> saveTastes({
    required String uid,
    required Set<int> tagIds,
    required Set<AvoidOption> avoid,
  }) => _local('saveTastes', () async {
    final foods = await _db.select(_db.foods).get();
    final hidden = {
      for (final f in foods)
        if (avoid.any((o) => o.matches(f.name, f.aliases))) f.id,
    };
    await _db.transaction(() async {
      await (_db.delete(
        _db.profileTastes,
      )..where((t) => t.userId.equals(uid))).go();
      await (_db.delete(
        _db.hiddenFoods,
      )..where((t) => t.userId.equals(uid))).go();
      await _db.batch((b) {
        b
          ..insertAll(_db.profileTastes, [
            for (final id in tagIds)
              ProfileTastesCompanion.insert(userId: uid, tagId: id),
          ])
          ..insertAll(_db.hiddenFoods, [
            for (final id in hidden)
              HiddenFoodsCompanion.insert(userId: uid, foodId: id),
          ]);
      });
      await _replaceRemoteSet(
        table: 'profile_tastes',
        uid: uid,
        column: 'tag_id',
        values: tagIds,
      );
      await _replaceRemoteSet(
        table: 'hidden_foods',
        uid: uid,
        column: 'food_id',
        values: hidden,
      );
    });
  });

  Future<void> _replaceRemoteSet({
    required String table,
    required String uid,
    required String column,
    required Set<Object> values,
  }) async {
    final prefix = '$table:$uid';
    await _outbox.discardPending(prefix);
    await _outbox.enqueue(
      OutboxOperation.delete(table, {'user_id': uid}, dedupeKey: prefix),
    );
    for (final value in values) {
      await _outbox.enqueue(
        OutboxOperation.insertIgnoringDuplicates(
          table,
          {'user_id': uid, column: value},
          conflictColumns: 'user_id,$column',
          dedupeKey: '$prefix:$value',
        ),
      );
    }
  }

  @override
  Future<Result<void>> markOnboarded(String uid) =>
      _local('markOnboarded', () async {
        final at = _now().toUtc();
        await _db.transaction(() async {
          await (_db.update(_db.profiles)..where((t) => t.id.equals(uid)))
              .write(ProfilesCompanion(onboardedAt: Value(at)));
          await _outbox.enqueue(
            OutboxOperation.update(
              'profiles',
              {'onboarded_at': at.toIso8601String()},
              match: {'id': uid},
              dedupeKey: 'profiles:$uid:onboarded',
            ),
          );
        });
      });

  @override
  Future<Result<List<PopularCook>>> popularCooks({int limit = 6}) =>
      _guard('popularCooks', () async {
        final rows = await _remote.rpc('popular_cooks', {'lim': limit});
        if (rows is! List) return const <PopularCook>[];
        return [
          for (final r in rows.cast<Map<String, dynamic>>())
            PopularCook.fromJson(r),
        ];
      });

  @override
  Future<Result<void>> requestFriend(String addresseeId) =>
      _local('requestFriend', () async {
        await _outbox.enqueue(
          OutboxOperation.insertIgnoringDuplicates(
            'friendships',
            {'addressee_id': addresseeId},
            conflictColumns: 'requester_id,addressee_id',
            dedupeKey: 'friendships:$addresseeId',
          ),
        );
        await _settings.setFlag(SettingKey.friendRequested, value: true);
      });

  @override
  Future<Result<void>> updateDetails({
    required String uid,
    required String displayName,
    required String? bio,
    required String? city,
    String? username,
  }) => _local('updateDetails', () async {
    final name = username;
    String? clean(String? v, int max) {
      final t = v?.trim();
      if (t == null || t.isEmpty) return null;
      return t.length > max ? t.substring(0, max) : t;
    }

    final shownName = clean(displayName, 60) ?? displayName.trim();
    final about = clean(bio, 160);
    final place = clean(city, 60);
    await _db.transaction(() async {
      await (_db.update(_db.profiles)..where((t) => t.id.equals(uid))).write(
        ProfilesCompanion(
          displayName: Value(shownName),
          bio: Value(about),
          city: Value(place),
          username: name == null ? const Value.absent() : Value(name),
          updatedAt: Value(_now()),
        ),
      );
      await _outbox.enqueue(
        OutboxOperation.update(
          'profiles',
          {
            'display_name': shownName,
            'bio': about,
            'city': place,
            'username': ?name,
          },
          match: {'id': uid},
          dedupeKey: 'profiles:$uid:details',
        ),
      );
    });
  });

  @override
  Future<Result<void>> updatePreferences(
    String uid,
    ProfilePreferences preferences,
  ) => _local('updatePreferences', () async {
    final remote = preferences.toRemote();
    if (remote.isEmpty) return;
    await _db.transaction(() async {
      await (_db.update(
        _db.profiles,
      )..where((t) => t.id.equals(uid))).write(preferences.toLocal(_now()));
      for (final MapEntry(key: column, :value) in remote.entries) {
        await _outbox.enqueue(
          OutboxOperation.update(
            'profiles',
            {column: value},
            match: {'id': uid},
            dedupeKey: 'profiles:$uid:$column',
          ),
        );
      }
    });
  });

  @override
  Stream<Set<AvoidOption>> watchAvoid(String uid) {
    final query = _db.select(_db.foods).join([
      innerJoin(
        _db.hiddenFoods,
        _db.hiddenFoods.foodId.equalsExp(_db.foods.id) &
            _db.hiddenFoods.userId.equals(uid),
      ),
    ]);
    return query.watch().map((rows) {
      final foods = [for (final r in rows) r.readTable(_db.foods)];
      return {
        for (final option in AvoidOption.values)
          if (foods.any((f) => option.matches(f.name, f.aliases))) option,
      };
    });
  }

  @override
  Future<Result<void>> saveAvoid(String uid, Set<AvoidOption> avoid) =>
      _local('saveAvoid', () async {
        final foods = await _db.select(_db.foods).get();
        final hidden = {
          for (final f in foods)
            if (avoid.any((o) => o.matches(f.name, f.aliases))) f.id,
        };
        await _db.transaction(() async {
          await (_db.delete(
            _db.hiddenFoods,
          )..where((t) => t.userId.equals(uid))).go();
          await _db.batch(
            (b) => b.insertAll(_db.hiddenFoods, [
              for (final id in hidden)
                HiddenFoodsCompanion.insert(userId: uid, foodId: id),
            ]),
          );
          await _replaceRemoteSet(
            table: 'hidden_foods',
            uid: uid,
            column: 'food_id',
            values: hidden,
          );
        });
      });

  Future<Result<void>> _local(
    String source,
    Future<void> Function() write,
  ) async {
    try {
      await write();
      _sync.requestSync();
      return const Result.ok(null);
    } on Exception catch (e, s) {
      ErrorReporter.report('ProfileRepository.$source', e, s);
      return Result.error(Exception(ProfileMessages.generic));
    }
  }

  Future<Result<T>> _guard<T>(String source, Future<T> Function() call) async {
    try {
      return Result.ok(await call());
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('ProfileRepository.$source', e, s);
      return Result.error(
        Exception(
          e.isTransient ? ProfileMessages.offline : ProfileMessages.generic,
        ),
      );
    } on FormatException catch (e, s) {
      ErrorReporter.report('ProfileRepository.$source', e, s);
      return const Result.castError();
    } on Exception catch (e, s) {
      ErrorReporter.report('ProfileRepository.$source', e, s);
      return Result.error(Exception(ProfileMessages.generic));
    }
  }
}
