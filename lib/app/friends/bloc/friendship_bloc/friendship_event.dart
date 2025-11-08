part of 'friendship_bloc.dart';

sealed class FriendshipEvent extends Equatable {
  const FriendshipEvent();

  @override
  List<Object> get props => [];
}

class FriendshipsFetch extends FriendshipEvent {}
