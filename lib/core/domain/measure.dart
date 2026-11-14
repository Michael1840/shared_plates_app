import 'package:shared_plates_app/core/domain/enums.dart';

class UnitDef {
  const new(this.code, this.kind, this.scope, this.toBase);

  final String code;
  final UnitKind kind;
  final UnitScope scope;
  final double toBase;
}

abstract final class Measure {
  static const defaults = <String, UnitDef>{
    'g': UnitDef('g', UnitKind.mass, UnitScope.metric, 1),
    'kg': UnitDef('kg', UnitKind.mass, UnitScope.metric, 1000),
    'ml': UnitDef('ml', UnitKind.volume, UnitScope.metric, 1),
    'l': UnitDef('l', UnitKind.volume, UnitScope.metric, 1000),
    'tsp': UnitDef('tsp', UnitKind.volume, UnitScope.both, 5),
    'tbsp': UnitDef('tbsp', UnitKind.volume, UnitScope.both, 15),
    'cup': UnitDef('cup', UnitKind.volume, UnitScope.both, 250),
    'pinch': UnitDef('pinch', UnitKind.volume, UnitScope.both, 0.3),
    'fl_oz': UnitDef('fl_oz', UnitKind.volume, UnitScope.imperial, 29.574),
    'oz': UnitDef('oz', UnitKind.mass, UnitScope.imperial, 28.35),
    'lb': UnitDef('lb', UnitKind.mass, UnitScope.imperial, 453.592),
    'each': UnitDef('each', UnitKind.count, UnitScope.both, 1),
  };

  static const _gramsPerOz = 28.35;
  static const _mlPerCup = 250.0;
  static const _mlPerTbsp = 15.0;

  static const _marks = <(double, String)>[
    (0, ''),
    (0.125, '⅛'),
    (0.25, '¼'),
    (1 / 3, '⅓'),
    (0.5, '½'),
    (2 / 3, '⅔'),
    (0.75, '¾'),
    (1, ''),
  ];

  static String fraction(double value) {
    if (value <= 0) return '0';
    final whole = value.floor();
    final rest = value - whole;
    var best = _marks.first;
    for (final mark in _marks) {
      if ((rest - mark.$1).abs() < (rest - best.$1).abs()) best = mark;
    }
    final w = whole + (best.$1 == 1 ? 1 : 0);
    final text = '${w > 0 ? w : ''}${best.$2}';
    return text.isEmpty ? '⅛' : text;
  }

  static String decimal(double value) {
    final rounded = (value * 10).round() / 10;
    return rounded == rounded.roundToDouble()
        ? rounded.round().toString()
        : rounded.toString();
  }

  static String? format({
    required double? quantity,
    required String? unit,
    required double scale,
    required UnitSystem system,
    Map<String, UnitDef> units = defaults,
  }) {
    final q = quantity;
    if (q == null || q <= 0) return null;
    final v = q * scale;
    final def = unit == null ? null : units[unit] ?? defaults[unit];
    if (def == null || def.kind == UnitKind.count) {
      return unit == null || def != null
          ? fraction(_quarters(v))
          : '${fraction(_quarters(v))} $unit';
    }
    if (def.scope == UnitScope.both) {
      final n = _quarters(v);
      return '${fraction(n)} ${_plural(def.code, n)}';
    }
    final base = v * def.toBase;
    return def.kind == UnitKind.mass
        ? _mass(base, system)
        : _volume(base, system);
  }

  static double _quarters(double v) {
    final q = (v * 4).round() / 4;
    return q == 0 ? 0.125 : q;
  }

  static String _plural(String code, double n) {
    if (n <= 1) return code;
    return switch (code) {
      'cup' => 'cups',
      'pinch' => 'pinches',
      _ => code,
    };
  }

  static String _mass(double grams, UnitSystem system) {
    if (system == UnitSystem.metric) {
      if (grams >= 1000) return '${decimal(grams / 1000)} kg';
      if (grams > 50) return '${(grams / 5).round() * 5} g';
      if (grams >= 10) return '${grams.round()} g';
      return '${decimal(grams)} g';
    }
    final oz = grams / _gramsPerOz;
    if (oz >= 16) return '${decimal(oz / 16)} lb';
    final halves = (oz * 2).round() / 2;
    return '${fraction(halves < 0.25 ? 0.25 : halves)} oz';
  }

  static String _volume(double ml, UnitSystem system) {
    if (system == UnitSystem.metric) {
      if (ml >= 1000) return '${decimal(ml / 1000)} l';
      if (ml > 50) return '${(ml / 5).round() * 5} ml';
      return '${ml.round()} ml';
    }
    final cups = ml / _mlPerCup;
    if (cups >= 0.25) {
      final c = (cups * 4).round() / 4;
      return '${fraction(c)} ${c > 1 ? 'cups' : 'cup'}';
    }
    final tbsp = (ml / _mlPerTbsp * 4).round() / 4;
    return '${fraction(tbsp < 0.25 ? 0.25 : tbsp)} tbsp';
  }

  static final _leadingAmount = RegExp(
    r'^\s*(?:\d+\s+\d+/\d+|\d+/\d+|\d+(?:[.,]\d+)?[¼½¾⅓⅔⅛]?|[¼½¾⅓⅔⅛])'
    r'(?:\s*(?:-|–|to)\s*(?:\d+(?:[.,]\d+)?|[¼½¾⅓⅔⅛]))?\s*',
  );

  static final _leadingUnit = RegExp(
    r'^(?:fl\.?\s*oz|kilograms?|kg|grams?|g|millilit(?:re|er)s?|ml|'
    'lit(?:re|er)s?|l|teaspoons?|tsp|tablespoons?|tbsp|cups?|pinch(?:es)?|'
    r'ounces?|oz|pounds?|lbs?)\b\.?\s*(?:of\s+)?',
    caseSensitive: false,
  );

  static String nameFrom(String rawText) {
    final afterAmount = rawText.replaceFirst(_leadingAmount, '');
    if (afterAmount.length == rawText.length) return rawText.trim();
    final name = afterAmount.replaceFirst(_leadingUnit, '').trim();
    return name.isEmpty ? rawText.trim() : name;
  }

  static int? scaledCents(int? cents, double scale) =>
      cents == null ? null : (cents * scale).round();
}
