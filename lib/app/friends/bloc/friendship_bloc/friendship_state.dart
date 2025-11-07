part of 'friendship_bloc.dart';

sealed class FriendshipState extends Equatable {
  const FriendshipState();
  
  @override
  List<Object> get props => [];
}

final class FriendshipInitial extends FriendshipState {}
