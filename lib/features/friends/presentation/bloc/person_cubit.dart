import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';
import 'package:shared_plates_app/features/friends/domain/person.dart';

enum PersonAction { added, accepted, removed, blocked, reported }

class PersonState extends Equatable {
  const new({
    this.profile = const DelayedResult.idle(),
    this.tagId,
    this.busy = false,
    this.done,
    this.doneTick = 0,
    this.error,
    this.errorTick = 0,
  });

  final DelayedResult<PersonProfile> profile;
  final int? tagId;
  final bool busy;
  final PersonAction? done;
  final int doneTick;
  final String? error;
  final int errorTick;

  List<RecipeCard> get recipes {
    final p = profile.value;
    if (p == null) return const [];
    final tag = tagId;
    if (tag == null) return p.recipes;
    return [
      for (final r in p.recipes)
        if (p.recipeTags[r.id]?.contains(tag) ?? false) r,
    ];
  }

  PersonState copyWith({
    DelayedResult<PersonProfile>? profile,
    int? tagId,
    bool clearTag = false,
    bool? busy,
    PersonAction? done,
    int? doneTick,
    String? error,
    int? errorTick,
  }) => PersonState(
    profile: profile ?? this.profile,
    tagId: clearTag ? null : tagId ?? this.tagId,
    busy: busy ?? this.busy,
    done: done ?? this.done,
    doneTick: doneTick ?? this.doneTick,
    error: error ?? this.error,
    errorTick: errorTick ?? this.errorTick,
  );

  @override
  List<Object?> get props => [
    profile,
    tagId,
    busy,
    done,
    doneTick,
    error,
    errorTick,
  ];
}

class PersonCubit extends Cubit<PersonState> {
  new({required this._friends, required this._userId, required this._personId})
    : super(const PersonState());

  final FriendsRepository _friends;
  final String _userId;
  final String _personId;

  Future<void> load() async {
    if (!state.profile.isSuccessful) {
      emit(state.copyWith(profile: const DelayedResult.inProgress()));
    }
    final result = await _friends.person(_userId, _personId);
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(profile: DelayedResult.fromValue(value)));
      case Error(:final error):
        if (!state.profile.isSuccessful) {
          emit(
            state.copyWith(profile: DelayedResult.fromError(error.cleanError)),
          );
        }
      case CastError():
        if (!state.profile.isSuccessful) {
          emit(
            state.copyWith(
              profile: const DelayedResult.fromError(BrowseMessages.generic),
            ),
          );
        }
    }
  }

  void filterTag(int? tagId) => emit(
    tagId == null || tagId == state.tagId
        ? state.copyWith(clearTag: true)
        : state.copyWith(tagId: tagId),
  );

  Future<void> addFriend() => _act(
    () => _friends.request(_personId),
    PersonAction.added,
    FriendLink.outgoing,
  );

  Future<void> accept() => _act(
    () => _friends.accept(_userId, _personId),
    PersonAction.accepted,
    FriendLink.friends,
  );

  Future<void> remove() => _act(
    () => _friends.remove(_userId, _personId),
    PersonAction.removed,
    FriendLink.none,
  );

  Future<void> block() => _act(
    () => _friends.block(_personId),
    PersonAction.blocked,
    FriendLink.none,
  );

  Future<void> report(String reason) =>
      _act(() => _friends.report(_personId, reason), PersonAction.reported);

  Future<void> _act(
    Future<Result<void>> Function() call,
    PersonAction action, [
    FriendLink? link,
  ]) async {
    if (state.busy) return;
    emit(state.copyWith(busy: true));
    final result = await call();
    if (isClosed) return;
    switch (result) {
      case Ok<void>():
        final p = state.profile.value;
        final next = link;
        emit(
          state.copyWith(
            busy: false,
            done: action,
            doneTick: state.doneTick + 1,
            profile: p == null || next == null
                ? null
                : DelayedResult.fromValue(p.withLink(next)),
          ),
        );
      case Error<void>(:final error):
        emit(
          state.copyWith(
            busy: false,
            error: error.cleanError,
            errorTick: state.errorTick + 1,
          ),
        );
      case CastError<void>():
        emit(
          state.copyWith(
            busy: false,
            error: FriendsMessages.actionFailed,
            errorTick: state.errorTick + 1,
          ),
        );
    }
  }
}
