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
  isLiked: json['is_liked'] as bool? ?? false,
  image: json['image'] as String?,
);

Map<String, dynamic> _$RecipeModelToJson(RecipeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cost': instance.cost,
      'serves': instance.serves,
      'image': instance.image,
      'is_liked': instance.isLiked,
      'created_by': instance.createdBy,
    };

RecipeDetailModel _$RecipeDetailModelFromJson(Map<String, dynamic> json) =>
    RecipeDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      cost: (json['cost'] as num).toDouble(),
      serves: (json['serves'] as num).toInt(),
      createdBy: json['created_by'] as String,
      isLiked: json['is_liked'] as bool? ?? false,
      image: json['image'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => StepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      privacyStatus:
          $enumDecodeNullable(_$PrivacyStatusEnumMap, json['privacy_status']) ??
          PrivacyStatus.public,
    );

Map<String, dynamic> _$RecipeDetailModelToJson(RecipeDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cost': instance.cost,
      'serves': instance.serves,
      'image': instance.image,
      'is_liked': instance.isLiked,
      'created_by': instance.createdBy,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'tags': instance.tags,
      'privacy_status': _$PrivacyStatusEnumMap[instance.privacyStatus]!,
    };

const _$PrivacyStatusEnumMap = {
  PrivacyStatus.public: '1',
  PrivacyStatus.friends: '2',
  PrivacyStatus.private: '3',
};
