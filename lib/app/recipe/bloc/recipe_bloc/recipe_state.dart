// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'recipe_bloc.dart';

final class RecipeState extends Equatable {
  final DelayedResult<void> loadingResult;
  final DelayedResult<void> moreLoadingResult;

  final DelayedResult<List<RecipeModel>> userRecipesResult;
  final DelayedResult<PaginationModel<RecipeModel>> trendingRecipesResult;
  final DelayedResult<List<RecipeModel>> friendsRecipesResult;

  List<RecipeModel> get userRecipes => userRecipesResult.value ?? [];
  List<RecipeModel> get friendsRecipes => friendsRecipesResult.value ?? [];
  List<RecipeModel> get trendingRecipes =>
      trendingRecipesResult.value?.items ?? [];

  bool get isLoading => loadingResult.isInProgress;
  bool get isMoreLoading => moreLoadingResult.isInProgress;

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
    required this.moreLoadingResult,
    required this.userRecipesResult,
    required this.trendingRecipesResult,
    required this.friendsRecipesResult,
    this.searchFilter,
    this.recipeCreated = false,
  });

  factory RecipeState.initial() => const RecipeState(
    loadingResult: DelayedResult.idle(),
    moreLoadingResult: DelayedResult.idle(),
    userRecipesResult: DelayedResult.inProgress(),
    trendingRecipesResult: DelayedResult.inProgress(),
    friendsRecipesResult: DelayedResult.inProgress(),
  );

  @override
  List<Object?> get props => [
    loadingResult,
    moreLoadingResult,
    userRecipesResult,
    trendingRecipesResult,
    friendsRecipesResult,
    searchFilter,
    recipeCreated,
  ];

  RecipeState copyWith({
    DelayedResult<void>? loadingResult,
    DelayedResult<void>? moreLoadingResult,
    DelayedResult<List<RecipeModel>>? userRecipesResult,
    DelayedResult<PaginationModel<RecipeModel>>? trendingRecipesResult,
    DelayedResult<List<RecipeModel>>? friendsRecipesResult,
    bool? recipeCreated,
    String? searchFilter,
  }) {
    return RecipeState(
      loadingResult: loadingResult ?? this.loadingResult,
      moreLoadingResult: moreLoadingResult ?? this.moreLoadingResult,
      userRecipesResult: userRecipesResult ?? this.userRecipesResult,
      trendingRecipesResult:
          trendingRecipesResult ?? this.trendingRecipesResult,
      friendsRecipesResult: friendsRecipesResult ?? this.friendsRecipesResult,
      recipeCreated: recipeCreated ?? this.recipeCreated,
      searchFilter: searchFilter ?? this.searchFilter,
    );
  }

  List<RecipeModel> sortRecipes(SortingFilter filter) {
    if (userRecipes.isEmpty) return [];

    final List<RecipeModel> sortedList = List.from(userRecipes);

    switch (filter) {
      case SortingFilter.priceHighToLow:
        // Sorts from highest cost to lowest
        sortedList.sort((a, b) => b.cost.compareTo(a.cost));
        break;

      case SortingFilter.priceLowToHigh:
        // Sorts from lowest cost to highest
        sortedList.sort((a, b) => a.cost.compareTo(b.cost));
        break;

      case SortingFilter.mostServings:
        // Sort by most servings first
        sortedList.sort((a, b) => b.serves.compareTo(a.serves));
        break;

      case SortingFilter.leastServings:
        // Sort by least servings first
        sortedList.sort((a, b) => a.serves.compareTo(b.serves));
        break;

      case SortingFilter.def:
        break;
    }

    return sortedList;
  }
}
