import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../api/models/result_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repo/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepo;

  UserBloc(UserRepository userRepo)
    : _userRepo = userRepo,
      super(UserInitial()) {
    on<UserLogin>(_handleLoginEvent);
    on<UserRegister>(_handleRegisterEvent);
    on<UserLogout>(_handleLogoutEvent);
    on<UserFromRefresh>(_handleLoginFromRefresh);
    on<ClearUserError>(_handleClearError);
  }

  Future<void> _handleClearError(
    ClearUserError event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserUnauthenticated());
  }

  Future<void> _handleLoginEvent(
    UserLogin event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      final result = await _userRepo.login(
        email: event.email,
        password: event.password,
      );

      switch (result) {
        case Error<UserModel>():
          throw result.error;
        case CastError<UserModel>():
          throw result.error;
        case Ok<UserModel>():
      }

      emit(UserAuthenticated(user: result.value, message: 'Login success'));
    } catch (e) {
      debugPrint(e.toString());
      emit(UserUnauthenticated(error: e.toString()));
    }
  }

  Future<void> _handleRegisterEvent(
    UserRegister event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      final result = await _userRepo.register(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        password2: event.password2,
      );

      switch (result) {
        case Error<UserModel>():
          throw result.error;
        case CastError<UserModel>():
          throw result.error;
        case Ok<UserModel>():
      }

      emit(UserAuthenticated(user: result.value, message: 'Register success'));
    } catch (e) {
      debugPrint(e.toString());
      emit(UserUnauthenticated(error: e.toString()));
    }
  }

  Future<void> _handleLoginFromRefresh(
    UserFromRefresh event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      // final result = await _userRepo.getUser();

      final results = await Future.wait([
        _userRepo.getUser(),
        Future.delayed(2.seconds),
      ]);

      final result = results[0];

      switch (result) {
        case Error<UserModel>():
          throw result.error;
        case CastError<UserModel>():
          throw result.error;
        case Ok<UserModel>():
      }

      emit(UserAuthenticated(user: result.value, message: 'Register success'));
    } catch (e) {
      debugPrint(e.toString());
      emit(UserUnauthenticated(error: e.toString()));
    }
  }

  Future<void> _handleLogoutEvent(
    UserLogout event,
    Emitter<UserState> emit,
  ) async {
    if (state is! UserAuthenticated) return;

    UserAuthenticated copiedState = (state as UserAuthenticated).copyWith();

    emit(UserLoading());

    try {
      final result = await _userRepo.logout();

      switch (result) {
        case Error<void>():
          throw result.error;
        case CastError<void>():
          throw result.error;
        case Ok<void>():
      }

      emit(const UserUnauthenticated());
    } catch (e) {
      debugPrint(e.toString());
      emit(copiedState.copyWith(error: e.toString()));
    }
  }
}
