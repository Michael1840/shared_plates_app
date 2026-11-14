import 'package:shared_plates_app/core/sync/remote_store.dart';

import 'fake_remote_store.dart';

const seedRecipeId = 'r1';

JsonRow seedCard({String authorId = 'author'}) => {
  'id': seedRecipeId,
  'author_id': authorId,
  'author_name': 'Lerato Mokoena',
  'author_username': 'lerato.eats',
  'title': 'Cape Malay chicken curry',
  'note': "My mum's Sunday curry. Go easy on the chilli.",
  'cover_style': 'stew',
  'base_servings': 4,
  'total_minutes': 55,
  'visibility': 'public',
  'status': 'published',
  'kcal_per_serving': 512,
  'protein_g': 38,
  'carbs_g': 36,
  'fat_g': 22,
  'fibre_g': 6,
  'ingredient_count': 4,
  'matched_lines': 3,
  'cost_cents': 14800,
  'cost_per_plate': 3700,
  'like_count': 284,
  'save_count': 120,
  'updated_at': '2026-11-13T21:00:00Z',
};

void seedRecipe(FakeRemoteStore remote, {String authorId = 'author'}) {
  JsonRow ingredient(
    String id,
    int position,
    String raw, {
    double? q,
    String? unit,
    int? cents,
  }) => {
    'id': id,
    'recipe_id': seedRecipeId,
    'position': position,
    'raw_text': raw,
    'quantity': q,
    'unit': unit,
    'cost_cents': cents,
    'updated_at': '2026-11-13T21:00:00Z',
  };
  remote
    ..seed('recipe_cards', [seedCard(authorId: authorId)])
    ..seed('recipe_ingredients', [
      ingredient('i3', 2, '30 ml sunflower oil', q: 30, unit: 'ml', cents: 200),
      ingredient(
        'i1',
        0,
        '1 kg bone-in chicken thighs',
        q: 1000,
        unit: 'g',
        cents: 7900,
      ),
      ingredient('i2', 1, '2 onions, sliced', q: 2, cents: 600),
      ingredient('i4', 3, 'Salt, to taste'),
    ])
    ..seed('recipe_steps', [
      {
        'id': 's2',
        'recipe_id': seedRecipeId,
        'position': 1,
        'body': 'Add the chicken and brown on all sides.',
        'timer_seconds': 300,
        'updated_at': '2026-11-13T21:00:00Z',
      },
      {
        'id': 's1',
        'recipe_id': seedRecipeId,
        'position': 0,
        'body': 'Heat the oil and soften the onions.',
        'timer_seconds': 480,
        'updated_at': '2026-11-13T21:00:00Z',
      },
    ])
    ..seed('step_ingredients', [
      {'step_id': 's1', 'ingredient_id': 'i3'},
      {'step_id': 's1', 'ingredient_id': 'i2'},
      {'step_id': 's2', 'ingredient_id': 'i1'},
    ])
    ..seed('recipe_tags', [
      {'recipe_id': seedRecipeId, 'tag_id': 1},
    ]);
}
