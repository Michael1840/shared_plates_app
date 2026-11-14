import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';

extension CardText on RecipeCard {
  String get byline {
    if (isMine) return 'Your recipe';
    final name = Formatters.shortName(authorName);
    return name.isEmpty ? '@${authorUsername ?? 'cook'}' : name;
  }

  String? get plateLabel {
    final cents = costPerPlate;
    return cents == null ? null : '${Formatters.rands(cents)} each';
  }

  String? get minutesLabel {
    final m = totalMinutes;
    return m == null ? null : Formatters.minutes(m);
  }

  String get likesLabel => Formatters.compact(likeCount);

  String get shelfBadge {
    final plate = costPerPlate;
    if (plate != null) return '${Formatters.rands(plate)} a plate';
    final m = totalMinutes;
    return m == null ? '${Formatters.compact(likeCount)} likes' : '$m min';
  }

  String get shelfMeta {
    final saves = saveCount > 0
        ? 'saved ${Formatters.compact(saveCount)}'
        : '${Formatters.compact(likeCount)} likes';
    return '$byline · $saves';
  }

  double get tilt {
    final h = id.hashCode % 7;
    return (h - 3) * 0.6;
  }
}
