// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendshopModel _$FriendshopModelFromJson(Map<String, dynamic> json) =>
    FriendshopModel(
      id: (json['id'] as num).toInt(),
      displayName: json['display_name'] as String,
      username: json['username'] as String,
      isOnline: json['is_online'] as bool,
    );

Map<String, dynamic> _$FriendshopModelToJson(FriendshopModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'username': instance.username,
      'is_online': instance.isOnline,
    };

FriendRequestModel _$FriendRequestModelFromJson(Map<String, dynamic> json) =>
    FriendRequestModel(
      id: (json['id'] as num).toInt(),
      toUser: json['to_user'] as String,
      fromDisplayName: json['from_display_name'] as String,
      fromUsername: json['from_username'] as String,
      blockedBy: json['blocked_by'] as String?,
      connectionStatus: $enumDecode(
        _$FriendshipStatusEnumMap,
        json['connection_status'],
      ),
      createdAt: FriendRequestModel._createdAtFromString(
        json['created_at'] as String?,
      ),
    );

Map<String, dynamic> _$FriendRequestModelToJson(
  FriendRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'to_user': instance.toUser,
  'from_display_name': instance.fromDisplayName,
  'from_username': instance.fromUsername,
  'blocked_by': instance.blockedBy,
  'connection_status': _$FriendshipStatusEnumMap[instance.connectionStatus]!,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$FriendshipStatusEnumMap = {
  FriendshipStatus.pending: '1',
  FriendshipStatus.accepted: '2',
  FriendshipStatus.blocked: '3',
};
