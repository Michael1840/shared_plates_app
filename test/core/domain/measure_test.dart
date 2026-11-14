import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/measure.dart';

String? fmt(
  double? q,
  String? unit, {
  double scale = 1,
  UnitSystem system = UnitSystem.metric,
}) => Measure.format(quantity: q, unit: unit, scale: scale, system: system);

void main() {
  group('fraction', () {
    test('rounds to friendly kitchen fractions', () {
      expect(Measure.fraction(0.5), '½');
      expect(Measure.fraction(1.25), '1¼');
      expect(Measure.fraction(2.34), '2⅓');
      expect(Measure.fraction(0.7), '⅔');
      expect(Measure.fraction(2.97), '3');
      expect(Measure.fraction(0.04), '⅛');
      expect(Measure.fraction(3), '3');
    });
  });

  group('scaling', () {
    test('counts scale with servings', () {
      expect(fmt(2, null), '2');
      expect(fmt(2, null, scale: 1.5), '3');
      expect(fmt(1, 'each', scale: 0.5), '½');
    });

    test('spoons and cups keep their unit in both systems', () {
      expect(fmt(2, 'tbsp', scale: 0.5), '1 tbsp');
      expect(fmt(1, 'tsp', scale: 0.25), '¼ tsp');
      expect(fmt(1, 'cup', scale: 2, system: UnitSystem.imperial), '2 cups');
      expect(fmt(2, 'pinch'), '2 pinches');
    });

    test('nothing to show without a quantity', () {
      expect(fmt(null, 'g'), isNull);
      expect(fmt(0, 'g'), isNull);
    });

    test('scaled costs round to cents', () {
      expect(Measure.scaledCents(7900, 1.5), 11850);
      expect(Measure.scaledCents(null, 2), isNull);
    });
  });

  group('metric', () {
    test('grams round sensibly and roll into kilograms', () {
      expect(fmt(15, 'g'), '15 g');
      expect(fmt(2.5, 'g'), '2.5 g');
      expect(fmt(400, 'g', scale: 0.75), '300 g');
      expect(fmt(1000, 'g'), '1 kg');
      expect(fmt(1000, 'g', scale: 1.5), '1.5 kg');
      expect(fmt(1, 'kg', scale: 0.5), '500 g');
    });

    test('ml and litres', () {
      expect(fmt(30, 'ml'), '30 ml');
      expect(fmt(250, 'ml', scale: 1.1), '275 ml');
      expect(fmt(1.5, 'l'), '1.5 l');
    });

    test('imperial units convert to metric', () {
      expect(fmt(1, 'lb'), '455 g');
      expect(fmt(8, 'oz'), '225 g');
      expect(fmt(2, 'fl_oz'), '60 ml');
    });
  });

  group('imperial', () {
    test('grams become ounces and pounds', () {
      expect(fmt(15, 'g', system: UnitSystem.imperial), '½ oz');
      expect(fmt(400, 'g', system: UnitSystem.imperial), '14 oz');
      expect(fmt(1000, 'g', system: UnitSystem.imperial), '2.2 lb');
      expect(fmt(1, 'g', system: UnitSystem.imperial), '¼ oz');
    });

    test('millilitres become cups or tablespoons', () {
      expect(fmt(250, 'ml', system: UnitSystem.imperial), '1 cup');
      expect(fmt(500, 'ml', system: UnitSystem.imperial), '2 cups');
      expect(fmt(30, 'ml', system: UnitSystem.imperial), '2 tbsp');
      expect(fmt(1, 'l', system: UnitSystem.imperial), '4 cups');
    });
  });

  group('nameFrom', () {
    test('drops the leading amount and unit', () {
      expect(
        Measure.nameFrom('1 kg bone-in chicken thighs'),
        'bone-in chicken thighs',
      );
      expect(Measure.nameFrom('2 onions, sliced'), 'onions, sliced');
      expect(Measure.nameFrom('1 1/2 cups of rice'), 'rice');
      expect(Measure.nameFrom('½ tsp turmeric'), 'turmeric');
      expect(Measure.nameFrom('2-3 tbsp oil'), 'oil');
      expect(Measure.nameFrom('250ml chicken stock'), 'chicken stock');
    });

    test('keeps lines without an amount', () {
      expect(Measure.nameFrom('Salt, to taste'), 'Salt, to taste');
      expect(Measure.nameFrom('Garlic'), 'Garlic');
    });

    test('does not eat words that start like units', () {
      expect(Measure.nameFrom('2 large eggs'), 'large eggs');
      expect(Measure.nameFrom('3 lemons'), 'lemons');
    });
  });
}
