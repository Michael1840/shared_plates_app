\set QUIET 1
\pset footer off
-- users: Apple (full_name), Google (name), email only
insert into auth.users (id, email, raw_user_meta_data) values
 ('11111111-1111-4111-8111-111111111111','thandi@example.com','{"full_name":"Thandi Nkosi"}'),
 ('22222222-2222-4222-8222-222222222222','lerato@example.com','{"name":"Lerato Mokoena"}'),
 ('33333333-3333-4333-8333-333333333333','riaan@example.com','{}');
\echo '--- 1. profiles created on sign-up'
select username, display_name from public.profiles order by display_name;

-- helper to act as someone
create or replace function pg_temp.act(uid text) returns void language sql as $$ select set_config('request.jwt.claim.sub', uid, false) $$;

\echo '--- 2. Lerato writes a public curry (tries to fake 999 likes)'
select pg_temp.act('22222222-2222-4222-8222-222222222222');
set role authenticated;
insert into public.recipes (id, title, note, base_servings, total_minutes, visibility, status, like_count)
values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Cape Malay chicken curry', 'My mum''s Sunday curry', 4, 55, 'public', 'published', 999);
insert into public.recipe_ingredients (recipe_id, position, raw_text, quantity, unit, portion_label, food_id, cost_cents)
select 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', v.pos, v.raw, v.q, v.u, v.portion, (select id from public.foods where name = v.food), v.cost
from (values
  (1, '1 kg bone-in chicken thighs', 1::numeric, 'kg', null, 'Chicken thigh', 11900),
  (2, '2 onions, sliced', 2, null, null, 'Onion', 900),
  (3, '4 garlic cloves', 4, null, 'clove', 'Garlic', 600),
  (4, '2 tbsp curry powder', 2, 'tbsp', null, 'Curry powder', 900),
  (5, '400 g chopped tomatoes', 1, null, 'can', 'Chopped tomatoes', 1500),
  (6, '1 handful of love', null, null, null, null, null)
) v(pos, raw, q, u, portion, food, cost);
insert into public.recipe_steps (id, recipe_id, position, body, timer_seconds) values
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',1,'Fry the onions until golden.',480);
insert into public.step_ingredients select 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', id from public.recipe_ingredients where position = 2 and recipe_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
insert into public.recipe_tags select 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', id from public.tags where slug in ('curry','cape-malay');
reset role;
select raw_text, grams from public.recipe_ingredients order by position;
select title, like_count, kcal_per_serving, protein_g, ingredient_count, matched_lines, cost_cents, published_at is not null as published from public.recipes;

\echo '--- 3. Thandi likes and saves it (counts + notification), double-like is rejected'
select pg_temp.act('11111111-1111-4111-8111-111111111111');
set role authenticated;
insert into public.likes (recipe_id) values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa');
insert into public.saves (recipe_id) values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa');
insert into public.likes (recipe_id) values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa') on conflict do nothing;
select title, like_count, save_count, is_liked, is_saved, cost_per_plate from public.recipe_cards;
reset role;
select kind, (select username from public.profiles where id = actor_id) actor from public.notifications;

\echo '--- 4. Friends-only recipe is hidden until they are friends'
select pg_temp.act('22222222-2222-4222-8222-222222222222');
set role authenticated;
insert into public.recipes (id, title, visibility, status) values ('cccccccc-cccc-4ccc-8ccc-cccccccccccc','Gran''s malva pudding','friends','published');
reset role;
select pg_temp.act('11111111-1111-4111-8111-111111111111');
set role authenticated;
select 'before' as stage, count(*) as visible from public.recipes where id = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
insert into public.friendships (addressee_id) values ('22222222-2222-4222-8222-222222222222');
\echo '    Thandi tries to accept her own request (should change nothing):'
update public.friendships set status = 'accepted';
select status from public.friendships;
reset role;
select pg_temp.act('22222222-2222-4222-8222-222222222222');
set role authenticated;
update public.friendships set status = 'accepted' where requester_id = '11111111-1111-4111-8111-111111111111';
reset role;
select pg_temp.act('11111111-1111-4111-8111-111111111111');
set role authenticated;
select 'after' as stage, count(*) as visible from public.recipes where id = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
select kind from public.notifications;

\echo '--- 5. Thandi cannot edit Lerato''s recipe or add to it'
update public.recipes set title = 'hacked' where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
select title from public.recipes where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
\set ON_ERROR_STOP 0
insert into public.recipe_ingredients (recipe_id, position, raw_text) values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 9, 'sneaky');
update public.notifications set kind = 'weekly_roundup';
\set ON_ERROR_STOP 1
select public.mark_notifications_read();
select count(*) filter (where read_at is not null) as read from public.notifications;

\echo '--- 6. Search, collections, trending, food matching'
select title, save_count from public.search_recipes(q => 'curry');
select title from public.search_recipes(q => 'cape malay chiken');
select title from public.collection_recipes('under-r100');
reset role;
select internal.refresh_trending();
set role authenticated;
select title from public.trending_recipes();
select line, food_name, round(score::numeric,2) score from public.match_foods(array['2 onions, sliced','1 kg bone-in chicken thighs','3 tbsp Cape Malay curry powder','pinch of salt','1 bunch dhania, chopped','a splash of something']);

\echo '--- 7. Riaan saves his own version'
reset role;
select pg_temp.act('33333333-3333-4333-8333-333333333333');
set role authenticated;
select public.fork_recipe('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa') is not null as forked;
select title, status, visibility, ingredient_count, matched_lines, kcal_per_serving, (select count(*) from public.step_ingredients) as step_links from public.recipes where author_id = '33333333-3333-4333-8333-333333333333';

\echo '--- 8. Storage: own folder ok, someone else''s folder refused'
insert into storage.objects (bucket_id, name) values ('recipe-photos', '33333333-3333-4333-8333-333333333333/aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa/cover-1.jpg');
\set ON_ERROR_STOP 0
insert into storage.objects (bucket_id, name) values ('recipe-photos', '22222222-2222-4222-8222-222222222222/aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa/cover-2.jpg');
\set ON_ERROR_STOP 1

\echo '--- 9. Blocking ends the friendship and hides recipes'
reset role;
select pg_temp.act('22222222-2222-4222-8222-222222222222');
set role authenticated;
insert into public.blocks (blocked_id) values ('11111111-1111-4111-8111-111111111111');
reset role;
select pg_temp.act('11111111-1111-4111-8111-111111111111');
set role authenticated;
select count(*) as recipes_thandi_sees, (select count(*) from public.friendships) as friendships from public.recipes;

\echo '--- 10. Anonymous username check'
reset role;
set role anon;
select public.username_available('thandi.cooks') as free, public.username_available('thandinkosi') as taken;
reset role;
