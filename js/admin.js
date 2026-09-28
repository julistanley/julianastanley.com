// The whole admin: sign in, list entries, edit Markdown, view history.
//
// Hash routes (so /admin/ stays a single static file):
//   #/            list of all entries, drafts included
//   #/edit/<slug> editor
//   #/new/<kind>  editor for a new page/post/news item
//   #/history/<slug>
//
// Only here (not on the public pages) do we load supabase-js, for auth.
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';
import { SUPABASE_URL, SUPABASE_ANON_KEY, isConfigured } from './config.js';
import { renderMarkdown, fmtDate, escapeHtml } from './render.js';

const main = document.getElementById('main');

const supabase = isConfigured()
  ? createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
  : null;
const FIELDS = 'id,kind,slug,title,description,date,nav_order,published,body,updated_at';
const SLUG_RE = /^[a-z0-9][a-z0-9_-]*$/;
// Kept in sync with scripts/bake.sh and the entries slug check constraint.
const RESERVED_SLUGS = ['admin', 'assets', 'css', 'js', 'snapshots',
                        'scripts', 'supabase', 'redirect-site', 'index.html'];

// ---------------------------------------------------------------- utilities

function h(strings, ...vals) {   // tagged template: interpolations are escaped
  return strings.reduce((out, s, i) => out + escapeHtml(vals[i - 1]) + s);
}

function show(html) { main.innerHTML = html; }

function flash(msg, isError = false) {
  const el = document.getElementById('flash');
  if (el) { el.textContent = msg; el.className = isError ? 'error' : 'ok'; }
}

function confirmDanger(msg) { return window.confirm(msg); }

// ---------------------------------------------------------------- auth views

function loginView(note = '') {
  show(`
    ${note}
    <h1>sign in</h1>
    <form id="login" class="stack">
      <label for="email">email</label>
      <input id="email" type="email" autocomplete="username" required>
      <label for="password">password</label>
      <input id="password" type="password" autocomplete="current-password" required>
      <p><button type="submit">sign in</button>
         <button type="button" id="forgot">email me a reset link</button></p>
      <p id="flash"></p>
    </form>`);
  document.getElementById('login').addEventListener('submit', async e => {
    e.preventDefault();
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) flash(error.message, true); else route();
  });
  document.getElementById('forgot').addEventListener('click', async () => {
    const email = document.getElementById('email').value.trim();
    if (!email) return flash('Type your email first.', true);
    const { error } = await supabase.auth.resetPasswordForEmail(email,
      { redirectTo: location.origin + '/admin/' });
    flash(error ? error.message : 'Reset link sent - check your email.', !!error);
  });
}

function newPasswordView() {
  show(`
    <h1>set a new password</h1>
    <form id="np" class="stack">
      <label for="password">new password</label>
      <input id="password" type="password" autocomplete="new-password" required minlength="8">
      <p><button type="submit">save password</button></p>
      <p id="flash"></p>
    </form>`);
  document.getElementById('np').addEventListener('submit', async e => {
    e.preventDefault();
    const { error } = await supabase.auth.updateUser(
      { password: document.getElementById('password').value });
    if (error) flash(error.message, true);
    else { recovering = false; location.hash = '#/'; route(); }
  });
}

// ---------------------------------------------------------------- list view

async function listView() {
  const { data, error } = await supabase.from('entries')
    .select(FIELDS).order('kind').order('nav_order').order('date', { ascending: false });
  if (error) return show(h`<p class="error">${error.message}</p>`);

  const row = e => `
    <tr>
      <td><a href="#/edit/${e.slug}">${escapeHtml(e.title || e.slug)}</a>
          ${e.published ? '' : ' <span class="draft">(draft)</span>'}</td>
      <td class="date">${e.kind === 'page' ? (e.nav_order != null ? 'nav ' + e.nav_order : '') : fmtDate(e.date)}</td>
      <td class="row-actions"><a href="#/history/${e.slug}">history</a></td>
    </tr>`;
  const section = kind => {
    const rows = data.filter(e => e.kind === kind);
    return rows.length
      ? `<h2>${kind}s</h2><table>${rows.map(row).join('')}</table>` : '';
  };

  show(`
    <p>
      <button id="new-post">new post</button>
      <button id="new-news">new news item</button>
      <button id="new-page">new page</button>
      <button id="signout" style="float: right">sign out</button>
    </p>
    ${section('page')}${section('post')}${section('news')}${section('setting')}
    <h2>account</h2>
    <form id="pw" class="stack" style="max-width: 40ch">
      <label for="newpw">change password</label>
      <input id="newpw" type="password" autocomplete="new-password" minlength="8">
      <p><button type="submit">update password</button></p>
      <p id="flash"></p>
    </form>`);

  for (const kind of ['post', 'news', 'page']) {
    document.getElementById(`new-${kind}`).addEventListener('click',
      () => { location.hash = `#/new/${kind}`; });
  }
  document.getElementById('signout').addEventListener('click', async () => {
    await supabase.auth.signOut();
    route();
  });
  document.getElementById('pw').addEventListener('submit', async e => {
    e.preventDefault();
    const { error } = await supabase.auth.updateUser(
      { password: document.getElementById('newpw').value });
    flash(error ? error.message : 'Password updated.', !!error);
  });
}

