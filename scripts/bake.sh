#!/usr/bin/env bash
# Regenerates the static route stubs from snapshots/entries.json:
#   404.html                       (fallback: any unknown path still renders)
#   <slug>/index.html              for every page except 'about'
#   blog/<slug>/index.html         for every published post
#   sitemap.xml
# Each stub is a byte-for-byte copy of index.html; js/app.js looks at the URL.
# snapshots/baked_paths.txt records what the last bake created, so stubs for
# renamed or deleted slugs are removed on the next run — and nothing else
# (admin/index.html in particular) is ever touched.
# Run from the repo root. The nightly GitHub Action runs this after exporting
# the database; run it by hand after adding a post if you don't want to wait.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'EOF'
import json, pathlib

root = pathlib.Path('.')
shell = (root / 'index.html').read_bytes()
entries = json.loads((root / 'snapshots/entries.json').read_text())
manifest = root / 'snapshots/baked_paths.txt'

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
    elif e['kind'] == 'post' and blog_on:
        path, url = root / 'blog' / e['slug'], f"/blog/{e['slug']}/"
    else:
        continue
    path.mkdir(parents=True, exist_ok=True)
    (path / 'index.html').write_bytes(shell)
    baked.append(str(path / 'index.html'))
    urls.append(url)

manifest.write_text('\n'.join(baked) + '\n')
(root / '404.html').write_bytes(shell)

site = 'https://julianastanley.com'
sitemap = ['<?xml version="1.0" encoding="UTF-8"?>',
           '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
sitemap += [f'  <url><loc>{site}{u}</loc></url>' for u in urls]
sitemap.append('</urlset>')
(root / 'sitemap.xml').write_text('\n'.join(sitemap) + '\n')

print(f'baked {len(urls)} routes')
EOF
