import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api/models/pagination_model.dart';
import '../../../api/models/result_model.dart';
import '../../../api/services/recipe_api_service.dart';
import '../models/recipe_model.dart';

abstract class RecipesRepository {
  final RecipeApiService _api;

  RecipesRepository(this._api);

  Future<Result<List<RecipeModel>>> getUserRecipes();

  Future<Result<PaginationModel<RecipeModel>>> getTrendingRecipes(
    int? length,
    int? page,
  );

  Future<Result<PaginationModel<RecipeModel>>> getMoreRecipes(String url);

  Future<Result<List<RecipeModel>>> getFriendsRecipes(int? length, int? page);

  Future<Result<RecipeDetailModel>> getRecipeById(int id);

  Future<Result<void>> likeRecipe(int id);

  Future<Result<RecipeModel>> createRecipe(Map<String, dynamic> req);

  Future<Result<RecipeModel>> updateRecipe(Map<String, dynamic> req, int id);

  Future<Result<RecipeModel>> uploadMealImage(FormData data, int id);
}

class RecipesDataProvider extends RecipesRepository {
  RecipesDataProvider(super._api);

  @override
  Future<Result<List<RecipeModel>>> getUserRecipes() async {
    try {
      return await _api.getUserRecipes();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    } catch (e) {
      debugPrint(e.toString());
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<PaginationModel<RecipeModel>>> getMoreRecipes(
    String url,
  ) async {
    try {
      return await _api.getMoreRecipes(url);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    } catch (e) {
      debugPrint(e.toString());
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<PaginationModel<RecipeModel>>> getTrendingRecipes(
    int? length,
    int? page,
  ) async {
    try {
      return await _api.getTrendingRecipes(length, page);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    } catch (e) {
      debugPrint(e.toString());
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> likeRecipe(int id) async {
    try {
      return await _api.likeRecipe(id);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    } catch (e) {
      debugPrint(e.toString());
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<List<RecipeModel>>> getFriendsRecipes(
    int? length,
    int? page,
  ) async {
    try {
      return await _api.getFriendsRecipes(length, page);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    } catch (e) {
      debugPrint(e.toString());
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<RecipeDetailModel>> getRecipeById(int id) async {
    try {
      return await _api.getRecipeById(id);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    } catch (e) {
      debugPrint(e.toString());
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<RecipeModel>> createRecipe(Map<String, dynamic> req) async {
    try {
      return await _api.createRecipe(req);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  @override
  Future<Result<RecipeModel>> uploadMealImage(FormData data, int id) async {
    try {
      return await _api.uploadMealImage(data, id);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  @override
  Future<Result<RecipeModel>> updateRecipe(
    Map<String, dynamic> req,
    int id,
  ) async {
    try {
      return await _api.getRecipeById(id);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }
}
