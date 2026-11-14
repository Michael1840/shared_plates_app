\set QUIET 1
\pset footer off
create or replace function pg_temp.act(uid text) returns void language sql as $$ select set_config('request.jwt.claim.sub', uid, false) $$;
\echo '--- 11. Riaan cooks the curry and tells Lerato; ticks a shopping item; views 35 recipes'
select pg_temp.act('33333333-3333-4333-8333-333333333333') \g /dev/null
set role authenticated;
insert into public.cooks (recipe_id, servings, told_creator) values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 6, true);
insert into public.shopping_ticks (ingredient_id, recipe_id)
  select id, '00000000-0000-4000-8000-000000000000' from public.recipe_ingredients where recipe_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa' and position = 1;
select (select title from public.recipes where id = t.recipe_id) as recipe_fixed_by_trigger from public.shopping_ticks t;
insert into public.recently_viewed (recipe_id) values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa');
reset role;
insert into public.recipes (author_id, title, visibility, status)
  select '22222222-2222-4222-8222-222222222222', 'Recipe ' || g, 'public', 'published' from generate_series(1, 35) g;
set role authenticated;
insert into public.recently_viewed (recipe_id, viewed_at)
  select id, now() + (row_number() over ())::int * interval '1 second' from public.recipes where title like 'Recipe %';
select count(*) as recently_viewed_kept from public.recently_viewed;
reset role;
select kind, (select username from public.profiles where id = actor_id) actor, data from public.notifications where kind = 'recipe_cooked';
select cook_count from public.recipes where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';

\echo '--- 12. Lerato changes servings 4 → 6: per-serving nutrition and cost per plate update'
select pg_temp.act('22222222-2222-4222-8222-222222222222') \g /dev/null
set role authenticated;
update public.recipes set base_servings = 6 where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
select kcal_per_serving, cost_per_plate from public.recipe_cards where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
\echo '    she soft-deletes a recipe; Riaan no longer sees it'
update public.recipes set deleted_at = now() where title = 'Recipe 1';
reset role;
select pg_temp.act('33333333-3333-4333-8333-333333333333') \g /dev/null
set role authenticated;
select count(*) as riaan_sees_recipe_1 from public.recipes where title = 'Recipe 1';
\echo '    unlike decrements'
reset role;
select pg_temp.act('33333333-3333-4333-8333-333333333333') \g /dev/null
set role authenticated;
insert into public.likes (recipe_id) values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa');
delete from public.likes where recipe_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
select like_count from public.recipes where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
\echo '--- 13. Popular cooks for Riaan (tastes: curry), hidden food filter'
insert into public.profile_tastes (tag_id) select id from public.tags where slug = 'curry';
select username, recipes, saves from public.popular_cooks();
insert into public.hidden_foods (food_id) select id from public.foods where name = 'Chicken thigh';
select count(*) as curry_results_with_chicken_hidden from public.search_recipes(q => 'curry');
\echo '--- 14. Weekly round-up as the cron job would run it'
reset role;
select internal.weekly_roundup();
select (select username from public.profiles where id = recipient_id) to_user, data from public.notifications where kind = 'weekly_roundup';
