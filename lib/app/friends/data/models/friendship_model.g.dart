// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendshopModel _$FriendshopModelFromJson(Map<String, dynamic> json) =>
    FriendshopModel(
      displayName: json['display_name'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$FriendshopModelToJson(FriendshopModel instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'username': instance.username,
    };

FriendRequestModel _$FriendRequestModelFromJson(
  Map<String, dynamic> json,
) => FriendRequestModel(
  id: (json['id'] as num).toInt(),
  toUser: FriendshopModel.fromJson(json['to_user'] as Map<String, dynamic>),
  fromUser: FriendshopModel.fromJson(json['from_user'] as Map<String, dynamic>),
  blockedBy: json['blocked_by'] == null
      ? null
      : FriendshopModel.fromJson(json['blocked_by'] as Map<String, dynamic>),
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
  'from_user': instance.fromUser,
  'blocked_by': instance.blockedBy,
  'connection_status': _$FriendshipStatusEnumMap[instance.connectionStatus]!,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$FriendshipStatusEnumMap = {
  FriendshipStatus.pending: '1',
  FriendshipStatus.accepted: '2',
  FriendshipStatus.blocked: '3',
};
