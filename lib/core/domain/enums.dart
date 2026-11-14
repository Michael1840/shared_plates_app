import 'package:json_annotation/json_annotation.dart';

enum UnitSystem { metric, imperial }

enum RecipeVisibility { private, friends, public }

enum FriendshipStatus { pending, accepted }

enum CoverStyle {
  stew,
  meat,
  veg,
  sweet,
  any;

  String get asset => 'assets/covers/$name.svg';
}

enum RecipeStatus { draft, published }

enum RecipeSource { typed, pasted }

enum TagKind { cuisine, diet, meal, occasion }

enum UnitKind { mass, volume, count }

enum UnitScope { metric, imperial, both }

enum NotificationKind {
  @JsonValue('recipe_saved')
  recipeSaved,
  @JsonValue('recipe_cooked')
  recipeCooked,
  @JsonValue('friend_request')
  friendRequest,
  @JsonValue('friend_accepted')
  friendAccepted,
  @JsonValue('weekly_roundup')
  weeklyRoundup,
}

enum CollectionKind { mood, weekly }

T enumByName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}
