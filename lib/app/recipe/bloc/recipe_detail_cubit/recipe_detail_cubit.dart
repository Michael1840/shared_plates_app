import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../api/models/result_model.dart';
import '../../../core/data/models/delayed_result.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repo/recipe_repo.dart';

part 'recipe_detail_state.dart';

class RecipeDetailCubit extends Cubit<RecipeDetailState> {
  final RecipesRepository _recipeRepo;

  RecipeDetailCubit(RecipesRepository recipeRepo)
    : _recipeRepo = recipeRepo,
      super(RecipeDetailState.initial());

  Future<void> fetchRecipe(int? id) async {
    emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

    if (id == null) {
      print('ID is null');

      emit(
        state.copyWith(
          loadingResult: const DelayedResult.fromError(
            'ID could not be found.',
          ),
        ),
      );
    } else {
      try {
        print('Trying');

        final result = await _recipeRepo.getRecipeById(id);

        switch (result) {
          case Error<RecipeDetailModel>():
            throw result.error;
          case CastError<RecipeDetailModel>():
            throw result.error;
          case Ok<RecipeDetailModel>():
        }

        emit(
          state.copyWith(loadingResult: DelayedResult.fromValue(result.value)),
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(
          state.copyWith(loadingResult: DelayedResult.fromError(e.toString())),
        );
      }
    }
  }
}
