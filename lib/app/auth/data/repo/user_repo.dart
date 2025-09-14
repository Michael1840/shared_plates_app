import 'package:flutter/cupertino.dart';

import '../../../api/models/result_model.dart';
import '../../../api/services/user_api_service.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  final UserApiService _api;

  UserRepository(this._api);

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
}

class UserDataProvider extends UserRepository {
  UserDataProvider(super._api);

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
      return await _api.logout();
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
      }

      return Result.ok(result.value);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }
}
