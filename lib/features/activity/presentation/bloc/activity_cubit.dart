import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/activity/data/activity_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';

class ActivityState extends Equatable {
  const new({
    this.items = const DelayedResult.idle(),
    this.answered = const {},
    this.busy = const {},
    this.error,
    this.errorTick = 0,
  });

  final FeedSlice<List<ActivityItem>> items;
  final Map<String, bool> answered;
  final Set<String> busy;
  final String? error;
  final int errorTick;

  List<ActivityItem> get all => items.value?.value ?? const [];

  List<ActivityItem> get fresh => [
    for (final i in all)
      if (i.unread) i,
  ];

  List<ActivityItem> get earlier => [
    for (final i in all)
      if (!i.unread) i,
  ];

  ActivityState copyWith({
    FeedSlice<List<ActivityItem>>? items,
    Map<String, bool>? answered,
    Set<String>? busy,
    String? error,
    int? errorTick,
  }) => ActivityState(
    items: items ?? this.items,
    answered: answered ?? this.answered,
    busy: busy ?? this.busy,
    error: error ?? this.error,
    errorTick: errorTick ?? this.errorTick,
  );

  @override
  List<Object?> get props => [items, answered, busy, error, errorTick];
}

class ActivityCubit extends Cubit<ActivityState> {
  new({required this._activity, required this._friends, required this._userId})
    : super(const ActivityState());

  final ActivityRepository _activity;
  final FriendsRepository _friends;
  final String _userId;

  Future<void> load() async {
    emit(state.copyWith(items: state.items.loadingFrom()));
    final result = await _activity.load(_userId);
    if (isClosed) return;
    emit(state.copyWith(items: sliceFrom(result, state.items)));
    if (result case Ok(:final value) when !value.isStale) {
      if (value.value.any((i) => i.unread)) {
        unawaited(_activity.markAllRead());
      }
    }
  }

  Future<void> answer(String personId, {required bool accept}) async {
    if (state.busy.contains(personId)) return;
    emit(state.copyWith(busy: {...state.busy, personId}));
    final result = accept
        ? await _friends.accept(_userId, personId)
        : await _friends.remove(_userId, personId);
    if (isClosed) return;
    final busy = {...state.busy}..remove(personId);
    switch (result) {
      case Ok<void>():
        emit(
          state.copyWith(
            busy: busy,
            answered: {...state.answered, personId: accept},
          ),
        );
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
}

class ActivityBadgeCubit extends Cubit<int> {
  new({required this._activity}) : super(0);

  final ActivityRepository _activity;

  Future<void> refresh(String? uid) async {
    if (uid == null) {
      emit(0);
      return;
    }
    final count = await _activity.unreadCount(uid);
    if (!isClosed) emit(count);
  }

  void clear() => emit(0);
}
