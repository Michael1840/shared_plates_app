import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/domain/popular_cook.dart';

enum SearchTab { recipes, people }

class SearchState extends Equatable {
  const new({
    this.filters = const SearchFilters(),
    this.tab = SearchTab.recipes,
    this.recipes = const DelayedResult.idle(),
    this.people = const DelayedResult.idle(),
    this.loadingMore = false,
    this.hasMore = false,
    this.requested = const {},
    this.suggestions = const [],
  });

  static const pageSize = 20;

  final SearchFilters filters;
  final SearchTab tab;
  final FeedSlice<List<RecipeCard>> recipes;
  final DelayedResult<List<PopularCook>> people;
  final bool loadingMore;
  final bool hasMore;
  final Set<String> requested;
  final List<Tag> suggestions;

  List<RecipeCard> get recipeList => recipes.value?.value ?? const [];

  bool get noResults =>
      recipes.isSuccessful && recipeList.isEmpty && !recipes.isStale;

  SearchState copyWith({
    SearchFilters? filters,
    SearchTab? tab,
    FeedSlice<List<RecipeCard>>? recipes,
    DelayedResult<List<PopularCook>>? people,
    bool? loadingMore,
    bool? hasMore,
    Set<String>? requested,
    List<Tag>? suggestions,
  }) => SearchState(
    filters: filters ?? this.filters,
    tab: tab ?? this.tab,
    recipes: recipes ?? this.recipes,
    people: people ?? this.people,
    loadingMore: loadingMore ?? this.loadingMore,
    hasMore: hasMore ?? this.hasMore,
    requested: requested ?? this.requested,
    suggestions: suggestions ?? this.suggestions,
  );

  @override
  List<Object?> get props => [
    filters,
    tab,
    recipes,
    people,
    loadingMore,
    hasMore,
    requested,
    suggestions,
  ];
}

class SearchCubit extends Cubit<SearchState> {
  new(
    this._browse,
    this._profiles, {
    SearchFilters initial = const SearchFilters(),
    this.debounce = const Duration(milliseconds: 350),
  }) : super(SearchState(filters: initial));

  final BrowseRepository _browse;
  final ProfileRepository _profiles;
  final Duration debounce;
  Timer? _timer;
  int _generation = 0;

  Future<void> start() async {
    final tags = await _profiles.watchTags().first;
    if (!isClosed) emit(state.copyWith(suggestions: tags.take(6).toList()));
    await _run();
  }

  Future<void> requestFriend(String id) async {
    if (state.requested.contains(id)) return;
    emit(state.copyWith(requested: {...state.requested, id}));
    final result = await _profiles.requestFriend(id);
    if (isClosed || result is Ok<void>) return;
    emit(state.copyWith(requested: {...state.requested}..remove(id)));
  }

  void queryChanged(String query) {
    emit(
      state.copyWith(
        filters: state.filters.copyWith(query: query, clearTitle: true),
      ),
    );
    _timer?.cancel();
    _timer = Timer(debounce, () => unawaited(_run()));
  }

  Future<void> submit() {
    _timer?.cancel();
    return _run();
  }

  Future<void> applyFilters(SearchFilters filters) {
    emit(state.copyWith(filters: filters));
    return _run();
  }

  Future<void> retry() => _run();

  void setTab(SearchTab tab) {
    emit(state.copyWith(tab: tab));
    if (tab == SearchTab.people && state.people.isIdle) {
      unawaited(_loadPeople(_generation));
    }
  }

  Future<void> _run() async {
    final generation = ++_generation;
    emit(
      state.copyWith(
        recipes: const DelayedResult.inProgress(),
        people: const DelayedResult.idle(),
        hasMore: false,
      ),
    );
    final peopleLoad = state.tab == SearchTab.people
        ? _loadPeople(generation)
        : Future<void>.value();
    final result = await _browse.search(state.filters);
    if (isClosed || generation != _generation) return;
    final slice = sliceFrom<List<RecipeCard>>(
      result,
      const DelayedResult.idle(),
    );
    emit(
      state.copyWith(
        recipes: slice,
        hasMore:
            !slice.isStale &&
            (slice.value?.value.length ?? 0) >= SearchState.pageSize,
      ),
    );
    await peopleLoad;
  }

  Future<void> _loadPeople(int generation) async {
    final query = state.filters.trimmedQuery;
    if (query.length < 2) {
      emit(state.copyWith(people: const DelayedResult.fromValue([])));
      return;
    }
    emit(state.copyWith(people: const DelayedResult.inProgress()));
    final result = await _browse.people(query);
    if (isClosed || generation != _generation) return;
    emit(
      state.copyWith(
        people: switch (result) {
          Ok(:final value) => DelayedResult.fromValue(value),
          Error(:final error) => DelayedResult.fromError(error.cleanError),
          CastError(:final error) => DelayedResult.fromError(error.cleanError),
        },
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state.recipes.value;
    if (current == null || state.loadingMore || !state.hasMore) return;
    final generation = _generation;
    emit(state.copyWith(loadingMore: true));
    final result = await _browse.search(
      state.filters,
      offset: current.value.length,
    );
    if (isClosed || generation != _generation) return;
    switch (result) {
      case Ok(:final value):
        final merged = [...current.value, ...value.value];
        emit(
          state.copyWith(
            recipes: DelayedResult.fromValue(current.copyWithValue(merged)),
            loadingMore: false,
            hasMore: value.value.length >= SearchState.pageSize,
          ),
        );
      case Error() || CastError():
        emit(state.copyWith(loadingMore: false, hasMore: false));
    }
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await super.close();
  }
}
