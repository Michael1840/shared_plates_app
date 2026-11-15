import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/domain/avoid_option.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.profile,
    this.avoid = const {},
    this.tellCooks = true,
    this.error,
    this.errorTick = 0,
  });

  final Profile? profile;
  final Set<AvoidOption> avoid;
  final bool tellCooks;
  final String? error;
  final int errorTick;

  SettingsState copyWith({
    Profile? profile,
    Set<AvoidOption>? avoid,
    bool? tellCooks,
    String? error,
    int? errorTick,
  }) => SettingsState(
    profile: profile ?? this.profile,
    avoid: avoid ?? this.avoid,
    tellCooks: tellCooks ?? this.tellCooks,
    error: error ?? this.error,
    errorTick: errorTick ?? this.errorTick,
  );

  @override
  List<Object?> get props => [profile, avoid, tellCooks, error, errorTick];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this._profiles,
    required this._settings,
    required this._userId,
  }) : super(const SettingsState());

  final ProfileRepository _profiles;
  final AppSettingsStore _settings;
  final String _userId;
  final List<StreamSubscription<Object?>> _subs = [];

  void start() {
    _subs
      ..add(
        _profiles.watchProfile(_userId).listen((p) {
          if (!isClosed && p != null) emit(state.copyWith(profile: p));
        }),
      )
      ..add(
        _profiles.watchAvoid(_userId).listen((a) {
          if (!isClosed) emit(state.copyWith(avoid: a));
        }),
      )
      ..add(
        _settings.watchValue(SettingKey.tellCooks).listen((v) {
          if (!isClosed) emit(state.copyWith(tellCooks: v != 'false'));
        }),
      );
  }

  Future<void> update(ProfilePreferences preferences) =>
      _report(_profiles.updatePreferences(_userId, preferences));

  Future<void> setAvoid(Set<AvoidOption> avoid) =>
      _report(_profiles.saveAvoid(_userId, avoid));

  Future<void> setTellCooks({required bool value}) =>
      _settings.setValue(SettingKey.tellCooks, '$value');

  Future<void> _report(Future<Result<void>> call) async {
    final result = await call;
    if (isClosed) return;
    if (result case Error(:final error)) {
      emit(
        state.copyWith(error: error.cleanError, errorTick: state.errorTick + 1),
      );
    }
  }

  @override
  Future<void> close() async {
    for (final s in _subs) {
      await s.cancel();
    }
    await super.close();
  }
}

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit(this._settings) : super(ThemeMode.system) {
    _sub = _settings.watchValue(SettingKey.themeMode).listen((v) {
      if (!isClosed) {
        emit(enumByName(ThemeMode.values, v, ThemeMode.system));
      }
    });
  }

  final AppSettingsStore _settings;
  late final StreamSubscription<String?> _sub;

  Future<void> set(ThemeMode mode) =>
      _settings.setValue(SettingKey.themeMode, mode.name);

  @override
  Future<void> close() async {
    await _sub.cancel();
    await super.close();
  }
}
