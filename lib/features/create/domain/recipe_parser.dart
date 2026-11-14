import 'package:equatable/equatable.dart';

class ParsedIngredient extends Equatable {
  const new({
    required this.rawText,
    required this.name,
    this.quantity,
    this.unit,
    this.portionLabel,
    this.prepNote,
    this.section,
  });

  final String rawText;
  final double? quantity;
  final String? unit;
  final String? portionLabel;
  final String name;
  final String? prepNote;
  final String? section;

  @override
  List<Object?> get props => [
    rawText,
    quantity,
    unit,
    portionLabel,
    name,
    prepNote,
    section,
  ];
}

class ParsedStep extends Equatable {
  const new({required this.body, this.timerSeconds});

  final String body;
  final int? timerSeconds;

  @override
  List<Object?> get props => [body, timerSeconds];
}

class ParsedRecipe extends Equatable {
  const new({
    this.title,
    this.servings,
    this.totalMinutes,
    this.ingredients = const [],
    this.steps = const [],
  });

  final String? title;
  final int? servings;
  final int? totalMinutes;
  final List<ParsedIngredient> ingredients;
  final List<ParsedStep> steps;

  @override
  List<Object?> get props => [
    title,
    servings,
    totalMinutes,
    ingredients,
    steps,
  ];
}

enum LineKind { title, serves, time, heading, section, ingredient, step, skip }

class ParsedLine extends Equatable {
  const new({
    required this.index,
    required this.text,
    required this.kind,
    this.unsure = false,
  });

  final int index;
  final String text;
  final LineKind kind;
  final bool unsure;

  ParsedLine as(LineKind next) =>
      ParsedLine(index: index, text: text, kind: next, unsure: unsure);

  @override
  List<Object?> get props => [index, text, kind, unsure];
}

abstract final class RecipeParser {
  static const Map<String, double> _fractions = {
    '½': 0.5,
    '⅓': 1 / 3,
    '⅔': 2 / 3,
    '¼': 0.25,
    '¾': 0.75,
    '⅕': 0.2,
    '⅛': 0.125,
    '⅜': 0.375,
    '⅝': 0.625,
    '⅞': 0.875,
  };

  static const _fractionChars = '½⅓⅔¼¾⅕⅛⅜⅝⅞';

  static final _unitAliases = <(RegExp, String)>[
    (RegExp(r'^(kg|kgs|kilo|kilos|kilogram|kilograms)$'), 'kg'),
    (RegExp(r'^(g|gr|gram|grams|gramme|grammes)$'), 'g'),
    (RegExp(r'^(ml|millilitre|millilitres|milliliter|milliliters)$'), 'ml'),
    (RegExp(r'^(l|litre|litres|liter|liters)$'), 'l'),
    (RegExp(r'^(tsp|tsps|teaspoon|teaspoons|t)$'), 'tsp'),
    (RegExp(r'^(tbsp|tbsps|tbs|tablespoon|tablespoons|T)$'), 'tbsp'),
    (RegExp(r'^(cup|cups|c)$'), 'cup'),
    (RegExp(r'^(pinch|pinches)$'), 'pinch'),
    (RegExp(r'^(fl\.? ?oz)$'), 'fl_oz'),
    (RegExp(r'^(oz|ounce|ounces)$'), 'oz'),
    (RegExp(r'^(lb|lbs|pound|pounds)$'), 'lb'),
  ];

  static final _portions = <(RegExp, String)>[
    (RegExp(r'^(clove|cloves)$'), 'clove'),
    (RegExp(r'^(can|cans|tin|tins)$'), 'can'),
    (RegExp(r'^(bunch|bunches)$'), 'bunch'),
    (RegExp(r'^(slice|slices)$'), 'slice'),
    (RegExp(r'^(thumb|thumbs)$'), 'thumb'),
    (RegExp(r'^(medium)$'), 'medium'),
    (RegExp(r'^(large)$'), 'large'),
    (RegExp(r'^(small)$'), 'small'),
  ];

  static final _ingredientsHeading = RegExp(
    r"^(ingredients|you('|’)ll need|what you need|shopping list)\s*:?$",
    caseSensitive: false,
  );
  static final _methodHeading = RegExp(
    '^(method|instructions|directions|steps|preparation|how to make it|'
    r'to make)\s*:?$',
    caseSensitive: false,
  );

