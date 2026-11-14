import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_plates_app/core/domain/enums.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

@freezed
abstract class RecipeCollection with _$RecipeCollection {
  const factory({
    required String id,
    required String slug,
    required String title,
    required CollectionKind kind,
    String? subtitle,
    @Default(<String, dynamic>{}) Map<String, dynamic> filter,
    @Default(0) int position,
    DateTime? startsOn,
    DateTime? endsOn,
  }) = _RecipeCollection;

  const new _();

  factory fromJson(Map<String, dynamic> json) =>
      _$RecipeCollectionFromJson(json);

  bool isLiveOn(DateTime day) {
    final start = startsOn;
    final end = endsOn;
    return (start == null || !day.isBefore(start)) &&
        (end == null || !day.isAfter(end));
  }
}
