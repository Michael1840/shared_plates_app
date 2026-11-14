-- SharedPlates · Row Level Security, views and API functions

-- ---------------------------------------------------------------- helpers for child tables
create or replace function public.step_recipe(sid uuid)
returns uuid language sql stable security definer set search_path = '' as $$
  select s.recipe_id from public.recipe_steps s where s.id = sid;
$$;

revoke execute on function public.are_friends(uuid, uuid), public.is_blocked(uuid, uuid),
  public.can_view_recipe(uuid), public.owns_recipe(uuid), public.step_recipe(uuid),
  public.fork_recipe(uuid) from public, anon;
grant execute on function public.are_friends(uuid, uuid), public.is_blocked(uuid, uuid),
  public.can_view_recipe(uuid), public.owns_recipe(uuid), public.step_recipe(uuid),
  public.fork_recipe(uuid) to authenticated;

-- ---------------------------------------------------------------- enable RLS everywhere
do $$
declare t text;
begin
  foreach t in array array['tags','units','foods','food_portions','collections','profiles','profile_tastes',
                           'hidden_foods','friendships','blocks','push_tokens','recipes','recipe_ingredients',
                           'recipe_steps','step_ingredients','recipe_tags','likes','saves','cooks',
                           'recently_viewed','shopping_ticks','notifications','reports']
  loop
    execute format('alter table public.%I enable row level security', t);
  end loop;
end $$;

-- reference data: readable by everyone, written only by the service role / dashboard
create policy "Anyone can read tags"        on public.tags          for select to anon, authenticated using (true);
create policy "Anyone can read units"       on public.units         for select to anon, authenticated using (true);
create policy "Anyone can read foods"       on public.foods         for select to anon, authenticated using (true);
create policy "Anyone can read portions"    on public.food_portions for select to anon, authenticated using (true);
create policy "Anyone can read collections" on public.collections   for select to anon, authenticated using (true);

-- profiles
create policy "Profiles are visible unless blocked" on public.profiles for select to authenticated
  using (id = (select auth.uid()) or not public.is_blocked(id, (select auth.uid())));
create policy "You can edit your profile" on public.profiles for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

-- own-row tables
create policy "Your tastes" on public.profile_tastes for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "Your hidden foods" on public.hidden_foods for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "Your blocks" on public.blocks for all to authenticated
  using (blocker_id = (select auth.uid())) with check (blocker_id = (select auth.uid()));
create policy "Your push tokens" on public.push_tokens for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- friendships
create policy "See your friendships" on public.friendships for select to authenticated
  using ((select auth.uid()) in (requester_id, addressee_id));
create policy "Send a request" on public.friendships for insert to authenticated
  with check (requester_id = (select auth.uid()));
create policy "Accept a request sent to you" on public.friendships for update to authenticated
  using (addressee_id = (select auth.uid())) with check (addressee_id = (select auth.uid()));
create policy "Remove or decline" on public.friendships for delete to authenticated
  using ((select auth.uid()) in (requester_id, addressee_id));

-- recipes
create policy "See recipes you're allowed to" on public.recipes for select to authenticated
  using (
    author_id = (select auth.uid())
    or (
      status = 'published' and deleted_at is null
      and not public.is_blocked(author_id, (select auth.uid()))
      and (visibility = 'public' or (visibility = 'friends' and public.are_friends(author_id, (select auth.uid()))))
    )
  );
create policy "Write your own recipes" on public.recipes for insert to authenticated
  with check (author_id = (select auth.uid()));
create policy "Edit your own recipes" on public.recipes for update to authenticated
  using (author_id = (select auth.uid())) with check (author_id = (select auth.uid()));
create policy "Delete your own recipes" on public.recipes for delete to authenticated
  using (author_id = (select auth.uid()));

-- recipe children
create policy "Read ingredients of visible recipes" on public.recipe_ingredients for select to authenticated
  using (public.can_view_recipe(recipe_id));
create policy "Write ingredients of your recipes" on public.recipe_ingredients for all to authenticated
  using (public.owns_recipe(recipe_id)) with check (public.owns_recipe(recipe_id));

create policy "Read steps of visible recipes" on public.recipe_steps for select to authenticated
  using (public.can_view_recipe(recipe_id));
