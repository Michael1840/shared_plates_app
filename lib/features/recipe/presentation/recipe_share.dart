import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';

abstract final class RecipeShare {
  static String link(String recipeId) => '${Env.shareBaseUrl}/r/$recipeId';

  static String message(RecipeCard card) {
    final by = Formatters.shortName(card.authorName);
    final who = card.isMine || by.isEmpty ? '' : ' by $by';
    return '${card.title}$who on SharedPlates\n${link(card.id)}';
  }

  static String shoppingList({
    required RecipeCard card,
    required List<RecipeIngredient> ingredients,
    required Set<String> ticked,
    required String? Function(RecipeIngredient) amountFor,
    required int servings,
  }) {
    final lines = [
      for (final i in ingredients)
        if (!ticked.contains(i.id))
          '• ${[?amountFor(i), Measure.nameFrom(i.rawText)].join(' ')}',
    ];
    return [
      '${card.title} (serves $servings)',
      ...lines,
      '',
      link(card.id),
    ].join('\n');
  }
}
