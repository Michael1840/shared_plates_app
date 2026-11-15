import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';

class FilterState extends Equatable {
  const FilterState({
    required this.filters,
    this.preview = const DelayedResult.idle(),
  });

  static const previewLimit = 50;

  final SearchFilters filters;
  final DelayedResult<int> preview;

  String get applyLabel {
    final count = preview.value;
    if (count == null) return 'Show recipes';
    if (count == 0) return 'No matches yet';
    if (count >= previewLimit) return 'Show $previewLimit+ recipes';
    return count == 1 ? 'Show 1 recipe' : 'Show $count recipes';
  }

  @override
  List<Object?> get props => [filters, preview];
}

class FilterCubit extends Cubit<FilterState> {
  FilterCubit(
    this._browse, {
    required SearchFilters initial,
    this.debounce = const Duration(milliseconds: 300),
  }) : super(FilterState(filters: initial));

  final BrowseRepository _browse;
  final Duration debounce;
  Timer? _timer;
  int _generation = 0;

  void start() => _schedule(Duration.zero);

  void setCost(CostLimit cost) =>
      _update(state.filters.copyWith(cost: cost, clearTitle: true));

  void setTime(TimeLimit time) =>
      _update(state.filters.copyWith(time: time, clearTitle: true));

  void setScope(SearchScope scope) =>
      _update(state.filters.copyWith(scope: scope, clearTitle: true));

  void setSort(SearchSort sort) => _update(state.filters.copyWith(sort: sort));

  void toggleDiet(String slug) {
    final next = {...state.filters.tagSlugs};
    if (!next.remove(slug)) next.add(slug);
    _update(state.filters.copyWith(tagSlugs: next, clearTitle: true));
  }

  void clear() => _update(state.filters.cleared());

  void _update(SearchFilters filters) {
    emit(FilterState(filters: filters, preview: state.preview));
    _schedule(debounce);
  }

  void _schedule(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, () => unawaited(_preview()));
  }

  Future<void> _preview() async {
    final generation = ++_generation;
    final filters = state.filters;
    emit(
      FilterState(filters: filters, preview: const DelayedResult.inProgress()),
    );
    final result = await _browse.search(
      filters,
      limit: FilterState.previewLimit,
    );
    if (isClosed || generation != _generation) return;
    emit(
      FilterState(
        filters: filters,
        preview: switch (result) {
          Ok(:final value) when !value.isStale => DelayedResult.fromValue(
            value.value.length,
          ),
          _ => const DelayedResult.idle(),
        },
      ),
    );
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await super.close();
  }
}
