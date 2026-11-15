import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';

enum UsernameCheck { unchanged, invalid, checking, free, taken, unknown }

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.displayName,
    required this.username,
    required this.city,
    required this.bio,
    this.check = UsernameCheck.unchanged,
    this.save = const DelayedResult.idle(),
  });

  static final usernamePattern = RegExp(r'^[a-z0-9._]{3,24}$');

  final String displayName;
  final String username;
  final String city;
  final String bio;
  final UsernameCheck check;
  final DelayedResult<bool> save;

  bool get canSave =>
      displayName.trim().isNotEmpty &&
      !save.isInProgress &&
      const {
        UsernameCheck.unchanged,
        UsernameCheck.free,
        UsernameCheck.unknown,
      }.contains(check);

  EditProfileState copyWith({
    String? displayName,
    String? username,
    String? city,
    String? bio,
    UsernameCheck? check,
    DelayedResult<bool>? save,
  }) => EditProfileState(
    displayName: displayName ?? this.displayName,
    username: username ?? this.username,
    city: city ?? this.city,
    bio: bio ?? this.bio,
    check: check ?? this.check,
    save: save ?? this.save,
  );

  @override
  List<Object?> get props => [displayName, username, city, bio, check, save];
}

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required this._profiles,
    required Profile profile,
    this._debounce = const Duration(milliseconds: 400),
  }) : _original = profile.username,
       _uid = profile.id,
       super(
         EditProfileState(
           displayName: profile.displayName,
           username: profile.username,
           city: profile.city ?? '',
           bio: profile.bio ?? '',
         ),
       );

  final ProfileRepository _profiles;
  final String _original;
  final String _uid;
  final Duration _debounce;
  Timer? _timer;

  void setDisplayName(String v) => emit(state.copyWith(displayName: v));

  void setCity(String v) => emit(state.copyWith(city: v));

  void setBio(String v) => emit(state.copyWith(bio: v));

  void setUsername(String raw) {
    final v = raw.trim().toLowerCase();
    _timer?.cancel();
    if (v == _original) {
      emit(state.copyWith(username: v, check: UsernameCheck.unchanged));
      return;
    }
    if (!EditProfileState.usernamePattern.hasMatch(v)) {
      emit(state.copyWith(username: v, check: UsernameCheck.invalid));
      return;
    }
    emit(state.copyWith(username: v, check: UsernameCheck.checking));
    _timer = Timer(_debounce, () => unawaited(_check(v)));
  }

  Future<void> _check(String v) async {
    final result = await _profiles.isUsernameAvailable(v);
    if (isClosed || state.username != v) return;
    emit(
      state.copyWith(
        check: switch (result) {
          Ok(:final value) => value ? UsernameCheck.free : UsernameCheck.taken,
          _ => UsernameCheck.unknown,
        },
      ),
    );
  }

  Future<bool> save() async {
    if (!state.canSave) return false;
    emit(state.copyWith(save: const DelayedResult.inProgress()));
    final result = await _profiles.updateDetails(
      uid: _uid,
      displayName: state.displayName,
      bio: state.bio,
      city: state.city,
      username: state.username == _original ? null : state.username,
    );
    if (isClosed) return false;
    switch (result) {
      case Ok<void>():
        emit(state.copyWith(save: const DelayedResult.fromValue(true)));
        return true;
      case Error<void>(:final error):
        emit(state.copyWith(save: DelayedResult.fromError(error.cleanError)));
        return false;
      case CastError<void>(:final error):
        emit(state.copyWith(save: DelayedResult.fromError(error.cleanError)));
        return false;
    }
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await super.close();
  }
}
