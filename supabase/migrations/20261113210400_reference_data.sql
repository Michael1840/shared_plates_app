-- SharedPlates · reference data
-- Starter food library: common South African ingredients, per 100 g, rounded from USDA FoodData Central-style values.
-- Replace or extend with a full import (e.g. SAFOODS) later; recipes recalculate automatically when portions change.

insert into public.units (code, label, kind, scope, to_base) values
  ('g', 'gram', 'mass', 'metric', 1),
  ('kg', 'kilogram', 'mass', 'metric', 1000),
  ('ml', 'millilitre', 'volume', 'metric', 1),
  ('l', 'litre', 'volume', 'metric', 1000),
  ('tsp', 'teaspoon (5 ml)', 'volume', 'both', 5),
  ('tbsp', 'tablespoon (15 ml)', 'volume', 'both', 15),
  ('cup', 'cup (250 ml)', 'volume', 'both', 250),
  ('pinch', 'pinch', 'volume', 'both', 0.3),
  ('fl_oz', 'fluid ounce', 'volume', 'imperial', 29.574),
  ('oz', 'ounce', 'mass', 'imperial', 28.35),
  ('lb', 'pound', 'mass', 'imperial', 453.592),
  ('each', 'each', 'count', 'both', 1)
on conflict (code) do nothing;

insert into public.tags (slug, label, kind, cover_style, position) values
  ('curry', 'Curries', 'cuisine', 'stew', 0),
  ('cape-malay', 'Cape Malay', 'cuisine', 'stew', 1),
  ('braai', 'Braai', 'occasion', 'meat', 2),
  ('sunday-lunch', 'Sunday lunch', 'occasion', 'meat', 3),
  ('weeknight', 'Quick weeknights', 'occasion', 'any', 4),
  ('freezer-friendly', 'Freezer-friendly', 'occasion', 'any', 5),
  ('stew', 'Stews', 'meal', 'stew', 6),
  ('soup', 'Soups', 'meal', 'stew', 7),
  ('one-pot', 'One pot', 'meal', 'stew', 8),
  ('pasta', 'Pasta', 'meal', 'any', 9),
  ('salad', 'Salads', 'meal', 'veg', 10),
  ('breakfast', 'Breakfast', 'meal', 'any', 11),
  ('baking', 'Baking', 'meal', 'sweet', 12),
  ('dessert', 'Desserts', 'meal', 'sweet', 13),
  ('veggie', 'Vegetarian', 'diet', 'veg', 14),
  ('vegan', 'Vegan', 'diet', 'veg', 15),
  ('halal', 'Halal', 'diet', 'any', 16),
  ('gluten-free', 'Gluten-free', 'diet', 'any', 17),
  ('dairy-free', 'Dairy-free', 'diet', 'any', 18)
on conflict (slug) do nothing;

