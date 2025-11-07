// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUserModel _$SearchUserModelFromJson(Map<String, dynamic> json) =>
    SearchUserModel(
      displayName: json['display_name'] as String,
      username: json['username'] as String,
      isFriend: json['is_friend'] as bool,
    );

Map<String, dynamic> _$SearchUserModelToJson(SearchUserModel instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'username': instance.username,
      'is_friend': instance.isFriend,
    };
