import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_plates_app/core/domain/enums.dart';

part 'reference.freezed.dart';
part 'reference.g.dart';

@freezed
abstract class Tag with _$Tag {
  const factory({
    required int id,
    required String slug,
    required String label,
    required TagKind kind,
    required DateTime updatedAt,
    @Default(CoverStyle.any) CoverStyle coverStyle,
    @Default(0) int position,
  }) = _Tag;

  factory fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

@freezed
abstract class MeasureUnit with _$MeasureUnit {
  const factory({
    required String code,
    required String label,
    required UnitKind kind,
    required UnitScope scope,
    required double toBase,
    required DateTime updatedAt,
  }) = _MeasureUnit;

  factory fromJson(Map<String, dynamic> json) => _$MeasureUnitFromJson(json);
}

@freezed
abstract class Food with _$Food {
  const factory({
    required String id,
    required String name,
    required DateTime updatedAt,
    @Default(<String>[]) List<String> aliases,
    String? category,
    @JsonKey(name: 'kcal_100g') @Default(0) double kcal100g,
    @JsonKey(name: 'protein_100g') @Default(0) double protein100g,
    @JsonKey(name: 'carbs_100g') @Default(0) double carbs100g,
    @JsonKey(name: 'fat_100g') @Default(0) double fat100g,
    @JsonKey(name: 'fibre_100g') @Default(0) double fibre100g,
    @JsonKey(name: 'sugar_100g') double? sugar100g,
    @JsonKey(name: 'sodium_mg_100g') double? sodiumMg100g,
    double? densityGMl,
  }) = _Food;

  factory fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
}

@freezed
abstract class FoodPortion with _$FoodPortion {
  const factory({
    required String foodId,
    required String label,
    required double grams,
    required DateTime updatedAt,
    @Default(false) bool isDefault,
  }) = _FoodPortion;

  factory fromJson(Map<String, dynamic> json) => _$FoodPortionFromJson(json);
}
