// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) => RecipeModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  cost: (json['cost'] as num).toDouble(),
  serves: (json['serves'] as num).toInt(),
  createdBy: json['created_by'] as String,
  assetUrl: json['asset_url'] as String?,
);

Map<String, dynamic> _$RecipeModelToJson(RecipeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cost': instance.cost,
      'serves': instance.serves,
      'asset_url': instance.assetUrl,
      'created_by': instance.createdBy,
    };

RecipeDetailModel _$RecipeDetailModelFromJson(Map<String, dynamic> json) =>
    RecipeDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      cost: (json['cost'] as num).toDouble(),
      serves: (json['serves'] as num).toInt(),
      createdBy: json['created_by'] as String,
      assetUrl: json['asset_url'] as String?,
    );

Map<String, dynamic> _$RecipeDetailModelToJson(RecipeDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cost': instance.cost,
      'serves': instance.serves,
      'asset_url': instance.assetUrl,
      'created_by': instance.createdBy,
    };