create policy "Write steps of your recipes" on public.recipe_steps for all to authenticated
  using (public.owns_recipe(recipe_id)) with check (public.owns_recipe(recipe_id));

create policy "Read step links of visible recipes" on public.step_ingredients for select to authenticated
  using (public.can_view_recipe(public.step_recipe(step_id)));
create policy "Write step links of your recipes" on public.step_ingredients for all to authenticated
  using (public.owns_recipe(public.step_recipe(step_id))) with check (public.owns_recipe(public.step_recipe(step_id)));

create policy "Read tags of visible recipes" on public.recipe_tags for select to authenticated
  using (public.can_view_recipe(recipe_id));
create policy "Tag your recipes" on public.recipe_tags for all to authenticated
  using (public.owns_recipe(recipe_id)) with check (public.owns_recipe(recipe_id));

-- likes, saves, cooks, views, ticks: your rows, on recipes you can see
create policy "Your likes" on public.likes for select to authenticated using (user_id = (select auth.uid()));
create policy "Like what you can see" on public.likes for insert to authenticated
  with check (user_id = (select auth.uid()) and public.can_view_recipe(recipe_id));
create policy "Unlike" on public.likes for delete to authenticated using (user_id = (select auth.uid()));

create policy "Your saves" on public.saves for select to authenticated using (user_id = (select auth.uid()));
create policy "Save what you can see" on public.saves for insert to authenticated
  with check (user_id = (select auth.uid()) and public.can_view_recipe(recipe_id));
create policy "Unsave" on public.saves for delete to authenticated using (user_id = (select auth.uid()));

create policy "Your cooks" on public.cooks for select to authenticated using (user_id = (select auth.uid()));
create policy "Log a cook" on public.cooks for insert to authenticated
  with check (user_id = (select auth.uid()) and public.can_view_recipe(recipe_id));
create policy "Remove a cook" on public.cooks for delete to authenticated using (user_id = (select auth.uid()));

create policy "Your recently viewed" on public.recently_viewed for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()) and public.can_view_recipe(recipe_id));

create policy "Your shopping ticks" on public.shopping_ticks for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()) and public.can_view_recipe(recipe_id));

-- notifications: read yours, mark read, clear
create policy "Your notifications" on public.notifications for select to authenticated
  using (recipient_id = (select auth.uid()));
create policy "Mark yours read" on public.notifications for update to authenticated
  using (recipient_id = (select auth.uid())) with check (recipient_id = (select auth.uid()));
create policy "Clear yours" on public.notifications for delete to authenticated
  using (recipient_id = (select auth.uid()));
revoke update on public.notifications from authenticated;
grant update (read_at) on public.notifications to authenticated;

-- reports: write-only
create policy "Report something" on public.reports for insert to authenticated
  with check (reporter_id = (select auth.uid()));

-- ---------------------------------------------------------------- recipe cards (feeds, search, grids)
create or replace view public.recipe_cards with (security_invoker = true) as
select
  r.id, r.author_id, p.username as author_username, p.display_name as author_name, p.avatar_path as author_avatar,
  r.title, r.note, r.cover_path, r.cover_style, r.base_servings, r.total_minutes, r.visibility, r.status,
  r.kcal_per_serving, r.protein_g, r.carbs_g, r.fat_g, r.fibre_g, r.ingredient_count, r.matched_lines,
  r.cost_cents, r.cost_currency,
  case when r.cost_cents is null then null else round(r.cost_cents::numeric / r.base_servings)::int end as cost_per_plate,
  r.like_count, r.save_count, r.cook_count, r.forked_from_id, r.published_at, r.updated_at,
  exists (select 1 from public.likes l where l.recipe_id = r.id and l.user_id = (select auth.uid())) as is_liked,
  exists (select 1 from public.saves s where s.recipe_id = r.id and s.user_id = (select auth.uid())) as is_saved,
  r.author_id = (select auth.uid()) as is_mine
from public.recipes r
join public.profiles p on p.id = r.author_id
where r.deleted_at is null;