// ---------------------------------------------------------------- editor

function todayISO() { return new Date().toISOString().slice(0, 10); }

async function editorView(slug, newKind) {
  let entry = { kind: newKind ?? 'post', slug: '', title: '', description: '',
                date: todayISO(), nav_order: null, published: true, body: '' };
  if (slug) {
    const { data, error } = await supabase.from('entries')
      .select(FIELDS).eq('slug', slug).maybeSingle();
    if (error || !data) return show(h`<p class="error">${error?.message ?? 'Not found: ' + slug}</p>`);
    entry = data;
  }

  show(`
    <p><a href="#/">&larr; all entries</a>
       ${entry.id ? `&middot; <a href="#/history/${entry.slug}">history</a>` : ''}</p>
    <form id="ed" class="stack">
      <label for="title">title</label>
      <input id="title" type="text" value="${escapeHtml(entry.title)}">
      <label for="slug">slug (the URL: pages at /&lt;slug&gt;/, posts at /blog/&lt;slug&gt;/)</label>
      <input id="slug" type="text" value="${escapeHtml(entry.slug)}"
             pattern="[a-z0-9][a-z0-9_-]*" required>
      <label for="description">description (one line, shown in listings; optional)</label>
      <input id="description" type="text" value="${escapeHtml(entry.description)}">
      <label for="kind">kind</label>
      <select id="kind">
        ${['page', 'post', 'news', 'setting'].map(k =>
          `<option ${k === entry.kind ? 'selected' : ''}>${k}</option>`).join('')}
      </select>
      <label for="date">date (posts and news)</label>
      <input id="date" type="date" value="${escapeHtml(entry.date ?? '')}">
      <label for="nav_order">nav position (pages only; empty = not in the nav)</label>
      <input id="nav_order" type="number" value="${entry.nav_order ?? ''}">
      <label><input id="published" type="checkbox" ${entry.published ? 'checked' : ''}
             style="width: auto"> published
             <span class="ok">— unchecked hides this from the site entirely;
             unpublishing the <b>blog</b> or <b>news</b> page hides that whole
             section (tab, listings, and post/news URLs)</span></label>
      <label for="body">body (Markdown)</label>
      <textarea id="body" spellcheck="true">${escapeHtml(entry.body)}</textarea>
      <p>
        <button type="submit">save</button>
        <button type="button" id="toggle-preview">preview</button>
        ${entry.id ? '<button type="button" id="delete">delete…</button>' : ''}
        ${entry.id && (entry.kind === 'page' || entry.kind === 'post')
          ? `<a href="${entry.kind === 'post' ? '/blog/' : '/'}${entry.slug === 'about' ? '' : entry.slug + '/'}">view</a>` : ''}
      </p>
      <p id="flash"></p>
    </form>
    <div id="preview" hidden></div>`);

  const $ = id => document.getElementById(id);

  $('toggle-preview').addEventListener('click', () => {
    const pv = $('preview');
    pv.hidden = !pv.hidden;
    if (!pv.hidden) pv.innerHTML = renderMarkdown($('body').value);
  });

  $('ed').addEventListener('submit', async e => {
    e.preventDefault();
    const newSlug = $('slug').value.trim();
    if (!SLUG_RE.test(newSlug)) return flash('Slug: lowercase letters, digits, - and _ only.', true);
    if (RESERVED_SLUGS.includes(newSlug)) return flash(`"${newSlug}" is reserved (it is a real directory on the site).`, true);
    const row = {
      kind: $('kind').value,
      slug: newSlug,
      title: $('title').value.trim(),
      description: $('description').value.trim(),
      date: $('date').value || null,
      nav_order: $('nav_order').value === '' ? null : Number($('nav_order').value),
      published: $('published').checked,
      body: $('body').value,
    };
    const q = entry.id
      ? supabase.from('entries').update(row).eq('id', entry.id).select('slug').single()
      : supabase.from('entries').insert(row).select('slug').single();
    const { data, error } = await q;
    if (error) return flash(error.message, true);
    flash('Saved.');
    if (!entry.id || data.slug !== slug) location.hash = `#/edit/${data.slug}`;
    else entry.slug = data.slug;
  });

  $('delete')?.addEventListener('click', async () => {
    if (!confirmDanger(`Delete "${entry.title || entry.slug}"? ` +
        'The last version stays in the history table.')) return;
    const { error } = await supabase.from('entries').delete().eq('id', entry.id);
    if (error) return flash(error.message, true);
    location.hash = '#/';
  });
}

