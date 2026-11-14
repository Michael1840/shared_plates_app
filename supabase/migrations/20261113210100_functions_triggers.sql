-- SharedPlates · functions and triggers

-- ---------------------------------------------------------------- updated_at
create or replace function internal.set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end $$;

do $$
declare t text;
begin
  foreach t in array array['tags','units','foods','food_portions','profiles','friendships','push_tokens',
                           'recipes','recipe_ingredients','recipe_steps','collections']
  loop
    execute format('create trigger set_updated_at before update on public.%I
                    for each row execute function internal.set_updated_at()', t);
  end loop;
end $$;

-- ---------------------------------------------------------------- new user → profile
-- Apple and Google send full_name / name; email sign-in sends neither.
create or replace function internal.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  meta  jsonb := coalesce(new.raw_user_meta_data, '{}');
  name  text  := coalesce(nullif(meta->>'full_name', ''), nullif(meta->>'name', ''), split_part(coalesce(new.email, 'cook'), '@', 1));
  base  text  := left(regexp_replace(lower(coalesce(nullif(meta->>'preferred_username', ''), name)), '[^a-z0-9._]+', '', 'g'), 18);
  uname text;
begin
  if char_length(base) < 3 then base := 'cook'; end if;
  uname := base;
  while exists (select 1 from public.profiles where username = uname::extensions.citext) loop
    uname := base || floor(random() * 9000 + 1000)::int;
  end loop;
  insert into public.profiles (id, username, display_name)
  values (new.id, uname, left(name, 60));
  return new;
end $$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function internal.handle_new_user();

-- ---------------------------------------------------------------- relationship helpers
create or replace function public.are_friends(a uuid, b uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.friendships f
    where f.status = 'accepted'
      and least(f.requester_id, f.addressee_id) = least(a, b)
      and greatest(f.requester_id, f.addressee_id) = greatest(a, b)
  );
$$;

create or replace function public.is_blocked(a uuid, b uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.blocks k
    where (k.blocker_id = a and k.blocked_id = b) or (k.blocker_id = b and k.blocked_id = a)
  );
$$;

-- One place for "may the signed-in user see this recipe?"
create or replace function public.can_view_recipe(rid uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.recipes r
    where r.id = rid
      and (
        r.author_id = auth.uid()
        or (
          r.status = 'published' and r.deleted_at is null
          and not public.is_blocked(r.author_id, auth.uid())
          and (
            r.visibility = 'public'
            or (r.visibility = 'friends' and public.are_friends(r.author_id, auth.uid()))
          )
        )
      )
  );
$$;

create or replace function public.owns_recipe(rid uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.recipes r where r.id = rid and r.author_id = auth.uid());
$$;

-- ---------------------------------------------------------------- ingredient grams
-- quantity + unit (+ portion) + food → grams, so nutrition can be summed.
create or replace function internal.ingredient_grams(q numeric, u text, portion text, fid uuid)
returns numeric language plpgsql stable set search_path = '' as $$
declare
  k public.unit_kind; base numeric; dens numeric; pg numeric;
begin
  if fid is null or q is null then return null; end if;
  if u is not null then
    select un.kind, un.to_base into k, base from public.units un where un.code = u;
    if k = 'mass' then return round(q * base, 2); end if;
    if k = 'volume' then
      select f.density_g_ml into dens from public.foods f where f.id = fid;
      return round(q * base * coalesce(dens, 1), 2);
    end if;
  end if;
  -- counted: "2 cloves garlic", "3 onions"
  select p.grams into pg from public.food_portions p
   where p.food_id = fid and (p.label = coalesce(portion, u) or (portion is null and (u is null or u = 'each') and p.is_default))
   order by (p.label = coalesce(portion, u)) desc
   limit 1;
  return case when pg is null then null else round(q * pg, 2) end;
end $$;

create or replace function internal.ingredients_before_write()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  new.grams := internal.ingredient_grams(new.quantity, new.unit, new.portion_label, new.food_id);
  return new;
end $$;

create trigger compute_grams
  before insert or update of quantity, unit, portion_label, food_id on public.recipe_ingredients
  for each row execute function internal.ingredients_before_write();

-- ---------------------------------------------------------------- recipe totals
create or replace function internal.recalc_recipe(rid uuid)
returns void language plpgsql security definer set search_path = '' as $$
declare
  srv smallint;
begin
  select base_servings into srv from public.recipes where id = rid;
  if srv is null then return; end if;

  update public.recipes r set
    kcal_per_serving = round(t.kcal / srv, 1),
    protein_g        = round(t.protein / srv, 1),
    carbs_g          = round(t.carbs / srv, 1),
    fat_g            = round(t.fat / srv, 1),
    fibre_g          = round(t.fibre / srv, 1),
    ingredient_count = t.lines,
    matched_lines    = t.matched,
    cost_cents       = t.cost,
    search           = setweight(to_tsvector('simple', coalesce(r.title, '')), 'A')
                    || setweight(to_tsvector('simple', coalesce(t.tag_words, '')), 'B')
                    || setweight(to_tsvector('simple', coalesce(t.food_words, '')), 'C')
  from (
    select
      coalesce(sum(i.grams * f.kcal_100g    / 100), 0) as kcal,
      coalesce(sum(i.grams * f.protein_100g / 100), 0) as protein,
      coalesce(sum(i.grams * f.carbs_100g   / 100), 0) as carbs,
      coalesce(sum(i.grams * f.fat_100g     / 100), 0) as fat,
      coalesce(sum(i.grams * f.fibre_100g   / 100), 0) as fibre,
      count(i.id)::smallint                                          as lines,
      count(i.id) filter (where i.grams is not null)::smallint       as matched,
      sum(i.cost_cents)::int                                         as cost,
      string_agg(coalesce(f.name, i.raw_text), ' ')                  as food_words,
      (select string_agg(tg.label, ' ') from public.recipe_tags rt join public.tags tg on tg.id = rt.tag_id where rt.recipe_id = rid) as tag_words
    from public.recipe_ingredients i
    left join public.foods f on f.id = i.food_id
    where i.recipe_id = rid
  ) t
  where r.id = rid;
end $$;

create or replace function internal.after_ingredient_change()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if tg_op in ('UPDATE', 'DELETE') then perform internal.recalc_recipe(old.recipe_id); end if;
  if tg_op in ('INSERT', 'UPDATE') and (tg_op = 'INSERT' or new.recipe_id <> old.recipe_id) then
    perform internal.recalc_recipe(new.recipe_id);
  end if;
  return null;
end $$;

create trigger recalc_on_ingredients
  after insert or update or delete on public.recipe_ingredients
  for each row execute function internal.after_ingredient_change();

create or replace function internal.after_recipe_tag_change()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  perform internal.recalc_recipe(coalesce(new.recipe_id, old.recipe_id));
  return null;
end $$;

create trigger recalc_on_tags
  after insert or delete on public.recipe_tags
  for each row execute function internal.after_recipe_tag_change();

create or replace function internal.after_recipe_change()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if tg_op = 'INSERT' or new.base_servings is distinct from old.base_servings or new.title is distinct from old.title then
    perform internal.recalc_recipe(new.id);
  end if;
  return null;
end $$;

create trigger recalc_on_recipe
  after insert or update of base_servings, title on public.recipes
  for each row execute function internal.after_recipe_change();

-- Re-match grams when a food's density or portions change
create or replace function internal.after_food_change()
returns trigger language plpgsql security definer set search_path = '' as $$
declare fid uuid := coalesce(new.food_id, old.food_id);
begin
  update public.recipe_ingredients set food_id = food_id where food_id = fid;
  return null;
end $$;

create trigger regrams_on_portion
  after insert or update or delete on public.food_portions
  for each row execute function internal.after_food_change();

-- ---------------------------------------------------------------- protect worked-out recipe columns
-- Authors can edit their recipe, but never counts, nutrition, cost or publish time.
create or replace function internal.protect_recipe()
returns trigger language plpgsql set search_path = '' as $$
begin
  if current_user in ('authenticated', 'anon') then
    if tg_op = 'INSERT' then
      new.author_id := auth.uid();
      new.like_count := 0; new.save_count := 0; new.cook_count := 0;
      new.kcal_per_serving := null; new.protein_g := null; new.carbs_g := null; new.fat_g := null; new.fibre_g := null;
      new.ingredient_count := 0; new.matched_lines := 0; new.cost_cents := null; new.search := null;
      new.published_at := null;
    else
      new.author_id := old.author_id;
      new.like_count := old.like_count; new.save_count := old.save_count; new.cook_count := old.cook_count;
      new.kcal_per_serving := old.kcal_per_serving; new.protein_g := old.protein_g; new.carbs_g := old.carbs_g;
      new.fat_g := old.fat_g; new.fibre_g := old.fibre_g; new.ingredient_count := old.ingredient_count;
      new.matched_lines := old.matched_lines; new.cost_cents := old.cost_cents; new.search := old.search;
      new.published_at := old.published_at; new.created_at := old.created_at;
    end if;
  end if;
  if new.status = 'published' and new.published_at is null then
    new.published_at := now();
  end if;
  return new;
end $$;

create trigger protect_recipe
  before insert or update on public.recipes
  for each row execute function internal.protect_recipe();

-- Copy into the reader's own recipes ("Save my version")
create or replace function public.fork_recipe(rid uuid)
returns uuid language plpgsql security definer set search_path = '' as $$
declare
  me uuid := auth.uid();
  fork_id uuid := gen_random_uuid();
  src public.recipes;
begin
  if me is null then raise exception 'Sign in to save your own version'; end if;
  if not public.can_view_recipe(rid) then raise exception 'Recipe not found' using errcode = 'P0002'; end if;
  select * into src from public.recipes where id = rid;

  insert into public.recipes (id, author_id, forked_from_id, title, note, cover_path, cover_style, base_servings,
                              total_minutes, visibility, status, source)
  values (fork_id, me, rid, src.title, null, src.cover_path, src.cover_style, src.base_servings,
          src.total_minutes, 'private', 'draft', 'typed');

  create temporary table if not exists _map (old_id uuid, new_id uuid) on commit drop;
  delete from pg_temp._map;
  insert into pg_temp._map select i.id, gen_random_uuid() from public.recipe_ingredients i where i.recipe_id = rid;
  insert into public.recipe_ingredients (id, recipe_id, position, section, raw_text, quantity, unit, portion_label,
                                         food_id, prep_note, cost_cents, optional)
  select m.new_id, fork_id, i.position, i.section, i.raw_text, i.quantity, i.unit, i.portion_label,
         i.food_id, i.prep_note, i.cost_cents, i.optional
  from public.recipe_ingredients i join pg_temp._map m on m.old_id = i.id;

  create temporary table if not exists _smap (old_id uuid, new_id uuid) on commit drop;
  delete from pg_temp._smap;
  insert into pg_temp._smap select s.id, gen_random_uuid() from public.recipe_steps s where s.recipe_id = rid;
  insert into public.recipe_steps (id, recipe_id, position, body, timer_seconds)
  select m.new_id, fork_id, s.position, s.body, s.timer_seconds
  from public.recipe_steps s join pg_temp._smap m on m.old_id = s.id;

  insert into public.step_ingredients (step_id, ingredient_id)
  select sm.new_id, im.new_id
  from public.step_ingredients si
  join pg_temp._smap sm on sm.old_id = si.step_id
  join pg_temp._map im on im.old_id = si.ingredient_id;

  insert into public.recipe_tags (recipe_id, tag_id)
  select fork_id, rt.tag_id from public.recipe_tags rt where rt.recipe_id = rid;

  return fork_id;
end $$;

-- ---------------------------------------------------------------- counters and notifications
create or replace function internal.after_like()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  update public.recipes set like_count = greatest(like_count + case when tg_op = 'INSERT' then 1 else -1 end, 0)
  where id = coalesce(new.recipe_id, old.recipe_id);
  return null;
end $$;

create trigger count_likes after insert or delete on public.likes
  for each row execute function internal.after_like();

create or replace function internal.after_save()
returns trigger language plpgsql security definer set search_path = '' as $$
declare author uuid;
begin
  update public.recipes set save_count = greatest(save_count + case when tg_op = 'INSERT' then 1 else -1 end, 0)
  where id = coalesce(new.recipe_id, old.recipe_id)
  returning author_id into author;

  if tg_op = 'INSERT' and author is not null and author <> new.user_id then
    -- one "saved" notification per person per recipe, even if they unsave and save again
    insert into public.notifications (recipient_id, actor_id, kind, recipe_id)
    select author, new.user_id, 'recipe_saved', new.recipe_id
    where exists (select 1 from public.profiles p where p.id = author and p.notify_saves)
      and not exists (select 1 from public.notifications n
                      where n.recipient_id = author and n.actor_id = new.user_id
                        and n.kind = 'recipe_saved' and n.recipe_id = new.recipe_id);
  end if;
  return null;
end $$;

create trigger count_saves after insert or delete on public.saves
  for each row execute function internal.after_save();

create or replace function internal.after_cook()
returns trigger language plpgsql security definer set search_path = '' as $$
declare author uuid;
begin
  update public.recipes set cook_count = greatest(cook_count + case when tg_op = 'INSERT' then 1 else -1 end, 0)
  where id = coalesce(new.recipe_id, old.recipe_id)
  returning author_id into author;

  if tg_op = 'INSERT' and new.told_creator and author is not null and author <> new.user_id then
    insert into public.notifications (recipient_id, actor_id, kind, recipe_id, data)
    select author, new.user_id, 'recipe_cooked', new.recipe_id, jsonb_build_object('servings', new.servings)
    where exists (select 1 from public.profiles p where p.id = author and p.notify_cooks);
  end if;
  return null;
end $$;

create trigger count_cooks after insert or delete on public.cooks
  for each row execute function internal.after_cook();

-- Friend requests: requester sends, addressee accepts; nothing else may change
create or replace function internal.guard_friendship()
returns trigger language plpgsql set search_path = '' as $$
begin
  if tg_op = 'INSERT' then
    if current_user in ('authenticated', 'anon') then
      new.requester_id := auth.uid();
      new.status := 'pending';
    end if;
    new.accepted_at := case when new.status = 'accepted' then now() end;
    if public.is_blocked(new.requester_id, new.addressee_id) then
      raise exception 'Can''t send a request to this person';
    end if;
  else
    if new.requester_id <> old.requester_id or new.addressee_id <> old.addressee_id then
      raise exception 'Only the status of a friendship can change';
    end if;
    if old.status = 'accepted' and new.status = 'pending' then
      raise exception 'Remove the friend instead';
    end if;
    if new.status = 'accepted' and old.status = 'pending' then
      new.accepted_at := now();
    end if;
  end if;
  return new;
end $$;

create trigger guard_friendship before insert or update on public.friendships
  for each row execute function internal.guard_friendship();

create or replace function internal.after_friendship()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if tg_op = 'INSERT' and new.status = 'pending' then
    insert into public.notifications (recipient_id, actor_id, kind)
    select new.addressee_id, new.requester_id, 'friend_request'
    where exists (select 1 from public.profiles p where p.id = new.addressee_id and p.notify_friends);
  elsif tg_op = 'UPDATE' and old.status = 'pending' and new.status = 'accepted' then
    insert into public.notifications (recipient_id, actor_id, kind)
    select new.requester_id, new.addressee_id, 'friend_accepted'
    where exists (select 1 from public.profiles p where p.id = new.requester_id and p.notify_friends);
    -- the request notification has done its job
    delete from public.notifications
     where recipient_id = new.addressee_id and actor_id = new.requester_id and kind = 'friend_request';
  end if;
  return null;
end $$;

create trigger after_friendship after insert or update on public.friendships
  for each row execute function internal.after_friendship();

-- Blocking someone ends the friendship
create or replace function internal.after_block()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  delete from public.friendships
   where least(requester_id, addressee_id) = least(new.blocker_id, new.blocked_id)
     and greatest(requester_id, addressee_id) = greatest(new.blocker_id, new.blocked_id);
  return null;
end $$;

create trigger after_block after insert on public.blocks
  for each row execute function internal.after_block();

-- Keep "Jump back in" short: 30 most recent per person
create or replace function internal.trim_recently_viewed()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  delete from public.recently_viewed rv
   where rv.user_id = new.user_id
     and rv.recipe_id in (select recipe_id from public.recently_viewed
                           where user_id = new.user_id order by viewed_at desc offset 30);
  return null;
end $$;

create trigger trim_recently_viewed after insert on public.recently_viewed
  for each row execute function internal.trim_recently_viewed();

-- shopping_ticks.recipe_id must match the ingredient's recipe
create or replace function internal.shopping_tick_recipe()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  select i.recipe_id into new.recipe_id from public.recipe_ingredients i where i.id = new.ingredient_id;
  return new;
end $$;

create trigger shopping_tick_recipe before insert or update on public.shopping_ticks
  for each row execute function internal.shopping_tick_recipe();
