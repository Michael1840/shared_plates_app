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
    on<RecipeFetchUserRecipes>(_handleFetchUserRecipes);
    on<RecipeFetchDashboardRecipes>(_handleFetchDashboardRecipes);
    on<RecipeCreate>(_handleRecipeCreate);
    on<ResetCreateRecipe>(_handleResetCreate);

    add(RecipeFetchUserRecipes());
    add(RecipeFetchDashboardRecipes());
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

  Future<void> _handleFetchUserRecipes(
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

  Future<void> _handleFetchDashboardRecipes(
    RecipeFetchDashboardRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(
      state.copyWith(
        trendingRecipesResult: const DelayedResult.inProgress(),
        friendsRecipesResult: const DelayedResult.inProgress(),
      ),
    );

    try {
      final List<Result<List<RecipeModel>>> results = await Future.wait([
        _recipeRepo.getTrendingRecipes(5, null),
        _recipeRepo.getFriendsRecipes(5, null),
      ]);

      final trendingResult = results[0];
      final friendsResult = results[1];

      List<RecipeModel>? trendingRecipes;
      List<RecipeModel>? friendsRecipes;

      Exception? trendingError;
      Exception? friendsError;

      switch (trendingResult) {
        case Error<List<RecipeModel>>():
          trendingError = trendingResult.error;
        case CastError<List<RecipeModel>>():
          trendingError = trendingResult.error;
        case Ok<List<RecipeModel>>():
          trendingRecipes = trendingResult.value;
      }

      switch (friendsResult) {
        case Error<List<RecipeModel>>():
          friendsError = friendsResult.error;
        case CastError<List<RecipeModel>>():
          friendsError = friendsResult.error;
        case Ok<List<RecipeModel>>():
          friendsRecipes = friendsResult.value;
      }

      DelayedResult<List<RecipeModel>> resolveResult(
        List<RecipeModel>? data,
        Exception? error,
      ) {
        if (data != null) return DelayedResult.fromValue(data);
        if (error != null) return DelayedResult.fromError(error.toString());
        return const DelayedResult.fromError('Unknown error occurred');
      }

      emit(
        state.copyWith(
          trendingRecipesResult: resolveResult(trendingRecipes, trendingError),
          friendsRecipesResult: resolveResult(friendsRecipes, friendsError),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          trendingRecipesResult: DelayedResult.fromError(e.toString()),
          friendsRecipesResult: DelayedResult.fromError(e.toString()),
        ),
      );
    }
  }
}
