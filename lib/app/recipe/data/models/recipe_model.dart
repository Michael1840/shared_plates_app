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
  @JsonKey(defaultValue: TagGroup.empty)
  final TagGroup tagGroup;
  final String? image;
  @JsonKey(defaultValue: false)
  final bool isLiked;
  final String createdBy;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.cost,
    required this.serves,
    required this.createdBy,
    required this.isLiked,
    required this.tagGroup,
    this.image,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);

  RecipeModel copyWith({
    int? id,
    String? title,
    double? cost,
    int? serves,
    TagGroup? tagGroup,
    String? image,
    bool? isLiked,
    String? createdBy,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      cost: cost ?? this.cost,
      serves: serves ?? this.serves,
      tagGroup: tagGroup ?? this.tagGroup,
      image: image ?? this.image,
      isLiked: isLiked ?? this.isLiked,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipeDetailModel extends RecipeModel {
  @JsonKey(defaultValue: [])
  final List<IngredientModel> ingredients;
  @JsonKey(defaultValue: [])
  final List<StepModel> steps;
  @JsonKey(defaultValue: [])
  final List<TagModel> tags;
  @JsonKey(defaultValue: PrivacyStatus.public)
  final PrivacyStatus privacyStatus;

  const RecipeDetailModel({
    required super.id,
    required super.title,
    required super.cost,
    required super.serves,
    required super.createdBy,
    required super.isLiked,
    required super.tagGroup,
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
