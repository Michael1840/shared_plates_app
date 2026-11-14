// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_cook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PopularCook _$PopularCookFromJson(Map<String, dynamic> json) => _PopularCook(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String,
  avatarPath: json['avatar_path'] as String?,
  recipes: (json['recipes'] as num?)?.toInt() ?? 0,
  saves: (json['saves'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PopularCookToJson(_PopularCook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_path': instance.avatarPath,
      'recipes': instance.recipes,
      'saves': instance.saves,
    };