  static final _bullet = RegExp(
    r'^\s*(?:[-*•·–]|\d+[.)]|step\s*\d+[:.)]?)\s*',
    caseSensitive: false,
  );
  static final _startsWithAmount = RegExp(
    '^\\s*(?:[-*•·–]\\s*)?(?:\\d|[$_fractionChars]|a |an |one |two |three |'
    'pinch|handful)',
    caseSensitive: false,
  );
  static final _numbered = RegExp(
    r'^\s*(?:\d+[.)]|step\s*\d+)',
    caseSensitive: false,
  );

  static const _wordNumbers = {
    'a': 1.0,
    'an': 1.0,
    'one': 1.0,
    'two': 2.0,
    'three': 3.0,
    'four': 4.0,
    'five': 5.0,
    'six': 6.0,
    'half': 0.5,
  };

  static final _qty = RegExp(
    '^(\\d+(?:[.,]\\d+)?\\s+\\d+\\/\\d+|\\d+\\s*[$_fractionChars]|\\d+\\/\\d+|'
    '\\d+(?:[.,]\\d+)?|[$_fractionChars])'
    r'(?:\s*(?:-|–|to)\s*\d+(?:[.,]\d+)?)?',
  );
  static final _wordQty = RegExp(
    r'^(a|an|one|two|three|four|five|six|half)\b\s*',
    caseSensitive: false,
  );
  static final _unitWord = RegExp(
    r'^([A-Za-z]+\.?(?:\s?oz)?)\b\.?\s*(?:of\s+)?',
  );
  static final _container = RegExp(
    r'^(can|cans|tin|tins|packet|packets|pack)\s+(of\s+)?',
    caseSensitive: false,
  );

  static double? _number(String token) {
    final t = token.replaceFirst(',', '.').trim();
    if (t.isEmpty) return null;
    final fraction = _fractions[t];
    if (fraction != null) return fraction;
    final mixed = RegExp('^(\\d+)\\s*([$_fractionChars])\$').firstMatch(t);
    if (mixed != null) {
      return double.parse(mixed[1]!) + _fractions[mixed[2]!]!;
    }
    final frac = RegExp(r'^(\d+)\/(\d+)$').firstMatch(t);
    if (frac != null) {
      final d = double.parse(frac[2]!);
      return d == 0 ? null : double.parse(frac[1]!) / d;
    }
    return double.tryParse(t);
  }

