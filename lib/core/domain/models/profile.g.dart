// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  avatarPath: json['avatar_path'] as String?,
  bio: json['bio'] as String?,
  city: json['city'] as String?,
  units:
      $enumDecodeNullable(_$UnitSystemEnumMap, json['units']) ??
      UnitSystem.metric,
  currency: json['currency'] as String? ?? 'ZAR',
  defaultVisibility:
      $enumDecodeNullable(
        _$RecipeVisibilityEnumMap,
        json['default_visibility'],
      ) ??
      RecipeVisibility.friends,
  keepScreenOn: json['keep_screen_on'] as bool? ?? true,
  notifySaves: json['notify_saves'] as bool? ?? true,
  notifyCooks: json['notify_cooks'] as bool? ?? true,
  notifyFriends: json['notify_friends'] as bool? ?? true,
  weeklyRoundup: json['weekly_roundup'] as bool? ?? true,
  onboardedAt: json['onboarded_at'] == null
      ? null
      : DateTime.parse(json['onboarded_at'] as String),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'display_name': instance.displayName,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'avatar_path': instance.avatarPath,
  'bio': instance.bio,
  'city': instance.city,
  'units': _$UnitSystemEnumMap[instance.units]!,
  'currency': instance.currency,
  'default_visibility': _$RecipeVisibilityEnumMap[instance.defaultVisibility]!,
  'keep_screen_on': instance.keepScreenOn,
  'notify_saves': instance.notifySaves,
  'notify_cooks': instance.notifyCooks,
  'notify_friends': instance.notifyFriends,
  'weekly_roundup': instance.weeklyRoundup,
  'onboarded_at': instance.onboardedAt?.toIso8601String(),
};

const _$UnitSystemEnumMap = {
  UnitSystem.metric: 'metric',
  UnitSystem.imperial: 'imperial',
};

const _$RecipeVisibilityEnumMap = {
  RecipeVisibility.private: 'private',
  RecipeVisibility.friends: 'friends',
  RecipeVisibility.public: 'public',
};
