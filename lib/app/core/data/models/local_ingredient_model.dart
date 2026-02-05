// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'local_ingredient_model.g.dart';

@JsonSerializable()
class LocalIngredientModel {
  @JsonKey(name: 'Ingredient_Name')
  final String ingredientName;
  @JsonKey(name: 'Category')
  final String category;
  @JsonKey(name: 'Calories_kcal_per_g')
  final double caloriesKcalPerG;
  @JsonKey(name: 'Protein_g_per_g')
  final double proteinGPerG;
  @JsonKey(name: 'Fat_g_per_g')
  final double fatGPerG;
  @JsonKey(name: 'Carbs_g_per_g')
  final double carbsGPerG;
  @JsonKey(name: 'Fiber_g_per_g')
  final double fiberGPerG;
  @JsonKey(name: 'Sugar_g_per_g')
  final double sugarGPerG;
  @JsonKey(name: 'Grams_per_Cup')
  final double gramsPerCup;
  @JsonKey(name: 'Grams_per_Tbsp')
  final double gramsPerTbsp;
  @JsonKey(name: 'Grams_per_Unit')
  final double gramsPerUnit;
  @JsonKey(name: 'Unit_Description')
  final String? unitDescription;

  const LocalIngredientModel({
    this.ingredientName = '',
    this.category = '',
    this.caloriesKcalPerG = 0.0,
    this.proteinGPerG = 0.0,
    this.fatGPerG = 0.0,
    this.carbsGPerG = 0.0,
    this.fiberGPerG = 0.0,
    this.sugarGPerG = 0.0,
    this.gramsPerCup = 0.0,
    this.gramsPerTbsp = 0.0,
    this.gramsPerUnit = 0.0,
    this.unitDescription,
  });

  factory LocalIngredientModel.fromJson(Map<String, dynamic> json) =>
      _$LocalIngredientModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalIngredientModelToJson(this);
}
