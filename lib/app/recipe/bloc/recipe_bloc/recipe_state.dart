// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'recipe_bloc.dart';

final class RecipeState extends Equatable {
  final DelayedResult<void> loadingResult;

  final DelayedResult<List<RecipeModel>> userRecipesResult;
  final DelayedResult<List<RecipeModel>> trendingRecipesResult;
  final DelayedResult<List<RecipeModel>> friendsRecipesResult;

  List<RecipeModel> get userRecipes => userRecipesResult.value ?? [];
  List<RecipeModel> get friendsRecipes => friendsRecipesResult.value ?? [];
  List<RecipeModel> get trendingRecipes => trendingRecipesResult.value ?? [];

  bool get isLoading => loadingResult.isInProgress;

  bool get isTrendingError => trendingRecipesResult.isError;
  bool get isUserError => userRecipesResult.isError;
  bool get isFriendsError => friendsRecipesResult.isError;

  bool get isDashboardError => isTrendingError || isFriendsError;

  bool get isUserLoading => userRecipesResult.isInProgress;
  bool get isTrendingLoading => trendingRecipesResult.isInProgress;
  bool get isFriendsLoading => friendsRecipesResult.isInProgress;

  final bool recipeCreated;

  final String? searchFilter;

  const RecipeState({
    required this.loadingResult,
    required this.userRecipesResult,
    required this.trendingRecipesResult,
    required this.friendsRecipesResult,
    this.searchFilter,
    this.recipeCreated = false,
  });

  factory RecipeState.initial() => const RecipeState(
    loadingResult: DelayedResult.idle(),
    userRecipesResult: DelayedResult.inProgress(),
    trendingRecipesResult: DelayedResult.inProgress(),
    friendsRecipesResult: DelayedResult.inProgress(),
  );

  @override
  List<Object?> get props => [
    loadingResult,
    userRecipesResult,
    trendingRecipesResult,
    friendsRecipesResult,
    searchFilter,
    recipeCreated,
  ];

  RecipeState copyWith({
    DelayedResult<void>? loadingResult,
    DelayedResult<List<RecipeModel>>? userRecipesResult,
    DelayedResult<List<RecipeModel>>? trendingRecipesResult,
    DelayedResult<List<RecipeModel>>? friendsRecipesResult,
    bool? recipeCreated,
    String? searchFilter,
  }) {
    return RecipeState(
      loadingResult: loadingResult ?? this.loadingResult,
      userRecipesResult: userRecipesResult ?? this.userRecipesResult,
      trendingRecipesResult:
          trendingRecipesResult ?? this.trendingRecipesResult,
      friendsRecipesResult: friendsRecipesResult ?? this.friendsRecipesResult,
      recipeCreated: recipeCreated ?? this.recipeCreated,
      searchFilter: searchFilter ?? this.searchFilter,
    );
  }
}
