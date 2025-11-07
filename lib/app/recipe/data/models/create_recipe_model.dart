import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import 'ingredient_model.dart';
import 'step_model.dart';

part 'create_recipe_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class CreateRecipeModel {
  final String title;
  final String description;
  final String serves;
  final List<String> cuisine;
  final List<String> diet;
  final List<String> categories;
  final String privacyStatus;
  final List<IngredientModel> ingredients;
  final List<StepModel> steps;
  @JsonKey(includeToJson: false)
  final File image;

  const CreateRecipeModel({
    required this.title,
    required this.description,
    required this.serves,
    required this.cuisine,
    required this.diet,
    required this.categories,
    required this.privacyStatus,
    required this.ingredients,
    required this.steps,
    required this.image,
  });

  Map<String, dynamic> toJson() => _$CreateRecipeModelToJson(this);
}
