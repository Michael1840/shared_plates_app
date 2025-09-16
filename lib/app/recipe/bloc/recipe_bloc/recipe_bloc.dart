import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../api/models/result_model.dart';
import '../../../core/data/models/delayed_result.dart';
import '../../../core/utils/constants.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repo/recipe_repo.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipesRepository _recipeRepo;

  RecipeBloc(RecipesRepository recipeRepo)
    : _recipeRepo = recipeRepo,
      super(RecipeState.initial()) {
    on<RecipeFetchUserRecipes>(_handleFetchUserProjects);
    on<RecipeFetchTrendingRecipes>(_handleFetchTrendingRecipes);
    on<RecipeFetchFriendRecipes>(_handleFetchFriendsRecipes);

    add(RecipeFetchUserRecipes());
  }

  Future<void> _handleFetchUserProjects(
    RecipeFetchUserRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(userRecipesResult: const DelayedResult.inProgress()));

    try {
      final result = await _recipeRepo.getUserRecipes();

      switch (result) {
        case Error<List<RecipeModel>>():
          throw result.error;
        case CastError<List<RecipeModel>>():
          throw result.error;
        case Ok<List<RecipeModel>>():
      }

      emit(
        state.copyWith(
          userRecipesResult: DelayedResult.fromValue(result.value),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          userRecipesResult: DelayedResult.fromError(e.toString()),
        ),
      );
    }
  }

  Future<void> _handleFetchTrendingRecipes(
    RecipeFetchTrendingRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(userRecipesResult: const DelayedResult.inProgress()));

    try {
      final result = await _recipeRepo.getTrendingRecipes();

      switch (result) {
        case Error<List<RecipeModel>>():
          throw result.error;
        case CastError<List<RecipeModel>>():
          throw result.error;
        case Ok<List<RecipeModel>>():
      }

      emit(
        state.copyWith(
          userRecipesResult: DelayedResult.fromValue(result.value),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          userRecipesResult: DelayedResult.fromError(e.toString()),
        ),
      );
    }
  }

  Future<void> _handleFetchFriendsRecipes(
    RecipeFetchFriendRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(userRecipesResult: const DelayedResult.inProgress()));

    try {
      final result = await _recipeRepo.getFriendsRecipes();

      switch (result) {
        case Error<List<RecipeModel>>():
          throw result.error;
        case CastError<List<RecipeModel>>():
          throw result.error;
        case Ok<List<RecipeModel>>():
      }

      emit(
        state.copyWith(
          userRecipesResult: DelayedResult.fromValue(result.value),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          userRecipesResult: DelayedResult.fromError(e.toString()),
        ),
      );
    }
  }
}
