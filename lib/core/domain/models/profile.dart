import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_plates_app/core/domain/enums.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory({
    required String id,
    required String username,
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? avatarPath,
    String? bio,
    String? city,
    @Default(UnitSystem.metric) UnitSystem units,
    @Default('ZAR') String currency,
    @Default(RecipeVisibility.friends) RecipeVisibility defaultVisibility,
    @Default(true) bool keepScreenOn,
    @Default(true) bool notifySaves,
    @Default(true) bool notifyCooks,
    @Default(true) bool notifyFriends,
    @Default(true) bool weeklyRoundup,
    DateTime? onboardedAt,
  }) = _Profile;

  factory fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
