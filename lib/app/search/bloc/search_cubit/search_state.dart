// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String? searchFilter;

  final List<String> tags;

  final DelayedResult<List<RecipeModel>> loadingResult;

  final bool friendsOnly;

  bool get isLoading => loadingResult.isInProgress;

  List<RecipeModel> get recipes => loadingResult.value ?? [];

  const SearchState({
    this.searchFilter,
    this.friendsOnly = false,
    required this.loadingResult,
    required this.tags,
  });

  factory SearchState.initial() =>
      const SearchState(loadingResult: DelayedResult.idle(), tags: []);

  @override
  List<Object?> get props => [loadingResult, tags, searchFilter];

  SearchState copyWith({
    String? searchFilter,
    List<String>? tags,
    DelayedResult<List<RecipeModel>>? loadingResult,
    bool? friendsOnly,
  }) {
    return SearchState(
      searchFilter: searchFilter ?? this.searchFilter,
      tags: tags ?? this.tags,
      loadingResult: loadingResult ?? this.loadingResult,
      friendsOnly: friendsOnly ?? this.friendsOnly,
    );
  }
}
