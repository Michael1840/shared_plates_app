// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientModel _$IngredientModelFromJson(Map<String, dynamic> json) =>
    IngredientModel(
      name: json['name'] as String,
      cost: json['cost'] as String,
      quantity: json['quantity'] as String,
      quantitySymbol: json['quantity_symbol'] as String,
    );

Map<String, dynamic> _$IngredientModelToJson(IngredientModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cost': instance.cost,
      'quantity': instance.quantity,
      'quantity_symbol': instance.quantitySymbol,
    };
