#!/bin/zsh
set -euo pipefail

# Isolated production build; no app or expander-family sources are needed.
project_root="${0:A:h:h}"
output_directory="${1:-$project_root/BenchmarkResults/quirk-ciphers-$(date +%Y%m%d-%H%M%S)}"
if [[ -e "$output_directory" ]]; then
    print -u2 "Output directory already exists: $output_directory"
    exit 1
fi
mkdir -p "$output_directory"
output_directory="${output_directory:A}"
mock_directory="$project_root/ScrambleTests/__CipherMock"
cipher_directory="$project_root/Scramble/Encrypter/Kernels"
cxx="${CXX:-clang++}"
common=(-std=c++20 -O3 -DNDEBUG -Wall -Wextra -Wpedantic -I "$project_root/Scramble/Composer")
sources=("$project_root/Tools/benchmark_quirk_ciphers.cpp" "$mock_directory/TESTQuirkHigh.cpp"
         "$mock_directory/TESTQuirkLow.cpp" "$cipher_directory/QuirkCipher.cpp"
         "$project_root/Scramble/Encrypter/CryptexLayer.cpp")
{
    "$cxx" --version
    uname -m
    uptime
    print 'Production: -O3, no LTO, all sixteen independent specializations in libquirk.a.'
    print 'NEON comparison: same ADD update, 17 paired samples x 64 calls per kernel; cached 1 MiB; one caller thread.'
    print 'Reference/prod order alternates; all 16 variants and both directions. Prototype references retain runtime dispatch.'
    print 'Reverse = reverse order of sixteen 16-byte chunks within each 256-byte window.'
} > "$output_directory/metadata.txt"

"$cxx" "${common[@]}" -c "$cipher_directory/QuirkCipher.cpp" -o "$output_directory/production.o"
ar rcs "$output_directory/libquirk.a" "$output_directory/production.o"
"$cxx" "${common[@]}" -fno-vectorize -fno-slp-vectorize -c "$mock_directory/TESTQuirkHigh.cpp" -o "$output_directory/reference-high.o"
"$cxx" "${common[@]}" -fno-vectorize -fno-slp-vectorize -c "$mock_directory/TESTQuirkLow.cpp" -o "$output_directory/reference-low.o"
"$cxx" "${common[@]}" -c "$project_root/Tools/benchmark_quirk_ciphers.cpp" -o "$output_directory/benchmark.o"
"$cxx" "${common[@]}" -c "$project_root/Scramble/Encrypter/CryptexLayer.cpp" -o "$output_directory/layer.o"
"$cxx" "${common[@]}" "$output_directory/benchmark.o" "$output_directory/reference-high.o" \
    "$output_directory/reference-low.o" "$output_directory/layer.o" "$output_directory/libquirk.a" -o "$output_directory/quirk-ciphers"

python3 - "$output_directory" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
probe=['#include "QuirkCipher.hpp"\n']
for half in ('High','Low'):
    for v in range(8):
        flags=', '.join(str(bool(v&bit)).lower() for bit in (4,2,1))
        for direction in ('Seal','Unseal'):
            probe.append(f'''extern "C" __attribute__((flatten)) void Quirk{half}{chr(65+v)}{direction}(
    const std::array<std::size_t,3> &windows, const std::uint8_t *source,
    std::uint8_t *dest, std::size_t length) {{
    QuirkDetail::Transform<{str(half=='High').lower()}, {str(direction=='Unseal').lower()}, {flags}>(windows,source,dest,length);
}}
''')
(p/'probe.cpp').write_text(''.join(probe))
PY
"$cxx" "${common[@]}" -I "$cipher_directory" -S "$output_directory/probe.cpp" -o "$output_directory/neon.s"
python3 - "$output_directory" <<'PY'
from pathlib import Path
from collections import Counter
import re,sys
p=Path(sys.argv[1])
s=(p/'neon.s').read_text()
assert not re.search(r'^\s*(?:rev64|rev32|rev16|tbl|tbx|rbit|ext)\.',s,re.M), 'Unexpected vector shuffle'
report=[]
for half in ('High','Low'):
    expected=5 if half=='High' else 4
    for v in range(8):
        for direction in ('Seal','Unseal'):
            name=f'Quirk{half}{chr(65+v)}{direction}'
            body=re.search(r'^_'+name+r':.*?\.cfi_endproc',s,re.M|re.S)
            assert body, name
            counts=Counter(re.findall(r'^\s*(and|eor|ushr|shl|add|sub|sri|bsl|bif|bit)\.16b',body[0],re.M))
            assert counts['and'] and sum(counts.values())==expected*counts['and'], (name,counts)
            report.append(f'{name}: {expected} data operations/16 bytes; {dict(counts)}')
(p/'codegen.txt').write_text('PASS: all 32 independent kernels; no vector shuffles.\n'+'\n'.join(report)+'\n')
print('PASS: every High kernel has 5 NEON data operations/16 bytes; every Low kernel has 4. No vector shuffles.')
PY

# No compilation while timing.
"$output_directory/quirk-ciphers" "$output_directory" | tee "$output_directory/production.log"
uptime >> "$output_directory/metadata.txt"

"$cxx" "${common[@]}" -DIGNORE_SIMD=1 -fno-vectorize -fno-slp-vectorize "${sources[@]}" -o "$output_directory/quirk-scalar"
"$output_directory/quirk-scalar" --check | tee "$output_directory/scalar.log"
"$cxx" -std=c++20 -O1 -g -I "$project_root/Scramble/Composer" -fsanitize=address,undefined \
    -fno-omit-frame-pointer "${sources[@]}" -o "$output_directory/quirk-sanitized"
"$output_directory/quirk-sanitized" --check | tee "$output_directory/sanitizers.log"
print "Results: $output_directory"
