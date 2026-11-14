// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeCollection _$RecipeCollectionFromJson(Map<String, dynamic> json) =>
    _RecipeCollection(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      kind: $enumDecode(_$CollectionKindEnumMap, json['kind']),
      subtitle: json['subtitle'] as String?,
      filter:
          json['filter'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      position: (json['position'] as num?)?.toInt() ?? 0,
      startsOn: json['starts_on'] == null
          ? null
          : DateTime.parse(json['starts_on'] as String),
      endsOn: json['ends_on'] == null
          ? null
          : DateTime.parse(json['ends_on'] as String),
    );

Map<String, dynamic> _$RecipeCollectionToJson(_RecipeCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'kind': _$CollectionKindEnumMap[instance.kind]!,
      'subtitle': instance.subtitle,
      'filter': instance.filter,
      'position': instance.position,
      'starts_on': instance.startsOn?.toIso8601String(),
      'ends_on': instance.endsOn?.toIso8601String(),
    };

const _$CollectionKindEnumMap = {
  CollectionKind.mood: 'mood',
  CollectionKind.weekly: 'weekly',
};
