// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'ingredient_model.dart';

part 'recipe_model.g.dart';

enum PrivacyStatus {
  @JsonValue('1')
  public,
  @JsonValue('2')
  friends,
  @JsonValue('3')
  private,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipeModel {
  final int id;
  final String title;
  final double cost;
  final int serves;
  final String? assetUrl;
  final String createdBy;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.cost,
    required this.serves,
    required this.createdBy,
    this.assetUrl,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipeDetailModel extends RecipeModel {
  final List<IngredientModel> ingredients;
  final List<String> tags;
  final PrivacyStatus privacyStatus;

  const RecipeDetailModel({
    required super.id,
    required super.title,
    required super.cost,
    required super.serves,
    required super.createdBy,
    super.assetUrl,
    required this.ingredients,
    required this.tags,
    required this.privacyStatus,
  });

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson()};
  }

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeDetailModelFromJson(json);
}
