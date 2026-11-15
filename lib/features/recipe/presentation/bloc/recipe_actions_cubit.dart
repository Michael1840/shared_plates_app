import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_actions_repository.dart';

class RecipeActionsState extends Equatable {
  const RecipeActionsState({
    this.userId,
    this.canAct = false,
    this.saved = const {},
    this.liked = const {},
    this.error,
    this.errorTick = 0,
  });

  final String? userId;
  final bool canAct;
  final Set<String> saved;
  final Set<String> liked;
  final String? error;
  final int errorTick;

  bool isSaved(String id) => saved.contains(id);

  bool isLiked(String id) => liked.contains(id);

  RecipeActionsState copyWith({
    String? userId,
    bool? canAct,
    Set<String>? saved,
    Set<String>? liked,
    String? error,
    int? errorTick,
  }) => RecipeActionsState(
    userId: userId ?? this.userId,
    canAct: canAct ?? this.canAct,
    saved: saved ?? this.saved,
    liked: liked ?? this.liked,
    error: error ?? this.error,
    errorTick: errorTick ?? this.errorTick,
  );

  @override
  List<Object?> get props => [userId, canAct, saved, liked, error, errorTick];
}

enum ActionOutcome { done, needsAccount, failed }

class RecipeActionsCubit extends Cubit<RecipeActionsState> {
  RecipeActionsCubit({required this._actions, required SessionCubit session})
    : super(const RecipeActionsState()) {
    _sessionSub = session.stream.listen(_onSession);
    _onSession(session.state);
  }

  final RecipeActionsRepository _actions;
  late final StreamSubscription<SessionState> _sessionSub;
  StreamSubscription<Set<String>>? _savedSub;
  StreamSubscription<Set<String>>? _likedSub;

  void _onSession(SessionState session) {
    final uid = session.status == SessionStatus.signedIn
        ? session.userId
        : null;
    if (uid == state.userId && state.canAct == (uid != null)) return;
    unawaited(_savedSub?.cancel());
    unawaited(_likedSub?.cancel());
    emit(RecipeActionsState(userId: uid, canAct: uid != null));
    if (uid == null) return;
    _savedSub = _actions.watchSavedIds(uid).listen((ids) {
      if (!isClosed) emit(state.copyWith(saved: ids));
    });
    _likedSub = _actions.watchLikedIds(uid).listen((ids) {
      if (!isClosed) emit(state.copyWith(liked: ids));
    });
  }

  Future<ActionOutcome> toggleSave(RecipeCard card) => _toggle(
    card,
    read: state.isSaved,
    apply: (uid, {required value}) =>
        _actions.setSaved(uid, card, saved: value),
    optimistic: ({required value}) => state.copyWith(
      saved: value
          ? {...state.saved, card.id}
          : ({...state.saved}..remove(card.id)),
    ),
  );

  Future<ActionOutcome> toggleLike(RecipeCard card) => _toggle(
    card,
    read: state.isLiked,
    apply: (uid, {required value}) =>
        _actions.setLiked(uid, card, liked: value),
    optimistic: ({required value}) => state.copyWith(
      liked: value
          ? {...state.liked, card.id}
          : ({...state.liked}..remove(card.id)),
    ),
  );

  Future<ActionOutcome> _toggle(
    RecipeCard card, {
    required bool Function(String id) read,
    required Future<Result<bool>> Function(String uid, {required bool value})
    apply,
    required RecipeActionsState Function({required bool value}) optimistic,
  }) async {
    final uid = state.userId;
    if (uid == null || !state.canAct) return ActionOutcome.needsAccount;
    final before = state;
    final next = !read(card.id);
    emit(optimistic(value: next));
    final result = await apply(uid, value: next);
    if (isClosed) return ActionOutcome.failed;
    switch (result) {
      case Ok<bool>():
        return ActionOutcome.done;
      case Error<bool>(:final error):
        emit(
          before.copyWith(
            error: error.cleanError,
            errorTick: state.errorTick + 1,
          ),
        );
        return ActionOutcome.failed;
      case CastError<bool>(:final error):
        emit(
          before.copyWith(
            error: error.cleanError,
            errorTick: state.errorTick + 1,
          ),
        );
        return ActionOutcome.failed;
    }
  }

  @override
  Future<void> close() async {
    await _sessionSub.cancel();
    await _savedSub?.cancel();
    await _likedSub?.cancel();
    await super.close();
  }
}