  static ParsedIngredient parseIngredient(String rawLine, {String? section}) {
    final raw = rawLine
        .replaceFirst(_bullet, '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    var rest = raw;
    double? quantity;

    final qty = _qty.firstMatch(rest);
    if (qty != null) {
      final q = qty[1]!;
      final mixed = RegExp(r'^(\d+)\s+(\d+)\/(\d+)$').firstMatch(q);
      quantity = mixed != null
          ? double.parse(mixed[1]!) +
                double.parse(mixed[2]!) / double.parse(mixed[3]!)
          : _number(q.replaceAll(RegExp(r'\s+'), ''));
      rest = rest.substring(qty[0]!.length).trim();
    } else {
      final w = _wordQty.firstMatch(rest);
      if (w != null) {
        quantity = _wordNumbers[w[1]!.toLowerCase()];
        rest = rest.substring(w[0]!.length).trim();
      }
    }

    String? unit;
    String? portion;
    final unitMatch = _unitWord.firstMatch(rest);
    if (unitMatch != null) {
      final word = unitMatch[1]!.replaceFirst(RegExp(r'\.$'), '');
      final lower = word.toLowerCase();
      final exact =
          _firstWhere(_unitAliases, (re) => re.hasMatch(word)) ??
          (word == 'T' || word == 't'
              ? null
              : _firstWhere(_unitAliases, (re) => re.hasMatch(lower)));
      final pinch = lower.contains('pinch');
      if (exact != null && (quantity != null || pinch)) {
        unit = exact;
        if (unit == 'pinch' && quantity == null) quantity = 1;
        rest = rest.substring(unitMatch[0]!.length).trim();
      } else {
        final p = _firstWhere(_portions, (re) => re.hasMatch(lower));
        if (p != null && quantity != null) {
          portion = p;
          rest = rest.substring(unitMatch[0]!.length).trim();
        }
      }
    }

    final container = _container.firstMatch(rest);
    if (container != null) {
      if (unit == null && portion == null && quantity != null) portion = 'can';
      rest = rest.substring(container[0]!.length);
    }

    String? prep;
    final bracket = RegExp(r'\(([^)]*)\)').firstMatch(rest);
    if (bracket != null) {
      final inner = bracket[1]!.trim();
      prep = inner.isEmpty ? null : inner;
      rest = rest.replaceFirst(bracket[0]!, ' ').trim();
    }
    final comma = rest.indexOf(',');
    if (comma > 0) {
      final after = rest.substring(comma + 1).trim();
      final joined = [after, ?prep].where((s) => s.isNotEmpty).join(', ');
      prep = joined.isEmpty ? null : joined;
      rest = rest.substring(0, comma).trim();
    }
    rest = rest
        .replaceFirst(RegExp(r'^(of|x)\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return ParsedIngredient(
      rawText: raw,
      quantity: quantity,
      unit: unit,
      portionLabel: portion,
      name: rest.isEmpty ? raw : rest,
      prepNote: prep,
      section: section,
    );
  }

  static String? _firstWhere(
    List<(RegExp, String)> table,
    bool Function(RegExp) test,
  ) {
    for (final (re, value) in table) {
      if (test(re)) return value;
    }
    return null;
  }

  static final _timer = RegExp(
    r'(\d+(?:[.,]\d+)?)\s*(?:-|–|to)?\s*(?:\d+\s*)?'
    r'(hours?|hrs?|h|minutes?|mins?|m)\b',
    caseSensitive: false,
  );

  static int? findTimerSeconds(String text) {
    final m = _timer.firstMatch(text);
    if (m == null) return null;
    final n = double.parse(m[1]!.replaceFirst(',', '.'));
    final isHour = m[2]!.toLowerCase().startsWith('h');
    final secs = (n * (isHour ? 3600 : 60)).round();
    return secs > 0 && secs <= 86400 ? secs : null;
  }

  static bool _looksLikeIngredient(String line) {
    if (line.length > 90) return false;
    if (_startsWithAmount.hasMatch(line)) return true;
    return RegExp(r'^\s*[-*•·–]\s*').hasMatch(line) &&
        line.length < 60 &&
        !RegExp(r'[.!?]$').hasMatch(line.trim());
  }

  static bool _looksLikeStep(String line) =>
      _numbered.hasMatch(line) ||
      line.length > 60 ||
      RegExp(r'[.!?]$').hasMatch(line.trim());

  static final _serves = RegExp(
    r'^(?:serves|feeds|makes|servings|yield)\s*:?\s*(\d+)',
    caseSensitive: false,
  );
  static final _time = RegExp(
    r'^(?:total time|time|takes|ready in|cook time)\s*:?\s*(.+)$',
    caseSensitive: false,
  );
  static final _sectionLine = RegExp(
    r'^(for the .+|.+:)$',
    caseSensitive: false,
  );

  static List<String> _lines(String text) => [
    for (final l in text.replaceAll('\r', '').split('\n'))
      if (l.trim().isNotEmpty) l.trim(),
  ];

  static List<ParsedLine> classify(String text) {
    final lines = _lines(text);
    final out = <ParsedLine>[];
    var mode = 'unknown';
    var explicitIngredients = false;
    for (final (i, line) in lines.indexed) {
      ParsedLine as(LineKind kind) =>
          ParsedLine(index: i, text: line, kind: kind);

      if (_ingredientsHeading.hasMatch(line)) {
        mode = 'ingredients';
        explicitIngredients = true;
        out.add(as(LineKind.heading));
        continue;
      }
      if (_methodHeading.hasMatch(line)) {
        mode = 'method';
        out.add(as(LineKind.heading));
        continue;
      }
      if (_serves.hasMatch(line)) {
        out.add(as(LineKind.serves));
        continue;
      }
      final time = _time.firstMatch(line);
      if (time != null && findTimerSeconds(time[1]!) != null) {
        out.add(as(LineKind.time));
        continue;
      }
      if (i == 0 && !_looksLikeIngredient(line) && line.length <= 120) {
        out.add(as(LineKind.title));
        continue;
      }
      if (mode != 'method' &&
          _sectionLine.hasMatch(line) &&
          line.length < 40 &&
          !_startsWithAmount.hasMatch(line)) {
        if (mode == 'unknown') mode = 'ingredients';
        out.add(as(LineKind.section));
        continue;
      }
      final asIngredient =
          mode == 'ingredients' ||
          (mode == 'unknown' &&
              _looksLikeIngredient(line) &&
              !_looksLikeStep(line));
      final tooLongForIngredient =
          mode == 'ingredients' &&
          _looksLikeStep(line) &&
          !_looksLikeIngredient(line) &&
          line.length > 90;
      if (asIngredient && !tooLongForIngredient) {
        final wordy =
            explicitIngredients &&
            !_looksLikeIngredient(line) &&
            line.split(RegExp(r'\s+')).length >= 6;
        out.add(
          ParsedLine(
            index: i,
            text: line,
            kind: LineKind.ingredient,
            unsure: wordy,
          ),
        );
      } else {
        if (line.replaceFirst(_bullet, '').trim().isNotEmpty) {
          out.add(as(LineKind.step));
        }
        if (mode == 'unknown') mode = 'method';
      }
    }
    final numbered = out
        .where((l) => l.kind == LineKind.step && _numbered.hasMatch(l.text))
        .length;
    if (numbered < 2) return out;
    return [
      for (final l in out)
        if (l.kind == LineKind.step && !_numbered.hasMatch(l.text))
          ParsedLine(index: l.index, text: l.text, kind: l.kind, unsure: true)
        else
          l,
    ];
  }

  static ParsedRecipe assemble(Iterable<ParsedLine> lines) {
    String? title;
    int? servings;
    int? totalMinutes;
    String? section;
    final ingredients = <ParsedIngredient>[];
    final steps = <ParsedStep>[];
    for (final line in lines) {
      switch (line.kind) {
        case LineKind.skip:
          continue;
        case LineKind.heading:
          section = null;
        case LineKind.title:
          title ??= line.text.replaceFirst(RegExp(r'^#+\s*'), '');
        case LineKind.serves:
          final n = RegExp(r'\d+').firstMatch(line.text);
          if (n != null) servings ??= int.parse(n[0]!);
        case LineKind.time:
          final s = findTimerSeconds(line.text);
          if (s != null) totalMinutes ??= (s / 60).round();
        case LineKind.section:
          section = line.text
              .replaceFirst(RegExp(r':$'), '')
              .replaceFirst(
                RegExp(r'^for the\s+', caseSensitive: false),
                'For the ',
              )
              .trim();
        case LineKind.ingredient:
          ingredients.add(parseIngredient(line.text, section: section));
        case LineKind.step:
          final body = line.text.replaceFirst(_bullet, '').trim();
          if (body.isNotEmpty) {
            steps.add(
              ParsedStep(body: body, timerSeconds: findTimerSeconds(body)),
            );
          }
      }
    }
    return ParsedRecipe(
      title: title,
      servings: servings,
      totalMinutes: totalMinutes,
      ingredients: ingredients,
      steps: steps,
    );
  }

  static ParsedRecipe parse(String text) => assemble(classify(text));

  static const _descriptors = {
    'chopped',
    'sliced',
    'diced',
    'grated',
    'crushed',
    'minced',
    'fresh',
    'dried',
    'ground',
    'whole',
    'large',
    'small',
    'medium',
    'bone',
    'boneless',
    'skinless',
    'canned',
    'tinned',
    'frozen',
    'cooked',
    'uncooked',
    'raw',
    'fine',
    'finely',
    'roughly',
    'peeled',
    'the',
    'and',
    'with',
    'for',
    'into',
    'cape',
    'malay',
    'full',
    'cream',
    'white',
    'brown',
    'red',
    'green',
  };

  static String _stem(String w) => w.replaceFirstMapped(
    RegExp(r'(oes|es|s)$'),
    (m) => m[0] == 'oes' ? 'o' : '',
  );

  static List<List<int>> linkSteps(
    List<String> steps,
    List<List<String>> names,
  ) {
    final words = [
      for (final candidates in names)
        {
          for (final c in candidates)
            for (final w in c.toLowerCase().split(RegExp('[^a-zà-ÿ]+')))
              if (w.length >= 3 && !_descriptors.contains(w)) _stem(w),
        }.where((w) => w.length >= 3).toList(),
    ];
    return [
      for (final step in steps)
        [
          for (final (i, ws) in words.indexed)
            if (ws.any(
              (w) =>
                  RegExp('\\b${RegExp.escape(w)}').hasMatch(step.toLowerCase()),
            ))
              i,
        ],
    ];
  }
}
