#!/usr/bin/env python3
"""Summarize completed synthetic trials; never treat missing trials as passes."""
import argparse,csv,html,json
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('directory',type=Path);a=p.parse_args();root=a.directory
records={};invalid=0
for line in (root/'results.jsonl').read_text().splitlines():
 if not line.strip():continue
 try:
  r=json.loads(line)
  if r['status']=='complete':records[r['trial_id']]=r
 except (ValueError,KeyError):invalid+=1
rows=[]
for r in records.values():
 c=r['challenge'];conf=r['confirmation'];setup=r['configuration'];mutates={}
 construction=setup.get('construction','legacy-cryptex')
 if construction in ('tree-frog-vault','flame-toad-vault'):
  mutates['PasswordXORKernel']=sum(layer[field]>=0 for layer in setup['layers'] for field in ('xor_before_rotations','xor_after_rotations'))
 else:
  for s in setup['stages']:
   for op in s['ciphers']:
    if op['lanes']:mutates[op['name']]=mutates.get(op['name'],0)+1
 by_row=[0]*8;confirmed_by_row=[0]*8
 for i,bit in enumerate(r['plaintext_bits']):
  by_row[bit%8]+=(c['significant']>>i)&1;confirmed_by_row[bit%8]+=(r['confirmed']>>i)&1
 rows.append(dict(significant_by_row=json.dumps(by_row),confirmed_by_row=json.dumps(confirmed_by_row),trial=r['trial_id'],fixture=r['fixture'],layout=r['layout'],best_accuracy=c['best_accuracy'],significant=bin(c['significant']).count('1'),confirmed=bin(r['confirmed']).count('1'),confirmation_best=conf['best_accuracy'],seconds=r['seconds'],construction=construction,plan_selector=setup.get('plan_selector',''),bit_plane_selection=json.dumps(setup.get('bit_plane_selection',[])),mutations=json.dumps(mutates,sort_keys=True)))
rows.sort(key=lambda r:(r['confirmed'],r['significant'],r['best_accuracy']))
fields=list(rows[0]) if rows else ['trial']
with (root/'ranking.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
(root/'summary.json').write_text(json.dumps(dict(completed=len(rows),invalid_or_partial_lines=invalid,ranking=rows),indent=2)+'\n')
def table(data):
 if not data:return '<p>No completed results.</p>'
 return '<table><thead><tr>'+''.join('<th>'+html.escape(k)+'</th>' for k in data[0])+'</tr></thead><tbody>'+''.join('<tr>'+''.join('<td>'+html.escape(f'{v:.6f}' if isinstance(v,float) else str(v))+'</td>' for v in r.values())+'</tr>' for r in data)+'</tbody></table>'
body='''<!doctype html><meta charset="utf-8"><title>Strong statistical sweep</title><style>body{font:16px system-ui;margin:40px;color:#152b46}table{border-collapse:collapse;font-size:13px}td,th{border:1px solid #d5dce4;padding:8px;text-align:left}th{background:#eaf0f5}p{max-width:1000px}pre{white-space:pre-wrap}</style><h1>Strong statistical plaintext recovery</h1><p>Same fixed plan reused on independent 1 MiB blocks. Every predictor is frozen before challenge and independent confirmation. Ranking describes this measured attack only: lower leakage is not a security proof or a recommendation to select these parameters.</p>'''
body+=f'<p>Completed: {len(rows)}. Ignored malformed/partial lines: {invalid}. Missing trials are not passes. Results retain family-wise correction for the full planned campaign. Runtime includes attack fitting, not just encryption.</p>'
body+='<h2>Lower observed leakage first</h2>'+table(rows)
if any(r['construction']=='tree-frog-vault' for r in rows):body+='<p>The TreeFrog vault has a known whole-block parity invariant. This single-bit/two-bit statistical search does not test or rule out that leakage.</p>'
body+='<h2>Exact configurations</h2><p>Vault records contain eight full-size layers, four row pairs per layer, two byte rotations and masks, and before/after PasswordXOR material indices (-1 means absent). There is one bit rotation after layer 3. FlameToad records additionally contain four sampling rotations per pair and the window/byte multipliers. Legacy records retain their stages, cipher lists and sampling banks; distant-window offsets are in 64-byte windows.</p>'
for r in sorted(records.values(),key=lambda r:r['trial_id']):body+='<details><summary>'+html.escape(r['trial_id'])+'</summary><pre>'+html.escape(json.dumps(r,indent=2))+'</pre></details>'
(root/'report.html').write_text(body)
print(f'Completed {len(rows)} trials; {invalid} partial/malformed lines. Report: {root / "report.html"}')
for r in rows:print(f"{r['trial']:12s} best={r['best_accuracy']:.4%} significant={r['significant']:2} confirmed={r['confirmed']:2}")
