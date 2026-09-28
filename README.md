# julianastanley.com

My personal website. One narrow column of monospace text, served as static
files from this repo by GitHub Pages.

The text itself lives in a small Supabase database and gets edited on the
site, at [/admin/](https://julianastanley.com/admin/). Saves are live
immediately; nothing here needs a rebuild or a commit to change what the
site says.

## How it works

Every piece of text is a row in one `entries` table: pages, blog posts,
news items, and even the header and footer ("settings"). `js/app.js` looks
at the URL, pulls the matching entry, and renders its Markdown. Postgres
row level security does the access control: anyone can read published
entries, and only my login can write. Signups are off. The anon key in
`js/config.js` is public on purpose.

A nightly GitHub Action exports the published content to
`snapshots/entries.json`. That file is the backup, the fallback the site
renders if the database is ever unreachable, and the daily activity that
keeps the free Supabase project from being paused. The same job runs
`scripts/bake.sh`, which copies `index.html` to `<slug>/index.html` for
each page and post so deep links work on GitHub Pages.

Notes to self, for editing at /admin/:

- a page's "nav position" decides whether and where it appears as a tab
- unpublishing the blog or news page hides that entire section
- a new post's /blog/... URL appears after the nightly run; run the
  "Nightly content snapshot" action by hand to get it sooner
- GitHub turns the nightly schedule off after ~60 days without repo
  activity (it emails first); re-enable it from the Actions tab

## Running locally

    python3 scripts/serve.py

then http://localhost:8766.

## If the database ever needs rebuilding

Make a new Supabase project and, in its SQL editor, run
`supabase/schema.sql`, then the output of `python3 scripts/restore.py`
(re-inserts everything from the last snapshot; drafts aren't in it). In
Auth settings: signups off, create the admin user by hand (auto-confirm),
site URL `https://julianastanley.com/admin/`, and add
`http://localhost:8766/*` to the redirect URLs. Put the new project URL
and anon key in `js/config.js`.

## Domains

DNS for julianastanley.com is the four GitHub Pages A records on `@` plus
a `www` CNAME to `julistanley.github.io`. The old domains
(julistanley.com, julianstanley.com) are a separate Netlify site that
301-redirects every path here; its config is `redirect-site/_redirects`.
