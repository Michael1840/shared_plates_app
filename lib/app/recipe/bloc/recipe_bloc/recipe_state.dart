// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'recipe_bloc.dart';

final class RecipeState extends Equatable {
  final DelayedResult<List<RecipeModel>> userRecipesResult;
  final DelayedResult<List<RecipeModel>> trendingRecipesResult;
  final DelayedResult<List<RecipeModel>> friendsRecipesResult;

  bool get isUserLoading => userRecipesResult.isInProgress;
  bool get isTrendingLoading => trendingRecipesResult.isInProgress;
  bool get isFriendsLoading => friendsRecipesResult.isInProgress;

  final String? searchFilter;

  const RecipeState({
    required this.userRecipesResult,
    required this.trendingRecipesResult,
    required this.friendsRecipesResult,
    this.searchFilter,
  });

  factory RecipeState.initial() => RecipeState(
    userRecipesResult: DelayedResult.fromValue(kRecipes),
    trendingRecipesResult: DelayedResult.fromValue(kRecipes),
    friendsRecipesResult: DelayedResult.fromValue(kRecipes),
  );

  @override
  List<Object?> get props => [
    userRecipesResult,
    trendingRecipesResult,
    friendsRecipesResult,
    searchFilter,
  ];

  RecipeState copyWith({
    DelayedResult<List<RecipeModel>>? userRecipesResult,
    DelayedResult<List<RecipeModel>>? trendingRecipesResult,
    DelayedResult<List<RecipeModel>>? friendsRecipesResult,
    String? searchFilter,
  }) {
    return RecipeState(
      userRecipesResult: userRecipesResult ?? this.userRecipesResult,
      trendingRecipesResult:
          trendingRecipesResult ?? this.trendingRecipesResult,
      friendsRecipesResult: friendsRecipesResult ?? this.friendsRecipesResult,
      searchFilter: searchFilter ?? this.searchFilter,
    );
  }
}
