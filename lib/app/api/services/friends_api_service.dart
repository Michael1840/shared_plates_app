import 'package:flutter/material.dart';

import '../../friends/data/models/friendship_model.dart';
import '../../friends/data/models/search_user_model.dart';
import '../api_helper.dart';
import '../models/api_response_model.dart';
import '../models/result_model.dart';

class FriendsApiService {
  final FriendRequestModelConverter _friendRequestModelConverter =
      FriendRequestModelConverter();

  final SearchUserModelConverter _searchUserModelConverter =
      SearchUserModelConverter();

  Future<Result<List<SearchUserModel>>> searchUsers(String query) async {
    return ApiHelper.requestModelList<SearchUserModel>(
      ApiRoutes.searchUsers(query),
      DioMethod.get,
      hasAuth: true,
      converter: _searchUserModelConverter,
    );
  }

  Future<Result<void>> addUser(String username) async {
    try {
      Map<String, dynamic> req = {'to_user': username};

      final ApiResponseModel response = await ApiHelper.request(
        ApiRoutes.addUser,
        DioMethod.post,
        hasAuth: true,
        data: req,
      );

      if (!response.isSuccess) {
        return Result.error(Exception('Failed to add friend $username'));
      }

      return const Result.ok(null);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<Result<List<FriendRequestModel>>> fetchFriends() async {
    return ApiHelper.requestModelList<FriendRequestModel>(
      ApiRoutes.friendships,
      DioMethod.get,
      hasAuth: true,
      converter: _friendRequestModelConverter,
    );
  }
}
