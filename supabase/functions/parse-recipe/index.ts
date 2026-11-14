// parse-recipe: turns a pasted recipe into title, ingredients (matched to the food library) and steps.
// POST { "text": "..." }  →  { title, servings, total_minutes, ingredients[], steps[], matched, total }
// Runs as the signed-in user, so match_foods goes through RLS like any other call.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2.45.4";
import { linkSteps, parseRecipe } from "./parse.ts";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "Send a POST with { text }" }, 405);

  let text = "";
  try {
    ({ text } = await req.json());
  } catch {
    return json({ error: "Body must be JSON: { \"text\": \"...\" }" }, 400);
  }
  if (typeof text !== "string" || text.trim().length === 0) return json({ error: "Paste some recipe text first" }, 400);
  if (text.length > 20000) return json({ error: "That's longer than a recipe. Paste up to 20,000 characters." }, 413);

  const parsed = parseRecipe(text);

  const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: req.headers.get("Authorization") ?? "" } },
  });

  const lines = parsed.ingredients.map((i) => i.name);
  let matches: Array<{ line: string; food_id: string | null; food_name: string | null; score: number | null }> = [];
  if (lines.length > 0) {
    const { data, error } = await supabase.rpc("match_foods", { lines });
    if (error) return json({ error: "Couldn't reach the food library", detail: error.message }, 502);
    matches = data ?? [];
  }

  const ingredients = parsed.ingredients.map((ing, idx) => {
    const m = matches[idx];
    return { ...ing, position: idx + 1, food_id: m?.food_id ?? null, food_name: m?.food_name ?? null, score: m?.score ?? null };
  });

  const links = linkSteps(parsed.steps, ingredients.map((i) => [i.name, i.food_name ?? ""].filter(Boolean)));
  const steps = parsed.steps.map((s, idx) => ({ ...s, position: idx + 1, ingredient_positions: links[idx].map((n) => n + 1) }));

  return json({
    title: parsed.title,
    servings: parsed.servings,
    total_minutes: parsed.total_minutes,
    ingredients,
    steps,
    matched: ingredients.filter((i) => i.food_id).length,
    total: ingredients.length,
  });
});
