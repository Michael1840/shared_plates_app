import 'package:flutter/widgets.dart';

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
        return Result.error(Exception('Failed to logout.'));
      }

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
        return Result.error(Exception('Failed to logout.'));
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
}
