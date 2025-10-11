// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'recipe_detail_cubit.dart';

class RecipeDetailState extends Equatable {
  final String? search;

  final DelayedResult<RecipeDetailModel> loadingResult;
  final DelayedResult<void> userLoadingResult;

  final int index;

  bool get isError => loadingResult.isError;
  bool get isLoading => loadingResult.isInProgress;
  bool get isUserLoading => userLoadingResult.isInProgress;
  bool get loaded => loadingResult.isIdle;
  bool get hasData => loadingResult.value != null;

  const RecipeDetailState({
    required this.loadingResult,
    required this.userLoadingResult,
    required this.index,
    this.search,
  });

  factory RecipeDetailState.initial() => const RecipeDetailState(
    loadingResult: DelayedResult.idle(),
    userLoadingResult: DelayedResult.idle(),
    index: 0,
  );

  @override
  List<Object?> get props => [loadingResult, search, userLoadingResult, index];

  RecipeDetailState copyWith({
    String? search,
    DelayedResult<RecipeDetailModel>? loadingResult,
    DelayedResult<void>? userLoadingResult,
    int? index,
  }) {
    return RecipeDetailState(
      search: search ?? this.search,
      loadingResult: loadingResult ?? this.loadingResult,
      userLoadingResult: userLoadingResult ?? this.userLoadingResult,
      index: index ?? this.index,
    );
  }
}
