import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../api/models/result_model.dart';
import '../../../core/data/models/delayed_result.dart';
import '../../data/models/create_recipe_model.dart';
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
    on<RecipeCreate>(_handleRecipeCreate);
    on<ResetCreateRecipe>(_handleResetCreate);

    add(RecipeFetchUserRecipes());
  }

  Future<void> _handleResetCreate(
    ResetCreateRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(recipeCreated: false));
  }

  Future<void> _handleRecipeCreate(
    RecipeCreate event,
    Emitter<RecipeState> emit,
  ) async {
    List<RecipeModel> recipes = List.from(state.userRecipesResult.value ?? []);

    emit(state.copyWith(userRecipesResult: const DelayedResult.inProgress()));

    try {
      final Result<RecipeModel> result = await _recipeRepo.createRecipe(
        event.req.toJson(),
      );

      switch (result) {
        case Error<RecipeModel>():
          throw result.error;
        case CastError<RecipeModel>():
          throw result.error;
        case Ok<RecipeModel>():
      }

      final FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          event.req.image.path,
          filename: event.req.image.path.split('/').last,
        ),
      });

      final Result<RecipeModel> imageResult = await _recipeRepo.uploadMealImage(
        formData,
        result.value.id,
      );

      switch (imageResult) {
        case Error<RecipeModel>():
          throw imageResult.error;
        case CastError<RecipeModel>():
          throw imageResult.error;
        case Ok<RecipeModel>():
      }

      recipes = [imageResult.value, ...recipes];

      emit(
        state.copyWith(
          userRecipesResult: DelayedResult.fromValue(recipes),
          recipeCreated: true,
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
