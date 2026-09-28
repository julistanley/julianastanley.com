-- =============================================================================
-- julianastanley.com — initial schema
--
-- Run this once in the Supabase dashboard: SQL Editor -> New query -> paste ->
-- Run. Then run 0002_seed.sql the same way.
--
-- Design summary
--   entries        every piece of text on the site. kind 'page' (about,
--                  publications, teaching, ...), 'post' (blog), or 'news'
--                  (one-liners on the front page). body is Markdown.
--   entry_history  the previous version of a row on every change, written by
--                  a trigger. This is the undo log; nothing is ever lost.
--   app_admins     the email addresses allowed to write. Everyone else
--                  (including anonymous visitors) can only read published
--                  entries.
--
-- Unlike stuff-to-investigate there are no signups here: the one account is
-- created by hand in the dashboard (Authentication -> Users -> Add user) and
-- "Allow new users to sign up" is turned OFF in Auth settings. app_admins is
-- a second line of defense on top of that.
-- =============================================================================

-- 'setting' rows are not pages: they hold site chrome the frontend reads by
-- slug ('site-title', 'tagline', 'footer'), editable at /admin/ like the rest.
create type public.entry_kind as enum ('page', 'post', 'news', 'setting');

create table public.entries (
  id           uuid primary key default gen_random_uuid(),
  kind         public.entry_kind not null,
  -- The URL: pages at /<slug>/, posts at /blog/<slug>/. News slugs are only
  -- used internally. Lowercase so old mixed-case Jekyll URLs match simply.
  -- Names of the repo's real directories are reserved (a page slug 'admin'
  -- would otherwise collide with the admin app when routes are baked).
  slug         text not null unique check (
                 slug ~ '^[a-z0-9][a-z0-9_-]*$'
                 and slug not in ('admin', 'assets', 'css', 'js', 'snapshots',
                                  'scripts', 'supabase', 'redirect-site',
                                  'index.html')
               ),
  title        text not null default '',
  description  text not null default '',   -- one-liner under post titles
  date         date,                        -- posts and news
  nav_order    integer,                     -- pages: position in the nav bar
                                            -- (null = not in the nav)
  published    boolean not null default true,
  body         text not null default '',    -- Markdown
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create table public.entry_history (
  id          bigint generated always as identity primary key,
  entry_id    uuid not null,               -- not a FK: survives a delete
  op          text not null check (op in ('insert', 'update', 'delete')),
  data        jsonb not null,              -- the row as it was BEFORE the change
                                           -- (for 'insert', the row as created)
  changed_by  uuid,
  changed_at  timestamptz not null default now()
);
create index entry_history_entry_idx on public.entry_history (entry_id, changed_at desc);

create table public.app_admins (
  email text primary key check (email = lower(email))
);

-- The login allowed to edit the site. Add more rows for more editors.
insert into public.app_admins (email) values ('julianastanley25@gmail.com');


-- ---------- Helper -------------------------------------------------------------
-- SECURITY DEFINER so it can read app_admins without needing a policy on it.
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.app_admins
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;


-- ---------- Trigger: bookkeeping -----------------------------------------------
create or replace function public.entries_bookkeeping()
returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' then
    new.created_at := now();
  else
    new.created_at := old.created_at;      -- immutable
  end if;
  new.updated_at := now();
  return new;
end;
$$;

create trigger entries_bookkeeping
  before insert or update on public.entries
  for each row execute function public.entries_bookkeeping();


-- ---------- Trigger: write history ---------------------------------------------
create or replace function public.entries_record_history()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if tg_op = 'INSERT' then
    insert into public.entry_history (entry_id, op, data, changed_by)
    values (new.id, 'insert', to_jsonb(new), auth.uid());
    return new;
  elsif tg_op = 'UPDATE' then
    -- Skip no-op updates so the history stays meaningful.
    if row(new.kind, new.slug, new.title, new.description, new.date,
           new.nav_order, new.published, new.body)
       is not distinct from
       row(old.kind, old.slug, old.title, old.description, old.date,
           old.nav_order, old.published, old.body) then
      return new;
    end if;
    insert into public.entry_history (entry_id, op, data, changed_by)
    values (old.id, 'update', to_jsonb(old), auth.uid());
    return new;
  else
    insert into public.entry_history (entry_id, op, data, changed_by)
    values (old.id, 'delete', to_jsonb(old), auth.uid());
    return old;
  end if;
end;
$$;

create trigger entries_history
  after insert or update or delete on public.entries
  for each row execute function public.entries_record_history();


-- ---------- Row Level Security --------------------------------------------------
alter table public.entries       enable row level security;
alter table public.entry_history enable row level security;
alter table public.app_admins    enable row level security;
-- app_admins has no policies at all: it is only read inside is_admin().

-- The whole point of the site: anyone may read published entries.
create policy "entries: anyone reads published"
  on public.entries for select
  using (published or public.is_admin());

create policy "entries: admin insert"
  on public.entries for insert with check (public.is_admin());
create policy "entries: admin update"
  on public.entries for update using (public.is_admin()) with check (public.is_admin());
create policy "entries: admin delete"
  on public.entries for delete using (public.is_admin());

-- History is admin-only (drafts may contain unpublished text); rows are
-- written by the trigger above, never directly.
create policy "history: admin read"
  on public.entry_history for select using (public.is_admin());
