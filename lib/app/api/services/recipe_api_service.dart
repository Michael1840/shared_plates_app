import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../recipe/data/models/recipe_model.dart';
import '../api_helper.dart';
import '../models/api_response_model.dart';
import '../models/pagination_model.dart';
import '../models/result_model.dart';

class RecipeApiService {
  final RecipeModelConverter _recipeModelConverter = RecipeModelConverter();

  final RecipeDetailModelConverter _recipeDetailModelConverter =
      RecipeDetailModelConverter();

  Future<Result<List<RecipeModel>>> getUserRecipes() async {
    try {
      return await ApiHelper.requestModelList<RecipeModel>(
        ApiRoutes.userRecipes,
        DioMethod.get,
        hasAuth: true,
        converter: _recipeModelConverter,
      );

      // if (!response.isSuccess) {
      //   return Result.error(Exception('Failed to get your recipes.'));
      // }

      // if (response.data['data'] is! Iterable) {
      //   return const Result.castError();
      // }

      // List<RecipeModel> recipes = (response.data['data'] as Iterable)
      //     .map((e) => RecipeModel.fromJson(e))
      //     .toList();

      // return Result.ok(recipes);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<List<RecipeModel>>> searchResults(
    int? length,
    int? page,
    String? query,
    String? sorting,
    List<String>? tags,
    bool? matchAllTags,
    int? maxPrice,
    bool? isLiked,
    bool? friendsOnly,
  ) async {
    try {
      return await ApiHelper.requestModelList<RecipeModel>(
        ApiRoutes.searchMeals(
          length: length,
          page: page,
          query: query,
          sorting: sorting,
          tags: tags,
          matchAllTags: matchAllTags,
          maxPrice: maxPrice,
          isLiked: isLiked,
          friendsOnly: friendsOnly,
        ),
        DioMethod.get,
        hasAuth: true,
        converter: _recipeModelConverter,
      );

      // if (!response.isSuccess) {
      //   return Result.error(Exception('Failed to get your recipes.'));
      // }

      // if (response.data['data'] is! Iterable) {
      //   return const Result.castError();
      // }

      // List<RecipeModel> recipes = (response.data['data'] as Iterable)
      //     .map((e) => RecipeModel.fromJson(e))
      //     .toList();

      // return Result.ok(recipes);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<PaginationModel<RecipeModel>>> getMoreRecipes(
    String nextUrl,
  ) async {
    try {
      return await ApiHelper.requestPaginatedList<RecipeModel>(
        nextUrl,
        DioMethod.get,
        hasAuth: true,
        converter: _recipeModelConverter,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<PaginationModel<RecipeModel>>> getTrendingRecipes(
    int? length,
    int? page,
  ) async {
    try {
      return ApiHelper.requestPaginatedList<RecipeModel>(
        ApiRoutes.trendingRecipes(length: length, page: page),
        DioMethod.get,
        hasAuth: true,
        converter: _recipeModelConverter,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<List<RecipeModel>>> getFriendsRecipes(
    int? length,
    int? page,
  ) async {
    return ApiHelper.requestModelList<RecipeModel>(
      ApiRoutes.friendsRecipes(length: length, page: page),
      DioMethod.get,
      hasAuth: true,
      converter: _recipeModelConverter,
    );
  }

  Future<Result<RecipeDetailModel>> getRecipeById(int id) async {
    return ApiHelper.requestModel<RecipeDetailModel>(
      ApiRoutes.recipeWithId(id),
      DioMethod.get,
      hasAuth: true,
      converter: _recipeDetailModelConverter,
    );
    // try {
    //   final ApiResponseModel response = await ApiHelper.request(
    //     ApiRoutes.recipeWithId(id),
    //     DioMethod.get,
    //     hasAuth: true,
    //   );

    //   if (!response.isSuccess) {
    //     return Result.error(Exception('Failed to get recipe.'));
    //   }

    //   if (response.data['data'] == null) {
    //     return const Result.castError();
    //   }

    //   final RecipeDetailModel recipe = RecipeDetailModel.fromJson(
    //     response.data['data'],
    //   );

    //   return Result.ok(recipe);
    // } on Exception catch (e) {
    //   debugPrint(e.toString());
    //   return Result.error(e);
    // }
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

  Future<Result<void>> likeRecipe(int id) async {
    try {
      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.likeRecipe(id),
        DioMethod.post,
        hasAuth: true,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to update recipe like status'));
      }

      return const Result.ok(null);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }
}
