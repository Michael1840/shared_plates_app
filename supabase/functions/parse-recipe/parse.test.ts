import { linkSteps, parseIngredient, parseRecipe } from "./parse.ts";

let failed = 0;
const eq = (label: string, got: unknown, want: unknown) => {
  const ok = JSON.stringify(got) === JSON.stringify(want);
  if (!ok) failed++;
  console.log(`${ok ? "ok  " : "FAIL"} ${label}${ok ? "" : `\n     got  ${JSON.stringify(got)}\n     want ${JSON.stringify(want)}`}`);
};

const pick = (s: string) => {
  const p = parseIngredient(s);
  return [p.quantity, p.unit, p.portion_label, p.name, p.prep_note];
};

eq("kg", pick("1 kg bone-in chicken thighs"), [1, "kg", null, "bone-in chicken thighs", null]);
eq("glued grams", pick("400g chopped tomatoes"), [400, "g", null, "chopped tomatoes", null]);
eq("count + prep", pick("2 onions, sliced"), [2, null, null, "onions", "sliced"]);
eq("cloves", pick("4 garlic cloves, crushed"), [4, null, null, "garlic cloves", "crushed"]);
eq("portion first", pick("4 cloves garlic"), [4, null, "clove", "garlic", null]);
eq("unicode fraction", pick("½ tsp ground turmeric"), [0.5, "tsp", null, "ground turmeric", null]);
eq("mixed fraction", pick("1 1/2 cups cake flour"), [1.5, "cup", null, "cake flour", null]);
eq("mixed unicode", pick("1½ tbsp sugar"), [1.5, "tbsp", null, "sugar", null]);
eq("comma decimal", pick("1,5 l chicken stock"), [1.5, "l", null, "chicken stock", null]);
eq("range", pick("2-3 tbsp curry powder"), [2, "tbsp", null, "curry powder", null]);
eq("can", pick("1 can (400 g) chopped tomatoes"), [1, null, "can", "chopped tomatoes", "400 g"]);
eq("pinch", pick("pinch of salt"), [1, "pinch", null, "salt", null]);
eq("word number", pick("two eggs"), [2, null, null, "eggs", null]);
eq("bullet", pick("- 250 ml cream"), [250, "ml", null, "cream", null]);
eq("no quantity", pick("Salt and pepper to taste"), [null, null, null, "Salt and pepper to taste", null]);

const paste = `Cape Malay chicken curry
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
4. Serve with the rice.`;

const r = parseRecipe(paste);
eq("title", r.title, "Cape Malay chicken curry");
eq("servings", r.servings, 4);
eq("total minutes", r.total_minutes, 55);
eq("ingredient count", r.ingredients.length, 6);
eq("section", r.ingredients[5].section, "For the rice");
eq("step count", r.steps.length, 4);
eq("step timers", r.steps.map((s) => s.timer_seconds), [480, 60, 2400, null]);
eq("step text cleaned", r.steps[0].body.startsWith("Heat"), true);
const links = linkSteps(r.steps, r.ingredients.map((i) => [i.name]));
eq("step links", links, [[1], [2, 3], [0, 4], [5]]);

const noHeadings = parseRecipe(`Quick chakalaka
- 1 onion, chopped
- 2 carrots, grated
- 1 can baked beans
Fry the onion until soft.
Add the carrots and beans and simmer for 10 minutes.`);
eq("no headings: ingredients", noHeadings.ingredients.map((i) => i.name), ["onion", "carrots", "baked beans"]);
eq("no headings: steps", noHeadings.steps.length, 2);

console.log(failed === 0 ? "\nall passed" : `\n${failed} failed`);
if (failed) process.exit(1);
