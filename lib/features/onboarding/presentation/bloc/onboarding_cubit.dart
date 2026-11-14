import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/domain/avoid_option.dart';
import 'package:shared_plates_app/features/profile/domain/popular_cook.dart';

enum UsernameCheck { unchanged, checking, available, taken, invalid, offline }

class OnboardingState extends Equatable {
  const new({
    this.displayName = '',
    this.username = '',
    this.originalUsername = '',
    this.usernameCheck = UsernameCheck.unchanged,
    this.units = UnitSystem.metric,
    this.unitsFromRegion = true,
    this.tags = const [],
    this.tasteIds = const {},
    this.avoid = const {},
    this.cooks = const DelayedResult.idle(),
    this.requested = const {},
    this.saving = const DelayedResult.idle(),
  });

  static final usernamePattern = RegExp(r'^[a-z0-9._]{3,24}$');

  final String displayName;
  final String username;
  final String originalUsername;
  final UsernameCheck usernameCheck;
  final UnitSystem units;
  final bool unitsFromRegion;
  final List<Tag> tags;
  final Set<int> tasteIds;
  final Set<AvoidOption> avoid;
  final DelayedResult<List<PopularCook>> cooks;
  final Set<String> requested;
  final DelayedResult<bool> saving;

  bool get canContinueYou =>
      displayName.trim().isNotEmpty &&
      (usernameCheck == UsernameCheck.unchanged ||
          usernameCheck == UsernameCheck.available);

  OnboardingState copyWith({
    String? displayName,
    String? username,
    String? originalUsername,
    UsernameCheck? usernameCheck,
    UnitSystem? units,
    bool? unitsFromRegion,
    List<Tag>? tags,
    Set<int>? tasteIds,
    Set<AvoidOption>? avoid,
    DelayedResult<List<PopularCook>>? cooks,
    Set<String>? requested,
    DelayedResult<bool>? saving,
  }) => OnboardingState(
    displayName: displayName ?? this.displayName,
    username: username ?? this.username,
    originalUsername: originalUsername ?? this.originalUsername,
    usernameCheck: usernameCheck ?? this.usernameCheck,
    units: units ?? this.units,
    unitsFromRegion: unitsFromRegion ?? this.unitsFromRegion,
    tags: tags ?? this.tags,
    tasteIds: tasteIds ?? this.tasteIds,
    avoid: avoid ?? this.avoid,
    cooks: cooks ?? this.cooks,
    requested: requested ?? this.requested,
    saving: saving ?? this.saving,
  );

  @override
  List<Object?> get props => [
    displayName,
    username,
    originalUsername,
    usernameCheck,
    units,
    unitsFromRegion,
    tags,
    tasteIds,
    avoid,
    cooks,
    requested,
    saving,
  ];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  new({
    required this._profiles,
    required this._userId,
    String? countryCode,
    this.debounce = const Duration(milliseconds: 450),
  }) : super(OnboardingState(units: unitsForCountry(countryCode)));

  static const _imperialCountries = {'US', 'LR', 'MM'};

  static UnitSystem unitsForCountry(String? code) =>
      _imperialCountries.contains(code?.toUpperCase())
      ? UnitSystem.imperial
      : UnitSystem.metric;

  final ProfileRepository _profiles;
  final String _userId;
  final Duration debounce;
  Timer? _usernameTimer;
  StreamSubscription<List<Tag>>? _tagsSub;
  int _checkToken = 0;

  Future<void> load() async {
    _tagsSub ??= _profiles.watchTags().listen((tags) {
      if (!isClosed) emit(state.copyWith(tags: tags));
    });
    final profile = await _profiles.localProfile(_userId);
    if (profile == null || isClosed) return;
    final tastes = await _profiles.watchTastes(_userId).first;
    if (isClosed) return;
    emit(
      state.copyWith(
        displayName: profile.displayName,
        username: profile.username,
        originalUsername: profile.username,
        tasteIds: tastes,
      ),
    );
  }

  void nameChanged(String value) => emit(state.copyWith(displayName: value));

