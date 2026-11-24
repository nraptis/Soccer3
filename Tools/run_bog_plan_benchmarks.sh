#!/bin/zsh
set -euo pipefail

project_root="${0:A:h:h}"
output_directory="${1:-$project_root/BenchmarkResults/bog-plan-$(date +%Y%m%d-%H%M%S)}"
if [[ -e "$output_directory" ]]; then
    print -u2 "Output directory already exists: $output_directory"
    exit 1
fi
mkdir -p "$output_directory"
output_directory="${output_directory:A}"
cxx="${CXX:-clang++}"
common=(-std=c++20 -O3 -DNDEBUG -Wall -Wextra -Wpedantic)
includes=(-I "$project_root" -I "$project_root/Scramble/Composer" -I "$project_root/Scramble/Encrypter"
          -I "$project_root/Scramble/Encrypter/Kernels" -I "$project_root/Scramble/Expander/Core"
          -I "$project_root/Scramble/Expander/Family" -I "$project_root/Scramble/Public")
mock="$project_root/ScrambleTests/__CipherMock"
{
    "$cxx" --version
    uname -m
    uptime
    print 'Warm 1 MiB; 17 samples x 16 complete executions; encrypt and decrypt; rotated case order; no LTO.'
    print 'Current schedules: actual FourToadKernel (caller + 3 persistent helpers), CorvidShift, CryptexLayer, and Cryptex execution code.'
    print 'Build/seed excluded. Deterministic representative parameters populate public layers matching current Weak/Normal/Strong cipher counts.'
    print 'Proposals: experimental verified NEON range kernels, serial or caller + 3 helpers reused for the whole pipeline; one barrier per pass.'
    print 'Every proposal retains four independent material lanes, masked movement on every layer, and a midpoint bit reversal.'
    print 'No RNG family implementation translation units built; family source contents not inspected.'
    print 'Parity screen: one fixed geometry/material fixture; 512 balanced challenges per proposal; one-known-block whole-block parity predictor.'
} > "$output_directory/metadata.txt"

python3 - "$project_root" "$output_directory" <<'PY'
from pathlib import Path
import json,re,sys
root,out=map(Path,sys.argv[1:])
s=(root/'Scramble/Encrypter/Cryptex.cpp').read_text()
begin=s.index('bool Cryptex::Build(')
end=s.index('\nbool Cryptex::SealData(',begin)
(out/'CryptexExecution.cpp').write_text(s[:begin]+s[end:])
build=s[begin:end]
weak=build[build.index('if (mStrength == EncryptionStrength::kWeak)'):build.index('} else if (mStrength == EncryptionStrength::kStrong)')]
strong=build[build.index('} else if (mStrength == EncryptionStrength::kStrong)'):build.index('} else { // Normal')]
normal=build[build.index('} else { // Normal'):]
counts={}
for name,body in (('Weak',weak),('Normal',normal),('Strong',strong)):
    counts[name]={kind:len(re.findall(r'new '+kind+r'\b',body)) for kind in ('FourToadKernel','FourCrowKernel','FourRavenKernel','PasswordXORKernel','BitReverseKernel')}
    assert counts[name]['FourToadKernel']==8 and counts[name]['BitReverseKernel']==1
assert counts['Weak']['FourCrowKernel']==counts['Weak']['FourRavenKernel']==4
assert counts['Normal']['FourRavenKernel']==counts['Strong']['FourRavenKernel']==8
assert counts['Strong']['PasswordXORKernel']==8
(out/'baseline-counts.json').write_text(json.dumps(counts,indent=2)+'\n')
probe=['#include "ScrambleTests/__CipherMock/TESTBogNEON.hpp"\n']
for family in 'ABCD':
    for order,name in zip(('kABC','kACB','kBAC','kBCA','kCAB','kCBA'),'ABCDEF'):
        for inverse in (False,True):
            symbol=f'Bog{family}{name}'+('Unseal' if inverse else 'Seal')
            probe.append(f'''extern "C" __attribute__((flatten)) void {symbol}(const TESTBog &plan,
const std::uint8_t *src,std::uint8_t *dst,std::size_t len,std::size_t begin,std::size_t end) {{
TESTBogNEON::Transform<TESTBog::HotPair::k{family},TESTBog::PackOrder::{order},{str(inverse).lower()}>(plan,src,dst,len,begin,end);
}}
''')
(out/'probe.cpp').write_text(''.join(probe))
PY

