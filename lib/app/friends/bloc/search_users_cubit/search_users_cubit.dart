import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../api/models/result_model.dart';
import '../../../core/data/models/delayed_result.dart';
import '../../data/models/search_user_model.dart';
import '../../data/repo/friends_repo.dart';

part 'search_users_state.dart';

class SearchUsersCubit extends Cubit<SearchUsersState> {
  final FriendsRepository _friendsRepository;

  SearchUsersCubit(FriendsRepository friendsRepository)
    : _friendsRepository = friendsRepository,
      super(SearchUsersState.initial());

  Future<void> searchUsers(String query) async {
    emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

    try {
      final result = await _friendsRepository.searchUsers(query);

      switch (result) {
        case Error<List<SearchUserModel>>():
          throw result.error;
        case CastError<List<SearchUserModel>>():
          throw result.error;
        case Ok<List<SearchUserModel>>():
      }

      emit(
        state.copyWith(loadingResult: DelayedResult.fromValue(result.value)),
      );
    } catch (e) {
      emit(
        state.copyWith(loadingResult: DelayedResult.fromError(e.toString())),
      );
    }
  }

  Future<Result<void>> addUser(String username) async {
    SearchUsersState originalState = state.copyWith();

    List<SearchUserModel> users = List.from(state.results);

    if (users.isEmpty) return Result.error(Exception('No users found'));

    int index = users.indexWhere((user) => user.username == username);

    if (index < 0) {
      return Result.error(
        Exception('User with username: $username could not be found'),
      );
    } else {
      users[index] = users[index].copyWith(isFriend: true);

      emit(state.copyWith(loadingResult: DelayedResult.fromValue(users)));
    }

    try {
      final result = await _friendsRepository.addUser(username);

      switch (result) {
        case Error<void>():
          emit(originalState);

          return result;
        case CastError<void>():
          emit(originalState);

          return result;
        case Ok<void>():
          return result;
      }
    } on Exception catch (e) {
      emit(originalState);

      return Result.error(e);
    }
  }
}
