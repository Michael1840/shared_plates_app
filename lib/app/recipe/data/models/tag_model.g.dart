// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagModel _$TagModelFromJson(Map<String, dynamic> json) =>
    TagModel(name: json['name'] as String, tagType: json['tag_type'] as String);

Map<String, dynamic> _$TagModelToJson(TagModel instance) => <String, dynamic>{
  'name': instance.name,
  'tag_type': instance.tagType,
};

TagGroup _$TagGroupFromJson(Map<String, dynamic> json) => TagGroup(
  count: (json['total'] as num).toInt(),
  tags: (json['latest'] as List<dynamic>)
      .map((e) => TagModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TagGroupToJson(TagGroup instance) => <String, dynamic>{
  'total': instance.count,
  'latest': instance.tags,
};
