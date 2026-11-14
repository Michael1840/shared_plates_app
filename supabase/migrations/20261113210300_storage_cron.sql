-- SharedPlates · storage buckets and scheduled jobs

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('recipe-photos', 'recipe-photos', false, 10485760, array['image/jpeg', 'image/png', 'image/webp', 'image/heic']),
  ('avatars',       'avatars',       true,  2097152,  array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

-- recipe-photos/{author_id}/{recipe_id}/cover-{hash}.jpg
create or replace function public.can_view_recipe_photo(object_name text)
returns boolean language plpgsql stable security definer set search_path = '' as $$
declare part text := split_part(object_name, '/', 2);
begin
  if part !~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then return false; end if;
  return public.can_view_recipe(part::uuid);
end $$;
revoke execute on function public.can_view_recipe_photo(text) from public, anon;
grant execute on function public.can_view_recipe_photo(text) to authenticated;

create policy "Recipe photos: read if you can see the recipe" on storage.objects for select to authenticated
  using (bucket_id = 'recipe-photos' and public.can_view_recipe_photo(name));
create policy "Recipe photos: upload to your folder" on storage.objects for insert to authenticated
  with check (bucket_id = 'recipe-photos' and split_part(name, '/', 1) = (select auth.uid())::text);
create policy "Recipe photos: replace your own" on storage.objects for update to authenticated
  using (bucket_id = 'recipe-photos' and split_part(name, '/', 1) = (select auth.uid())::text);
create policy "Recipe photos: delete your own" on storage.objects for delete to authenticated
  using (bucket_id = 'recipe-photos' and split_part(name, '/', 1) = (select auth.uid())::text);

create policy "Avatars: upload to your folder" on storage.objects for insert to authenticated
  with check (bucket_id = 'avatars' and split_part(name, '/', 1) = (select auth.uid())::text);
create policy "Avatars: replace your own" on storage.objects for update to authenticated
  using (bucket_id = 'avatars' and split_part(name, '/', 1) = (select auth.uid())::text);
create policy "Avatars: delete your own" on storage.objects for delete to authenticated
  using (bucket_id = 'avatars' and split_part(name, '/', 1) = (select auth.uid())::text);

-- Trending refreshes hourly; the round-up goes out Sundays at 19:00 SAST (17:00 UTC)
do $$
begin
  if exists (select 1 from pg_available_extensions where name = 'pg_cron') then
    create extension if not exists pg_cron;
    perform cron.schedule('sharedplates-refresh-trending', '7 * * * *', 'select internal.refresh_trending()');
    perform cron.schedule('sharedplates-weekly-roundup', '0 17 * * 0', 'select internal.weekly_roundup()');
  else
    raise notice 'pg_cron is not available; schedule internal.refresh_trending() and internal.weekly_roundup() yourself';
  end if;
end $$;
