// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
  id: (json['id'] as num).toInt(),
  slug: json['slug'] as String,
  label: json['label'] as String,
  kind: $enumDecode(_$TagKindEnumMap, json['kind']),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  coverStyle:
      $enumDecodeNullable(_$CoverStyleEnumMap, json['cover_style']) ??
      CoverStyle.any,
  position: (json['position'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'label': instance.label,
  'kind': _$TagKindEnumMap[instance.kind]!,
  'updated_at': instance.updatedAt.toIso8601String(),
  'cover_style': _$CoverStyleEnumMap[instance.coverStyle]!,
  'position': instance.position,
};

const _$TagKindEnumMap = {
  TagKind.cuisine: 'cuisine',
  TagKind.diet: 'diet',
  TagKind.meal: 'meal',
  TagKind.occasion: 'occasion',
};

const _$CoverStyleEnumMap = {
  CoverStyle.stew: 'stew',
  CoverStyle.meat: 'meat',
  CoverStyle.veg: 'veg',
  CoverStyle.sweet: 'sweet',
  CoverStyle.any: 'any',
};

_MeasureUnit _$MeasureUnitFromJson(Map<String, dynamic> json) => _MeasureUnit(
  code: json['code'] as String,
  label: json['label'] as String,
  kind: $enumDecode(_$UnitKindEnumMap, json['kind']),
  scope: $enumDecode(_$UnitScopeEnumMap, json['scope']),
  toBase: (json['to_base'] as num).toDouble(),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$MeasureUnitToJson(_MeasureUnit instance) =>
    <String, dynamic>{
      'code': instance.code,
      'label': instance.label,
      'kind': _$UnitKindEnumMap[instance.kind]!,
      'scope': _$UnitScopeEnumMap[instance.scope]!,
      'to_base': instance.toBase,
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$UnitKindEnumMap = {
  UnitKind.mass: 'mass',
  UnitKind.volume: 'volume',
  UnitKind.count: 'count',
};

const _$UnitScopeEnumMap = {
  UnitScope.metric: 'metric',
  UnitScope.imperial: 'imperial',
  UnitScope.both: 'both',
};

_Food _$FoodFromJson(Map<String, dynamic> json) => _Food(
  id: json['id'] as String,
  name: json['name'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  aliases:
      (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  category: json['category'] as String?,
  kcal100g: (json['kcal_100g'] as num?)?.toDouble() ?? 0,
  protein100g: (json['protein_100g'] as num?)?.toDouble() ?? 0,
  carbs100g: (json['carbs_100g'] as num?)?.toDouble() ?? 0,
  fat100g: (json['fat_100g'] as num?)?.toDouble() ?? 0,
  fibre100g: (json['fibre_100g'] as num?)?.toDouble() ?? 0,
  sugar100g: (json['sugar_100g'] as num?)?.toDouble(),
  sodiumMg100g: (json['sodium_mg_100g'] as num?)?.toDouble(),
  densityGMl: (json['density_g_ml'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FoodToJson(_Food instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'updated_at': instance.updatedAt.toIso8601String(),
  'aliases': instance.aliases,
  'category': instance.category,
  'kcal_100g': instance.kcal100g,
  'protein_100g': instance.protein100g,
  'carbs_100g': instance.carbs100g,
  'fat_100g': instance.fat100g,
  'fibre_100g': instance.fibre100g,
  'sugar_100g': instance.sugar100g,
  'sodium_mg_100g': instance.sodiumMg100g,
  'density_g_ml': instance.densityGMl,
};

_FoodPortion _$FoodPortionFromJson(Map<String, dynamic> json) => _FoodPortion(
  foodId: json['food_id'] as String,
  label: json['label'] as String,
  grams: (json['grams'] as num).toDouble(),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$FoodPortionToJson(_FoodPortion instance) =>
    <String, dynamic>{
      'food_id': instance.foodId,
      'label': instance.label,
      'grams': instance.grams,
      'updated_at': instance.updatedAt.toIso8601String(),
      'is_default': instance.isDefault,
    };
