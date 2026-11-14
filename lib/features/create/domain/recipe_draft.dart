import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/step_timer.dart';
import 'package:shared_plates_app/features/create/domain/food_matcher.dart';
import 'package:shared_plates_app/features/create/domain/recipe_parser.dart';

class DraftIngredient extends Equatable {
  const new({
    required this.id,
    required this.rawText,
    this.name,
    this.quantity,
    this.unit,
    this.portionLabel,
    this.prepNote,
    this.section,
    this.foodId,
    this.costCents,
    this.optional = false,
    this.keptAsIs = false,
  });

  factory fromLine(
    String id,
    String line, {
    required FoodLibrary library,
    String? section,
    int? costCents,
  }) => DraftIngredient.fromParsed(
    id,
    RecipeParser.parseIngredient(line, section: section),
    library: library,
    costCents: costCents,
  );

  factory fromParsed(
    String id,
    ParsedIngredient parsed, {
    required FoodLibrary library,
    int? costCents,
  }) {
    final unit = parsed.unit;
    return DraftIngredient(
      id: id,
      rawText: parsed.rawText,
      name: parsed.name,
      quantity: parsed.quantity != null && parsed.quantity! > 0
          ? parsed.quantity
          : null,
      unit: unit != null && library.units.containsKey(unit) ? unit : null,
      portionLabel: parsed.portionLabel,
      prepNote: parsed.prepNote,
      section: parsed.section,
      foodId: library.match(parsed.name)?.food.id,
      costCents: costCents,
    );
  }

  final String id;
  final String rawText;
  final String? name;
  final double? quantity;
  final String? unit;
  final String? portionLabel;
  final String? prepNote;
  final String? section;
  final String? foodId;
  final int? costCents;
  final bool optional;
  final bool keptAsIs;

  String get displayName => name ?? Measure.nameFrom(rawText);

  String? get amountLabel {
    final q = quantity;
    if (q == null) return null;
    final amount = Measure.fraction(q);
    final measure = unit ?? portionLabel;
    return measure == null ? amount : '$amount $measure';
  }

  DraftIngredient copyWith({
    String? foodId,
    bool clearFood = false,
    int? costCents,
    bool clearCost = false,
    bool? keptAsIs,
    String? section,
  }) => DraftIngredient(
    id: id,
    rawText: rawText,
    name: name,
    quantity: quantity,
    unit: unit,
    portionLabel: portionLabel,
    prepNote: prepNote,
    section: section ?? this.section,
    foodId: clearFood ? null : foodId ?? this.foodId,
    costCents: clearCost ? null : costCents ?? this.costCents,
    optional: optional,
    keptAsIs: keptAsIs ?? this.keptAsIs,
  );

  @override
  List<Object?> get props => [
    id,
    rawText,
    name,
    quantity,
    unit,
    portionLabel,
    prepNote,
    section,
    foodId,
    costCents,
    optional,
    keptAsIs,
  ];
}

class DraftStep extends Equatable {
  const new({required this.id, this.body = ''});

  final String id;
  final String body;

  int? get timerSeconds => StepTimer.parse(body);

  @override
  List<Object?> get props => [id, body];
}

enum DraftProblem { name, ingredients, steps }

class RecipeDraft extends Equatable {
  const new({
    required this.id,
    this.title = '',
    this.note,
    this.servings = 4,
    this.totalMinutes,
    this.coverStyle = CoverStyle.any,
    this.coverPath,
    this.localCoverPath,
    this.visibility = RecipeVisibility.friends,
    this.status = RecipeStatus.draft,
    this.source = RecipeSource.typed,
    this.sourceText,
    this.forkedFromId,
    this.ingredients = const [],
    this.steps = const [],
    this.tagIds = const {},
    this.createdAt,
    this.publishedAt,
  });

  static const minServings = 1;
  static const maxServings = 48;
  static const maxMinutes = 2880;
  static const maxTitle = 120;

  final String id;
  final String title;
  final String? note;
  final int servings;
  final int? totalMinutes;
  final CoverStyle coverStyle;
  final String? coverPath;
  final String? localCoverPath;
  final RecipeVisibility visibility;
  final RecipeStatus status;
  final RecipeSource source;
  final String? sourceText;
  final String? forkedFromId;
  final List<DraftIngredient> ingredients;
  final List<DraftStep> steps;
  final Set<int> tagIds;
  final DateTime? createdAt;
  final DateTime? publishedAt;

