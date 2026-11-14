import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';

extension AppNavigation on BuildContext {
  Future<void> openRecipe(RecipeCard card) =>
      push<void>(Routes.recipeFor(card.id), extra: card);

  Future<void> openSearch([SearchFilters filters = const SearchFilters()]) =>
      push<void>(Routes.search, extra: filters);

  Future<void> openPerson(String id) => push<void>(Routes.personFor(id));
}