-- ---------------------------------------------------------------- search and browse
-- All of these run as the caller, so RLS decides what comes back.
create or replace function public.search_recipes(
  q                  text    default null,
  max_cost_per_plate integer default null,   -- cents
  max_total_cost     integer default null,   -- cents, whole recipe ("Under R100")
  max_minutes        integer default null,
  tag_slugs          text[]  default null,   -- any of
  scope              text    default 'everyone', -- everyone | friends | mine | saved
  sort               text    default 'most_saved', -- most_saved | newest | cheapest | quickest | relevance
  lim                integer default 20,
  off                integer default 0
)
returns setof public.recipe_cards
language sql stable security invoker set search_path = '' as $$
  with me as (select auth.uid() as id),
  query as (select case when nullif(btrim(q), '') is null then null
                        else websearch_to_tsquery('simple', q) end as tsq,
                   lower(nullif(btrim(q), '')) as raw)
  select c.*
  from public.recipe_cards c, me, query
  where (c.status = 'published' or (scope = 'mine' and c.is_mine))
    and (scope <> 'mine' or c.is_mine)
    and (scope <> 'friends' or public.are_friends(c.author_id, me.id))
    and (scope <> 'saved' or c.is_saved)
    and (query.raw is null
         or (select r.search from public.recipes r where r.id = c.id) @@ query.tsq
         or extensions.word_similarity(query.raw, lower(c.title)) > 0.4)
    and (max_cost_per_plate is null or c.cost_per_plate <= max_cost_per_plate)
    and (max_total_cost is null or c.cost_cents <= max_total_cost)
    and (max_minutes is null or c.total_minutes <= max_minutes)
    and (tag_slugs is null or exists (
          select 1 from public.recipe_tags rt join public.tags t on t.id = rt.tag_id
          where rt.recipe_id = c.id and t.slug = any (tag_slugs)))
    and not exists (
          select 1 from public.recipe_ingredients i join public.hidden_foods h on h.food_id = i.food_id
          where i.recipe_id = c.id and h.user_id = me.id)
  order by
    case when sort = 'relevance' and query.tsq is not null
         then ts_rank((select r.search from public.recipes r where r.id = c.id), query.tsq) end desc nulls last,
    case when sort = 'most_saved' then c.save_count end desc nulls last,
    case when sort = 'cheapest' then c.cost_per_plate end asc nulls last,
    case when sort = 'quickest' then c.total_minutes end asc nulls last,
    c.published_at desc nulls last
  limit least(lim, 50) offset off;
$$;

create or replace function public.collection_recipes(collection_slug text, lim integer default 20, off integer default 0)
returns setof public.recipe_cards
language sql stable security invoker set search_path = '' as $$
  select s.*
  from public.collections col,
  lateral public.search_recipes(
    null,
    (col.filter->>'max_cost_per_plate')::int,
    (col.filter->>'max_total_cost')::int,
    (col.filter->>'max_minutes')::int,
    case when col.filter ? 'tags' then array(select jsonb_array_elements_text(col.filter->'tags')) end,
    'everyone',
    coalesce(col.filter->>'sort', 'most_saved'),
    lim, off) s
  where col.slug = collection_slug;
$$;

create or replace function public.friends_feed(lim integer default 20, before timestamptz default null)
returns setof public.recipe_cards
language sql stable security invoker set search_path = '' as $$
  select c.* from public.recipe_cards c
  where c.status = 'published' and not c.is_mine
    and public.are_friends(c.author_id, (select auth.uid()))
    and (before is null or c.published_at < before)
  order by c.published_at desc
  limit least(lim, 50);
$$;

-- ---------------------------------------------------------------- trending
create materialized view internal.trending_scores as
select r.id as recipe_id,
       (coalesce(s.n, 0) * 3 + coalesce(k.n, 0) * 4 + coalesce(l.n, 0))::numeric as score
from public.recipes r
left join (select recipe_id, count(*) n from public.saves where created_at > now() - interval '7 days' group by 1) s on s.recipe_id = r.id
left join (select recipe_id, count(*) n from public.cooks where cooked_at  > now() - interval '7 days' group by 1) k on k.recipe_id = r.id
left join (select recipe_id, count(*) n from public.likes where created_at > now() - interval '7 days' group by 1) l on l.recipe_id = r.id
where r.status = 'published' and r.visibility = 'public' and r.deleted_at is null
  and coalesce(s.n, 0) + coalesce(k.n, 0) + coalesce(l.n, 0) > 0;
create unique index trending_scores_recipe on internal.trending_scores (recipe_id);

