import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';
import 'package:shared_plates_app/features/friends/domain/person.dart';
import 'package:shared_plates_app/features/profile/domain/popular_cook.dart';

class FriendsState extends Equatable {
  const new({
    this.overview = const DelayedResult.idle(),
    this.query = '',
    this.results = const DelayedResult.idle(),
    this.busy = const {},
    this.requested = const {},
    this.error,
    this.errorTick = 0,
  });

  final FeedSlice<FriendsOverview> overview;
  final String query;
  final DelayedResult<List<PopularCook>> results;
  final Set<String> busy;
  final Set<String> requested;
  final String? error;
  final int errorTick;

  FriendsOverview? get data => overview.value?.value;

  bool get searching => query.trim().length >= 2;

  FriendLink linkTo(String id) {
    final o = data;
    if (requested.contains(id)) return FriendLink.outgoing;
    if (o == null) return FriendLink.none;
    if (o.friends.any((f) => f.person.id == id)) return FriendLink.friends;
    if (o.incoming.any((f) => f.person.id == id)) return FriendLink.incoming;
    if (o.outgoing.any((f) => f.person.id == id)) return FriendLink.outgoing;
    return FriendLink.none;
  }

  FriendsState copyWith({
    FeedSlice<FriendsOverview>? overview,
    String? query,
    DelayedResult<List<PopularCook>>? results,
    Set<String>? busy,
    Set<String>? requested,
    String? error,
    int? errorTick,
  }) => FriendsState(
    overview: overview ?? this.overview,
    query: query ?? this.query,
    results: results ?? this.results,
    busy: busy ?? this.busy,
    requested: requested ?? this.requested,
    error: error ?? this.error,
    errorTick: errorTick ?? this.errorTick,
  );

  @override
  List<Object?> get props => [
    overview,
    query,
    results,
    busy,
    requested,
    error,
    errorTick,
  ];
}

class FriendsCubit extends Cubit<FriendsState> {
  new({
    required this._friends,
    required this._browse,
    required this._userId,
    this._debounce = const Duration(milliseconds: 350),
  }) : super(const FriendsState());

  final FriendsRepository _friends;
  final BrowseRepository _browse;
  final String _userId;
  final Duration _debounce;
  Timer? _searchTimer;
  int _searchToken = 0;

  Future<void> load() async {
    emit(state.copyWith(overview: state.overview.loadingFrom()));
    final result = await _friends.overview(_userId);
    if (isClosed) return;
    emit(state.copyWith(overview: sliceFrom(result, state.overview)));
  }

  void search(String query) {
    emit(state.copyWith(query: query));
    _searchTimer?.cancel();
    if (query.trim().length < 2) {
      emit(state.copyWith(results: const DelayedResult.idle()));
      return;
    }
    _searchTimer = Timer(_debounce, () => unawaited(_runSearch(query)));
  }

  Future<void> _runSearch(String query) async {
    final token = ++_searchToken;
    emit(state.copyWith(results: const DelayedResult.inProgress()));
    final result = await _browse.people(query);
    if (isClosed || token != _searchToken) return;
    emit(
      state.copyWith(
        results: switch (result) {
          Ok(:final value) => DelayedResult.fromValue(value),
          Error(:final error) => DelayedResult.fromError(error.cleanError),
          CastError() => const DelayedResult.fromError(BrowseMessages.generic),
        },
      ),
    );
  }

  Future<void> request(String personId) => _act(
    personId,
    () => _friends.request(personId),
    onDone: () =>
        emit(state.copyWith(requested: {...state.requested, personId})),
  );

  Future<void> accept(String personId) =>
      _act(personId, () => _friends.accept(_userId, personId), reload: true);

  Future<void> decline(String personId) =>
      _act(personId, () => _friends.remove(_userId, personId), reload: true);

  Future<void> _act(
    String personId,
    Future<Result<void>> Function() call, {
    void Function()? onDone,
    bool reload = false,
  }) async {
    if (state.busy.contains(personId)) return;
    emit(state.copyWith(busy: {...state.busy, personId}));
    final result = await call();
    if (isClosed) return;
    final busy = {...state.busy}..remove(personId);
    switch (result) {
      case Ok<void>():
        emit(state.copyWith(busy: busy));
        onDone?.call();
        if (reload) await load();
      case Error<void>(:final error):
        emit(
          state.copyWith(
            busy: busy,
            error: error.cleanError,
            errorTick: state.errorTick + 1,
          ),
        );
      case CastError<void>():
        emit(
          state.copyWith(
            busy: busy,
            error: FriendsMessages.actionFailed,
            errorTick: state.errorTick + 1,
          ),
        );
    }
  }

  @override
  Future<void> close() async {
    _searchTimer?.cancel();
    await super.close();
  }
}
