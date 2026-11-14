import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/features/create/domain/recipe_parser.dart';

List<Object?> _pick(String line) {
  final p = RecipeParser.parseIngredient(line);
  return [p.quantity, p.unit, p.portionLabel, p.name, p.prepNote];
}

const _paste = '''
Cape Malay chicken curry
Serves 4
Takes 55 min

Ingredients
1 kg bone-in chicken thighs
2 onions, sliced
4 garlic cloves, crushed
2 tbsp Cape Malay curry powder
1 can (400 g) chopped tomatoes
For the rice:
2 cups basmati rice

Method
1. Heat the oil and fry the onions for 8 minutes until golden.
2. Add the garlic and curry powder and fry for 1 min.
3. Add the chicken and tomatoes, cover and simmer for 40 minutes.
4. Serve with the rice.''';

void main() {
  group('parseIngredient', () {
    final cases = <String, (String, List<Object?>)>{
      'kg': (
        '1 kg bone-in chicken thighs',
        [1, 'kg', null, 'bone-in chicken thighs', null],
      ),
      'glued grams': (
        '400g chopped tomatoes',
        [400, 'g', null, 'chopped tomatoes', null],
      ),
      'count + prep': ('2 onions, sliced', [2, null, null, 'onions', 'sliced']),
      'cloves': (
        '4 garlic cloves, crushed',
        [4, null, null, 'garlic cloves', 'crushed'],
      ),
      'portion first': ('4 cloves garlic', [4, null, 'clove', 'garlic', null]),
      'unicode fraction': (
        '½ tsp ground turmeric',
        [0.5, 'tsp', null, 'ground turmeric', null],
      ),
      'mixed fraction': (
        '1 1/2 cups cake flour',
        [1.5, 'cup', null, 'cake flour', null],
      ),
      'mixed unicode': ('1½ tbsp sugar', [1.5, 'tbsp', null, 'sugar', null]),
      'comma decimal': (
        '1,5 l chicken stock',
        [1.5, 'l', null, 'chicken stock', null],
      ),
      'range': (
        '2-3 tbsp curry powder',
        [2, 'tbsp', null, 'curry powder', null],
      ),
      'can': (
        '1 can (400 g) chopped tomatoes',
        [1, null, 'can', 'chopped tomatoes', '400 g'],
      ),
      'pinch': ('pinch of salt', [1, 'pinch', null, 'salt', null]),
      'word number': ('two eggs', [2, null, null, 'eggs', null]),
      'bullet': ('- 250 ml cream', [250, 'ml', null, 'cream', null]),
      'no quantity': (
        'Salt and pepper to taste',
        [null, null, null, 'Salt and pepper to taste', null],
      ),
      'capital T is a tablespoon': (
        '1 T butter',
        [1, 'tbsp', null, 'butter', null],
      ),
    };
    for (final MapEntry(key: label, value: (line, want)) in cases.entries) {
      test(label, () => expect(_pick(line), want));
    }
  });

  group('parse', () {
    final r = RecipeParser.parse(_paste);

    test('reads the header lines', () {
      expect(r.title, 'Cape Malay chicken curry');
      expect(r.servings, 4);
      expect(r.totalMinutes, 55);
    });

    test('splits ingredients with sections', () {
      expect(r.ingredients, hasLength(6));
      expect(r.ingredients[5].section, 'For the rice');
      expect(r.ingredients[0].section, isNull);
    });

    test('cleans steps and finds timers', () {
      expect(r.steps, hasLength(4));
      expect(r.steps.map((s) => s.timerSeconds), [480, 60, 2400, null]);
      expect(r.steps.first.body, startsWith('Heat'));
    });

    test('links steps to the ingredients they mention', () {
      final links = RecipeParser.linkSteps(
        [for (final s in r.steps) s.body],
        [
          for (final i in r.ingredients) [i.name],
        ],
      );
      expect(links, [
        [1],
        [2, 3],
        [0, 4],
        [5],
      ]);
    });

    test('works without headings', () {
      final quick = RecipeParser.parse('''
Quick chakalaka
- 1 onion, chopped
- 2 carrots, grated
- 1 can baked beans
Fry the onion until soft.
Add the carrots and beans and simmer for 10 minutes.''');

      expect(quick.ingredients.map((i) => i.name), [
        'onion',
        'carrots',
        'baked beans',
      ]);
      expect(quick.steps, hasLength(2));
    });
  });

  group('classify', () {
    test('labels every line for review', () {
      final lines = RecipeParser.classify(_paste);
      final kinds = lines.map((l) => l.kind).toList();

      expect(kinds.first, LineKind.title);
      expect(kinds.where((k) => k == LineKind.ingredient), hasLength(6));
      expect(kinds.where((k) => k == LineKind.step), hasLength(4));
      expect(lines.where((l) => l.unsure), isEmpty);
    });

    test('flags a stray note among numbered steps', () {
      final lines = RecipeParser.classify('''
Gran's chakalaka
Method
1. Fry the onion until soft.
2. Add the beans and simmer for 10 min.
Mom always adds a spoon of chutney at the end''');

      final unsure = lines.where((l) => l.unsure).single;
      expect(unsure.text, startsWith('Mom always'));
      expect(unsure.kind, LineKind.step);
    });

    test('relabelled lines rebuild the recipe', () {
      final lines = RecipeParser.classify(_paste);
      final relabelled = [
        for (final l in lines)
          if (l.text.startsWith('4. Serve')) l.as(LineKind.ingredient) else l,
      ];

      final r = RecipeParser.assemble(relabelled);
      expect(r.steps, hasLength(3));
      expect(r.ingredients.last.rawText, 'Serve with the rice.');
    });
  });
}
