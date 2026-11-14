// Pure parsing for pasted recipes. No network, so the app can run the same logic offline.

export type ParsedIngredient = {
  raw_text: string;
  quantity: number | null;
  unit: string | null;          // matches public.units.code
  portion_label: string | null; // matches public.food_portions.label
  name: string;                 // what's left to match against the food library
  prep_note: string | null;
  section: string | null;
};

export type ParsedStep = { body: string; timer_seconds: number | null };

export type ParsedRecipe = {
  title: string | null;
  servings: number | null;
  total_minutes: number | null;
  ingredients: ParsedIngredient[];
  steps: ParsedStep[];
};

const FRACTIONS: Record<string, number> = {
  "½": 0.5, "⅓": 1 / 3, "⅔": 2 / 3, "¼": 0.25, "¾": 0.75, "⅕": 0.2, "⅛": 0.125, "⅜": 0.375, "⅝": 0.625, "⅞": 0.875,
};

const UNIT_ALIASES: Array<[RegExp, string]> = [
  [/^(kg|kgs|kilo|kilos|kilogram|kilograms)$/, "kg"],
  [/^(g|gr|gram|grams|gramme|grammes)$/, "g"],
  [/^(ml|millilitre|millilitres|milliliter|milliliters)$/, "ml"],
  [/^(l|litre|litres|liter|liters)$/, "l"],
  [/^(tsp|tsps|teaspoon|teaspoons|t)$/, "tsp"],
  [/^(tbsp|tbsps|tbs|tablespoon|tablespoons|T)$/, "tbsp"],
  [/^(cup|cups|c)$/, "cup"],
  [/^(pinch|pinches)$/, "pinch"],
  [/^(fl\.? ?oz)$/, "fl_oz"],
  [/^(oz|ounce|ounces)$/, "oz"],
  [/^(lb|lbs|pound|pounds)$/, "lb"],
];

const PORTIONS: Array<[RegExp, string]> = [
  [/^(clove|cloves)$/, "clove"],
  [/^(can|cans|tin|tins)$/, "can"],
  [/^(bunch|bunches)$/, "bunch"],
  [/^(slice|slices)$/, "slice"],
  [/^(thumb|thumbs)$/, "thumb"],
  [/^(medium)$/, "medium"],
  [/^(large)$/, "large"],
  [/^(small)$/, "small"],
];

