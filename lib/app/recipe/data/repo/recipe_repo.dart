import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api/models/result_model.dart';
import '../../../api/services/recipe_api_service.dart';
import '../models/recipe_model.dart';

abstract class RecipesRepository {
  final RecipeApiService _api;

  RecipesRepository(this._api);

  Future<Result<List<RecipeModel>>> getUserRecipes();
  Future<Result<List<RecipeModel>>> getTrendingRecipes();
  Future<Result<List<RecipeModel>>> getFriendsRecipes();
  Future<Result<RecipeDetailModel>> getRecipeById(int id);
  Future<Result<RecipeModel>> createRecipe(FormData form, int id);
  Future<Result<RecipeModel>> updateRecipe(Map<String, dynamic> req, int id);
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
  Future<Result<List<RecipeModel>>> getTrendingRecipes() async {
    try {
      return await _api.getTrendingRecipes();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    } catch (e) {
      debugPrint(e.toString());
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<List<RecipeModel>>> getFriendsRecipes() async {
    try {
      return await _api.getFriendsRecipes();
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
  Future<Result<RecipeModel>> createRecipe(FormData form, int id) async {
    try {
      return await _api.getRecipeById(id);
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
