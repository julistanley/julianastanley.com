// Reads the URL, finds the matching entry, renders it into #main.
//
// Routes:
//   /                    the 'about' page, plus the latest news
//   /<slug>/             any other page ('publications', 'teaching', ...)
//   /blog/               the 'blog' page body, plus the list of posts
//   /blog/<slug>/        one post ('/blog/2022/Prelim/'-style old URLs work too)
//   /news/               the 'news' page body, plus every news item
// Every route is served by a copy of index.html (see scripts/bake.sh), so
// this file runs once per page load; there is no client-side navigation.
import { loadSnapshot, loadLive } from './content.js';
import { renderMarkdown, fmtDate, escapeHtml } from './render.js';

const NEWS_ON_ABOUT = 5;

// Site chrome lives in the database too, as kind='setting' entries edited at
// /admin/ like everything else; these are the fallbacks if a row is missing.
const DEFAULTS = {
  'site-title': 'Juliana (Juli) Stanley',
  'tagline': '',
  'footer': '© {year} Juliana Stanley',
};

function setting(entries, slug) {
  const e = entries.bySlug.get(slug);
  return (e?.kind === 'setting' && e.body.trim()) || DEFAULTS[slug];
}

/** Fills in the header; returns the site title for use in document.title. */
function applyChrome(entries) {
  const title = setting(entries, 'site-title');
  const tagline = setting(entries, 'tagline');
  document.querySelector('header h1 a').textContent = title;
  const tag = document.querySelector('header .tagline');
  tag.textContent = tagline;
  tag.hidden = !tagline;
  document.querySelector('meta[name="description"]')?.setAttribute('content', tagline);
  return title;
}

function resolve(pathname) {
  const parts = pathname.toLowerCase().split('/').filter(Boolean);
  if (parts.at(-1) === 'index.html') parts.pop();   // /blog/index.html etc.
  if (parts.length === 0) return { type: 'page', slug: 'about' };
  if (parts[0] === 'blog' && parts.length > 1) {
    // Last segment so old Jekyll URLs like /blog/2022/Prelim/ still resolve.
    return { type: 'post', slug: parts[parts.length - 1] };
  }
  if (parts[0] === 'news') return { type: 'page', slug: 'news' };
  return { type: 'page', slug: parts[0] };
}

function pageHref(slug) {
  return slug === 'about' ? '/' : `/${slug}/`;
}

function navHtml(pages, current) {
  return pages
    .filter(p => p.nav_order != null)
    .sort((a, b) => a.nav_order - b.nav_order)
    .map(p => {
      const label = escapeHtml(p.title || p.slug);
      return p.slug === current
        ? `<b>${label}</b>`
        : `<a href="${pageHref(p.slug)}">${label}</a>`;
    })
    .join('');
}

function newsHtml(news, limit) {
  const items = (limit ? news.slice(0, limit) : news)
    .map(n => `<li><span class="date">${fmtDate(n.date)}</span> —
               ${renderMarkdown(n.body).replace(/^<p>|<\/p>\s*$/g, '')}</li>`)
    .join('\n');
  return `<ul class="listing">${items}</ul>`;
}

function postListHtml(posts) {
  const items = posts.map(p => `
    <li><span class="date">${fmtDate(p.date)}</span>
        <a href="/blog/${p.slug}/">${escapeHtml(p.title)}</a>
        ${p.description ? `<br><span class="desc">${escapeHtml(p.description)}</span>` : ''}
    </li>`).join('\n');
  return `<ul class="listing">${items}</ul>`;
}

