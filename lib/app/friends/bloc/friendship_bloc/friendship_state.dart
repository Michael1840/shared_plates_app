// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'friendship_bloc.dart';

final class FriendshipState extends Equatable {
  final DelayedResult<void> loadingResult;

  bool get isLoading => loadingResult.isInProgress;

  final List<FriendRequestModel> friends;
  final List<FriendRequestModel> requests;

  final String? searchFilter;

  const FriendshipState({
    required this.loadingResult,
    required this.friends,
    required this.requests,
    this.searchFilter,
  });

  factory FriendshipState.initial() => const FriendshipState(
    loadingResult: DelayedResult.idle(),
    friends: [],
    requests: [],
  );

  @override
  List<Object?> get props => [loadingResult, searchFilter];

  FriendshipState copyWith({
    DelayedResult<void>? loadingResult,
    List<FriendRequestModel>? friends,
    List<FriendRequestModel>? requests,
    String? searchFilter,
  }) {
    return FriendshipState(
      loadingResult: loadingResult ?? this.loadingResult,
      friends: friends ?? this.friends,
      requests: requests ?? this.requests,
      searchFilter: searchFilter ?? this.searchFilter,
    );
  }
}
