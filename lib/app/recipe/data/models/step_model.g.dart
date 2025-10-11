// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepModel _$StepModelFromJson(Map<String, dynamic> json) => StepModel(
  stepIndex: (json['step_index'] as num).toInt(),
  stepDescription: json['step_description'] as String,
);

Map<String, dynamic> _$StepModelToJson(StepModel instance) => <String, dynamic>{
  'step_index': instance.stepIndex,
  'step_description': instance.stepDescription,
};
