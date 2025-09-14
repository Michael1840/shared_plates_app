part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class UserLogin extends UserEvent {
  final String email;
  final String password;

  const UserLogin({
    required this.email,
    required this.password,
  });
}

final class UserRegister extends UserEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String password2;

  const UserRegister({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.password2,
  });
}

final class UserLogout extends UserEvent {}
