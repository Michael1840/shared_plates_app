// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_ingredient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalIngredientModel _$LocalIngredientModelFromJson(
  Map<String, dynamic> json,
) => LocalIngredientModel(
  ingredientName: json['Ingredient_Name'] as String? ?? '',
  category: json['Category'] as String? ?? '',
  caloriesKcalPerG: (json['Calories_kcal_per_g'] as num?)?.toDouble() ?? 0.0,
  proteinGPerG: (json['Protein_g_per_g'] as num?)?.toDouble() ?? 0.0,
  fatGPerG: (json['Fat_g_per_g'] as num?)?.toDouble() ?? 0.0,
  carbsGPerG: (json['Carbs_g_per_g'] as num?)?.toDouble() ?? 0.0,
  fiberGPerG: (json['Fiber_g_per_g'] as num?)?.toDouble() ?? 0.0,
  sugarGPerG: (json['Sugar_g_per_g'] as num?)?.toDouble() ?? 0.0,
  gramsPerCup: (json['Grams_per_Cup'] as num?)?.toDouble() ?? 0.0,
  gramsPerTbsp: (json['Grams_per_Tbsp'] as num?)?.toDouble() ?? 0.0,
  gramsPerUnit: (json['Grams_per_Unit'] as num?)?.toDouble() ?? 0.0,
  unitDescription: json['Unit_Description'] as String?,
);

Map<String, dynamic> _$LocalIngredientModelToJson(
  LocalIngredientModel instance,
) => <String, dynamic>{
  'Ingredient_Name': instance.ingredientName,
  'Category': instance.category,
  'Calories_kcal_per_g': instance.caloriesKcalPerG,
  'Protein_g_per_g': instance.proteinGPerG,
  'Fat_g_per_g': instance.fatGPerG,
  'Carbs_g_per_g': instance.carbsGPerG,
  'Fiber_g_per_g': instance.fiberGPerG,
  'Sugar_g_per_g': instance.sugarGPerG,
  'Grams_per_Cup': instance.gramsPerCup,
  'Grams_per_Tbsp': instance.gramsPerTbsp,
  'Grams_per_Unit': instance.gramsPerUnit,
  'Unit_Description': instance.unitDescription,
};
