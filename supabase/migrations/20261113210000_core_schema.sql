-- SharedPlates · core schema
-- Extensions, enums, tables and indexes. Functions, triggers and RLS follow in later migrations.

create extension if not exists citext with schema extensions;
create extension if not exists pg_trgm with schema extensions;

create schema if not exists internal;
revoke all on schema internal from public;

-- ---------------------------------------------------------------- enums
create type public.unit_system       as enum ('metric', 'imperial');
create type public.visibility        as enum ('private', 'friends', 'public');
create type public.friendship_status as enum ('pending', 'accepted');
create type public.cover_style       as enum ('stew', 'meat', 'veg', 'sweet', 'any');
create type public.recipe_status     as enum ('draft', 'published');
create type public.recipe_source     as enum ('typed', 'pasted');
create type public.tag_kind          as enum ('cuisine', 'diet', 'meal', 'occasion');
create type public.unit_kind         as enum ('mass', 'volume', 'count');
create type public.unit_scope        as enum ('metric', 'imperial', 'both');
create type public.notif_kind        as enum ('recipe_saved', 'recipe_cooked', 'friend_request', 'friend_accepted', 'weekly_roundup');
create type public.collection_kind   as enum ('mood', 'weekly');

-- array_to_string isn't immutable, so wrap it for the generated search column
create or replace function internal.food_search_text(name text, aliases text[])
returns text language sql immutable parallel safe set search_path = '' as $$
  select lower(name || ' ' || coalesce(array_to_string(aliases, ' '), ''));
$$;

-- ---------------------------------------------------------------- reference data
create table public.tags (
  id          smallint generated always as identity primary key,
  slug        text not null unique check (slug ~ '^[a-z0-9-]+$'),
  label       text not null,
  kind        public.tag_kind not null,
  cover_style public.cover_style not null default 'any',
  position    smallint not null default 0,
  updated_at  timestamptz not null default now()
);

create table public.units (
  code      text primary key,
  label     text not null,
  kind      public.unit_kind not null,
  scope     public.unit_scope not null,
  to_base   numeric not null check (to_base > 0),   -- grams for mass, ml for volume, 1 for count
  updated_at timestamptz not null default now()
);

create table public.foods (
  id              uuid primary key default gen_random_uuid(),
  name            text not null,
  aliases         text[] not null default '{}',
  category        text,
  kcal_100g       numeric(7,2) not null default 0,
  protein_100g    numeric(6,2) not null default 0,
  carbs_100g      numeric(6,2) not null default 0,
  fat_100g        numeric(6,2) not null default 0,
  fibre_100g      numeric(6,2) not null default 0,
  sugar_100g      numeric(6,2),
  sodium_mg_100g  numeric(8,2),
  density_g_ml    numeric(6,3),                      -- converts volume to grams
  source          text not null default 'starter',
  search_text     text generated always as (internal.food_search_text(name, aliases)) stored,
  updated_at      timestamptz not null default now(),
  unique (name)
);
create index foods_search_trgm on public.foods using gin (search_text extensions.gin_trgm_ops);
create index foods_updated_at on public.foods (updated_at);

create table public.food_portions (
  food_id    uuid not null references public.foods (id) on delete cascade,
  label      text not null,                          -- clove, medium, cup chopped
  grams      numeric(8,2) not null check (grams > 0),
  is_default boolean not null default false,         -- used for "2 onions"
  updated_at timestamptz not null default now(),
  primary key (food_id, label)
);
create unique index food_portions_one_default on public.food_portions (food_id) where is_default;

