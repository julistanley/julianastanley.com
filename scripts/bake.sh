#!/usr/bin/env bash
# Regenerates the static route stubs from snapshots/entries.json:
#   404.html                       (fallback: any unknown path still renders)
#   <slug>/index.html              for every page except 'about'
#   blog/<slug>/index.html         for every published post
#   sitemap.xml
# Each stub is a byte-for-byte copy of index.html; js/app.js looks at the URL.
# Run from the repo root. The nightly GitHub Action runs this after exporting
# the database; run it by hand after adding a post if you don't want to wait.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'EOF'
import json, pathlib

root = pathlib.Path('.')
shell = (root / 'index.html').read_bytes()
entries = json.loads((root / 'snapshots/entries.json').read_text())

# Remove stubs from a previous bake, so renamed or deleted slugs disappear.
# Only files that are literally a copy of the shell are ever deleted.
for old in list(root.glob('*/index.html')) + list(root.glob('blog/*/index.html')):
    if old.parent != root and old.read_bytes() != shell:
        continue        # a real file (e.g. admin/index.html): leave it alone
    old.unlink()
    if not any(old.parent.iterdir()):
        old.parent.rmdir()

urls = ['/']
for e in entries:
    if not e.get('published', True):
        continue
    if e['kind'] == 'page' and e['slug'] != 'about':
        path, url = root / e['slug'], f"/{e['slug']}/"
    elif e['kind'] == 'post':
        path, url = root / 'blog' / e['slug'], f"/blog/{e['slug']}/"
    else:
        continue
    path.mkdir(parents=True, exist_ok=True)
    (path / 'index.html').write_bytes(shell)
    urls.append(url)

(root / '404.html').write_bytes(shell)

site = 'https://julianastanley.com'
sitemap = ['<?xml version="1.0" encoding="UTF-8"?>',
           '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
sitemap += [f'  <url><loc>{site}{u}</loc></url>' for u in urls]
sitemap.append('</urlset>')
(root / 'sitemap.xml').write_text('\n'.join(sitemap) + '\n')

print(f'baked {len(urls)} routes')
EOF
