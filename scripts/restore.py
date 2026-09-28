#!/usr/bin/env python3
"""Prints SQL that re-inserts the site content from snapshots/entries.json.

Disaster recovery, step two: after running supabase/schema.sql in a fresh
project, run `python3 scripts/restore.py | pbcopy` and paste the result into
the SQL editor. The snapshot only ever holds published entries, so drafts
are not covered.
"""
import json
import pathlib
import sys

snap = pathlib.Path(__file__).resolve().parent.parent / 'snapshots/entries.json'
entries = json.loads(snap.read_text())

def lit(v):
    if v is None:
        return 'null'
    if isinstance(v, bool):
        return 'true' if v else 'false'
    if isinstance(v, (int, float)):
        return str(v)
    return "'" + str(v).replace("'", "''") + "'"

rows = []
for e in entries:
    if '$md$' in e['body']:
        sys.exit(f"can't dollar-quote the body of '{e['slug']}'")
    rows.append('  (%s::public.entry_kind, %s, %s, %s, %s, %s, %s, $md$%s$md$)' % (
        lit(e['kind']), lit(e['slug']), lit(e['title']), lit(e['description']),
        lit(e['date']), lit(e['nav_order']), lit(e['published']), e['body']))

print('insert into public.entries')
print('  (kind, slug, title, description, date, nav_order, published, body)')
print('values')
print(',\n'.join(rows))
print('on conflict (slug) do nothing;')
