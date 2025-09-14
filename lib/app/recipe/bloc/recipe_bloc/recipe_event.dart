part of 'recipe_bloc.dart';

sealed class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class RecipesSearchRecipes extends RecipeEvent {}

class RecipeFetchUserRecipes extends RecipeEvent {}

class RecipeFetchFriendRecipes extends RecipeEvent {}

class RecipeFetchTrendingRecipes extends RecipeEvent {}
