-- =============================================================================
-- 0004: 'setting' entry kind — the site headline, tagline, and footer become
-- ordinary editable rows.
--
-- Postgres cannot add an enum value and use it in the same transaction, so
-- this is split in two: run THIS file first, then 0005_settings_seed.sql as a
-- SEPARATE query. Safe on any database (IF NOT EXISTS).
-- =============================================================================

alter type public.entry_kind add value if not exists 'setting';
