import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';

class RecipeDetail extends Equatable {
  const RecipeDetail({
    required this.card,
    this.ingredients = const [],
    this.steps = const [],
    this.stepIngredients = const {},
    this.tags = const [],
    this.ticks = const {},
  });

  final RecipeCard card;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final Map<String, List<String>> stepIngredients;
  final List<Tag> tags;
  final Set<String> ticks;

  bool get hasContent => ingredients.isNotEmpty || steps.isNotEmpty;

  List<RecipeIngredient> ingredientsForStep(String stepId) {
    final ids = stepIngredients[stepId] ?? const <String>[];
    return [
      for (final i in ingredients)
        if (ids.contains(i.id)) i,
    ];
  }

  @override
  List<Object?> get props => [
    card,
    ingredients,
    steps,
    stepIngredients,
    tags,
    ticks,
  ];
}
