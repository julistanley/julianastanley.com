# julianastanley.com

Personal website of Juliana (Juli) Stanley. Deliberately plain: one narrow
monospace column of text. Every word on the site lives in a database and is
editable from the site itself at `/admin/` — no rebuilds, no commits, no
"I'll update it later".

## How it is built

| Piece | Choice | Why |
|---|---|---|
| Frontend | Plain HTML/CSS/JavaScript modules, no build step | Easy to read, deploys as static files anywhere |
| Content | Markdown rows in [Supabase](https://supabase.com) (free tier): Postgres + Auth | Edit any page in the browser after logging in |
| Security | Row Level Security policies in Postgres | Anyone can read published entries; only the admin login can write |
| Hosting | GitHub Pages from this (public) repo | Free; the content is public anyway |
| Old domains | A tiny Netlify site of 301 redirects | julistanley.com and julianstanley.com keep working, path included |
| Backups | Per-entry history table + nightly snapshot committed to this repo | Nothing is ever lost; doubles as the free-tier keep-alive ping |

### Files

    index.html                 the shell for every route (rendered by js/app.js)
    404.html, <slug>/…         copies of index.html made by scripts/bake.sh
    admin/index.html           the editor (login, list, edit, history)
    css/site.css
    js/config.js               Supabase URL + anon key (public, safe to commit)
    js/content.js              reads entries from Supabase, falls back to snapshot
    js/render.js               Markdown -> sanitized HTML
    js/app.js                  routing + page/post/news rendering
    js/admin.js                everything behind /admin/
    snapshots/entries.json     nightly export of the content; also the fallback
    scripts/bake.sh            regenerates route stubs + sitemap from the snapshot
    supabase/migrations/       SQL: 0001 schema + policies, 0002 initial content
    redirect-site/             the Netlify redirect rules for the old domains
    .github/workflows/snapshot.yml   the nightly export

### How an edit flows

1. Sign in at `julianastanley.com/admin/` (email + password).
2. Edit the Markdown, save. The change is live immediately — public pages
   read straight from the database.
3. That night, the GitHub Action copies the published content into
   `snapshots/entries.json` (the backup), rebakes `/blog/<slug>/` stubs for
   any new posts, and refreshes the sitemap.

A brand-new post is readable the moment it is saved (linked from `/blog/`);
only its *direct* deep link renders via the 404 fallback until the next
nightly bake. Run the "Nightly content snapshot" action by hand (Actions tab
→ Run workflow) to bake immediately.

## One-time setup

### 1. Supabase

1. Create a new project at https://supabase.com/dashboard (any name, e.g.
   `julianastanley-com`). Save the database password somewhere, you won't
   need it day-to-day.
2. **SQL Editor → New query**: paste and run each file in
   `supabase/migrations/` **in numeric order** (each is run once):
   - `0001_init.sql` — tables, triggers, security policies. Edit the
     `app_admins` insert first if you want a different admin email
     (lowercase).
   - `0002_seed.sql` — the initial content.
   - `0003_fixes.sql` — only for a database that ran 0001/0002 before
     2026-09-28; fresh installs already include these fixes.
   - `0004_settings.sql`, then `0005_settings_seed.sql` **as a separate
     query** — the header/footer settings rows (0004 is only needed on a
     database created before they existed; both are safe to re-run).
3. **Authentication → Sign In / Providers → Email**: turn **Allow new users
   to sign up** OFF. This site has exactly one account.
4. **Authentication → Users → Add user → Create new user**: your admin email
   (the one in `app_admins`) and a strong password. Check "Auto Confirm
   User".
