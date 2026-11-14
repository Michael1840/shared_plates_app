import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';
import 'package:shared_plates_app/features/recipe/domain/recipe_detail.dart';

class RecipeDetailState extends Equatable {
  const new({
    this.detail = const DelayedResult.idle(),
    this.preview,
    this.refreshError,
    this.servings,
    this.units = UnitSystem.metric,
    this.unitDefs = Measure.defaults,
    this.coverUrl,
    this.localTicks = const {},
    this.fork = const DelayedResult.idle(),
    this.changeTick = 0,
  });

  static const minServings = 1;
  static const maxServings = 48;

  final DelayedResult<RecipeDetail> detail;
  final RecipeCard? preview;
  final String? refreshError;
  final int? servings;
  final UnitSystem units;
  final Map<String, UnitDef> unitDefs;
  final String? coverUrl;
  final Set<String> localTicks;
  final DelayedResult<String> fork;
  final int changeTick;

  RecipeCard? get card => detail.value?.card ?? preview;

  int get baseServings => card?.baseServings ?? 4;

  int get currentServings => servings ?? baseServings;

  double get scale => currentServings / baseServings;

  bool get isOffline => refreshError != null && detail.isSuccessful;

  Set<String> get ticks => {...?detail.value?.ticks, ...localTicks};

  String? amountFor(RecipeIngredient i) => Measure.format(
    quantity: i.quantity,
    unit: i.unit,
    scale: scale,
    system: units,
    units: unitDefs,
  );

  int? costFor(RecipeIngredient i) => Measure.scaledCents(i.costCents, scale);

  RecipeDetailState copyWith({
    DelayedResult<RecipeDetail>? detail,
    String? refreshError,
    bool clearRefreshError = false,
    int? servings,
    UnitSystem? units,
    Map<String, UnitDef>? unitDefs,
    String? coverUrl,
    Set<String>? localTicks,
    DelayedResult<String>? fork,
    int? changeTick,
  }) => RecipeDetailState(
    detail: detail ?? this.detail,
    preview: preview,
    refreshError: clearRefreshError ? null : refreshError ?? this.refreshError,
    servings: servings ?? this.servings,
    units: units ?? this.units,
    unitDefs: unitDefs ?? this.unitDefs,
    coverUrl: coverUrl ?? this.coverUrl,
    localTicks: localTicks ?? this.localTicks,
    fork: fork ?? this.fork,
    changeTick: changeTick ?? this.changeTick,
  );

  @override
  List<Object?> get props => [
    detail,
    preview,
    refreshError,
    servings,
    units,
    unitDefs,
    coverUrl,
    localTicks,
    fork,
    changeTick,
  ];
}

class RecipeDetailCubit extends Cubit<RecipeDetailState> {
  new({
    required this._repository,
    required this._recipeId,
    this._viewerId,
    UnitSystem units = UnitSystem.metric,
    RecipeCard? preview,
  }) : super(RecipeDetailState(units: units, preview: preview));

  final RecipeDetailRepository _repository;
  final String _recipeId;
  final String? _viewerId;
  StreamSubscription<RecipeDetail?>? _sub;
  bool _refreshed = false;

  Future<void> start() async {
    emit(state.copyWith(detail: const DelayedResult.inProgress()));
    final defs = await _repository.units();
    if (isClosed) return;
    emit(state.copyWith(unitDefs: defs));
    _sub = _repository.watch(_recipeId, viewerId: _viewerId).listen(_onLocal);
    final viewer = _viewerId;
    if (viewer != null) {
      unawaited(_repository.markViewed(viewer, _recipeId));
    }
    await refresh();
  }

  void _onLocal(RecipeDetail? detail) {
    if (isClosed) return;
    if (detail != null && detail.hasContent) {
      emit(state.copyWith(detail: DelayedResult.fromValue(detail)));
      unawaited(_resolveCover(detail.card));
      return;
    }
    if (_refreshed && !state.detail.isSuccessful) {
      emit(
        state.copyWith(
          detail: DelayedResult.fromError(
            state.refreshError ?? RecipeMessages.missing,
          ),
        ),
      );
    }
  }

  Future<void> _resolveCover(RecipeCard card) async {
    final path = card.coverPath;
    if (card.localCoverPath != null || path == null) return;
    if (state.coverUrl != null) return;
    final url = state.preview?.coverUrl ?? await _repository.coverUrl(path);
    if (!isClosed && url != null) emit(state.copyWith(coverUrl: url));
  }

  Future<void> refresh() async {
    final result = await _repository.refresh(_recipeId);
    _refreshed = true;
    if (isClosed) return;
    switch (result) {
      case Ok<void>():
        emit(state.copyWith(clearRefreshError: true));
        final viewer = _viewerId;
        if (viewer != null) unawaited(_repository.cacheCovers(viewer));
      case Error<void>(:final error):
        emit(state.copyWith(refreshError: error.cleanError));
      case CastError<void>(:final error):
        emit(state.copyWith(refreshError: error.cleanError));
    }
    if (!state.detail.isSuccessful) {
      emit(
        state.copyWith(
          detail: DelayedResult.fromError(
            state.refreshError ?? RecipeMessages.missing,
          ),
        ),
      );
    }
  }

  void changeServings(int delta) {
    final next = (state.currentServings + delta).clamp(
      RecipeDetailState.minServings,
      RecipeDetailState.maxServings,
    );
    if (next == state.currentServings) return;
    emit(state.copyWith(servings: next, changeTick: state.changeTick + 1));
  }

  void setUnits(UnitSystem units) {
    if (units == state.units) return;
    emit(state.copyWith(units: units, changeTick: state.changeTick + 1));
  }

  Future<void> toggleTick(String ingredientId) async {
    final ticked = !state.ticks.contains(ingredientId);
    final viewer = _viewerId;
    if (viewer == null) {
      final next = {...state.localTicks};
      if (ticked) {
        next.add(ingredientId);
      } else {
        next.remove(ingredientId);
      }
      emit(state.copyWith(localTicks: next));
      return;
    }
    await _repository.setTick(
      uid: viewer,
      recipeId: _recipeId,
      ingredientId: ingredientId,
      ticked: ticked,
    );
  }

  Future<String?> saveMyVersion() async {
    if (state.fork.isInProgress) return null;
    emit(state.copyWith(fork: const DelayedResult.inProgress()));
    final result = await _repository.fork(_recipeId);
    if (isClosed) return null;
    switch (result) {
      case Ok<String>(:final value):
        emit(state.copyWith(fork: DelayedResult.fromValue(value)));
        return value;
      case Error<String>(:final error):
        emit(state.copyWith(fork: DelayedResult.fromError(error.cleanError)));
        return null;
      case CastError<String>(:final error):
        emit(state.copyWith(fork: DelayedResult.fromError(error.cleanError)));
        return null;
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await super.close();
  }
}