// ---------------------------------------------------------------- history

async function historyView(slug) {
  if (!SLUG_RE.test(slug)) return show(h`<p class="error">Bad slug: ${slug}</p>`);
  const { data: entry } = await supabase.from('entries')
    .select('id,title').eq('slug', slug).maybeSingle();
  // Match by slug as well as id, so history written before a delete+recreate
  // (new uuid, same slug) stays visible; for deleted entries only the slug
  // remains. SLUG_RE above keeps the filter string well-formed.
  let query = supabase.from('entry_history')
    .select('id,entry_id,op,data,changed_at').order('changed_at', { ascending: false }).limit(100);
  query = entry
    ? query.or(`entry_id.eq.${entry.id},data->>slug.eq.${slug}`)
    : query.eq('data->>slug', slug);
  const { data, error } = await query;
  if (error) return show(h`<p class="error">${error.message}</p>`);

  show(`
    <p><a href="#/">&larr; all entries</a>
       ${entry ? `&middot; <a href="#/edit/${slug}">edit</a>` : ''}</p>
    <h1>history: ${escapeHtml(entry?.title ?? slug)}</h1>
    <p class="ok">Each row is the version <i>before</i> that change was made.</p>
    <table>${data.map(r => `
      <tr>
        <td class="date">${fmtDate(r.changed_at)}
            ${new Date(r.changed_at).toLocaleTimeString('en-US')}</td>
        <td>${r.op}</td>
        <td><a href="#" data-id="${r.id}" class="peek">view this version</a></td>
      </tr>`).join('')}
    </table>
    <div id="peek-box" hidden>
      <p><button id="restore">restore this version now&hellip;</button></p>
      <pre id="peek-body"></pre>
    </div>`);

  let picked = null;
  for (const a of main.querySelectorAll('a.peek')) {
    a.addEventListener('click', e => {
      e.preventDefault();
      picked = data.find(r => r.id === Number(a.dataset.id));
      document.getElementById('peek-box').hidden = false;
      document.getElementById('peek-body').textContent =
        `title: ${picked.data.title}\n\n${picked.data.body}`;
    });
  }
  document.getElementById('restore').addEventListener('click', async () => {
    if (!picked) return;
    const d = picked.data;
    const fields = { title: d.title, description: d.description, date: d.date,
                     nav_order: d.nav_order, published: d.published, body: d.body };
    if (!confirmDanger('Overwrite the live entry with this version (title, body, ' +
        'date, description, nav position, published flag)? ' +
        'The replaced version is itself kept in the history.')) return;
    const { error } = entry
      ? await supabase.from('entries').update(fields).eq('id', entry.id)
      : await supabase.from('entries').insert({ ...fields, kind: d.kind, slug: d.slug });
    if (error) return alert(error.message);
    location.hash = `#/edit/${slug}`;
  });
}

// ---------------------------------------------------------------- router

let recovering = false;

async function route() {
  const { data: { session } } = await supabase.auth.getSession();
  // The flag stays set until the new password is saved, so a route() that was
  // already in flight when PASSWORD_RECOVERY fired can't hide the form.
  if (recovering) return newPasswordView();
  if (!session) return loginView();

  const parts = location.hash.replace(/^#\/?/, '').split('/').filter(Boolean);
  if (parts[0] === 'edit' && parts[1]) return editorView(parts[1]);
  if (parts[0] === 'new') return editorView(null, parts[1] ?? 'post');
  if (parts[0] === 'history' && parts[1]) return historyView(parts[1]);
  return listView();
}

if (!supabase) {
  main.innerHTML = `<p>Supabase is not configured yet: fill in
    <code>js/config.js</code> (see the README).</p>`;
} else {
  supabase.auth.onAuthStateChange(event => {
    if (event === 'PASSWORD_RECOVERY') { recovering = true; newPasswordView(); }
  });
  window.addEventListener('hashchange', route);
  route();
}
