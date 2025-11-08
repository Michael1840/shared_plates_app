import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

import '../../../api/models/result_model.dart';
import '../../../core/data/models/delayed_result.dart';
import '../../data/models/friendship_model.dart';
import '../../data/repo/friends_repo.dart';

part 'friendship_event.dart';
part 'friendship_state.dart';

class FriendshipBloc extends Bloc<FriendshipEvent, FriendshipState> {
  final FriendsRepository _friendsRepository;

  FriendshipBloc(FriendsRepository friendsRepository)
    : _friendsRepository = friendsRepository,
      super(FriendshipState.initial()) {
    on<FriendshipsFetch>(_handleFetchFriendships);

    add(FriendshipsFetch());
  }

  Future<void> _handleFetchFriendships(
    FriendshipsFetch event,
    Emitter<FriendshipState> emit,
  ) async {
    emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

    try {
      final result = await _friendsRepository.fetchFriends();

      switch (result) {
        case Error<List<FriendRequestModel>>():
          throw result.error;
        case CastError<List<FriendRequestModel>>():
          throw result.error;
        case Ok<List<FriendRequestModel>>():
      }

      final List<FriendRequestModel> all = result.value;

      if (all.isEmpty) {
        emit(
          state.copyWith(
            loadingResult: DelayedResult.fromValue(null),
            friends: [],
            requests: [],
          ),
        );
        return;
      }

      final List<FriendRequestModel> friends = all
          .where((f) => f.connectionStatus == FriendshipStatus.accepted)
          .toList();
      final List<FriendRequestModel> requests = all
          .where((f) => f.connectionStatus == FriendshipStatus.pending)
          .toList();

      emit(
        state.copyWith(
          loadingResult: DelayedResult.fromValue(null),
          friends: friends,
          requests: requests,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(loadingResult: DelayedResult.fromError(e.toString())),
      );
    }
  }
}
