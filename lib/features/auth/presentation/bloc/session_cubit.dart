import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';

enum SessionStatus { unknown, signedOut, guest, onboarding, signedIn }

class SessionState extends Equatable {
  const new({this.status = SessionStatus.unknown, this.userId});

  final SessionStatus status;
  final String? userId;

  bool get isAuthenticated =>
      status == SessionStatus.onboarding || status == SessionStatus.signedIn;

  @override
  List<Object?> get props => [status, userId];
}

class SessionCubit extends Cubit<SessionState> {
  new({
    required this._auth,
    required this._profiles,
    required this._settings,
    required this._sync,
    required this._db,
  }) : super(const SessionState());

  final AuthRepository _auth;
  final ProfileRepository _profiles;
  final AppSettingsStore _settings;
  final SyncService _sync;
  final AppDatabase _db;
  StreamSubscription<AuthUser?>? _userSub;
  Future<void> _queue = Future.value();

  Future<void> start() async {
    _userSub ??= _auth.userChanges.listen((user) => unawaited(_resolve(user)));
    await _resolve(_auth.currentUser);
  }

  Future<void> _resolve(AuthUser? user) =>
      _queue = _queue.then((_) => _apply(user));

  Future<void> _apply(AuthUser? user) async {
    if (isClosed) return;
    if (user == null) {
      final guest = await _settings.flag(SettingKey.guest);
      emit(
        SessionState(
          status: guest ? SessionStatus.guest : SessionStatus.signedOut,
        ),
      );
      return;
    }
    if (user.isAnonymous) {
      emit(SessionState(status: SessionStatus.guest, userId: user.id));
      return;
    }
    if (state.userId == user.id && state.isAuthenticated) return;
    await _settings.setFlag(SettingKey.guest, value: false);
    final local = await _profiles.localProfile(user.id);
    final profile = switch (await _profiles.refreshProfile(user.id)) {
      Ok(:final value) => value ?? local,
      Error() || CastError() => local,
    };
    unawaited(_sync.syncNow(force: true));
    final needsOnboarding = profile != null && profile.onboardedAt == null;
    emit(
      SessionState(
        status: needsOnboarding
            ? SessionStatus.onboarding
            : SessionStatus.signedIn,
        userId: user.id,
      ),
    );
  }

  Future<void> continueAsGuest() async {
    await _settings.setFlag(SettingKey.guest, value: true);
    final result = await _auth.signInAnonymously();
    if (isClosed || result is Ok<void>) return;
    emit(const SessionState(status: SessionStatus.guest));
  }

  Future<void> leaveGuest() async {
    if (state.userId != null) {
      await _auth.signOut();
      await _db.clearUserData();
    }
    await _settings.setFlag(SettingKey.guest, value: false);
    emit(const SessionState(status: SessionStatus.signedOut));
  }

  void completeOnboarding() {
    if (state.userId == null) return;
    emit(SessionState(status: SessionStatus.signedIn, userId: state.userId));
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _db.clearUserData();
    emit(const SessionState(status: SessionStatus.signedOut));
  }

  @override
  Future<void> close() async {
    await _userSub?.cancel();
    await super.close();
  }
}
