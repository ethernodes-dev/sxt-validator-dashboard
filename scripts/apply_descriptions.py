#!/usr/bin/env python3
"""
Apply panel descriptions from branding/panel_descriptions.py to the dashboard JSON.

Matching strategy per panel:
1. Try exact title match within its row.
2. If not found, try matching by first 60 chars of the expr/rawSql of the first target.
3. "__KEEP__" value means: leave the existing description untouched.
4. Panels not listed in the dict are NOT touched.
"""

import json
import sys
import importlib.util

DASH_PATH = 'grafana/dashboards/sxt-validator.json'
DESC_PATH = 'branding/panel_descriptions.py'

# Load descriptions module
spec = importlib.util.spec_from_file_location("pd", DESC_PATH)
pd = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pd)
DESCRIPTIONS = pd.DESCRIPTIONS

# Load dashboard
with open(DASH_PATH) as f:
    dash = json.load(f)

def first_expr(panel):
    targets = panel.get('targets', [])
    if not targets:
        return ''
    t = targets[0]
    return (t.get('expr') or t.get('rawSql') or '').strip()

stats = {'applied': 0, 'kept': 0, 'untouched': 0, 'not_found': [], 'no_key_in_dict': []}

for row in dash['panels']:
    if row.get('type') != 'row':
        continue
    rtitle = row.get('title', '')
    row_descs = DESCRIPTIONS.get(rtitle)
    if row_descs is None:
        # No entries defined for this row; skip.
        continue

    for panel in row.get('panels', []):
        title = panel.get('title', '').strip()
        expr = first_expr(panel)
        expr_key = expr[:60] if expr else ''

        # Try title match first
        new_desc = None
        matched_key = None
        if title and title in row_descs:
            new_desc = row_descs[title]
            matched_key = title
        else:
            # Try expr-based match: look for any key that IS a prefix of expr
            for key in row_descs:
                if key == '__default__':
                    continue
                if key and expr.startswith(key):
                    new_desc = row_descs[key]
                    matched_key = key
                    break

        if new_desc is None:
            stats['not_found'].append(f"  [{rtitle}] title={title!r} expr_start={expr_key!r}")
            continue

        if new_desc == '__KEEP__':
            stats['kept'] += 1
            continue

        current = (panel.get('description') or '').strip()
        if current == new_desc.strip():
            stats['untouched'] += 1
            continue

        panel['description'] = new_desc
        stats['applied'] += 1

# Bump dashboard version
dash['version'] = dash.get('version', 0) + 1

with open(DASH_PATH, 'w') as f:
    json.dump(dash, f, indent=2, ensure_ascii=True)

print(f"Dashboard version: {dash['version']}")
print(f"Descriptions applied:    {stats['applied']}")
print(f"Kept as-is (__KEEP__):   {stats['kept']}")
print(f"Already up-to-date:      {stats['untouched']}")
print(f"Panels not found in dict ({len(stats['not_found'])}):")
for line in stats['not_found'][:20]:
    print(line)
if len(stats['not_found']) > 20:
    print(f"  ... and {len(stats['not_found'])-20} more")
