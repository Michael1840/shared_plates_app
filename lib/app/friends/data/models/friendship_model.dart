// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'friendship_model.g.dart';

enum FriendshipStatus {
  @JsonValue('1')
  pending,
  @JsonValue('2')
  accepted,
  @JsonValue('3')
  blocked,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FriendshopModel {
  final int id;
  final String displayName;
  final String username;
  final bool isOnline;

  const FriendshopModel({
    required this.id,
    required this.displayName,
    required this.username,
    required this.isOnline,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FriendRequestModel {
  final int id;
  final String toUser;
  final String fromDisplayName;
  final String fromUsername;
  final String? blockedBy;
  final FriendshipStatus connectionStatus;

  @JsonKey(fromJson: _createdAtFromString)
  final DateTime createdAt;

  const FriendRequestModel({
    required this.id,
    required this.toUser,
    required this.fromDisplayName,
    required this.fromUsername,
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
}
