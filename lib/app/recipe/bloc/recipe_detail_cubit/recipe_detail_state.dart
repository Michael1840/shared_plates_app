// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'recipe_detail_cubit.dart';

class RecipeDetailState extends Equatable {
  final String? search;

  final DelayedResult<RecipeDetailModel> loadingResult;
  final DelayedResult<void> userLoadingResult;

  bool get isError => loadingResult.isError;
  bool get isLoading => loadingResult.isInProgress;
  bool get isUserLoading => userLoadingResult.isInProgress;
  bool get loaded => loadingResult.isIdle;
  bool get hasData => loadingResult.value != null;

  const RecipeDetailState({
    required this.loadingResult,
    required this.userLoadingResult,
    this.search,
  });

  factory RecipeDetailState.initial() => const RecipeDetailState(
    loadingResult: DelayedResult.idle(),
    userLoadingResult: DelayedResult.idle(),
  );

  @override
  List<Object?> get props => [loadingResult, search, userLoadingResult];

  RecipeDetailState copyWith({
    String? search,
    DelayedResult<RecipeDetailModel>? loadingResult,
    DelayedResult<void>? userLoadingResult,
  }) {
    return RecipeDetailState(
      search: search ?? this.search,
      loadingResult: loadingResult ?? this.loadingResult,
      userLoadingResult: userLoadingResult ?? this.userLoadingResult,
    );
  }
}
