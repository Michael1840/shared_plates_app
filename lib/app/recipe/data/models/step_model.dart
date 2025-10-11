import 'package:json_annotation/json_annotation.dart';

part 'step_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StepModel {
  final int stepIndex;
  final String stepDescription;

  const StepModel({required this.stepIndex, required this.stepDescription});

  factory StepModel.fromJson(Map<String, dynamic> json) =>
      _$StepModelFromJson(json);
}