objects=()
for source in "$project_root/Scramble/Encrypter/Kernels/FourToadKernel.cpp" \
              "$project_root/Scramble/Encrypter/Kernels/FourCrowKernel.cpp" \
              "$project_root/Scramble/Encrypter/Kernels/FourRavenKernel.cpp" \
              "$project_root/Scramble/Encrypter/Kernels/CorvidShift.cpp" \
              "$project_root/Scramble/Encrypter/CryptexLayer.cpp" "$output_directory/CryptexExecution.cpp" \
              "$project_root/Tools/benchmark_bog_plan.cpp"; do
    object="$output_directory/${source:t:r}.o"
    "$cxx" "${common[@]}" "${includes[@]}" -c "$source" -o "$object"
    objects+=("$object")
done
for source in "$mock/TESTBog.cpp" "$mock/TESTQuirkHigh.cpp" "$mock/TESTQuirkLow.cpp"; do
    object="$output_directory/${source:t:r}.o"
    "$cxx" "${common[@]}" -fno-vectorize -fno-slp-vectorize "${includes[@]}" -c "$source" -o "$object"
    objects+=("$object")
done
"$cxx" "${common[@]}" "${objects[@]}" -o "$output_directory/bog-plan"
"$cxx" "${common[@]}" "${includes[@]}" -S "$output_directory/probe.cpp" -o "$output_directory/neon.s"
python3 - "$output_directory" <<'PY'
from pathlib import Path
from collections import Counter
import json,re,sys
p=Path(sys.argv[1]); s=(p/'neon.s').read_text(); result={}
assert not re.search(r'^\s*(?:rev64|rev32|rev16|tbl|tbx|rbit|ext)\.',s,re.M)
for family in 'ABCD':
    values=set()
    for order in 'ABCDEF':
        for direction in ('Seal','Unseal'):
            name=f'Bog{family}{order}{direction}'
            body=re.search(r'^_'+name+r':.*?\.cfi_endproc',s,re.M|re.S)
            assert body,name
            counts=Counter(re.findall(r'^\s*(sri|sli|ushr|shl|usra|ssra|add|sub|bsl|bif|bit|bic|orr|and|eor)\.16b',body[0],re.M))
            chunks=counts['add']+counts['sub']+counts['usra']+counts['ssra']
            assert chunks and sum(counts.values())%chunks==0,(name,counts)
            result[name]={'data_operations_per_16_bytes':sum(counts.values())//chunks,'opcodes':dict(counts)}
            values.add(sum(counts.values())//chunks)
    print(f'Bog {family}: {sorted(values)} NEON data operations/16 bytes, including key packing and update.')
(p/'codegen.json').write_text(json.dumps(result,indent=2)+'\n')
PY

# All compilation above finishes before timing begins.
"$output_directory/bog-plan" "$output_directory" | tee "$output_directory/run.log"
uptime >> "$output_directory/metadata.txt"
python3 - "$output_directory" <<'PY'
from pathlib import Path
import csv,json,sys
p=Path(sys.argv[1]); rows=list(csv.DictReader((p/'summary.csv').open()))
lookup={(r['case'],r['direction']):float(r['median_us_per_1MiB']) for r in rows}
result={'scope':'Complete current eight-layer schedules with representative deterministic parameters. Seed/build excluded; 1 MiB. Proposal range kernels are experimental, not active production composition.', 'proposals':{}}
for layers in (4,6,8):
    for execution in ('serial','four workers'):
        name=f'{layers} layers {execution}'
        result['proposals'][name]={}
        for direction in ('encrypt','decrypt'):
            cost=lookup[(name,direction)]
            fractions={strength:cost/lookup[(f'current {strength}',direction)] for strength in ('Weak','Normal','Strong')}
            result['proposals'][name][direction]={'us_per_MiB':cost,'fraction_of_current':fractions}
            print(name,direction,f'{cost:.1f} us/MiB; '+', '.join(f'{k} {100*v:.1f}%' for k,v in fractions.items()))
(p/'analysis.json').write_text(json.dumps(result,indent=2)+'\n')
PY

sources=("$project_root/Tools/benchmark_bog_plan.cpp" "$mock/TESTBog.cpp" "$mock/TESTQuirkHigh.cpp" "$mock/TESTQuirkLow.cpp"
         "$project_root/Scramble/Encrypter/Kernels/FourToadKernel.cpp" "$project_root/Scramble/Encrypter/Kernels/CorvidShift.cpp"
         "$project_root/Scramble/Encrypter/Kernels/FourCrowKernel.cpp" "$project_root/Scramble/Encrypter/Kernels/FourRavenKernel.cpp"
         "$project_root/Scramble/Encrypter/CryptexLayer.cpp" "$output_directory/CryptexExecution.cpp")
"$cxx" -std=c++20 -O1 -g "${includes[@]}" -fsanitize=address,undefined -fno-omit-frame-pointer \
    "${sources[@]}" -o "$output_directory/bog-plan-sanitized"
"$output_directory/bog-plan-sanitized" --check | tee "$output_directory/sanitizers.log"
print "Results: $output_directory"
