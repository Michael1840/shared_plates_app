import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';

import '../../../api/models/result_model.dart';
import '../../../core/data/helpers/token_storage.dart';
import '../../data/models/user_model.dart';
import '../../data/repo/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  StreamSubscription<UserModel?>? _userSubscription;

  final UserRepository _userRepo;

  UserBloc(UserRepository userRepo)
    : _userRepo = userRepo,
      super(UserInitial()) {
    on<UserLogin>(_handleLoginEvent);
    on<UserRegister>(_handleRegisterEvent);
    on<UserLogout>(_handleLogoutEvent);
    on<UserFromRefresh>(_handleLoginFromRefresh);
    on<ClearUserError>(_handleClearError);
    on<UserAuthChanged>(_handleAuthChange);
    on<UserNotFound>(_handleUserNotFound);

    _initialize();
  }

  TokenStorage get tokenStorage => GetIt.I<TokenStorage>();

  void _initialize() {
    _userSubscription = _userRepo.authStateChanges.listen((user) {
      add(UserAuthChanged(user));
    });

    final user = _userRepo.currentUser;
    add(UserAuthChanged(user));
  }

  Future<void> _handleAuthChange(
    UserAuthChanged event,
    Emitter<UserState> emit,
  ) async {
    if (event.user != null) {
      emit(UserAuthenticated(user: event.user!));
    } else {
      bool onboardingComplete = await tokenStorage.getOnboarding() ?? false;

      emit(UserUnauthenticated(onboardingComplete: onboardingComplete));
    }
  }

  Future<void> _handleClearError(
    ClearUserError event,
    Emitter<UserState> emit,
  ) async {
    bool onboardingComplete = await tokenStorage.getOnboarding() ?? false;

    emit(UserUnauthenticated(onboardingComplete: onboardingComplete));
  }

  Future<void> _handleUserNotFound(
    UserNotFound event,
    Emitter<UserState> emit,
  ) async {
    emit(UserUnauthenticated(onboardingComplete: event.onboardingCompleted));
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
      bool onboardingComplete = await tokenStorage.getOnboarding() ?? false;

      emit(
        UserUnauthenticated(
          error: e.toString(),
          onboardingComplete: onboardingComplete,
        ),
      );
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
      bool onboardingComplete = await tokenStorage.getOnboarding() ?? false;

      emit(
        UserUnauthenticated(
          error: e.toString(),
          onboardingComplete: onboardingComplete,
        ),
      );
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

      final Result<UserModel> result = results[0];

      switch (result) {
        case Error<UserModel>():
          throw result.error;
        case CastError<UserModel>():
          throw result.error;
        case Ok<UserModel>():
      }

      emit(
        UserAuthenticated(
          user: result.value,
          message: 'Welcome back ${result.value.displayName}',
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      bool onboardingComplete = await tokenStorage.getOnboarding() ?? false;

      emit(
        UserUnauthenticated(
          error: e.toString(),
          onboardingComplete: onboardingComplete,
        ),
      );
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

      final tokenStorage = GetIt.I<TokenStorage>();

      tokenStorage.clearTokens();

      bool onboardingComplete = await tokenStorage.getOnboarding() ?? false;

      emit(UserUnauthenticated(onboardingComplete: onboardingComplete));
    } catch (e) {
      debugPrint(e.toString());
      emit(copiedState.copyWith(error: () => e.toString()));
    }
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    _userRepo.dispose();
    super.close();
  }
}
