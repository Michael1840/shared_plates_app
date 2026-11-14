import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';

class FoodMatch extends Equatable {
  const new(this.food, this.score);

  final Food food;
  final double score;

  @override
  List<Object?> get props => [food.id, score];
}

class FoodLibrary {
  new({
    List<Food> foods = const [],
    List<FoodPortion> portions = const [],
    this.units = Measure.defaults,
  }) : foods = {for (final f in foods) f.id: f},
       _portions = _group(portions),
       _candidates = [
         for (final f in foods)
           for (final c in [f.name, ...f.aliases])
             if (_tokens(c).isNotEmpty) (f, _tokens(c)),
       ];

  static const matchAt = 0.6;
  static const suggestAt = 0.5;

  final Map<String, Food> foods;
  final Map<String, UnitDef> units;
  final Map<String, List<FoodPortion>> _portions;
  final List<(Food, List<String>)> _candidates;

  bool get isEmpty => foods.isEmpty;

  static Map<String, List<FoodPortion>> _group(List<FoodPortion> portions) {
    final out = <String, List<FoodPortion>>{};
    for (final p in portions) {
      out.putIfAbsent(p.foodId, () => []).add(p);
    }
    return out;
  }

  static String _stem(String w) => w.replaceFirstMapped(
    RegExp(r'(oes|es|s)$'),
    (m) => m[0] == 'oes' ? 'o' : '',
  );

  static List<String> _tokens(String text) => [
    for (final w in text.toLowerCase().split(RegExp('[^a-zà-ÿ]+')))
      if (w.length >= 2) _stem(w),
  ];

  FoodMatch? _best(String name) {
    final words = _tokens(name).toSet();
    if (words.isEmpty) return null;
    FoodMatch? best;
    var bestTokens = 0;
    for (final (food, tokens) in _candidates) {
      final hits = tokens.where(words.contains).length;
      if (hits == 0) continue;
      final score = hits / tokens.length;
      final better =
          best == null ||
          score > best.score ||
          (score == best.score &&
              (hits > bestTokens ||
                  (hits == bestTokens &&
                      food.name.length > best.food.name.length)));
      if (better) {
        best = FoodMatch(food, score);
        bestTokens = hits;
      }
    }
    return best;
  }

  FoodMatch? match(String name) {
    final best = _best(name);
    return best != null && best.score >= matchAt ? best : null;
  }

  FoodMatch? suggest(String name) {
    final best = _best(name);
    return best != null && best.score >= suggestAt && best.score < matchAt
        ? best
        : null;
  }

  double? gramsFor({
    required String? foodId,
    required double? quantity,
    required String? unit,
    required String? portion,
  }) {
    final food = foodId == null ? null : foods[foodId];
    final q = quantity;
    if (food == null || q == null) return null;
    final def = unit == null ? null : units[unit];
    if (def != null && def.kind == UnitKind.mass) return q * def.toBase;
    if (def != null && def.kind == UnitKind.volume) {
      return q * def.toBase * (food.densityGMl ?? 1);
    }
    final options = _portions[food.id] ?? const <FoodPortion>[];
    final wanted = portion ?? unit;
    FoodPortion? pick;
    for (final p in options) {
      if (p.label == wanted) {
        pick = p;
        break;
      }
      if (portion == null && (unit == null || unit == 'each') && p.isDefault) {
        pick ??= p;
      }
    }
    return pick == null ? null : q * pick.grams;
  }

  double? defaultPortionGrams(String foodId) {
    for (final p in _portions[foodId] ?? const <FoodPortion>[]) {
      if (p.isDefault) return p.grams;
    }
    return null;
  }
}
