import 'package:json_annotation/json_annotation.dart';

part 'ingredient_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IngredientModel {
  final String name;
  final String cost;
  final String quantity;
  final String quantitySymbol;

  const IngredientModel({
    required this.name,
    required this.cost,
    required this.quantity,
    required this.quantitySymbol,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);
}