5. **Authentication → URL Configuration**: set *Site URL* to
   `https://julianastanley.com/admin/` and add that plus
   `http://localhost:8766/*` to *Redirect URLs* (password-reset links come
   back to these; the wildcard matters — the reset link returns to
   `/admin/`, and a bare origin doesn't cover it).
   Note on reset emails: Supabase's built-in mailer is rate-limited and only
   delivers to members of your Supabase organization — add the admin email
   as a team member, or just reset the password from **Authentication →
   Users** in the dashboard when needed.
6. **Project Settings → API** (or "Data API"): copy the **Project URL** and
   the **anon / publishable key** into `js/config.js`. Both are public by
   design; Row Level Security is what protects writes.

### 2. GitHub repo + Pages

1. Create a public repo named `julianastanley.com`, push this folder to it
   (branch `main`).
2. Repo **Settings → Pages**: Source "Deploy from a branch", branch `main`,
   folder `/ (root)`.
3. Still in Pages settings, set **Custom domain** to `julianastanley.com`
   (this matches the `CNAME` file) and, once DNS below propagates, check
   **Enforce HTTPS**.

No Actions settings need changing: `snapshot.yml` requests the write
permission it needs itself (`permissions: contents: write`), so the repo
default can stay read-only.

### 3. DNS (Namecheap, julianastanley.com)

Advanced DNS for `julianastanley.com` — remove the parking records, add:

| Type | Host | Value |
|---|---|---|
| A | @ | 185.199.108.153 |
| A | @ | 185.199.109.153 |
| A | @ | 185.199.110.153 |
| A | @ | 185.199.111.153 |
| CNAME | www | `<your-github-username>.github.io.` |

GitHub redirects `www.julianastanley.com` → `julianastanley.com` on its own
once the custom domain is set.

### 4. Old domains (Netlify)

The current julistanley.com site on Netlify gets replaced by redirects:

1. Deploy the `redirect-site/` folder as its own Netlify site (simplest:
   drag the folder onto https://app.netlify.com/drop while logged in), or
   change the existing site to publish it.
2. In that Netlify site's **Domain management**, attach `julistanley.com`,
   `www.julistanley.com`, `julianstanley.com`, and `www.julianstanley.com`.
3. Every old URL now 301-redirects to the same path on julianastanley.com
   (old Jekyll paths like `/blog/2022/Prelim/` are also understood by the
   new site's router).

### 5. Nothing else

Backups need no setup: the nightly workflow reads the same public data the
website serves, so there are no secrets to configure. It also acts as the
keep-alive that stops the free Supabase project from pausing after a week
of inactivity.

One caveat: GitHub disables a `schedule` trigger after ~60 days without any
repository activity (it emails a warning first). If that happens, re-enable
the workflow from the **Actions** tab — and if the Supabase project was
paused in the meantime, restore it from its dashboard (the site keeps
serving from `snapshots/entries.json` while it's down; only editing stops
working).

## Running locally

    python3 scripts/serve.py

then visit http://localhost:8766. The page uses ES modules, so it must be
served over HTTP rather than opened as a file. (The script is plain
`http.server` with caching turned off, so edits show up on reload.) Without Supabase configured,
the site renders from `snapshots/entries.json` and `/admin/` explains itself.

## Data model

One table, `entries`, holds every piece of text:

- `kind`: `page` (about, publications, teaching, …), `post` (blog),
  `news` (the dated one-liners on the front page), or `setting` (site
  chrome: the rows with slugs `site-title`, `tagline`, and `footer` hold
  the header and footer of every page — edit their body at `/admin/`).
- `slug` is the URL: pages at `/<slug>/`, posts at `/blog/<slug>/`.
- `nav_order` puts a page in the top navigation and orders the tabs
  (empty = hidden). The tab label is the page's title. The blog tab is
  simply the `blog` page's row.
- `published = false` keeps drafts invisible to everyone but you. It is
  also the section switch: unpublishing the **blog** page hides the tab,
  the post listings, and every post URL in one go (posts keep their own
  published flags for when it comes back); likewise the **news** page
  hides the news items everywhere, including the front page.
- `body` is Markdown.

`entry_history` records the previous version of a row on every change
(written by a trigger); the admin's "history" view can restore any of them.
`app_admins` lists the email addresses allowed to write anything.
