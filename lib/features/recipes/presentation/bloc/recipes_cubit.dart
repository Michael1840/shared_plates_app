import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/recipes/data/library_repository.dart';

enum LibraryTab { all, saved, created }

enum LibrarySort { recent, title }

enum QuickFilter {
  underR100('Under R100'),
  quick('Quick'),
  veggie('Veggie'),
  dessert('Dessert');

  const QuickFilter(this.label);

  final String label;
}

class RecipesState extends Equatable {
  const RecipesState({
    this.entries = const DelayedResult.idle(),
    this.tags = const [],
    this.tab = LibraryTab.all,
    this.query = '',
    this.filters = const {},
    this.sort = LibrarySort.recent,
  });

  static const budgetPerPlateCents = 10000;
  static const quickMinutes = 30;

  final DelayedResult<List<LibraryEntry>> entries;
  final List<Tag> tags;
  final LibraryTab tab;
  final String query;
  final Set<QuickFilter> filters;
  final LibrarySort sort;

  List<LibraryEntry> get _all => entries.value ?? const [];

  int countFor(LibraryTab tab) => _all.where((e) => _inTab(e, tab)).length;

  int get createdCount => countFor(LibraryTab.created);

  static bool _inTab(LibraryEntry e, LibraryTab tab) => switch (tab) {
    LibraryTab.all => true,
    LibraryTab.saved => e.isSaved && !e.isMine,
    LibraryTab.created => e.isMine,
  };

  int? _tagId(String slug) {
    for (final t in tags) {
      if (t.slug == slug) return t.id;
    }
    return null;
  }

  bool _passes(LibraryEntry e, QuickFilter f) => switch (f) {
    QuickFilter.underR100 =>
      (e.card.costPerPlate ?? budgetPerPlateCents) < budgetPerPlateCents,
    QuickFilter.quick =>
      e.card.totalMinutes != null && e.card.totalMinutes! <= quickMinutes,
    QuickFilter.veggie =>
      e.tagIds.contains(_tagId('veggie')) || e.tagIds.contains(_tagId('vegan')),
    QuickFilter.dessert =>
      e.tagIds.contains(_tagId('dessert')) ||
          e.tagIds.contains(_tagId('baking')),
  };

  List<LibraryEntry> get visible {
    final q = query.trim().toLowerCase();
    return [
      for (final e in _all)
        if (_inTab(e, tab) &&
            (q.isEmpty || e.card.title.toLowerCase().contains(q)) &&
            filters.every((f) => _passes(e, f)))
          e,
    ]..sort((a, b) {
      if (a.isDraft != b.isDraft) return a.isDraft ? -1 : 1;
      return sort == LibrarySort.title
          ? a.card.title.toLowerCase().compareTo(b.card.title.toLowerCase())
          : b.addedAt.compareTo(a.addedAt);
    });
  }

  bool get isEmptyLibrary => entries.isSuccessful && _all.isEmpty;

  RecipesState copyWith({
    DelayedResult<List<LibraryEntry>>? entries,
    List<Tag>? tags,
    LibraryTab? tab,
    String? query,
    Set<QuickFilter>? filters,
    LibrarySort? sort,
  }) => RecipesState(
    entries: entries ?? this.entries,
    tags: tags ?? this.tags,
    tab: tab ?? this.tab,
    query: query ?? this.query,
    filters: filters ?? this.filters,
    sort: sort ?? this.sort,
  );

  @override
  List<Object?> get props => [entries, tags, tab, query, filters, sort];
}

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit({
    required this._library,
    required this._profiles,
    required this._userId,
  }) : super(const RecipesState());

  final LibraryRepository _library;
  final ProfileRepository _profiles;
  final String _userId;
  StreamSubscription<List<LibraryEntry>>? _entriesSub;
  StreamSubscription<List<Tag>>? _tagsSub;

  void start() {
    emit(state.copyWith(entries: const DelayedResult.inProgress()));
    _entriesSub = _library.watch(_userId).listen((entries) {
      if (!isClosed) {
        emit(state.copyWith(entries: DelayedResult.fromValue(entries)));
      }
    });
    _tagsSub = _profiles.watchTags().listen((tags) {
      if (!isClosed) emit(state.copyWith(tags: tags));
    });
  }

  void setTab(LibraryTab tab) => emit(state.copyWith(tab: tab));

  void setQuery(String query) => emit(state.copyWith(query: query));

  void toggleFilter(QuickFilter filter) {
    final next = {...state.filters};
    if (!next.remove(filter)) next.add(filter);
    emit(state.copyWith(filters: next));
  }

  void clearFilters() => emit(state.copyWith(filters: const {}, query: ''));

  void toggleSort() => emit(
    state.copyWith(
      sort: state.sort == LibrarySort.recent
          ? LibrarySort.title
          : LibrarySort.recent,
    ),
  );

  @override
  Future<void> close() async {
    await _entriesSub?.cancel();
    await _tagsSub?.cancel();
    await super.close();
  }
}
