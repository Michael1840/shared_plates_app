import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';

class CookArgs {
  const CookArgs({required this.servings, required this.units, this.coverUrl});

  final int servings;
  final UnitSystem units;
  final String? coverUrl;
}

class CookedArgs {
  const CookedArgs({required this.card, required this.servings, this.coverUrl});

  final RecipeCard card;
  final int servings;
  final String? coverUrl;
}
