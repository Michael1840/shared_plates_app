import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/step_timer.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/screen_awake.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';
import 'package:shared_plates_app/features/recipe/domain/recipe_detail.dart';

class CookTimer extends Equatable {
  const CookTimer({required this.total, required this.remaining, this.endsAt});

  final int total;
  final int remaining;
  final DateTime? endsAt;

  bool get running => endsAt != null;

  bool get finished => remaining <= 0;

  bool get started => running || remaining < total;

  @override
  List<Object?> get props => [total, remaining, endsAt];
}

class CookModeState extends Equatable {
  const CookModeState({
    this.detail = const DelayedResult.idle(),
    this.servings,
    this.units = UnitSystem.metric,
    this.unitDefs = Measure.defaults,
    this.step = 0,
    this.direction = 0,
    this.timers = const {},
    this.alarmTick = 0,
    this.alarmStep,
  });

  final DelayedResult<RecipeDetail> detail;
  final int? servings;
  final UnitSystem units;
  final Map<String, UnitDef> unitDefs;
  final int step;
  final int direction;
  final Map<int, CookTimer> timers;
  final int alarmTick;
  final int? alarmStep;

  List<RecipeStep> get steps => detail.value?.steps ?? const [];

  int get stepCount => steps.length;

  bool get isFirst => step == 0;

  bool get isLast => step >= stepCount - 1;

  RecipeStep? get current => step < stepCount ? steps[step] : null;

  int get baseServings => detail.value?.card.baseServings ?? 4;

  int get currentServings => servings ?? baseServings;

  double get scale => currentServings / baseServings;

  String? amountFor(RecipeIngredient i) => Measure.format(
    quantity: i.quantity,
    unit: i.unit,
    scale: scale,
    system: units,
    units: unitDefs,
  );

  String labelFor(RecipeIngredient i) =>
      [?amountFor(i), Measure.nameFrom(i.rawText)].join(' ');

  List<RecipeIngredient> needsFor(int index) {
    final detail = this.detail.value;
    if (detail == null || index >= stepCount) return const [];
    return detail.ingredientsForStep(steps[index].id);
  }

  int? secondsFor(int index) => index < stepCount
      ? StepTimer.secondsFor(
          explicit: steps[index].timerSeconds,
          body: steps[index].body,
        )
      : null;

  CookTimer? timerFor(int index) {
    final existing = timers[index];
    if (existing != null) return existing;
    final seconds = secondsFor(index);
    return seconds == null
        ? null
        : CookTimer(total: seconds, remaining: seconds);
  }

  Iterable<int> get runningElsewhere => [
    for (final e in timers.entries)
      if (e.key != step && e.value.running) e.key,
  ];

  CookModeState copyWith({
    DelayedResult<RecipeDetail>? detail,
    Map<String, UnitDef>? unitDefs,
    int? step,
    int? direction,
    Map<int, CookTimer>? timers,
    int? alarmTick,
    int? alarmStep,
  }) => CookModeState(
    detail: detail ?? this.detail,
    servings: servings,
    units: units,
    unitDefs: unitDefs ?? this.unitDefs,
    step: step ?? this.step,
    direction: direction ?? this.direction,
    timers: timers ?? this.timers,
    alarmTick: alarmTick ?? this.alarmTick,
    alarmStep: alarmStep ?? this.alarmStep,
  );

  @override
  List<Object?> get props => [
    detail,
    servings,
    units,
    unitDefs,
    step,
    direction,
    timers,
    alarmTick,
    alarmStep,
  ];
}

class CookModeCubit extends Cubit<CookModeState> {
  CookModeCubit({
    required this._repository,
    required this._recipeId,
    required this._screen,
    this._viewerId,
    this._keepScreenOn = true,
    int? servings,
    UnitSystem units = UnitSystem.metric,
    DateTime Function()? clock,
    this._tickEvery = const Duration(seconds: 1),
  }) : _now = clock ?? DateTime.now,
       super(CookModeState(servings: servings, units: units));

  static const missing = "This recipe isn't on your phone yet.";

  final RecipeDetailRepository _repository;
  final String _recipeId;
  final ScreenAwake _screen;
  final String? _viewerId;
  final bool _keepScreenOn;
  final DateTime Function() _now;
  final Duration _tickEvery;
  Timer? _ticker;
  bool _awake = false;

  Future<void> start() async {
    emit(state.copyWith(detail: const DelayedResult.inProgress()));
    if (_keepScreenOn) {
      _awake = true;
      unawaited(_screen.keepOn());
    }
    final defs = await _repository.units();
    final detail = await _repository
        .watch(_recipeId, viewerId: _viewerId)
        .first;
    if (isClosed) return;
    if (detail == null || detail.steps.isEmpty) {
      emit(state.copyWith(detail: const DelayedResult.fromError(missing)));
      return;
    }
    emit(
      state.copyWith(unitDefs: defs, detail: DelayedResult.fromValue(detail)),
    );
  }

  void next() => goTo(state.step + 1);

  void back() => goTo(state.step - 1);

  void goTo(int index) {
    if (index < 0 || index >= state.stepCount || index == state.step) return;
    emit(state.copyWith(step: index, direction: index > state.step ? 1 : -1));
  }

  void toggleTimer() {
    final index = state.step;
    final timer = state.timerFor(index);
    if (timer == null) return;
    final now = _now();
    final CookTimer updated;
    if (timer.finished) {
      updated = CookTimer(total: timer.total, remaining: timer.total);
    } else if (timer.running) {
      updated = CookTimer(
        total: timer.total,
        remaining: _left(timer.endsAt!, now),
      );
    } else {
      updated = CookTimer(
        total: timer.total,
        remaining: timer.remaining,
        endsAt: now.add(Duration(seconds: timer.remaining)),
      );
    }
    emit(state.copyWith(timers: {...state.timers, index: updated}));
    _syncTicker();
  }

  void tick() {
    if (isClosed) return;
    final now = _now();
    final next = <int, CookTimer>{};
    int? rang;
    for (final MapEntry(key: index, value: timer) in state.timers.entries) {
      final endsAt = timer.endsAt;
      if (endsAt == null) {
        next[index] = timer;
        continue;
      }
      final left = _left(endsAt, now);
      if (left <= 0) {
        rang = index;
        next[index] = CookTimer(total: timer.total, remaining: 0);
      } else {
        next[index] = CookTimer(
          total: timer.total,
          remaining: left,
          endsAt: endsAt,
        );
      }
    }
    final ringing = rang;
    emit(
      ringing == null
          ? state.copyWith(timers: next)
          : state.copyWith(
              timers: next,
              alarmTick: state.alarmTick + 1,
              alarmStep: ringing,
            ),
    );
    _syncTicker();
  }

  int _left(DateTime endsAt, DateTime now) =>
      (endsAt.difference(now).inMilliseconds / 1000).ceil();

  void _syncTicker() {
    final anyRunning = state.timers.values.any((t) => t.running);
    if (anyRunning && _ticker == null) {
      _ticker = Timer.periodic(_tickEvery, (_) => tick());
    } else if (!anyRunning) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  @override
  Future<void> close() async {
    _ticker?.cancel();
    if (_awake) await _screen.release();
    await super.close();
  }
}
