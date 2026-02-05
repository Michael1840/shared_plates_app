import 'dart:convert';

import 'package:flutter/services.dart';

import '../../ui/custom/fields/my_dropdown_field.dart';
import '../models/local_ingredient_model.dart';

class LocalIngredients {
  late List<LocalIngredientModel>? _ingredients;

  List<LocalIngredientModel> get ingredients => _ingredients ?? [];

  List<CustomDropdownValue<LocalIngredientModel>> get searchItems => ingredients
      .map(
        (i) => CustomDropdownValue<LocalIngredientModel>(
          id: i,
          value: i.ingredientName,
        ),
      )
      .toList();

  Future<void> init() async {
    await _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final String response = await rootBundle.loadString(
      'assets/ingredients/ingredients.json',
    );
    final List<dynamic> data = json.decode(response);

    _ingredients = data
        .map((json) => LocalIngredientModel.fromJson(json))
        .toList();
  }

  List<LocalIngredientModel> searchIngredients(String s) {
    if (ingredients.isEmpty) return [];

    return ingredients
        .where(
          (ing) =>
              ing.ingredientName.toLowerCase().trim().contains(
                s.toLowerCase().trim(),
              ) ||
              ing.category.toLowerCase().trim().contains(
                s.toLowerCase().trim(),
              ),
        )
        .toList();
  }
}
