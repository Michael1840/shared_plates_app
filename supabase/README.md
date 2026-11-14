# SharedPlates · Supabase backend

Everything the redesign needs: 23 tables, Row Level Security on all of them, triggers for nutrition, cost, counts and notifications, search, Discover collections, trending, storage buckets, scheduled jobs and a starter food library. Tested end to end on Postgres 16 with a stand-in for Supabase Auth and Storage.

## Apply it

With the Supabase CLI, from a folder that contains this `supabase/` directory:

```bash
supabase link --project-ref gerwtfbubnoskoppmjbf
supabase db push
supabase functions deploy parse-recipe
```

Or paste each file in `migrations/` into the SQL editor, in filename order.

## Dashboard steps the SQL can't do

1. **Auth → Providers:** turn on Apple and Google. For email, turn on "Email OTP" and set the code length to 6 (the design uses a 6-digit code, not a magic link).
2. **Database → Extensions:** if the last migration printed "pg_cron is not available", enable `pg_cron` and run the two `cron.schedule` lines at the bottom of `20261113210300_storage_cron.sql`.
3. **Push (later):** when you have APNs, FCM and Huawei keys, add a Database Webhook on `notifications` INSERT that calls a `send-push` function.

## What's in each migration

| File | Contents |
|---|---|
| `…210000_core_schema.sql` | Extensions (`citext`, `pg_trgm`), 11 enums, all tables and indexes |
| `…210100_functions_triggers.sql` | New user → profile, friend and block helpers, `can_view_recipe`, grams from quantity/unit/portion, nutrition and cost recalculation, protected columns, `fork_recipe`, counters, notifications, friend request rules |
| `…210200_rls_and_api.sql` | RLS policies, `recipe_cards` view, `search_recipes`, `collection_recipes`, `friends_feed`, `trending_recipes`, `match_foods`, `username_available`, `popular_cooks`, `mark_notifications_read`, weekly round-up |
| `…210300_storage_cron.sql` | `recipe-photos` (private) and `avatars` (public) buckets with folder rules, hourly trending refresh, Sunday round-up |
| `…210400_reference_data.sql` | 12 units, 19 tags, 4 Home mood collections, 49 starter foods with 23 portion sizes |

## Calling it from Flutter

| Screen | Call |
|---|---|
| Onboarding username | `rpc('username_available', {name})` |
| Onboarding step 3 | `rpc('popular_cooks')` |
| Home · Cook by mood | `from('collections').select()` then `rpc('collection_recipes', {collection_slug})` |
| Home · Trending | `rpc('trending_recipes', {lim: 10})` |
| Home · Jump back in | `from('recently_viewed').select('viewed_at, recipe_cards!inner(*)')` or join on `recipe_cards` |
| Search and filters | `rpc('search_recipes', {q, max_total_cost, max_minutes, tag_slugs, scope, sort})` |
| Recipe page | `from('recipe_cards')` + `recipe_ingredients`, `recipe_steps`, `step_ingredients` |
| Like / save | insert or delete on `likes` / `saves` (retries are safe) |
| Save my version | `rpc('fork_recipe', {rid})` |
| Paste a recipe | `functions.invoke('parse-recipe', body: {text})` |
| Activity | `from('notifications')`, then `rpc('mark_notifications_read')` |
| Friends | insert into `friendships` (addressee_id), addressee updates `status` to `accepted`, delete to decline or remove |

Amounts are stored for `base_servings`. Scale and convert units in the app with `units.to_base`, `foods.density_g_ml` and `food_portions`, so it works offline.

Money is in cents (`cost_cents`, `cost_per_plate`); R100 is `10000`.

## Notes

- Clients can send their own UUIDs (use v7) for recipes, ingredients and steps, so drafts made offline keep their ids.
- Authors can't write counts, nutrition, cost, `published_at` or `author_id`; a trigger resets them.
- The starter foods are rounded reference values to get going. Swap in a full food composition import (e.g. SAFOODS) when you have it; recipes recalculate when portions change.
- `functions/parse-recipe/parse.ts` has no network code, so the same parser can be ported to Dart for offline pasting. Run its tests with `node --experimental-strip-types parse.test.ts` or `deno test`.
