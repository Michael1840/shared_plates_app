import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/features/create/domain/food_matcher.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';

abstract final class TagGuesser {
  static const _meaty = {'meat', 'seafood', 'poultry', 'fish'};

  static const _hints = <String, List<String>>{
    'curry': ['curry', 'masala', 'garam'],
    'braai': ['braai', 'boerewors', 'wors', 'chops', 'sosatie'],
    'soup': ['soup'],
    'stew': ['stew', 'potjie'],
    'salad': ['salad'],
    'pasta': ['pasta', 'penne', 'spaghetti', 'macaroni', 'fusilli'],
    'breakfast': ['breakfast', 'pancake', 'oats', 'flapjack'],
    'baking': ['bake', 'cake', 'bread', 'muffin', 'rusks', 'scone'],
    'dessert': ['pudding', 'dessert', 'malva', 'tart', 'koeksister'],
    'one-pot': ['one pot', 'one-pot'],
  };

  static Set<int> guess({
    required RecipeDraft draft,
    required FoodLibrary library,
    required List<Tag> tags,
  }) {
    final bySlug = {for (final t in tags) t.slug: t.id};
    final text = [
      draft.title,
      for (final i in draft.ingredients) i.rawText,
    ].join(' ').toLowerCase();
    final matched = [
      for (final i in draft.ingredients) ?library.foods[i.foodId],
    ];
    final out = <int>{};
    for (final MapEntry(key: slug, value: words) in _hints.entries) {
      final id = bySlug[slug];
      if (id != null && words.any(text.contains)) out.add(id);
    }
    final veggie = bySlug['veggie'];
    final meatInText = RegExp(
      r'\b(chicken|beef|lamb|pork|mince|bacon|fish|tuna|prawn|wors|steak)',
    ).hasMatch(text);
    if (veggie != null &&
        matched.length >= 2 &&
        !meatInText &&
        matched.every((f) => !_meaty.contains(f.category))) {
      out.add(veggie);
    }
    return out..removeAll(draft.tagIds);
  }
}
