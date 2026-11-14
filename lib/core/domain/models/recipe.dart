import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_plates_app/core/domain/enums.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
abstract class Recipe with _$Recipe {
  const factory({
    required String id,
    required String authorId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String title,
    String? forkedFromId,
    String? note,
    String? coverPath,
    @Default(CoverStyle.any) CoverStyle coverStyle,
    @Default(4) int baseServings,
    int? totalMinutes,
    @Default(RecipeVisibility.friends) RecipeVisibility visibility,
    @Default(RecipeStatus.draft) RecipeStatus status,
    @Default(RecipeSource.typed) RecipeSource source,
    String? sourceText,
    double? kcalPerServing,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? fibreG,
    @Default(0) int ingredientCount,
    @Default(0) int matchedLines,
    int? costCents,
    @Default('ZAR') String costCurrency,
    @Default(0) int likeCount,
    @Default(0) int saveCount,
    @Default(0) int cookCount,
    DateTime? publishedAt,
    DateTime? deletedAt,
  }) = _Recipe;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toWritableJson() => {
    'id': id,
    'title': title,
    'forked_from_id': forkedFromId,
    'note': note,
    'cover_path': coverPath,
    'cover_style': coverStyle.name,
    'base_servings': baseServings,
    'total_minutes': totalMinutes,
    'visibility': visibility.name,
    'status': status.name,
    'source': source.name,
    'source_text': sourceText,
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
  };
}

@freezed
abstract class RecipeIngredient with _$RecipeIngredient {
  const factory({
    required String id,
    required String recipeId,
    required int position,
    required String rawText,
    required DateTime updatedAt,
    String? section,
    double? quantity,
    String? unit,
    String? portionLabel,
    String? foodId,
    String? prepNote,
    double? grams,
    int? costCents,
    @Default(false) bool optional,
  }) = _RecipeIngredient;

  const new _();

  factory fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);

  Map<String, dynamic> toWritableJson() => toJson()
    ..remove('grams')
    ..remove('updated_at');
}

@freezed
abstract class RecipeStep with _$RecipeStep {
  const factory({
    required String id,
    required String recipeId,
    required int position,
    required String body,
    required DateTime updatedAt,
    int? timerSeconds,
  }) = _RecipeStep;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$RecipeStepFromJson(json);

  Map<String, dynamic> toWritableJson() => toJson()..remove('updated_at');
}

@freezed
abstract class RecipeCard with _$RecipeCard {
  const factory({
    required String id,
    required String authorId,
    required String title,
    required DateTime updatedAt,
    String? authorUsername,
    String? authorName,
    String? authorAvatar,
    String? note,
    String? coverPath,
    @Default(CoverStyle.any) CoverStyle coverStyle,
    @Default(4) int baseServings,
    int? totalMinutes,
    @Default(RecipeVisibility.friends) RecipeVisibility visibility,
    @Default(RecipeStatus.published) RecipeStatus status,
    double? kcalPerServing,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? fibreG,
    @Default(0) int ingredientCount,
    @Default(0) int matchedLines,
    int? costCents,
    @Default('ZAR') String costCurrency,
    int? costPerPlate,
    @Default(0) int likeCount,
    @Default(0) int saveCount,
    @Default(0) int cookCount,
    String? forkedFromId,
    DateTime? publishedAt,
    @Default(false) bool isLiked,
    @Default(false) bool isSaved,
    @Default(false) bool isMine,
    String? coverUrl,
  }) = _RecipeCard;

  factory fromJson(Map<String, dynamic> json) => _$RecipeCardFromJson(json);
}