const HEADINGS: Array<[RegExp, "ingredients" | "method"]> = [
  [/^(ingredients|you('|’)ll need|what you need|shopping list)\s*:?$/i, "ingredients"],
  [/^(method|instructions|directions|steps|preparation|how to make it|to make)\s*:?$/i, "method"],
];

const BULLET = /^\s*(?:[-*•·–]|\d+[.)]|step\s*\d+[:.)]?)\s*/i;
const STARTS_WITH_AMOUNT = /^\s*(?:[-*•·–]\s*)?(?:\d|[½⅓⅔¼¾⅕⅛⅜⅝⅞]|a |an |one |two |three |pinch|handful)/i;

function parseNumber(token: string): number | null {
  const t = token.replace(",", ".").trim();
  if (!t) return null;
  if (FRACTIONS[t] !== undefined) return FRACTIONS[t];
  const mixedUnicode = t.match(/^(\d+)\s*([½⅓⅔¼¾⅕⅛⅜⅝⅞])$/);
  if (mixedUnicode) return Number(mixedUnicode[1]) + FRACTIONS[mixedUnicode[2]];
  const frac = t.match(/^(\d+)\/(\d+)$/);
  if (frac) return Number(frac[2]) === 0 ? null : Number(frac[1]) / Number(frac[2]);
  const n = Number(t);
  return Number.isFinite(n) ? n : null;
}

const WORD_NUMBERS: Record<string, number> = { a: 1, an: 1, one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, half: 0.5 };

export function parseIngredient(rawLine: string, section: string | null = null): ParsedIngredient {
  const raw = rawLine.replace(BULLET, "").replace(/\s+/g, " ").trim();
  let rest = raw;
  let quantity: number | null = null;

  // "1 ½", "1 1/2", "1½", "1.5", "1,5", "½", "1-2" (take the first), "two"
  const qty = rest.match(/^(\d+(?:[.,]\d+)?\s+\d+\/\d+|\d+\s*[½⅓⅔¼¾⅕⅛⅜⅝⅞]|\d+\/\d+|\d+(?:[.,]\d+)?|[½⅓⅔¼¾⅕⅛⅜⅝⅞])(?:\s*(?:-|–|to)\s*\d+(?:[.,]\d+)?)?/);
  if (qty) {
    const q = qty[1];
    const mixed = q.match(/^(\d+)\s+(\d+)\/(\d+)$/);
    quantity = mixed ? Number(mixed[1]) + Number(mixed[2]) / Number(mixed[3]) : parseNumber(q.replace(/\s+/g, ""));
    rest = rest.slice(qty[0].length).trim();
  } else {
    const w = rest.match(/^(a|an|one|two|three|four|five|six|half)\b\s*/i);
    if (w) {
      quantity = WORD_NUMBERS[w[1].toLowerCase()];
      rest = rest.slice(w[0].length).trim();
    }
  }

  // unit right after the number, including "400g" glued on
  let unit: string | null = null;
  let portion: string | null = null;
  const unitMatch = rest.match(/^([A-Za-z]+\.?(?:\s?oz)?)\b\.?\s*(?:of\s+)?/);
  if (unitMatch) {
    const word = unitMatch[1].replace(/\.$/, "");
    const exact = UNIT_ALIASES.find(([re]) => re.test(word)) ?? UNIT_ALIASES.find(([re]) => re.test(word.toLowerCase()) && word !== "T" && word !== "t");
    if (exact && (quantity !== null || /pinch/i.test(word))) {
      unit = exact[1];
      if (unit === "pinch" && quantity === null) quantity = 1;
      rest = rest.slice(unitMatch[0].length).trim();
    } else {
      const p = PORTIONS.find(([re]) => re.test(word.toLowerCase()));
      if (p && quantity !== null) {
        portion = p[1];
        rest = rest.slice(unitMatch[0].length).trim();
      }
    }
  }
  // "400 g can chopped tomatoes" → keep grams, drop the container word
  rest = rest.replace(/^(can|cans|tin|tins|packet|packets|pack)\s+(of\s+)?/i, (m) => {
    if (!unit && !portion && quantity !== null) portion = "can";
    return "";
  });

  // prep note after a comma or in brackets
  let prep: string | null = null;
  const bracket = rest.match(/\(([^)]*)\)/);
  if (bracket) {
    prep = bracket[1].trim() || null;
    rest = rest.replace(bracket[0], " ").trim();
  }
  const comma = rest.indexOf(",");
  if (comma > 0) {
    const after = rest.slice(comma + 1).trim();
    prep = [after, prep].filter(Boolean).join(", ") || null;
    rest = rest.slice(0, comma).trim();
  }
  rest = rest.replace(/^(of|x)\s+/i, "").replace(/\s+/g, " ").trim();

  return { raw_text: raw, quantity, unit, portion_label: portion, name: rest || raw, prep_note: prep, section };
}

export function findTimerSeconds(text: string): number | null {
  const m = text.match(/(\d+(?:[.,]\d+)?)\s*(?:-|–|to)?\s*(?:\d+\s*)?(hours?|hrs?|h|minutes?|mins?|m)\b/i);
  if (!m) return null;
  const n = Number(m[1].replace(",", "."));
  const isHour = /^h/i.test(m[2]);
  const secs = Math.round(n * (isHour ? 3600 : 60));
  return secs > 0 && secs <= 86400 ? secs : null;
}

function looksLikeIngredient(line: string): boolean {
  if (line.length > 90) return false;
  if (STARTS_WITH_AMOUNT.test(line)) return true;
  return /^\s*[-*•·–]\s*/.test(line) && line.length < 60 && !/[.!?]$/.test(line.trim());
}

