// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String? searchFilter;

  final String popularityFilter;

  final List<String> tags;

  final DelayedResult<List<RecipeModel>> loadingResult;

  final bool friendsOnly;
  final bool? matchAllTags;
  final bool? likedOnly;

  final double maxPrice;
  final int? actualMaxPrice;

  bool get isLoading => loadingResult.isInProgress;

  List<RecipeModel> get recipes => loadingResult.value ?? [];

  bool get isEnabled =>
      matchAllTags == true ||
      likedOnly == true ||
      tags.isNotEmpty ||
      (searchFilter != null && searchFilter!.isNotEmpty) ||
      actualMaxPrice != null;

  const SearchState({
    this.searchFilter,
    this.popularityFilter = 'recent',
    this.friendsOnly = false,
    this.matchAllTags,
    this.likedOnly,
    this.maxPrice = 1,
    this.actualMaxPrice,
    required this.loadingResult,
    required this.tags,
  });

  factory SearchState.initial() =>
      const SearchState(loadingResult: DelayedResult.idle(), tags: []);

  @override
  List<Object?> get props => [
    loadingResult,
    tags,
    searchFilter,
    friendsOnly,
    popularityFilter,
    maxPrice,
    matchAllTags,
    likedOnly,
    actualMaxPrice,
  ];

  SearchState copyWith({
    String? searchFilter,
    String? popularityFilter,
    List<String>? tags,
    DelayedResult<List<RecipeModel>>? loadingResult,
    bool? friendsOnly,
    bool? matchAllTags,
    bool? likedOnly,
    double? maxPrice,
    int? actualMaxPrice,
  }) {
    return SearchState(
      searchFilter: searchFilter ?? this.searchFilter,
      popularityFilter: popularityFilter ?? this.popularityFilter,
      tags: tags ?? this.tags,
      loadingResult: loadingResult ?? this.loadingResult,
      friendsOnly: friendsOnly ?? this.friendsOnly,
      matchAllTags: matchAllTags ?? this.matchAllTags,
      likedOnly: likedOnly ?? this.likedOnly,
      maxPrice: maxPrice ?? this.maxPrice,
      actualMaxPrice: actualMaxPrice ?? this.actualMaxPrice,
    );
  }
}
