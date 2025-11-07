// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import '../../../api/models/model_converter.dart';

part 'search_user_model.g.dart';

class SearchUserModelConverter extends ModelConverter<SearchUserModel> {
  @override
  SearchUserModel fromJson(Map<String, dynamic> json) =>
      SearchUserModel.fromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchUserModel {
  final String displayName;
  final String username;
  final bool isFriend;

  const SearchUserModel({
    required this.displayName,
    required this.username,
    required this.isFriend,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) =>
      _$SearchUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchUserModelToJson(this);

  SearchUserModel copyWith({
    String? displayName,
    String? username,
    bool? isFriend,
  }) {
    return SearchUserModel(
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      isFriend: isFriend ?? this.isFriend,
    );
  }
}
