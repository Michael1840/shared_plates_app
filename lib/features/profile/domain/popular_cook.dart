import 'package:freezed_annotation/freezed_annotation.dart';

part 'popular_cook.freezed.dart';
part 'popular_cook.g.dart';

@freezed
abstract class PopularCook with _$PopularCook {
  const factory PopularCook({
    required String id,
    required String username,
    required String displayName,
    String? avatarPath,
    @Default(0) int recipes,
    @Default(0) int saves,
  }) = _PopularCook;

  const PopularCook._();

  factory PopularCook.fromJson(Map<String, dynamic> json) =>
      _$PopularCookFromJson(json);

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    final letters = [
      for (final p in parts.take(2))
        if (p.isNotEmpty) p[0],
    ].join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }
}
