import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';

class CreateStartState extends Equatable {
  const new({
    this.drafts = const [],
    this.saved = const DelayedResult.idle(),
    this.fork = const DelayedResult.idle(),
  });

  final List<DraftSummary> drafts;
  final DelayedResult<List<RecipeCard>> saved;
  final DelayedResult<String> fork;

  CreateStartState copyWith({
    List<DraftSummary>? drafts,
    DelayedResult<List<RecipeCard>>? saved,
    DelayedResult<String>? fork,
  }) => CreateStartState(
    drafts: drafts ?? this.drafts,
    saved: saved ?? this.saved,
    fork: fork ?? this.fork,
  );

  @override
  List<Object?> get props => [drafts, saved, fork];
}

class CreateStartCubit extends Cubit<CreateStartState> {
  new({
    required this._repository,
    required this._recipes,
    required this._userId,
  }) : super(const CreateStartState());

  final CreateRepository _repository;
  final RecipeDetailRepository _recipes;
  final String _userId;
  StreamSubscription<List<DraftSummary>>? _sub;

  void start() {
    _sub = _repository.watchDrafts(_userId).listen((drafts) {
      if (!isClosed) emit(state.copyWith(drafts: drafts));
    });
  }

  Future<void> loadSaved() async {
    emit(state.copyWith(saved: const DelayedResult.inProgress()));
    final cards = await _repository.savedRecipes(_userId);
    if (!isClosed) {
      emit(state.copyWith(saved: DelayedResult.fromValue(cards)));
    }
  }

  Future<String?> startFrom(String recipeId) async {
    if (state.fork.isInProgress) return null;
    emit(state.copyWith(fork: const DelayedResult.inProgress()));
    final result = await _recipes.fork(recipeId);
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

  Future<void> discard(String id) => _repository.discard(id);

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await super.close();
  }
}
