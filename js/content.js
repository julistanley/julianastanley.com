// Loads the site content: every published entry (pages, blog posts, news,
// settings).
//
// Two sources. snapshots/entries.json is the copy committed to this repo by
// the nightly GitHub Action - same-origin and fast, at most a day old; the
// page renders from it first. Supabase is the live truth - one REST call
// with the public anon key (no client library needed just to read); the page
// re-renders from it only when it differs from the snapshot.
import { SUPABASE_URL, SUPABASE_ANON_KEY, isConfigured } from './config.js';

const FIELDS = 'kind,slug,title,description,date,nav_order,published,body,updated_at';

/** Wraps the raw row list in the lookups the renderer wants. */
function indexEntries(list) {
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

/** The nightly snapshot, or null if it can't be fetched. */
export async function loadSnapshot() {
  try {
    const res = await fetch('/snapshots/entries.json', { cache: 'no-cache' });
    if (!res.ok) return null;
    return indexEntries(await res.json());
  } catch { return null; }
}

/** The live database, or null (not configured, unreachable, or empty -
 *  an empty array is how PostgREST reports "RLS let you see nothing"). */
export async function loadLive() {
  if (!isConfigured()) return null;
  try {
    const url = `${SUPABASE_URL}/rest/v1/entries`
      + `?select=${FIELDS}&published=eq.true&order=slug.asc&limit=1000`;
    const res = await fetch(url, { headers: { apikey: SUPABASE_ANON_KEY } });
    if (!res.ok) throw new Error(`entries: HTTP ${res.status}`);
    const data = await res.json();
    if (Array.isArray(data) && data.length) return indexEntries(data);
    console.warn('Supabase returned no entries.');
  } catch (err) { console.warn('Live content unavailable:', err); }
  return null;
}
