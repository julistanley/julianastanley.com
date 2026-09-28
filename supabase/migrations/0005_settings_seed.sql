-- =============================================================================
-- 0005: the three site-chrome settings, as editable rows. Run AFTER (and
-- separately from) 0004_settings.sql. Safe to re-run: existing rows are kept.
--
-- The frontend reads these by slug; edit their *body* at /admin/ to change
-- the header and footer of every page. Deleting one just brings back the
-- built-in default.
-- =============================================================================

insert into public.entries (kind, slug, title, description, published, body)
values
  ('setting', 'site-title', 'site title',
   'The headline at the top of every page (plain text).',
   true, 'Juliana (Juli) Stanley'),
  ('setting', 'tagline', 'tagline',
   'The line under the headline (plain text; empty hides it).',
   true, '(Computational) Biologist and PhD Student, MIT'),
  ('setting', 'footer', 'footer',
   'Markdown. {year} becomes the current year; "last updated" and the admin link are appended automatically.',
   true, '© {year} Juliana Stanley')
on conflict (slug) do nothing;