  void usernameChanged(String raw) {
    final value = raw.trim().toLowerCase();
    _usernameTimer?.cancel();
    _checkToken++;
    if (value == state.originalUsername) {
      emit(
        state.copyWith(username: value, usernameCheck: UsernameCheck.unchanged),
      );
      return;
    }
    if (!OnboardingState.usernamePattern.hasMatch(value)) {
      emit(
        state.copyWith(username: value, usernameCheck: UsernameCheck.invalid),
      );
      return;
    }
    emit(
      state.copyWith(username: value, usernameCheck: UsernameCheck.checking),
    );
    final token = _checkToken;
    _usernameTimer = Timer(debounce, () => unawaited(_check(value, token)));
  }

  Future<void> _check(String value, int token) async {
    final result = await _profiles.isUsernameAvailable(value);
    if (isClosed || token != _checkToken) return;
    final check = switch (result) {
      Ok(:final value) => value ? UsernameCheck.available : UsernameCheck.taken,
      Error() || CastError() => UsernameCheck.offline,
    };
    emit(state.copyWith(usernameCheck: check));
  }

  void unitsChanged(UnitSystem units) =>
      emit(state.copyWith(units: units, unitsFromRegion: false));

  void toggleTaste(int tagId) {
    final next = {...state.tasteIds};
    if (!next.remove(tagId)) next.add(tagId);
    emit(state.copyWith(tasteIds: next));
  }

  void toggleAvoid(AvoidOption option) {
    final next = {...state.avoid};
    if (!next.remove(option)) next.add(option);
    emit(state.copyWith(avoid: next));
  }

  Future<bool> saveYou() async {
    if (!state.canContinueYou) return false;
    final changed = state.usernameCheck == UsernameCheck.available;
    return await _save(
      () => _profiles.saveBasics(
        uid: _userId,
        displayName: state.displayName.trim(),
        units: state.units,
        username: changed ? state.username : null,
      ),
    );
  }

  Future<bool> saveTastes() => _save(
    () => _profiles.saveTastes(
      uid: _userId,
      tagIds: state.tasteIds,
      avoid: state.avoid,
    ),
  );

  Future<bool> finish() => _save(() => _profiles.markOnboarded(_userId));

  Future<bool> _save(Future<Result<void>> Function() write) async {
    emit(state.copyWith(saving: const DelayedResult.inProgress()));
    final result = await write();
    if (isClosed) return false;
    switch (result) {
      case Error<void>(:final error):
        emit(state.copyWith(saving: DelayedResult.fromError(error.cleanError)));
        return false;
      case CastError<void>(:final error):
        emit(state.copyWith(saving: DelayedResult.fromError(error.cleanError)));
        return false;
      case Ok<void>():
        emit(state.copyWith(saving: const DelayedResult.idle()));
        return true;
    }
  }

  Future<void> loadCooks() async {
    if (state.cooks.isInProgress) return;
    emit(state.copyWith(cooks: const DelayedResult.inProgress()));
    final result = await _profiles.popularCooks();
    if (isClosed) return;
    switch (result) {
      case Error<List<PopularCook>>(:final error):
        emit(state.copyWith(cooks: DelayedResult.fromError(error.cleanError)));
      case CastError<List<PopularCook>>(:final error):
        emit(state.copyWith(cooks: DelayedResult.fromError(error.cleanError)));
      case Ok<List<PopularCook>>(:final value):
        emit(state.copyWith(cooks: DelayedResult.fromValue(value)));
    }
  }

  Future<void> requestFriend(String cookId) async {
    if (state.requested.contains(cookId)) return;
    emit(state.copyWith(requested: {...state.requested, cookId}));
    final result = await _profiles.requestFriend(cookId);
    if (isClosed || result is Ok<void>) return;
    emit(state.copyWith(requested: {...state.requested}..remove(cookId)));
  }

  @override
  Future<void> close() async {
    _usernameTimer?.cancel();
    await _tagsSub?.cancel();
    await super.close();
  }
}
