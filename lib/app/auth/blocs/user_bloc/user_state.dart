part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserLoading extends UserState {}

final class UserInitial extends UserState {}

final class UserUnauthenticated extends UserState {
  final String? error;

  const UserUnauthenticated({this.error});

  @override
  List<Object?> get props => [error];
}

final class UserAuthenticated extends UserState {
  final UserModel user;
  final String? error;
  final String? message;

  const UserAuthenticated({required this.user, this.error, this.message});

  @override
  List<Object?> get props => [user, message, error];

  UserAuthenticated copyWith({
    String? error,
    String? message,
    UserModel? user,
  }) => UserAuthenticated(
    user: user ?? this.user,
    error: error ?? this.error,
    message: message ?? this.message,
  );
}