function looksLikeStep(line: string): boolean {
  return /^\s*(?:\d+[.)]|step\s*\d+)/i.test(line) || line.length > 60 || /[.!?]$/.test(line.trim());
}

export function parseRecipe(text: string): ParsedRecipe {
  const lines = text.replace(/\r/g, "").split("\n").map((l) => l.trim()).filter((l) => l.length > 0);
  let title: string | null = null;
  let servings: number | null = null;
  let totalMinutes: number | null = null;
  const ingredients: ParsedIngredient[] = [];
  const steps: ParsedStep[] = [];
  let mode: "unknown" | "ingredients" | "method" = "unknown";
  let section: string | null = null;

  for (const [i, line] of lines.entries()) {
    const heading = HEADINGS.find(([re]) => re.test(line));
    if (heading) { mode = heading[1]; section = null; continue; }

    const serves = line.match(/^(?:serves|feeds|makes|servings|yield)\s*:?\s*(\d+)/i);
    if (serves) { servings = Number(serves[1]); continue; }
    const time = line.match(/^(?:total time|time|takes|ready in|cook time)\s*:?\s*(.+)$/i);
    if (time) {
      const s = findTimerSeconds(time[1]);
      if (s) { totalMinutes = Math.round(s / 60); continue; }
    }

    if (i === 0 && !looksLikeIngredient(line) && line.length <= 120) { title = line.replace(/^#+\s*/, ""); continue; }

    // sub-headings inside the ingredient list: "For the sauce:"
    if (mode !== "method" && /^(for the .+|.+:)$/i.test(line) && line.length < 40 && !STARTS_WITH_AMOUNT.test(line)) {
      section = line.replace(/:$/, "").replace(/^for the\s+/i, "For the ").trim();
      if (mode === "unknown") mode = "ingredients";
      continue;
    }

    const asIngredient = mode === "ingredients" || (mode === "unknown" && looksLikeIngredient(line) && !looksLikeStep(line));
    if (asIngredient && !(mode === "ingredients" && looksLikeStep(line) && !looksLikeIngredient(line) && line.length > 90)) {
      ingredients.push(parseIngredient(line, section));
    } else {
      const body = line.replace(BULLET, "").trim();
      if (body) steps.push({ body, timer_seconds: findTimerSeconds(body) });
      if (mode === "unknown") mode = "method";
    }
  }
  return { title, servings, total_minutes: totalMinutes, ingredients, steps };
}

// Words that describe an ingredient rather than name it, so they don't link steps by accident
const DESCRIPTORS = new Set([
  "chopped", "sliced", "diced", "grated", "crushed", "minced", "fresh", "dried", "ground", "whole", "large", "small",
  "medium", "bone", "boneless", "skinless", "canned", "tinned", "frozen", "cooked", "uncooked", "raw", "fine", "finely",
  "roughly", "peeled", "the", "and", "with", "for", "into", "cape", "malay", "full", "cream", "white", "brown", "red", "green",
]);

const stemOf = (w: string) => w.replace(/(oes|es|s)$/, (m) => (m === "oes" ? "o" : ""));
const escape = (w: string) => w.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

// Which ingredients each step mentions, by any naming word of the typed name or matched food.
export function linkSteps(steps: ParsedStep[], names: string[][]): number[][] {
  const words = names.map((cands) => {
    const set = new Set<string>();
    for (const c of cands) {
      for (const w of c.toLowerCase().split(/[^a-zà-ÿ]+/)) {
        if (w.length >= 3 && !DESCRIPTORS.has(w)) set.add(stemOf(w));
      }
    }
    return [...set].filter((w) => w.length >= 3);
  });
  return steps.map((s) => {
    const body = s.body.toLowerCase();
    const hits: number[] = [];
    words.forEach((ws, idx) => {
      if (ws.some((w) => new RegExp(`\\b${escape(w)}`).test(body))) hits.push(idx);
    });
    return hits;
  });
}
