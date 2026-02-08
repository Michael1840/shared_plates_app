import 'package:json_annotation/json_annotation.dart';

part 'ingredient_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IngredientModel {
  final int id;
  final String name;
  final String cost;
  final String quantity;
  final String quantitySymbol;
  final String calories;
  final String protein;
  final String fat;
  final String carbs;

  const IngredientModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.quantity,
    required this.quantitySymbol,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'cost': cost,
    'quantity': quantity,
    'quantity_symbol': quantitySymbol,
    'calories': calories,
    'protein': protein,
    'fat': fat,
    'carbs': carbs,
  };

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);
}
