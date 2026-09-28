// Loads the site content: every published entry (pages, blog posts, news).
//
// Normal path: one REST call to Supabase with the public anon key (no client
// library needed just to read). Fallback: snapshots/entries.json, a copy of
// the same data committed to this repo by the nightly GitHub Action, used
// when Supabase is not configured yet or unreachable.
import { SUPABASE_URL, SUPABASE_ANON_KEY, isConfigured } from './config.js';

const FIELDS = 'kind,slug,title,description,date,nav_order,published,body,updated_at';

async function fromSupabase() {
  const url = `${SUPABASE_URL}/rest/v1/entries`
    + `?select=${FIELDS}&published=eq.true&order=slug.asc&limit=1000`;
  const res = await fetch(url, { headers: { apikey: SUPABASE_ANON_KEY } });
  if (!res.ok) throw new Error(`entries: HTTP ${res.status}`);
  return res.json();
}

async function fromSnapshot() {
  const res = await fetch('/snapshots/entries.json', { cache: 'no-cache' });
  if (!res.ok) throw new Error(`snapshot: HTTP ${res.status}`);
  return res.json();
}

/** Returns { list, bySlug, pages, posts, news }. Posts and news newest-first. */
export async function loadEntries() {
  let list;
  if (isConfigured()) {
    try {
      const data = await fromSupabase();
      // An empty array is how PostgREST reports "RLS let you see nothing";
      // the snapshot is more useful than a blank site in that case too.
      if (Array.isArray(data) && data.length) list = data;
      else console.warn('Supabase returned no entries; falling back to snapshot.');
    } catch (err) { console.warn('Falling back to snapshot:', err); }
  }
  if (!list) list = await fromSnapshot();

  const bySlug = new Map(list.map(e => [e.slug, e]));
  const newestFirst = (a, b) => (b.date || '').localeCompare(a.date || '');
  return {
    list,
    bySlug,
    pages: list.filter(e => e.kind === 'page'),
    posts: list.filter(e => e.kind === 'post').sort(newestFirst),
    news:  list.filter(e => e.kind === 'news').sort(newestFirst),
  };
}
