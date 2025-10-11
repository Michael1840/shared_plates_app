import 'package:json_annotation/json_annotation.dart';

part 'ingredient_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IngredientModel {
  final int id;
  final String name;
  final String cost;
  final String quantity;
  final String quantitySymbol;

  const IngredientModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.quantity,
    required this.quantitySymbol,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'cost': cost,
    'quantity': quantity,
    'quantity_symbol': quantitySymbol,
  };

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);
}
