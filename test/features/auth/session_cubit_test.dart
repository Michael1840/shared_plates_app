import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAuthRepository auth;
  late MockProfileRepository profiles;
  late MockSettingsStore settings;
  late MockSyncService sync;
  late MockAppDatabase db;
  late StreamController<AuthUser?> users;

  Profile profile({DateTime? onboardedAt}) => Profile(
    id: 'u1',
    username: 'thandi',
    displayName: 'Thandi',
    createdAt: DateTime.utc(2026, 11),
    updatedAt: DateTime.utc(2026, 11),
    onboardedAt: onboardedAt,
  );

  setUpAll(() => registerFallbackValue(SettingKey.guest));

  setUp(() {
    auth = MockAuthRepository();
    profiles = MockProfileRepository();
    settings = MockSettingsStore();
    sync = MockSyncService();
    db = MockAppDatabase();
    users = StreamController<AuthUser?>.broadcast();
    when(() => auth.userChanges).thenAnswer((_) => users.stream);
    when(() => settings.flag(any())).thenAnswer((_) async => false);
    when(() => settings.setFlag(any(), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => sync.syncNow(force: any(named: 'force')))
        .thenAnswer((_) async => const SyncReport());
  });

  tearDown(() => users.close());

  SessionCubit build() => SessionCubit(
    auth: auth,
    profiles: profiles,
    settings: settings,
    sync: sync,
    db: db,
  );

  blocTest<SessionCubit, SessionState>(
    'is signed out without a session',
    setUp: () => when(() => auth.currentUser).thenReturn(null),
    build: build,
    act: (c) => c.start(),
    expect: () => [const SessionState(status: SessionStatus.signedOut)],
  );

  blocTest<SessionCubit, SessionState>(
    'restores guest mode',
    setUp: () {
      when(() => auth.currentUser).thenReturn(null);
      when(() => settings.flag(SettingKey.guest)).thenAnswer((_) async => true);
    },
    build: build,
    act: (c) => c.start(),
    expect: () => [const SessionState(status: SessionStatus.guest)],
  );

  blocTest<SessionCubit, SessionState>(
    'sends a new user to onboarding and starts a sync',
    setUp: () {
      when(() => auth.currentUser).thenReturn(const AuthUser(id: 'u1'));
      when(() => profiles.localProfile('u1')).thenAnswer((_) async => null);
      when(() => profiles.refreshProfile('u1'))
          .thenAnswer((_) async => Result.ok(profile()));
    },
    build: build,
    act: (c) => c.start(),
    expect: () => [
      const SessionState(status: SessionStatus.onboarding, userId: 'u1'),
    ],
    verify: (_) => verify(() => sync.syncNow(force: true)).called(1),
  );

  blocTest<SessionCubit, SessionState>(
    'uses the cached profile when offline',
    setUp: () {
      when(() => auth.currentUser).thenReturn(const AuthUser(id: 'u1'));
      when(() => profiles.localProfile('u1')).thenAnswer(
        (_) async => profile(onboardedAt: DateTime.utc(2026, 11, 2)),
      );
      when(() => profiles.refreshProfile('u1'))
          .thenAnswer((_) async => Result.error(Exception('offline')));
    },
    build: build,
    act: (c) => c.start(),
    expect: () => [
      const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'reacts to a sign-in from the auth stream',
    setUp: () {
      when(() => auth.currentUser).thenReturn(null);
      when(() => profiles.localProfile('u1')).thenAnswer((_) async => null);
      when(() => profiles.refreshProfile('u1')).thenAnswer(
        (_) async => Result.ok(profile(onboardedAt: DateTime.utc(2026, 11))),
      );
    },
    build: build,
    act: (c) async {
      await c.start();
      users.add(const AuthUser(id: 'u1'));
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      const SessionState(status: SessionStatus.signedOut),
      const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'completing onboarding signs the user in',
    build: build,
    seed: () =>
        const SessionState(status: SessionStatus.onboarding, userId: 'u1'),
    act: (c) => c.completeOnboarding(),
    expect: () => [
      const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'signing out clears local data',
    setUp: () {
      when(() => auth.signOut()).thenAnswer((_) async => const Result.ok(null));
      when(() => db.clearUserData()).thenAnswer((_) async {});
    },
    build: build,
    seed: () =>
        const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
    act: (c) => c.signOut(),
    expect: () => [const SessionState(status: SessionStatus.signedOut)],
    verify: (_) => verify(() => db.clearUserData()).called(1),
  );

  blocTest<SessionCubit, SessionState>(
    'treats an anonymous session as a guest',
    setUp: () =>
        when(() => auth.currentUser)
            .thenReturn(const AuthUser(id: 'anon', isAnonymous: true)),
    build: build,
    act: (c) => c.start(),
    expect: () => [
      const SessionState(status: SessionStatus.guest, userId: 'anon'),
    ],
    verify: (_) => verifyNever(() => profiles.refreshProfile(any())),
  );

  blocTest<SessionCubit, SessionState>(
    'falls back to a local guest when anonymous sign-in fails',
    setUp: () =>
        when(() => auth.signInAnonymously())
            .thenAnswer((_) async => Result.error(Exception('disabled'))),
    build: build,
    act: (c) => c.continueAsGuest(),
    expect: () => [const SessionState(status: SessionStatus.guest)],
  );

  blocTest<SessionCubit, SessionState>(
    'leaving an anonymous guest session signs it out',
    setUp: () {
      when(() => auth.signOut()).thenAnswer((_) async => const Result.ok(null));
      when(() => db.clearUserData()).thenAnswer((_) async {});
    },
    build: build,
    seed: () => const SessionState(status: SessionStatus.guest, userId: 'anon'),
    act: (c) => c.leaveGuest(),
    expect: () => [const SessionState(status: SessionStatus.signedOut)],
    verify: (_) => verify(() => auth.signOut()).called(1),
  );
}
