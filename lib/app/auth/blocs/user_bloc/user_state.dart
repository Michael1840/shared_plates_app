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
  final bool onboardingComplete;

  const UserUnauthenticated({this.error, required this.onboardingComplete});

  @override
  List<Object?> get props => [error, onboardingComplete];
}

final class UserAuthenticated extends UserState {
  final UserModel user;
  final String? error;
  final String? message;

  const UserAuthenticated({required this.user, this.error, this.message});

  @override
  List<Object?> get props => [user, message, error];

  UserAuthenticated copyWith({
    String? Function()? error,
    String? Function()? message,
    UserModel? user,
  }) => UserAuthenticated(
    user: user ?? this.user,
    error: error != null ? error() : this.error,
    message: message != null ? message() : this.message,
  );
}
