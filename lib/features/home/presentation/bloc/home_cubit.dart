import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/collection.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';

class HomeState extends Equatable {
  const HomeState({
    this.moods = const DelayedResult.idle(),
    this.trending = const DelayedResult.idle(),
    this.picks = const DelayedResult.idle(),
    this.recent = const [],
    this.pickLabels = const [],
  });

  final FeedSlice<List<RecipeCollection>> moods;
  final FeedSlice<List<RecipeCard>> trending;
  final FeedSlice<List<RecipeCard>> picks;
  final List<RecentRecipe> recent;
  final List<String> pickLabels;

  bool get isLoading =>
      (moods.isInProgress || moods.isIdle) &&
      (trending.isInProgress || trending.isIdle);

  bool get isStale => moods.isStale || trending.isStale || picks.isStale;

  bool get failedEverything =>
      moods.isError && trending.isError && recent.isEmpty;

  String? get error => trending.error ?? moods.error;

  HomeState copyWith({
    FeedSlice<List<RecipeCollection>>? moods,
    FeedSlice<List<RecipeCard>>? trending,
    FeedSlice<List<RecipeCard>>? picks,
    List<RecentRecipe>? recent,
    List<String>? pickLabels,
  }) => HomeState(
    moods: moods ?? this.moods,
    trending: trending ?? this.trending,
    picks: picks ?? this.picks,
    recent: recent ?? this.recent,
    pickLabels: pickLabels ?? this.pickLabels,
  );

  @override
  List<Object?> get props => [moods, trending, picks, recent, pickLabels];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this._browse,
    required this._profiles,
    required this._userId,
  }) : super(const HomeState());

  final BrowseRepository _browse;
  final ProfileRepository _profiles;
  final String? _userId;
  StreamSubscription<List<RecentRecipe>>? _recentSub;
  bool _picksRequested = false;

  Future<void> load() async {
    final uid = _userId;
    if (uid != null) {
      _recentSub ??= _browse.watchRecentlyViewed(uid).listen((recent) {
        if (!isClosed) emit(state.copyWith(recent: recent));
      });
    }
    emit(
      state.copyWith(
        moods: state.moods.loadingFrom(),
        trending: state.trending.loadingFrom(),
      ),
    );
    final results = await (_browse.collections(), _browse.trending()).wait;
    if (isClosed) return;
    final (moods, trending) = results;
    emit(
      state.copyWith(
        moods: sliceFrom(moods, state.moods),
        trending: sliceFrom(trending, state.trending),
      ),
    );
  }

  Future<void> loadPicks() async {
    if (_picksRequested) return;
    _picksRequested = true;
    final uid = _userId;
    final tags = await _profiles.watchTags().first;
    final tastes = uid == null
        ? <int>{}
        : await _profiles.watchTastes(uid).first;
    final picked = [
      for (final t in tags)
        if (tastes.contains(t.id)) t,
    ];
    if (isClosed) return;
    emit(
      state.copyWith(
        picks: state.picks.loadingFrom(),
        pickLabels: [for (final t in picked.take(3)) t.label.toLowerCase()],
      ),
    );
    final result = await _browse.search(
      SearchFilters(tagSlugs: {for (final t in picked) t.slug}),
      limit: 6,
    );
    if (isClosed) return;
    emit(state.copyWith(picks: sliceFrom(result, state.picks)));
  }

  @override
  Future<void> close() async {
    await _recentSub?.cancel();
    await super.close();
  }
}