  bool get isPublished => status == RecipeStatus.published;

  List<DraftStep> get filledSteps => [
    for (final s in steps)
      if (s.body.trim().isNotEmpty) s,
  ];

  bool get isBlank =>
      title.trim().isEmpty &&
      ingredients.isEmpty &&
      filledSteps.isEmpty &&
      localCoverPath == null;

  List<DraftProblem> get problems => [
    if (title.trim().isEmpty) DraftProblem.name,
    if (ingredients.isEmpty) DraftProblem.ingredients,
    if (filledSteps.isEmpty) DraftProblem.steps,
  ];

  int? get costCents {
    final costs = [
      for (final i in ingredients)
        if (i.costCents != null) i.costCents!,
    ];
    return costs.isEmpty ? null : costs.fold<int>(0, (a, b) => a + b);
  }

  int? get costPerServing {
    final total = costCents;
    return total == null ? null : (total / servings).round();
  }

  List<List<String>> linksFor(FoodLibrary library) {
    final filled = filledSteps;
    final links = RecipeParser.linkSteps(
      [for (final s in filled) s.body],
      [
        for (final i in ingredients)
          [i.displayName, ?library.foods[i.foodId]?.name],
      ],
    );
    return [
      for (final hits in links) [for (final h in hits) ingredients[h].id],
    ];
  }

  RecipeDraft copyWith({
    String? title,
    String? note,
    int? servings,
    int? totalMinutes,
    bool clearMinutes = false,
    CoverStyle? coverStyle,
    String? coverPath,
    String? localCoverPath,
    bool clearPhoto = false,
    RecipeVisibility? visibility,
    RecipeStatus? status,
    RecipeSource? source,
    String? sourceText,
    List<DraftIngredient>? ingredients,
    List<DraftStep>? steps,
    Set<int>? tagIds,
    DateTime? createdAt,
    DateTime? publishedAt,
  }) => RecipeDraft(
    id: id,
    title: title ?? this.title,
    note: note ?? this.note,
    servings: servings ?? this.servings,
    totalMinutes: clearMinutes ? null : totalMinutes ?? this.totalMinutes,
    coverStyle: coverStyle ?? this.coverStyle,
    coverPath: clearPhoto ? null : coverPath ?? this.coverPath,
    localCoverPath: clearPhoto ? null : localCoverPath ?? this.localCoverPath,
    visibility: visibility ?? this.visibility,
    status: status ?? this.status,
    source: source ?? this.source,
    sourceText: sourceText ?? this.sourceText,
    forkedFromId: forkedFromId,
    ingredients: ingredients ?? this.ingredients,
    steps: steps ?? this.steps,
    tagIds: tagIds ?? this.tagIds,
    createdAt: createdAt ?? this.createdAt,
    publishedAt: publishedAt ?? this.publishedAt,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    note,
    servings,
    totalMinutes,
    coverStyle,
    coverPath,
    localCoverPath,
    visibility,
    status,
    source,
    sourceText,
    forkedFromId,
    ingredients,
    steps,
    tagIds,
    createdAt,
    publishedAt,
  ];
}

class NutritionTotals extends Equatable {
  const new({
    this.kcal = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.fibre = 0,
    this.matched = 0,
  });

  factory of(RecipeDraft draft, FoodLibrary library) {
    var kcal = 0.0;
    var protein = 0.0;
    var carbs = 0.0;
    var fat = 0.0;
    var fibre = 0.0;
    var matched = 0;
    for (final i in draft.ingredients) {
      final grams = library.gramsFor(
        foodId: i.foodId,
        quantity: i.quantity,
        unit: i.unit,
        portion: i.portionLabel,
      );
      final food = library.foods[i.foodId];
      if (grams == null || food == null) continue;
      matched++;
      kcal += grams * food.kcal100g / 100;
      protein += grams * food.protein100g / 100;
      carbs += grams * food.carbs100g / 100;
      fat += grams * food.fat100g / 100;
      fibre += grams * food.fibre100g / 100;
    }
    final s = draft.servings;
    double round(double v) => (v / s * 10).round() / 10;
    return NutritionTotals(
      kcal: round(kcal),
      protein: round(protein),
      carbs: round(carbs),
      fat: round(fat),
      fibre: round(fibre),
      matched: matched,
    );
  }

  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final double fibre;
  final int matched;

  @override
  List<Object?> get props => [kcal, protein, carbs, fat, fibre, matched];
}
