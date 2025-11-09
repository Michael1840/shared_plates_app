// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import '../../../api/models/model_converter.dart';
import 'ingredient_model.dart';
import 'step_model.dart';
import 'tag_model.dart';

part 'recipe_model.g.dart';

enum PrivacyStatus {
  @JsonValue('1')
  public,
  @JsonValue('2')
  friends,
  @JsonValue('3')
  private,
}

class RecipeModelConverter extends ModelConverter<RecipeModel> {
  @override
  RecipeModel fromJson(Map<String, dynamic> json) => RecipeModel.fromJson(json);
}

class RecipeDetailModelConverter extends ModelConverter<RecipeDetailModel> {
  @override
  RecipeDetailModel fromJson(Map<String, dynamic> json) =>
      RecipeDetailModel.fromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipeModel {
  final int id;
  final String title;
  final double cost;
  final int serves;
  final String? image;
  final String createdBy;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.cost,
    required this.serves,
    required this.createdBy,
    this.image,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipeDetailModel extends RecipeModel {
  final List<IngredientModel> ingredients;
  final List<StepModel> steps;
  final List<TagModel> tags;

  @JsonKey(defaultValue: PrivacyStatus.public)
  final PrivacyStatus privacyStatus;

  const RecipeDetailModel({
    required super.id,
    required super.title,
    required super.cost,
    required super.serves,
    required super.createdBy,
    super.image,
    required this.ingredients,
    required this.tags,
    required this.steps,
    required this.privacyStatus,
  });

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson()};
  }

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeDetailModelFromJson(json);
}
