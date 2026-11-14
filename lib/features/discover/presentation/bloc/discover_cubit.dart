import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/collection.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';

class DiscoverState extends Equatable {
  const new({
    this.collections = const DelayedResult.idle(),
    this.quick = const DelayedResult.idle(),
    this.mostSaved = const DelayedResult.idle(),
    this.newest = const DelayedResult.idle(),
  });

  static const quickSlug = 'ready-in-20';

  final FeedSlice<List<RecipeCollection>> collections;
  final FeedSlice<List<RecipeCard>> quick;
  final FeedSlice<List<RecipeCard>> mostSaved;
  final FeedSlice<List<RecipeCard>> newest;

  RecipeCollection? featuredOn(DateTime day) {
    final all = collections.value?.value ?? const <RecipeCollection>[];
    for (final c in all) {
      if (c.kind == CollectionKind.weekly && c.isLiveOn(day)) return c;
    }
    return all.isEmpty ? null : all.first;
  }

  RecipeCollection? collectionBySlug(String slug) {
    for (final c in collections.value?.value ?? const <RecipeCollection>[]) {
      if (c.slug == slug) return c;
    }
    return null;
  }

  bool get isLoading =>
      (collections.isInProgress || collections.isIdle) &&
      (mostSaved.isInProgress || mostSaved.isIdle);

  bool get isStale =>
      collections.isStale ||
      quick.isStale ||
      mostSaved.isStale ||
      newest.isStale;

  bool get failedEverything =>
      collections.isError && mostSaved.isError && quick.isError;

  String? get error => mostSaved.error ?? collections.error;

  DiscoverState copyWith({
    FeedSlice<List<RecipeCollection>>? collections,
    FeedSlice<List<RecipeCard>>? quick,
    FeedSlice<List<RecipeCard>>? mostSaved,
    FeedSlice<List<RecipeCard>>? newest,
  }) => DiscoverState(
    collections: collections ?? this.collections,
    quick: quick ?? this.quick,
    mostSaved: mostSaved ?? this.mostSaved,
    newest: newest ?? this.newest,
  );

  @override
  List<Object?> get props => [collections, quick, mostSaved, newest];
}

class DiscoverCubit extends Cubit<DiscoverState> {
  new(this._browse) : super(const DiscoverState());

  final BrowseRepository _browse;

  Future<void> load() async {
    emit(
      state.copyWith(
        collections: state.collections.loadingFrom(),
        quick: state.quick.loadingFrom(),
        mostSaved: state.mostSaved.loadingFrom(),
        newest: state.newest.loadingFrom(),
      ),
    );
    final (collections, quick, mostSaved, newest) = await (
      _browse.collections(),
      _browse.collectionRecipes(DiscoverState.quickSlug),
      _browse.search(const SearchFilters(), limit: 10),
      _browse.search(const SearchFilters(sort: SearchSort.newest), limit: 10),
    ).wait;
    if (isClosed) return;
    emit(
      DiscoverState(
        collections: sliceFrom(collections, state.collections),
        quick: sliceFrom(quick, state.quick),
        mostSaved: sliceFrom(mostSaved, state.mostSaved),
        newest: sliceFrom(newest, state.newest),
      ),
    );
  }
}