-- ---------------------------------------------------------------- people
create table public.profiles (
  id                  uuid primary key references auth.users (id) on delete cascade,
  username            extensions.citext not null unique check (username ~ '^[a-z0-9._]{3,24}$'),
  display_name        text not null check (char_length(display_name) between 1 and 60),
  avatar_path         text,
  bio                 text check (char_length(bio) <= 160),
  city                text check (char_length(city) <= 60),
  units               public.unit_system not null default 'metric',
  currency            char(3) not null default 'ZAR',
  default_visibility  public.visibility not null default 'friends',
  keep_screen_on      boolean not null default true,
  notify_saves        boolean not null default true,
  notify_cooks        boolean not null default true,
  notify_friends      boolean not null default true,
  weekly_roundup      boolean not null default true,
  onboarded_at        timestamptz,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
create index profiles_display_name_trgm on public.profiles using gin (lower(display_name) extensions.gin_trgm_ops);

create table public.profile_tastes (
  user_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  tag_id  smallint not null references public.tags (id) on delete cascade,
  primary key (user_id, tag_id)
);

create table public.hidden_foods (
  user_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  food_id uuid not null references public.foods (id) on delete cascade,
  primary key (user_id, food_id)
);

create table public.friendships (
  requester_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  addressee_id uuid not null references public.profiles (id) on delete cascade,
  status       public.friendship_status not null default 'pending',
  created_at   timestamptz not null default now(),
  accepted_at  timestamptz,
  updated_at   timestamptz not null default now(),
  primary key (requester_id, addressee_id),
  check (requester_id <> addressee_id)
);
create unique index friendships_one_per_pair on public.friendships (least(requester_id, addressee_id), greatest(requester_id, addressee_id));
create index friendships_addressee on public.friendships (addressee_id, status);

create table public.blocks (
  blocker_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  blocked_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);
create index blocks_blocked on public.blocks (blocked_id);

create table public.push_tokens (
  token      text primary key,
  user_id    uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  platform   text not null check (platform in ('ios', 'android', 'huawei')),
  updated_at timestamptz not null default now()
);
create index push_tokens_user on public.push_tokens (user_id);

-- ---------------------------------------------------------------- recipes
create table public.recipes (
  id                uuid primary key default gen_random_uuid(),   -- clients may send their own UUID v7
  author_id         uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  forked_from_id    uuid references public.recipes (id) on delete set null,
  title             text not null default '' check (char_length(title) <= 120),
  note              text check (char_length(note) <= 280),
  cover_path        text,
  cover_style       public.cover_style not null default 'any',
  base_servings     smallint not null default 4 check (base_servings between 1 and 48),
  total_minutes     smallint check (total_minutes between 1 and 2880),
  visibility        public.visibility not null default 'friends',
  status            public.recipe_status not null default 'draft',
  source            public.recipe_source not null default 'typed',
  source_text       text,
  -- worked out by recalc_recipe(); clients can't write these
  kcal_per_serving  numeric(8,1),
  protein_g         numeric(7,1),
  carbs_g           numeric(7,1),
  fat_g             numeric(7,1),
  fibre_g           numeric(7,1),
  ingredient_count  smallint not null default 0,
  matched_lines     smallint not null default 0,
  cost_cents        integer,
  cost_currency     char(3) not null default 'ZAR',
  like_count        integer not null default 0,
  save_count        integer not null default 0,
  cook_count        integer not null default 0,
  search            tsvector,
  published_at      timestamptz,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  deleted_at        timestamptz,
  constraint recipes_publishable check (status = 'draft' or char_length(btrim(title)) > 0)
);
create index recipes_author on public.recipes (author_id, updated_at desc);
create index recipes_public_recent on public.recipes (published_at desc) where status = 'published' and deleted_at is null;
create index recipes_updated_at on public.recipes (updated_at);
create index recipes_search on public.recipes using gin (search);
create index recipes_title_trgm on public.recipes using gin (lower(title) extensions.gin_trgm_ops);
create index recipes_forked_from on public.recipes (forked_from_id) where forked_from_id is not null;

create table public.recipe_ingredients (
  id            uuid primary key default gen_random_uuid(),
  recipe_id     uuid not null references public.recipes (id) on delete cascade,
  position      smallint not null,
  section       text check (char_length(section) <= 60),
  raw_text      text not null check (char_length(raw_text) between 1 and 200),
  quantity      numeric(10,3) check (quantity > 0),       -- for base_servings
  unit          text references public.units (code),
  portion_label text,                                      -- clove, medium; matches food_portions.label
  food_id       uuid references public.foods (id) on delete set null,
  prep_note     text check (char_length(prep_note) <= 80),
  grams         numeric(10,2),                             -- worked out by trigger
  cost_cents    integer check (cost_cents >= 0),           -- author's own price for this line
  optional      boolean not null default false,
  updated_at    timestamptz not null default now()
);
create index recipe_ingredients_recipe on public.recipe_ingredients (recipe_id, position);
create index recipe_ingredients_food on public.recipe_ingredients (food_id) where food_id is not null;

create table public.recipe_steps (
  id            uuid primary key default gen_random_uuid(),
  recipe_id     uuid not null references public.recipes (id) on delete cascade,
  position      smallint not null,
  body          text not null check (char_length(body) between 1 and 2000),
  timer_seconds integer check (timer_seconds between 1 and 86400),
  updated_at    timestamptz not null default now()
);
create index recipe_steps_recipe on public.recipe_steps (recipe_id, position);

create table public.step_ingredients (
  step_id       uuid not null references public.recipe_steps (id) on delete cascade,
  ingredient_id uuid not null references public.recipe_ingredients (id) on delete cascade,
  primary key (step_id, ingredient_id)
);
create index step_ingredients_ingredient on public.step_ingredients (ingredient_id);

create table public.recipe_tags (
  recipe_id uuid not null references public.recipes (id) on delete cascade,
  tag_id    smallint not null references public.tags (id) on delete cascade,
  primary key (recipe_id, tag_id)
);
create index recipe_tags_tag on public.recipe_tags (tag_id);

-- ---------------------------------------------------------------- activity
create table public.likes (
  user_id    uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  recipe_id  uuid not null references public.recipes (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, recipe_id)
);
create index likes_recipe on public.likes (recipe_id, created_at);

create table public.saves (
  user_id    uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  recipe_id  uuid not null references public.recipes (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, recipe_id)
);
create index saves_recipe on public.saves (recipe_id, created_at);

create table public.cooks (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  recipe_id    uuid not null references public.recipes (id) on delete cascade,
  servings     smallint check (servings between 1 and 48),
  told_creator boolean not null default false,
  cooked_at    timestamptz not null default now()
);
create index cooks_recipe on public.cooks (recipe_id, cooked_at);
create index cooks_user on public.cooks (user_id, cooked_at desc);

create table public.recently_viewed (
  user_id   uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  recipe_id uuid not null references public.recipes (id) on delete cascade,
  viewed_at timestamptz not null default now(),
  primary key (user_id, recipe_id)
);
create index recently_viewed_user on public.recently_viewed (user_id, viewed_at desc);

create table public.shopping_ticks (
  user_id       uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  ingredient_id uuid not null references public.recipe_ingredients (id) on delete cascade,
  recipe_id     uuid not null references public.recipes (id) on delete cascade,
  ticked_at     timestamptz not null default now(),
  primary key (user_id, ingredient_id)
);
create index shopping_ticks_recipe on public.shopping_ticks (user_id, recipe_id);

create table public.notifications (
  id           uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references public.profiles (id) on delete cascade,
  actor_id     uuid references public.profiles (id) on delete cascade,
  kind         public.notif_kind not null,
  recipe_id    uuid references public.recipes (id) on delete cascade,
  data         jsonb not null default '{}',
  read_at      timestamptz,
  created_at   timestamptz not null default now()
);
create index notifications_recipient on public.notifications (recipient_id, created_at desc);
create index notifications_unread on public.notifications (recipient_id) where read_at is null;

create table public.reports (
  id          uuid primary key default gen_random_uuid(),
  reporter_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  recipe_id   uuid references public.recipes (id) on delete set null,
  user_id     uuid references public.profiles (id) on delete set null,
  reason      text not null check (char_length(reason) between 1 and 500),
  created_at  timestamptz not null default now(),
  resolved_at timestamptz,
  check (recipe_id is not null or user_id is not null)
);

-- ---------------------------------------------------------------- discover
create table public.collections (
  id         uuid primary key default gen_random_uuid(),
  slug       text not null unique check (slug ~ '^[a-z0-9-]+$'),
  title      text not null,
  subtitle   text,
  kind       public.collection_kind not null,
  filter     jsonb not null default '{}',   -- {"max_cost_per_plate":10000,"max_minutes":20,"tags":["braai"]}
  position   smallint not null default 0,
  starts_on  date,
  ends_on    date,
  updated_at timestamptz not null default now()
);