insert into public.foods (name, aliases, category, kcal_100g, protein_100g, carbs_100g, fat_100g, fibre_100g, sugar_100g, sodium_mg_100g, density_g_ml, source) values
  ('Chicken thigh', array['chicken thighs','hoender']::text[], 'meat', 211, 17.3, 0, 15.3, 0, 0, 84, null, 'starter'),
  ('Chicken breast', array['chicken fillet','chicken breasts']::text[], 'meat', 120, 22.5, 0, 2.6, 0, 0, 45, null, 'starter'),
  ('Beef mince', array['mince','ground beef']::text[], 'meat', 254, 17.2, 0, 20, 0, 0, 66, null, 'starter'),
  ('Lamb chops', array['lamb chop','tjops','chops']::text[], 'meat', 282, 16.4, 0, 23.6, 0, 0, 59, null, 'starter'),
  ('Boerewors', array['wors']::text[], 'meat', 300, 14, 3, 26, 0, 1, 800, null, 'starter'),
  ('Prawns', array['shrimp','prawn']::text[], 'seafood', 85, 20.1, 0, 0.5, 0, 0, 119, null, 'starter'),
  ('Onion', array['onions','ui']::text[], 'veg', 40, 1.1, 9.3, 0.1, 1.7, 4.2, 4, null, 'starter'),
  ('Garlic', array['garlic cloves','knoffel']::text[], 'veg', 149, 6.4, 33, 0.5, 2.1, 1, 17, null, 'starter'),
  ('Fresh ginger', array['ginger','gemmer']::text[], 'veg', 80, 1.8, 17.8, 0.8, 2, 1.7, 13, null, 'starter'),
  ('Potato', array['potatoes','aartappel']::text[], 'veg', 77, 2, 17.5, 0.1, 2.2, 0.8, 6, null, 'starter'),
  ('Carrot', array['carrots','wortel']::text[], 'veg', 41, 0.9, 9.6, 0.2, 2.8, 4.7, 69, null, 'starter'),
  ('Green pepper', array['green peppers','green bell pepper']::text[], 'veg', 20, 0.9, 4.6, 0.2, 1.7, 2.4, 3, null, 'starter'),
  ('Red pepper', array['red peppers','red bell pepper']::text[], 'veg', 31, 1, 6, 0.3, 2.1, 4.2, 4, null, 'starter'),
  ('Tomato', array['tomatoes']::text[], 'veg', 18, 0.9, 3.9, 0.2, 1.2, 2.6, 5, null, 'starter'),
  ('Spinach', array['spinach leaves']::text[], 'veg', 23, 2.9, 3.6, 0.4, 2.2, 0.4, 79, null, 'starter'),
  ('Chilli', array['chili','chillies','green chilli']::text[], 'veg', 40, 1.9, 8.8, 0.4, 1.5, 5.3, 9, null, 'starter'),
  ('Fresh coriander', array['coriander','dhania','cilantro']::text[], 'herb', 23, 2.1, 3.7, 0.5, 2.8, 0.9, 46, 0.07, 'starter'),
  ('Lemon', array['lemons']::text[], 'fruit', 29, 1.1, 9.3, 0.3, 2.8, 2.5, 2, null, 'starter'),
  ('Curry powder', array['masala','curry masala']::text[], 'spice', 325, 14.3, 55.8, 14, 53.2, 2.8, 52, 0.42, 'starter'),
  ('Ground turmeric', array['turmeric','borrie']::text[], 'spice', 312, 9.7, 67, 3.3, 22.7, 3.2, 27, 0.45, 'starter'),
  ('Ground cumin', array['cumin','jeera']::text[], 'spice', 375, 17.8, 44.2, 22.3, 10.5, 2.3, 168, 0.42, 'starter'),
  ('Paprika', array['smoked paprika']::text[], 'spice', 282, 14.1, 54, 12.9, 34.9, 10.3, 68, 0.45, 'starter'),
  ('Black pepper', array['pepper','ground black pepper']::text[], 'spice', 251, 10.4, 64, 3.3, 25.3, 0.6, 20, 0.45, 'starter'),
  ('Salt', array['table salt','sea salt']::text[], 'pantry', 0, 0, 0, 0, 0, 0, 38758, 1.2, 'starter'),
  ('Sunflower oil', array['oil','cooking oil','vegetable oil']::text[], 'oil', 884, 0, 0, 100, 0, 0, 0, 0.92, 'starter'),
  ('Chopped tomatoes', array['tinned tomatoes','canned tomatoes','chopped canned tomatoes']::text[], 'pantry', 21, 1, 4, 0.3, 1, 2.6, 140, 1.05, 'starter'),
  ('Chicken stock', array['stock','chicken broth']::text[], 'pantry', 7, 1, 0.5, 0.2, 0, 0.3, 340, 1.0, 'starter'),
  ('Coconut milk', array['coconut cream']::text[], 'pantry', 197, 2, 2.8, 21.3, 0, 0, 13, 1.0, 'starter'),
  ('Butter beans', array['lima beans','canned butter beans']::text[], 'legume', 79, 4.8, 14, 0.2, 4.2, 0.6, 240, null, 'starter'),
  ('Baked beans', array['baked beans in tomato sauce']::text[], 'legume', 94, 4.8, 21, 0.4, 4, 7.8, 370, null, 'starter'),
  ('Sugar beans', array['dried sugar beans','beans']::text[], 'legume', 333, 23, 60, 1, 15, 2, 24, 0.8, 'starter'),
  ('Samp', array['stamp mielies']::text[], 'grain', 360, 7, 78, 1.5, 8, 0.6, 1, 0.75, 'starter'),
  ('White rice', array['rice','basmati rice','uncooked rice']::text[], 'grain', 365, 7.1, 80, 0.7, 1.3, 0.1, 5, 0.85, 'starter'),
  ('Pasta', array['penne','spaghetti','macaroni','dry pasta']::text[], 'grain', 371, 13, 75, 1.5, 3.2, 2.7, 6, 0.42, 'starter'),
  ('Maize meal', array['mealie meal','pap']::text[], 'grain', 360, 8.1, 77, 1.8, 6, 0.6, 5, 0.6, 'starter'),
  ('White bread', array['bread']::text[], 'bakery', 266, 7.6, 49, 3.3, 2.7, 5, 490, null, 'starter'),
  ('Cake flour', array['flour','all-purpose flour','plain flour']::text[], 'baking', 364, 10, 76, 1, 2.7, 0.3, 2, 0.53, 'starter'),
  ('White sugar', array['sugar','castor sugar']::text[], 'baking', 387, 0, 100, 0, 0, 100, 1, 0.85, 'starter'),
  ('Brown sugar', '{}'::text[], 'baking', 380, 0.1, 98, 0, 0, 97, 28, 0.9, 'starter'),
  ('Bicarbonate of soda', array['bicarb','baking soda']::text[], 'baking', 0, 0, 0, 0, 0, 0, 27360, 0.92, 'starter'),
  ('Apricot jam', array['jam']::text[], 'pantry', 250, 0.4, 64, 0.1, 0.7, 48, 30, 1.3, 'starter'),
  ('Honey', '{}'::text[], 'pantry', 304, 0.3, 82, 0, 0.2, 82, 4, 1.42, 'starter'),
  ('White vinegar', array['vinegar','brown vinegar']::text[], 'pantry', 18, 0, 0.04, 0, 0, 0.04, 2, 1.0, 'starter'),
  ('Butter', '{}'::text[], 'dairy', 717, 0.9, 0.1, 81, 0, 0.1, 11, 0.96, 'starter'),
  ('Milk', array['full cream milk']::text[], 'dairy', 61, 3.2, 4.8, 3.3, 0, 5.1, 43, 1.03, 'starter'),
  ('Cream', array['fresh cream','cooking cream']::text[], 'dairy', 340, 2.1, 2.8, 36, 0, 2.9, 27, 1.0, 'starter'),
  ('Egg', array['eggs']::text[], 'dairy', 143, 12.6, 0.7, 9.5, 0, 0.4, 142, null, 'starter'),
  ('Cheddar', array['cheddar cheese','grated cheese']::text[], 'dairy', 403, 24.9, 1.3, 33.1, 0, 0.5, 621, 0.45, 'starter'),
  ('Mozzarella', array['mozzarella cheese']::text[], 'dairy', 300, 22, 2.2, 22, 0, 1, 627, 0.45, 'starter')