function render(entries) {
  const SITE_TITLE = applyChrome(entries);
  const route = resolve(location.pathname);
  const main = document.getElementById('main');
  let entry, html = '', title = SITE_TITLE;

  // Whole sections switch off with their page's published flag: an
  // unpublished 'blog' page hides every post, an unpublished 'news' page
  // hides the news items (loadEntries only ever sees published entries,
  // so presence in bySlug means published).
  const blogOn = entries.bySlug.get('blog')?.kind === 'page';
  const newsOn = entries.bySlug.get('news')?.kind === 'page';

  if (route.type === 'post') {
    entry = blogOn ? entries.posts.find(p => p.slug === route.slug) : undefined;
  } else {
    entry = entries.bySlug.get(route.slug);
    if (entry && entry.kind !== 'page') entry = undefined;  // settings, news
  }

  if (!entry) {
    title = `not found | ${SITE_TITLE}`;
    html = `<h1>404</h1>
            <p>No such page.</p>
            ${blogOn && entries.posts.length
              ? `<p>Maybe you want one of these posts:</p>${postListHtml(entries.posts)}` : ''}`;
  } else if (entry.kind === 'post') {
    title = `${entry.title} | ${SITE_TITLE}`;
    html = `<h1>${escapeHtml(entry.title)}</h1>
            <p class="date">${fmtDate(entry.date)}</p>
            ${renderMarkdown(entry.body)}
            <p><a href="/blog/">&larr; blog</a></p>`;
  } else if (entry.slug === 'about') {
    const newsBlock = newsOn && entries.news.length
      ? `<h2 id="news">news</h2>
         ${newsHtml(entries.news, NEWS_ON_ABOUT)}
         <p><a href="/news/">all news &rarr;</a></p>`
      : '';
    html = `${renderMarkdown(entry.body)}${newsBlock}`;
  } else if (entry.slug === 'blog') {
    title = `blog | ${SITE_TITLE}`;
    html = `<h1>${escapeHtml(entry.title)}</h1>
            ${renderMarkdown(entry.body)}
            ${postListHtml(entries.posts)}`;
  } else if (entry.slug === 'news') {
    title = `news | ${SITE_TITLE}`;
    html = `<h1>${escapeHtml(entry.title)}</h1>
            ${renderMarkdown(entry.body)}
            ${newsHtml(entries.news)}`;
  } else {
    title = `${entry.title} | ${SITE_TITLE}`;
    html = `<h1>${escapeHtml(entry.title)}</h1>
            ${entry.description ? `<p class="date">${escapeHtml(entry.description)}</p>` : ''}
            ${renderMarkdown(entry.body)}`;
  }

  document.title = title;
  document.getElementById('nav').innerHTML =
    navHtml(entries.pages, entry?.kind === 'post' ? 'blog' : route.slug);
  main.innerHTML = html;

  renderFooter(entries, entry);
}

// True when a Supabase session exists in this browser (i.e. this is Juli).
function hasSession() {
  try {
    return Object.keys(localStorage).some(k => /^sb-.*-auth-token$/.test(k));
  } catch { return false; }
}

function renderFooter(entries, entry) {
  const last = entries.list.map(e => e.updated_at || '').sort().at(-1);
  const edit = hasSession() && entry
    ? ` &middot; <a href="/admin/#/edit/${entry.slug}">edit this page</a>`
    : '';
  const text = setting(entries, 'footer')
    .replaceAll('{year}', String(new Date().getFullYear()));
  const html = renderMarkdown(text).trim().replace(/^<p>|<\/p>$/g, '');
  document.getElementById('footer').innerHTML =
    `${html} &middot; last updated ${fmtDate(last)} &middot;
     <a href="/admin/">admin</a>${edit}`;
}

// Render the snapshot right away (it's local and at most a nightly run
// old), then sync with the database and re-render only if anything is
// actually different - so an edit made since last night still shows up,
// without a flash on the loads where nothing changed.
(async () => {
  const snap = await loadSnapshot();
  if (snap) render(snap);
  const live = await loadLive();
  if (live && (!snap || JSON.stringify(live.list) !== JSON.stringify(snap.list))) {
    render(live);
  }
  if (!snap && !live) {
    document.getElementById('main').innerHTML =
      `<p>Could not load the site content. The raw content lives in
       <a href="/snapshots/entries.json">snapshots/entries.json</a>.</p>`;
  }
})();
