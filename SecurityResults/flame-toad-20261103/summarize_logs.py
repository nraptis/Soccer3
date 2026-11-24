#!/usr/bin/env python3
"""Summarize actual completed XCTest lines; missing trials remain missing."""
from pathlib import Path
import re,json,csv
root=Path(__file__).resolve().parent
names={0:'weak',1:'normal',2:'strong'}
result={'construction':'flame-toad-vault','statistical':[],'whole_block_parity':[],'bit_plane_parity':[],'test_suites':[]}
for name in ['functional-4.log','security-1.log','plane-parity.log']:
 p=root/name
 if not p.exists():continue
 text=p.read_text()
 result['test_suites'].append({'log':name,'completed':'** TEST SUCCEEDED **' in text or '** TEST EXECUTE SUCCEEDED **' in text,'passed_cases':len(re.findall(r"Test Case .* passed \(",text)),'failed_cases':len(re.findall(r"Test Case .* failed \(",text))})
 for status,strength,fixture,accuracy,significant,confirmed,seconds in re.findall(r'(PASS|FAIL) \| flame-toad-vault \| strength=(\d+) fixture=(\d+) \| best prediction=([\d.]+)% \| significant=(\d+)/64 confirmed=(\d+)/64 \| ([\d.]+)s',text):
  result['statistical'].append(dict(status=status,strength=names[int(strength)],fixture=int(fixture),best_accuracy_percent=float(accuracy),significant=int(significant),confirmed=int(confirmed),seconds=float(seconds)))
 for strength,fixture,accuracy,best,cutoff,status in re.findall(r'Whole-block parity \| flame-toad-vault \| strength=(\d+) fixture=(\d+) \| prediction=([\d.]+)% \| two-sided best=([\d.]+)% cutoff=([\d.]+)% \| (PASS|FAIL)',text):
  result['whole_block_parity'].append(dict(status=status,strength=names[int(strength)],fixture=int(fixture),accuracy_percent=float(accuracy),best_orientation_percent=float(best),cutoff_percent=float(cutoff)))
 for strength,fixture,best,cutoff,significant,shuffled,status in re.findall(r'Bit-plane parity \| flame-toad-vault \| strength=(\d+) fixture=(\d+) \| best=([\d.]+)% cutoff=([\d.]+)% \| significant=(\d+)/255 shuffled=(\d+) \| (PASS|FAIL)',text):
  result['bit_plane_parity'].append(dict(status=status,strength=names[int(strength)],fixture=int(fixture),best_accuracy_percent=float(best),cutoff_percent=float(cutoff),significant=int(significant),shuffled=int(shuffled)))
p=root/'vault-audit.log'
if p.exists():
 result['vault_timings']=[json.loads(line.removeprefix('TIMING ')) for line in p.read_text().splitlines() if line.startswith('TIMING ')]
 result['configurations']=[json.loads(line.removeprefix('CONFIGURATION ')) for line in p.read_text().splitlines() if line.startswith('CONFIGURATION ')]
result['all_requested_trials_recorded']=all(len(result[k])==6 for k in ['statistical','whole_block_parity','bit_plane_parity'])
(root/'results-summary.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='configurations'},indent=2))