on conflict (name) do nothing;

insert into public.food_portions (food_id, label, grams, is_default)
select f.id, v.label, v.grams, v.is_default
from (values
  ('Chicken thigh', 'each', 110, true),
  ('Chicken breast', 'each', 170, true),
  ('Lamb chops', 'each', 100, true),
  ('Onion', 'medium', 150, true),
  ('Onion', 'small', 70, false),
  ('Onion', 'large', 200, false),
  ('Garlic', 'clove', 3, true),
  ('Fresh ginger', 'thumb', 15, true),
  ('Potato', 'medium', 170, true),
  ('Carrot', 'medium', 60, true),
  ('Green pepper', 'medium', 120, true),
  ('Red pepper', 'medium', 120, true),
  ('Tomato', 'medium', 120, true),
  ('Spinach', 'bunch', 250, true),
  ('Chilli', 'each', 10, true),
  ('Fresh coriander', 'bunch', 30, true),
  ('Lemon', 'each', 85, true),
  ('Chopped tomatoes', 'can', 400, true),
  ('Coconut milk', 'can', 400, true),
  ('Butter beans', 'can', 400, true),
  ('Baked beans', 'can', 410, true),
  ('White bread', 'slice', 30, true),
  ('Egg', 'large', 50, true)
) as v(food, label, grams, is_default)
join public.foods f on f.name = v.food
on conflict (food_id, label) do nothing;

insert into public.collections (slug, title, subtitle, kind, filter, position) values
  ('under-r100',      'Under R100',      'Feeds four, honest',      'mood', '{"max_total_cost": 10000}', 0),
  ('ready-in-20',     'Ready in 20',     'Weeknight savers',        'mood', '{"max_minutes": 20, "sort": "quickest"}', 1),
  ('braai-night',     'Braai night',     'Fire''s on',              'mood', '{"tags": ["braai"]}', 2),
  ('something-sweet', 'Something sweet', 'For after',               'mood', '{"tags": ["dessert", "baking"]}', 3)
on conflict (slug) do nothing;
