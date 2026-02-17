import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../../api/models/result_model.dart';
import '../../../api/services/user_api_service.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  Stream<UserModel?> get authStateChanges;

  UserModel? get currentUser;

  Future<Result<UserModel>> login({
    required String email,
    required String password,
  });
  Future<Result<UserModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String password2,
  });
  Future<Result<void>> logout();
  Future<Result<UserModel>> getUser();
  void dispose();
}

class UserRepositoryImpl implements UserRepository {
  final UserApiService _api;

  UserRepositoryImpl(this._api);

  final StreamController<UserModel?> _authController =
      StreamController<UserModel?>.broadcast();

  UserModel? _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _authController.stream;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> req = {'email': email, 'password': password};

    try {
      final result = await _api.login(req);

      switch (result) {
        case Error<void>():
          return Result.error(result.error);
        case CastError<void>():
          return const Result.castError();
        case Ok<void>():
      }

      return await getUser();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String password2,
  }) async {
    Map<String, dynamic> req = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password2': password,
    };

    try {
      final result = await _api.register(req);

      switch (result) {
        case Error<void>():
          return Result.error(result.error);
        case CastError<void>():
          return const Result.castError();
        case Ok<void>():
      }

      return await getUser();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final result = await _api.logout();

      switch (result) {
        case Error<void>():
          return Result.error(result.error);
        case CastError<void>():
          return const Result.castError();
        case Ok<void>():
          _authController.add(null);
      }

      return const Result.ok(null);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<UserModel>> getUser() async {
    try {
      final result = await _api.profile();

      switch (result) {
        case Error<UserModel>():
          return Result.error(result.error);
        case CastError<UserModel>():
          return const Result.castError();
        case Ok<UserModel>():
          _authController.add(result.value);
      }

      return Result.ok(result.value);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  @override
  void dispose() {
    _authController.close();
  }
}
