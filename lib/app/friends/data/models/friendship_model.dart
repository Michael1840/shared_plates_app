// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import '../../../api/models/model_converter.dart';

part 'friendship_model.g.dart';

enum FriendshipStatus {
  @JsonValue('1')
  pending,
  @JsonValue('2')
  accepted,
  @JsonValue('3')
  blocked,
}

class FriendRequestModelConverter extends ModelConverter<FriendRequestModel> {
  @override
  FriendRequestModel fromJson(Map<String, dynamic> json) =>
      FriendRequestModel.fromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FriendshopModel {
  final String displayName;
  final String username;

  const FriendshopModel({required this.displayName, required this.username});

  bool get isOnline => true;

  factory FriendshopModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshopModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendshopModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FriendRequestModel {
  final int id;
  final FriendshopModel toUser;
  final FriendshopModel fromUser;
  final FriendshopModel? blockedBy;
  final FriendshipStatus connectionStatus;

  @JsonKey(fromJson: _createdAtFromString)
  final DateTime createdAt;

  const FriendRequestModel({
    required this.id,
    required this.toUser,
    required this.fromUser,
    required this.blockedBy,
    required this.connectionStatus,
    required this.createdAt,
  });

  static DateTime _createdAtFromString(String? value) {
    if (value == null) throw Exception('Format error, cannot cast null date');

    DateTime? date = DateTime.tryParse(value);

    if (date == null) throw Exception('Format error, cannot cast null date');

    return date;
  }

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendRequestModelToJson(this);
}
