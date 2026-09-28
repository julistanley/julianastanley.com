// Public configuration. Both values are safe to commit: the anon key is
// meant to ship in the browser, and Row Level Security in Postgres is what
// actually protects the data (see supabase/migrations/0001_init.sql).
//
// Find them in the Supabase dashboard: Project Settings -> API.
//
// Until these are filled in, the site serves the checked-in copy of the
// content from snapshots/entries.json and the admin page explains itself.

export const SUPABASE_URL = 'REPLACE_WITH_PROJECT_URL';
export const SUPABASE_ANON_KEY = 'REPLACE_WITH_ANON_KEY';

export function isConfigured() {
  return !SUPABASE_URL.startsWith('REPLACE') && !SUPABASE_ANON_KEY.startsWith('REPLACE');
}
