import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/cook/data/cook_repository.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';

class CookDoneState extends Equatable {
  const new({
    required this.card,
    required this.servings,
    this.monthCount,
    this.toldCreator = true,
    this.logged = false,
    this.fork = const DelayedResult.idle(),
  });

  final RecipeCard card;
  final int servings;
  final int? monthCount;
  final bool toldCreator;
  final bool logged;
  final DelayedResult<String> fork;

  bool get canTellCreator => !card.isMine;

  CookDoneState copyWith({
    int? monthCount,
    bool? toldCreator,
    bool? logged,
    DelayedResult<String>? fork,
  }) => CookDoneState(
    card: card,
    servings: servings,
    monthCount: monthCount ?? this.monthCount,
    toldCreator: toldCreator ?? this.toldCreator,
    logged: logged ?? this.logged,
    fork: fork ?? this.fork,
  );

  @override
  List<Object?> get props => [
    card,
    servings,
    monthCount,
    toldCreator,
    logged,
    fork,
  ];
}

class CookDoneCubit extends Cubit<CookDoneState> {
  new({
    required this._cooks,
    required this._recipes,
    required RecipeCard card,
    required int servings,
    this._userId,
    this._settings,
  }) : super(CookDoneState(card: card, servings: servings));

  final CookRepository _cooks;
  final RecipeDetailRepository _recipes;
  final String? _userId;
  final AppSettingsStore? _settings;

  Future<void> load() async {
    final uid = _userId;
    if (uid == null) return;
    final tell = await _settings?.value(SettingKey.tellCooks);
    if (tell == 'false' && !isClosed && !state.logged) {
      emit(state.copyWith(toldCreator: false));
    }
    final before = await _cooks.cooksThisMonth(uid);
    if (!isClosed) emit(state.copyWith(monthCount: before + 1));
  }

  void setToldCreator({required bool value}) {
    if (state.logged || !state.canTellCreator) return;
    emit(state.copyWith(toldCreator: value));
  }

  Future<void> finish() async {
    final uid = _userId;
    if (uid == null || state.logged) return;
    if (!isClosed) emit(state.copyWith(logged: true));
    await _cooks.logCook(
      uid: uid,
      recipeId: state.card.id,
      servings: state.servings,
      toldCreator: state.canTellCreator && state.toldCreator,
    );
  }

  Future<String?> saveMyVersion() async {
    if (state.fork.isInProgress) return null;
    await finish();
    if (isClosed) return null;
    emit(state.copyWith(fork: const DelayedResult.inProgress()));
    final result = await _recipes.fork(state.card.id);
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
}
