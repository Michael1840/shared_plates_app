import 'package:json_annotation/json_annotation.dart';

part 'step_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StepModel {
  final int index;
  final String name;

  const StepModel({required this.index, required this.name});

  factory StepModel.fromJson(Map<String, dynamic> json) =>
      _$StepModelFromJson(json);
}
