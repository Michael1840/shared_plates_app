// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  displayName: json['display_name'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  isAdmin: json['is_admin'] as bool,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'display_name': instance.displayName,
  'username': instance.username,
  'email': instance.email,
  'is_admin': instance.isAdmin,
};
