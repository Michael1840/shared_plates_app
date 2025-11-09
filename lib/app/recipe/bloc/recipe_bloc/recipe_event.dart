part of 'recipe_bloc.dart';

enum RecipeType { trending, friends, user }

sealed class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class RecipesSearchRecipes extends RecipeEvent {}

class RecipeFetchUserRecipes extends RecipeEvent {}

class RecipeFetchDashboardRecipes extends RecipeEvent {}

class ResetCreateRecipe extends RecipeEvent {}

class LikeRecipe extends RecipeEvent {
  final RecipeType type;
  final int recipeId;

  const LikeRecipe(this.type, this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class RecipeCreate extends RecipeEvent {
  final CreateRecipeModel req;

  const RecipeCreate({required this.req});

  @override
  List<Object> get props => [req];
}
