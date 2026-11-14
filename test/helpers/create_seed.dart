import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';

final _at = DateTime.utc(2026);

Future<void> seedFoodLibrary(AppDatabase db, {bool tags = true}) async {
  await db.batch((b) {
    b
      ..insertAll(db.foods, [
        FoodsCompanion.insert(
          id: 'f-onion',
          name: 'Onion',
          aliases: const Value(['onions']),
          category: const Value('veg'),
          kcal100g: const Value(40),
          updatedAt: _at,
        ),
        FoodsCompanion.insert(
          id: 'f-oil',
          name: 'Sunflower oil',
          aliases: const Value(['oil', 'cooking oil']),
          category: const Value('oil'),
          kcal100g: const Value(884),
          fat100g: const Value(100),
          densityGMl: const Value(0.92),
          updatedAt: _at,
        ),
        FoodsCompanion.insert(
          id: 'f-chicken',
          name: 'Chicken thigh',
          aliases: const Value(['chicken thighs']),
          category: const Value('meat'),
          kcal100g: const Value(211),
          updatedAt: _at,
        ),
        FoodsCompanion.insert(
          id: 'f-curry',
          name: 'Curry powder',
          aliases: const Value(['masala']),
          category: const Value('spice'),
          kcal100g: const Value(325),
          densityGMl: const Value(0.42),
          updatedAt: _at,
        ),
        FoodsCompanion.insert(
          id: 'f-carrot',
          name: 'Carrot',
          aliases: const Value(['carrots']),
          category: const Value('veg'),
          kcal100g: const Value(41),
          updatedAt: _at,
        ),
      ])
      ..insertAll(db.foodPortions, [
        FoodPortionsCompanion.insert(
          foodId: 'f-onion',
          label: 'medium',
          grams: 150,
          isDefault: const Value(true),
          updatedAt: _at,
        ),
        FoodPortionsCompanion.insert(
          foodId: 'f-carrot',
          label: 'medium',
          grams: 70,
          isDefault: const Value(true),
          updatedAt: _at,
        ),
      ]);
    if (!tags) return;
    b.insertAll(db.tags, [
      TagsCompanion.insert(
        id: const Value(1),
        slug: 'curry',
        label: 'Curries',
        kind: TagKind.cuisine,
        coverStyle: CoverStyle.stew,
        updatedAt: _at,
      ),
      TagsCompanion.insert(
        id: const Value(15),
        slug: 'veggie',
        label: 'Vegetarian',
        kind: TagKind.diet,
        coverStyle: CoverStyle.veg,
        updatedAt: _at,
      ),
    ]);
  });
}
