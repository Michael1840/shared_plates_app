import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../recipe/data/models/recipe_model.dart';
import '../api_helper.dart';
import '../models/api_response_model.dart';
import '../models/result_model.dart';

class RecipeApiService {
  Future<Result<List<RecipeModel>>> getUserRecipes() async {
    try {
      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.userRecipes,
        DioMethod.get,
        hasAuth: true,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to get your recipes.'));
      }

      if (response.data['data'] is! Iterable) {
        return const Result.castError();
      }

      List<RecipeModel> recipes = (response.data['data'] as Iterable)
          .map((e) => RecipeModel.fromJson(e))
          .toList();

      return Result.ok(recipes);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<List<RecipeModel>>> getTrendingRecipes() async {
    try {
      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.trendingRecipes,
        DioMethod.get,
        hasAuth: true,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to get trending recipes.'));
      }

      if (response.data['data'] is! Iterable) {
        return const Result.castError();
      }

      List<RecipeModel> recipes = (response.data['data'] as Iterable)
          .map((e) => RecipeModel.fromJson(e))
          .toList();

      return Result.ok(recipes);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<List<RecipeModel>>> getFriendsRecipes() async {
    try {
      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.friendsRecipes,
        DioMethod.get,
        hasAuth: true,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to get your friends recipes.'));
      }

      if (response.data['data'] is! Iterable) {
        return const Result.castError();
      }

      List<RecipeModel> recipes = (response.data['data'] as Iterable)
          .map((e) => RecipeModel.fromJson(e))
          .toList();

      return Result.ok(recipes);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<RecipeDetailModel>> getRecipeById(int id) async {
    try {
      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.recipeWithId(id),
        DioMethod.get,
        hasAuth: true,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to get recipe.'));
      }

      if (response.data['data'] == null) {
        return const Result.castError();
      }

      final RecipeDetailModel recipe = RecipeDetailModel.fromJson(
        response.data['data'],
      );

      return Result.ok(recipe);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<RecipeModel>> createRecipe(Map<String, dynamic> req) async {
    try {
      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.recipe,
        DioMethod.post,
        hasAuth: true,
        data: req,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to create recipe.'));
      }

      if (response.data['data'] == null) {
        return const Result.castError();
      }

      final RecipeModel recipe = RecipeModel.fromJson(response.data['data']);

      return Result.ok(recipe);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<RecipeModel>> uploadMealImage(FormData data, int id) async {
    try {
      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.uploadMealImage(id),
        DioMethod.post,
        hasAuth: true,
        formData: data,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to upload meal image.'));
      }

      if (response.data['data'] == null) {
        return const Result.castError();
      }

      final RecipeModel recipe = RecipeModel.fromJson(response.data['data']);

      return Result.ok(recipe);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<RecipeModel>> updateRecipe(
    Map<String, dynamic> req,
    int id,
  ) async {
    try {
      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.recipeWithId(id),
        DioMethod.put,
        hasAuth: true,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to update recipe.'));
      }

      if (response.data['data'] == null) {
        return const Result.castError();
      }

      final RecipeModel recipe = RecipeModel.fromJson(response.data['data']);

      return Result.ok(recipe);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }
}
