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

  NutrionalInfo nutrionalInfo({
    required double quantity,
    required String unit,
  }) => IngredientCalculator.calculateAllNutrition(
    ingredient: this,
    quantity: quantity,
    unit: unit,
  );
}

class NutrionalInfo {
  final LocalIngredientModel ingredient;
  final double calories;
  final double fiber;
  final double sugar;
  final double fat;
  final double protein;
  final double carbs;

  const NutrionalInfo({
    required this.ingredient,
    required this.calories,
    required this.fiber,
    required this.sugar,
    required this.fat,
    required this.protein,
    required this.carbs,
  });
}

class IngredientCalculator {
  /// Calculate total calories based on quantity and unit
  static double calculateCalories({
    required LocalIngredientModel ingredient,
    required double quantity,
    required String unit,
  }) {
    final caloriesPerGram = ingredient.caloriesKcalPerG;
    final grams = convertToGrams(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    );
    return caloriesPerGram * grams;
  }

  /// Calculate total protein in grams
  static double calculateProtein({
    required LocalIngredientModel ingredient,
    required double quantity,
    required String unit,
  }) {
    final proteinPerGram = ingredient.proteinGPerG;
    final grams = convertToGrams(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    );
    return proteinPerGram * grams;
  }

  /// Calculate total fat in grams
  static double calculateFat({
    required LocalIngredientModel ingredient,
    required double quantity,
    required String unit,
  }) {
    final fatPerGram = ingredient.fatGPerG;
    final grams = convertToGrams(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    );
    return fatPerGram * grams;
  }

  /// Calculate total carbs in grams
  static double calculateCarbs({
    required LocalIngredientModel ingredient,
    required double quantity,
    required String unit,
  }) {
    final carbsPerGram = ingredient.carbsGPerG;
    final grams = convertToGrams(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    );
    return carbsPerGram * grams;
  }

  /// Calculate total fiber in grams
  static double calculateFiber({
    required LocalIngredientModel ingredient,
    required double quantity,
    required String unit,
  }) {
    final fiberPerGram = ingredient.fiberGPerG;
    final grams = convertToGrams(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    );
    return fiberPerGram * grams;
  }

  /// Calculate total sugar in grams
  static double calculateSugar({
    required LocalIngredientModel ingredient,
    required double quantity,
    required String unit,
  }) {
    final sugarPerGram = ingredient.sugarGPerG;
    final grams = convertToGrams(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    );
    return sugarPerGram * grams;
  }

  /// Core conversion method - converts any unit to grams
  static double convertToGrams({
    required LocalIngredientModel ingredient,
    required double quantity,
    required String unit,
  }) {
    switch (unit.toLowerCase()) {
      case 'mg':
        return quantity / 1000; // milligrams to grams

      case 'g':
        return quantity; // already in grams

      case 'kg':
        return quantity * 1000; // kilograms to grams

      case 'ml':
        // For liquids, assume density ~1g/ml (water-based)
        // You may want to add density data to ingredients for accuracy
        return quantity;

      case 'l':
        return quantity * 1000; // liters to grams (assuming density 1)

      default:
        // Check if it's a custom unit (Unit_Description match)
        final unitDescription = ingredient.unitDescription;
        final gramsPerUnit = ingredient.gramsPerUnit;

        if (unitDescription != null &&
            unit.toLowerCase() == unitDescription.toLowerCase() &&
            gramsPerUnit > 0) {
          return quantity * gramsPerUnit;
        }

        // Fallback: assume unit is grams if unknown
        return quantity;
    }
  }

  /// Get all nutrition in one call
  static NutrionalInfo calculateAllNutrition({
    required LocalIngredientModel ingredient,
    required double quantity,
    required String unit,
  }) => NutrionalInfo(
    ingredient: ingredient,
    calories: calculateCalories(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    ),
    fiber: calculateFiber(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    ),
    sugar: calculateSugar(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    ),
    fat: calculateFat(ingredient: ingredient, quantity: quantity, unit: unit),
    protein: calculateProtein(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    ),
    carbs: calculateCarbs(
      ingredient: ingredient,
      quantity: quantity,
      unit: unit,
    ),
  );
}
