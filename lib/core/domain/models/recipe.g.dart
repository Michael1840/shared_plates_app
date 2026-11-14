// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: json['id'] as String,
  authorId: json['author_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  title: json['title'] as String? ?? '',
  forkedFromId: json['forked_from_id'] as String?,
  note: json['note'] as String?,
  coverPath: json['cover_path'] as String?,
  coverStyle:
      $enumDecodeNullable(_$CoverStyleEnumMap, json['cover_style']) ??
      CoverStyle.any,
  baseServings: (json['base_servings'] as num?)?.toInt() ?? 4,
  totalMinutes: (json['total_minutes'] as num?)?.toInt(),
  visibility:
      $enumDecodeNullable(_$RecipeVisibilityEnumMap, json['visibility']) ??
      RecipeVisibility.friends,
  status:
      $enumDecodeNullable(_$RecipeStatusEnumMap, json['status']) ??
      RecipeStatus.draft,
  source:
      $enumDecodeNullable(_$RecipeSourceEnumMap, json['source']) ??
      RecipeSource.typed,
  sourceText: json['source_text'] as String?,
  kcalPerServing: (json['kcal_per_serving'] as num?)?.toDouble(),
  proteinG: (json['protein_g'] as num?)?.toDouble(),
  carbsG: (json['carbs_g'] as num?)?.toDouble(),
  fatG: (json['fat_g'] as num?)?.toDouble(),
  fibreG: (json['fibre_g'] as num?)?.toDouble(),
  ingredientCount: (json['ingredient_count'] as num?)?.toInt() ?? 0,
  matchedLines: (json['matched_lines'] as num?)?.toInt() ?? 0,
  costCents: (json['cost_cents'] as num?)?.toInt(),
  costCurrency: json['cost_currency'] as String? ?? 'ZAR',
  likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
  saveCount: (json['save_count'] as num?)?.toInt() ?? 0,
  cookCount: (json['cook_count'] as num?)?.toInt() ?? 0,
  publishedAt: json['published_at'] == null
      ? null
      : DateTime.parse(json['published_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'author_id': instance.authorId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'title': instance.title,
  'forked_from_id': instance.forkedFromId,
  'note': instance.note,
  'cover_path': instance.coverPath,
  'cover_style': _$CoverStyleEnumMap[instance.coverStyle]!,
  'base_servings': instance.baseServings,
  'total_minutes': instance.totalMinutes,
  'visibility': _$RecipeVisibilityEnumMap[instance.visibility]!,
  'status': _$RecipeStatusEnumMap[instance.status]!,
  'source': _$RecipeSourceEnumMap[instance.source]!,
  'source_text': instance.sourceText,
  'kcal_per_serving': instance.kcalPerServing,
  'protein_g': instance.proteinG,
  'carbs_g': instance.carbsG,
  'fat_g': instance.fatG,
  'fibre_g': instance.fibreG,
  'ingredient_count': instance.ingredientCount,
  'matched_lines': instance.matchedLines,
  'cost_cents': instance.costCents,
  'cost_currency': instance.costCurrency,
  'like_count': instance.likeCount,
  'save_count': instance.saveCount,
  'cook_count': instance.cookCount,
  'published_at': instance.publishedAt?.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$CoverStyleEnumMap = {
  CoverStyle.stew: 'stew',
  CoverStyle.meat: 'meat',
  CoverStyle.veg: 'veg',
  CoverStyle.sweet: 'sweet',
  CoverStyle.any: 'any',
};

const _$RecipeVisibilityEnumMap = {
  RecipeVisibility.private: 'private',
  RecipeVisibility.friends: 'friends',
  RecipeVisibility.public: 'public',
};

const _$RecipeStatusEnumMap = {
  RecipeStatus.draft: 'draft',
  RecipeStatus.published: 'published',
};

const _$RecipeSourceEnumMap = {
  RecipeSource.typed: 'typed',
  RecipeSource.pasted: 'pasted',
};

_RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) =>
    _RecipeIngredient(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String,
      position: (json['position'] as num).toInt(),
      rawText: json['raw_text'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      section: json['section'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      portionLabel: json['portion_label'] as String?,
      foodId: json['food_id'] as String?,
      prepNote: json['prep_note'] as String?,
      grams: (json['grams'] as num?)?.toDouble(),
      costCents: (json['cost_cents'] as num?)?.toInt(),
      optional: json['optional'] as bool? ?? false,
    );

Map<String, dynamic> _$RecipeIngredientToJson(_RecipeIngredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipe_id': instance.recipeId,
      'position': instance.position,
      'raw_text': instance.rawText,
      'updated_at': instance.updatedAt.toIso8601String(),
      'section': instance.section,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'portion_label': instance.portionLabel,
      'food_id': instance.foodId,
      'prep_note': instance.prepNote,
      'grams': instance.grams,
      'cost_cents': instance.costCents,
      'optional': instance.optional,
    };

_RecipeStep _$RecipeStepFromJson(Map<String, dynamic> json) => _RecipeStep(
  id: json['id'] as String,
  recipeId: json['recipe_id'] as String,
  position: (json['position'] as num).toInt(),
  body: json['body'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  timerSeconds: (json['timer_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$RecipeStepToJson(_RecipeStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipe_id': instance.recipeId,
      'position': instance.position,
      'body': instance.body,
      'updated_at': instance.updatedAt.toIso8601String(),
      'timer_seconds': instance.timerSeconds,
    };

_RecipeCard _$RecipeCardFromJson(Map<String, dynamic> json) => _RecipeCard(
  id: json['id'] as String,
  authorId: json['author_id'] as String,
  title: json['title'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  authorUsername: json['author_username'] as String?,
  authorName: json['author_name'] as String?,
  authorAvatar: json['author_avatar'] as String?,
  note: json['note'] as String?,
  coverPath: json['cover_path'] as String?,
  coverStyle:
      $enumDecodeNullable(_$CoverStyleEnumMap, json['cover_style']) ??
      CoverStyle.any,
  baseServings: (json['base_servings'] as num?)?.toInt() ?? 4,
  totalMinutes: (json['total_minutes'] as num?)?.toInt(),
  visibility:
      $enumDecodeNullable(_$RecipeVisibilityEnumMap, json['visibility']) ??
      RecipeVisibility.friends,
  status:
      $enumDecodeNullable(_$RecipeStatusEnumMap, json['status']) ??
      RecipeStatus.published,
  kcalPerServing: (json['kcal_per_serving'] as num?)?.toDouble(),
  proteinG: (json['protein_g'] as num?)?.toDouble(),
  carbsG: (json['carbs_g'] as num?)?.toDouble(),
  fatG: (json['fat_g'] as num?)?.toDouble(),
  fibreG: (json['fibre_g'] as num?)?.toDouble(),
  ingredientCount: (json['ingredient_count'] as num?)?.toInt() ?? 0,
  matchedLines: (json['matched_lines'] as num?)?.toInt() ?? 0,
  costCents: (json['cost_cents'] as num?)?.toInt(),
  costCurrency: json['cost_currency'] as String? ?? 'ZAR',
  costPerPlate: (json['cost_per_plate'] as num?)?.toInt(),
  likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
  saveCount: (json['save_count'] as num?)?.toInt() ?? 0,
  cookCount: (json['cook_count'] as num?)?.toInt() ?? 0,
  forkedFromId: json['forked_from_id'] as String?,
  publishedAt: json['published_at'] == null
      ? null
      : DateTime.parse(json['published_at'] as String),
  isLiked: json['is_liked'] as bool? ?? false,
  isSaved: json['is_saved'] as bool? ?? false,
  isMine: json['is_mine'] as bool? ?? false,
);

Map<String, dynamic> _$RecipeCardToJson(_RecipeCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'title': instance.title,
      'updated_at': instance.updatedAt.toIso8601String(),
      'author_username': instance.authorUsername,
      'author_name': instance.authorName,
      'author_avatar': instance.authorAvatar,
      'note': instance.note,
      'cover_path': instance.coverPath,
      'cover_style': _$CoverStyleEnumMap[instance.coverStyle]!,
      'base_servings': instance.baseServings,
      'total_minutes': instance.totalMinutes,
      'visibility': _$RecipeVisibilityEnumMap[instance.visibility]!,
      'status': _$RecipeStatusEnumMap[instance.status]!,
      'kcal_per_serving': instance.kcalPerServing,
      'protein_g': instance.proteinG,
      'carbs_g': instance.carbsG,
      'fat_g': instance.fatG,
      'fibre_g': instance.fibreG,
      'ingredient_count': instance.ingredientCount,
      'matched_lines': instance.matchedLines,
      'cost_cents': instance.costCents,
      'cost_currency': instance.costCurrency,
      'cost_per_plate': instance.costPerPlate,
      'like_count': instance.likeCount,
      'save_count': instance.saveCount,
      'cook_count': instance.cookCount,
      'forked_from_id': instance.forkedFromId,
      'published_at': instance.publishedAt?.toIso8601String(),
      'is_liked': instance.isLiked,
      'is_saved': instance.isSaved,
      'is_mine': instance.isMine,
    };
