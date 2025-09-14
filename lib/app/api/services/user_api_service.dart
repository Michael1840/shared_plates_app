import 'package:flutter/widgets.dart';

import '../../../main.dart';
import '../../auth/data/models/user_model.dart';
import '../api_helper.dart';
import '../models/api_response_model.dart';
import '../models/result_model.dart';

class UserApiService {
  Future<Result<void>> login(Map<String, dynamic> req) async {
    try {
      final ApiResponseModel response = await apiHelper.request(
        ApiRoutes.login,
        DioMethod.post,
        hasAuth: false,
        data: req,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to login.'));
      }

      String? accessToken = response.data['token']?['access'];
      String? refreshToken = response.data['token']?['refresh'];

      if (accessToken == null || refreshToken == null) {
        return Result.error(Exception('Failed to login.'));
      }

      tokenStorage.saveTokens(accessToken, refreshToken);

      return const Result.ok(null);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<void>> register(Map<String, dynamic> req) async {
    try {
      final ApiResponseModel response = await apiHelper.request(
        ApiRoutes.register,
        DioMethod.post,
        hasAuth: false,
        data: req,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to register.'));
      }

      return const Result.ok(null);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      final ApiResponseModel response = await apiHelper.request(
        ApiRoutes.logout,
        DioMethod.get,
        hasAuth: false,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to logout.'));
      }

      return const Result.ok(null);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<UserModel>> profile() async {
    try {
      final ApiResponseModel response = await apiHelper.request(
        ApiRoutes.profile,
        DioMethod.get,
        hasAuth: true,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to get profile.'));
      }

      if (response.data == null) {
        return const Result.castError();
      }

      final UserModel user = UserModel.fromJson(response.data);

      return Result.ok(user);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }
}
