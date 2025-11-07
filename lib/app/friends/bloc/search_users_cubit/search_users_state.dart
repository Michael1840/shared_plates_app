// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_users_cubit.dart';

final class SearchUsersState extends Equatable {
  final DelayedResult<List<SearchUserModel>> loadingResult;

  List<SearchUserModel> get results => loadingResult.value ?? [];
  bool get isLoading => loadingResult.isInProgress;

  const SearchUsersState({required this.loadingResult});

  factory SearchUsersState.initial() =>
      const SearchUsersState(loadingResult: DelayedResult.idle());

  @override
  List<Object> get props => [loadingResult];

  SearchUsersState copyWith({
    DelayedResult<List<SearchUserModel>>? loadingResult,
  }) {
    return SearchUsersState(loadingResult: loadingResult ?? this.loadingResult);
  }
}
