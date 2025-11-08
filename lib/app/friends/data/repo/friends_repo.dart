import 'package:flutter/material.dart';

import '../../../api/models/result_model.dart';
import '../../../api/services/friends_api_service.dart';
import '../models/friendship_model.dart';
import '../models/search_user_model.dart';

abstract class FriendsRepository {
  final FriendsApiService _api;

  FriendsRepository(this._api);

  Future<Result<List<SearchUserModel>>> searchUsers(String query);

  Future<Result<void>> addUser(String username);

  Future<Result<List<FriendRequestModel>>> fetchFriends();
}

class FriendshipDataProvider extends FriendsRepository {
  FriendshipDataProvider(super._api);

  @override
  Future<Result<List<SearchUserModel>>> searchUsers(String query) async {
    try {
      return await _api.searchUsers(query);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> addUser(String username) async {
    try {
      return await _api.addUser(username);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<FriendRequestModel>>> fetchFriends() async {
    try {
      return await _api.fetchFriends();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }
}
