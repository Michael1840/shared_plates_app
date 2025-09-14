import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  final String id;
  final String displayName;
  final String username;
  final String email;
  final bool isAdmin;

  const UserModel({
    required this.id,
    required this.displayName,
    required this.username,
    required this.email,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.empty() => const UserModel(
    id: '',
    displayName: '',
    username: '',
    email: '',
    isAdmin: false,
  );

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
