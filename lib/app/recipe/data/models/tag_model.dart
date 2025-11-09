// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TagModel {
  final String name;
  final String tagType;

  const TagModel({required this.name, required this.tagType});

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);
}
