#!/usr/bin/env bash
# Regenerates the static HTML from snapshots/entries.json:
#   404.html                       (fallback: any unknown path still renders)
#   <slug>/index.html              for every page except 'about'
#   blog/<slug>/index.html         for every published post
#   index.html itself              (the 'about' route)
#   sitemap.xml
# Each file is index.html with the current site title, tagline, nav, and
# page <title> filled in between the marker comments, so the first paint is
# never older than the last snapshot; js/app.js takes it from there.
# snapshots/baked_paths.txt records what the last bake created, so stubs for
# renamed or deleted slugs are removed on the next run — and nothing else
# (admin/index.html in particular) is ever touched.
# Run from the repo root. The nightly GitHub Action runs this after exporting
# the database; run it by hand after adding a post if you don't want to wait.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'EOF'
import html
import json
import pathlib
import re

root = pathlib.Path('.')
template = (root / 'index.html').read_text()
entries = json.loads((root / 'snapshots/entries.json').read_text())
manifest = root / 'snapshots/baked_paths.txt'

# Site chrome, same defaults as js/app.js.
settings = {e['slug']: e['body'].strip() for e in entries if e['kind'] == 'setting'}
site = settings.get('site-title') or 'Juliana (Juli) Stanley'
tagline = settings.get('tagline', '(Computational) Biologist and PhD Student, MIT')
nav_pages = sorted((e for e in entries
                    if e['kind'] == 'page' and e.get('nav_order') is not None),
                   key=lambda e: e['nav_order'])

def nav_html(current):
    out = []
    for p in nav_pages:
        label = html.escape(p['title'] or p['slug'])
        href = '/' if p['slug'] == 'about' else f"/{p['slug']}/"
        out.append(f'<b>{label}</b>' if p['slug'] == current
                   else f'<a href="{href}">{label}</a>')
    return ''.join(out)

def fill(doc, marker, content):
    return re.sub(f'(<!--{marker}-->).*?(<!--/{marker}-->)',
                  lambda m: m.group(1) + content + m.group(2), doc, flags=re.S)

def page_html(current, tab_title):
    doc = fill(template, 'title', html.escape(site))
    doc = fill(doc, 'tagline', html.escape(tagline))
    doc = fill(doc, 'nav', nav_html(current))
    doc = re.sub('<title>.*?</title>',
                 lambda m: f'<title>{html.escape(tab_title)}</title>', doc, count=1)
    doc = re.sub('(<meta name="description" content=")[^"]*(">)',
                 lambda m: m.group(1) + html.escape(tagline, quote=True) + m.group(2),
                 doc, count=1)
    return doc.encode()

# Names of real directories in this repo; a page slug that collides with one
# would overwrite real files, so it is skipped here (and rejected by the
# database's slug constraint and the editor). 'blog' is fine: its stub lives
# happily next to the post stubs.
RESERVED = {'admin', 'assets', 'css', 'js', 'snapshots', 'scripts',
            'supabase', 'redirect-site'}

# Remove exactly what the previous bake created.
if manifest.exists():
    stale = [root / line for line in manifest.read_text().split() if line]
    for p in stale:
        p.unlink(missing_ok=True)
    for p in sorted({p.parent for p in stale}, key=lambda d: -len(d.parts)):
        if p != root and p.is_dir() and not any(p.iterdir()):
            p.rmdir()

# An unpublished 'blog' page switches the whole blog section off (the
# frontend does the same); no post stubs then, so post URLs are plain 404s.
blog_on = any(e['kind'] == 'page' and e['slug'] == 'blog'
              and e.get('published', True) for e in entries)

urls, baked = ['/'], []
for e in entries:
    if not e.get('published', True):
        continue
    if e['kind'] == 'page' and e['slug'] in RESERVED:
        print(f"WARNING: page slug '{e['slug']}' is reserved; no stub baked")
        continue
    if e['kind'] == 'page' and e['slug'] != 'about':
        path, url = root / e['slug'], f"/{e['slug']}/"
        current = e['slug']
    elif e['kind'] == 'post' and blog_on:
        path, url = root / 'blog' / e['slug'], f"/blog/{e['slug']}/"
        current = 'blog'
    else:
        continue
    path.mkdir(parents=True, exist_ok=True)
    (path / 'index.html').write_bytes(
        page_html(current, f"{e['title'] or e['slug']} | {site}"))
    baked.append(str(path / 'index.html'))
    urls.append(url)

manifest.write_text('\n'.join(baked) + '\n')
(root / 'index.html').write_bytes(page_html('about', site))
(root / '404.html').write_bytes(page_html(None, site))

sitemap = ['<?xml version="1.0" encoding="UTF-8"?>',
           '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
sitemap += [f'  <url><loc>https://julianastanley.com{u}</loc></url>' for u in urls]
sitemap.append('</urlset>')
(root / 'sitemap.xml').write_text('\n'.join(sitemap) + '\n')

print(f'baked {len(urls)} routes')
EOF