create or replace function internal.refresh_trending()
returns void language plpgsql security definer set search_path = '' as $$
begin
  refresh materialized view concurrently internal.trending_scores;
end $$;

create or replace function public.trending_ids(lim integer)
returns table (recipe_id uuid, score numeric)
language sql stable security definer set search_path = '' as $$
  select t.recipe_id, t.score from internal.trending_scores t order by t.score desc limit least(lim, 100);
$$;
revoke execute on function public.trending_ids(integer) from public, anon;
grant execute on function public.trending_ids(integer) to authenticated;

create or replace function public.trending_recipes(lim integer default 10)
returns setof public.recipe_cards
language sql stable security invoker set search_path = '' as $$
  select c.* from public.recipe_cards c
  join public.trending_ids(lim * 2) t on t.recipe_id = c.id
  order by t.score desc
  limit lim;
$$;



-- ---------------------------------------------------------------- creating: match pasted lines to foods
create or replace function public.match_foods(lines text[])
returns table (line text, food_id uuid, food_name text, score real)
language sql stable security invoker set search_path = '' as $$
  select l.line, m.id, m.name, m.score
  from unnest(lines) as l(line)
  left join lateral (
    select f.id, f.name, max(extensions.word_similarity(c.candidate, lower(l.line))) as score
    from public.foods f,
    lateral unnest(array[lower(f.name)] || (select array_agg(lower(a)) from unnest(f.aliases) a)) as c(candidate)
    where c.candidate is not null
    group by f.id, f.name
    having max(extensions.word_similarity(c.candidate, lower(l.line))) >= 0.6
    order by score desc, length(f.name) desc
    limit 1
  ) m on true;
$$;

-- ---------------------------------------------------------------- onboarding and people
create or replace function public.username_available(name text)
returns boolean language sql stable security definer set search_path = '' as $$
  select name ~ '^[a-z0-9._]{3,24}$'
     and not exists (select 1 from public.profiles p where p.username = name::extensions.citext);
$$;
revoke execute on function public.username_available(text) from public;
grant execute on function public.username_available(text) to anon, authenticated;

-- "Popular cooks for your tastes" on onboarding step 3
create or replace function public.popular_cooks(lim integer default 6)
returns table (id uuid, username extensions.citext, display_name text, avatar_path text, recipes bigint, saves bigint)
language sql stable security invoker set search_path = '' as $$
  select p.id, p.username, p.display_name, p.avatar_path, count(distinct r.id), sum(r.save_count)
  from public.profiles p
  join public.recipes r on r.author_id = p.id and r.status = 'published' and r.visibility = 'public' and r.deleted_at is null
  where p.id <> auth.uid()
    and not exists (select 1 from public.friendships f
                    where (f.requester_id = p.id and f.addressee_id = auth.uid())
                       or (f.addressee_id = p.id and f.requester_id = auth.uid()))
    and (
      not exists (select 1 from public.profile_tastes t where t.user_id = auth.uid())
      or exists (select 1 from public.recipe_tags rt join public.profile_tastes t on t.tag_id = rt.tag_id
                 where rt.recipe_id = r.id and t.user_id = auth.uid())
    )
  group by p.id
  order by sum(r.save_count) desc, count(distinct r.id) desc
  limit least(lim, 20);
$$;

create or replace function public.mark_notifications_read(ids uuid[] default null)
returns void language sql security invoker set search_path = '' as $$
  update public.notifications set read_at = now()
  where recipient_id = auth.uid() and read_at is null and (ids is null or id = any (ids));
$$;

-- ---------------------------------------------------------------- weekly round-up (Sundays)
create or replace function internal.weekly_roundup()
returns void language plpgsql security definer set search_path = '' as $$
begin
  insert into public.notifications (recipient_id, kind, data)
  select r.author_id, 'weekly_roundup',
         jsonb_build_object('saves', count(s.*), 'cooks', (
            select count(*) from public.cooks c join public.recipes r2 on r2.id = c.recipe_id
            where r2.author_id = r.author_id and c.cooked_at > now() - interval '7 days'))
  from public.saves s
  join public.recipes r on r.id = s.recipe_id
  join public.profiles p on p.id = r.author_id and p.weekly_roundup
  where s.created_at > now() - interval '7 days' and s.user_id <> r.author_id
  group by r.author_id
  having count(s.*) > 0;
end $$;
