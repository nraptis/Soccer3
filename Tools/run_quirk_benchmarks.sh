#!/bin/zsh
set -euo pipefail

# Build/test only the Quirk prototype, without the app or expander families.
project_root="${0:A:h:h}"
output_directory="${1:-$project_root/BenchmarkResults/quirk-$(date +%Y%m%d-%H%M%S)}"
if [[ -e "$output_directory" ]]; then
    print -u2 "Output directory already exists: $output_directory"
    exit 1
fi
mkdir -p "$output_directory"
output_directory="${output_directory:A}"
mock_directory="$project_root/ScrambleTests/__CipherMock"
cxx="${CXX:-clang++}"
common=(-std=c++20 -O3 -DNDEBUG -Wall -Wextra -Wpedantic)
{
    "$cxx" --version
    uname -m
    uptime
    print '256-byte windows; reverse sixteen 16-byte chunks, preserving bytes inside each chunk.'
    print 'Scalar reference: -O3 -fno-vectorize -fno-slp-vectorize; auto reference: -O3; explicit NEON: -O3.'
    print 'No LTO; one caller thread; 11 samples x 32 passes; warm 1 MiB input.'
    print 'Reversible low-nibble XOR and modulo-16 ADD/SUB; paired NEON study: 17 samples x 64 passes per operator.'
    print 'ADD is preferred if its timing is indistinguishable from XOR within measurement noise.'
} > "$output_directory/metadata.txt"

"$cxx" "${common[@]}" -fno-vectorize -fno-slp-vectorize -c \
    "$mock_directory/TESTQuirkHigh.cpp" -o "$output_directory/scalar.o"
"$cxx" "${common[@]}" -c "$mock_directory/TESTQuirkHigh.cpp" -o "$output_directory/auto.o"
"$cxx" "${common[@]}" -c "$project_root/Tools/benchmark_quirk.cpp" -o "$output_directory/benchmark.o"
for mode in scalar auto; do
    "$cxx" "${common[@]}" "$output_directory/benchmark.o" "$output_directory/$mode.o" -o "$output_directory/quirk-$mode"
done

# A minimal code-generation probe isolates the NEON kernel from test/library code.
python3 - "$output_directory" <<'PY'
from pathlib import Path
import sys
Path(sys.argv[1], 'neon_probe.cpp').write_text('''#include "TESTQuirkHighNEON.hpp"
extern "C" bool QuirkNEONProbe(const TESTQuirkHigh *plan, const std::uint8_t *source,
                               std::uint8_t *dest, std::size_t length) {
    return TESTQuirkHighNEON::SealData(*plan, source, dest, length);
}
extern "C" bool QuirkNEONInverseProbe(const TESTQuirkHigh *plan, const std::uint8_t *source,
                                      std::uint8_t *dest, std::size_t length) {
    return TESTQuirkHighNEON::UnsealData(*plan, source, dest, length);
}
''')
PY
"$cxx" "${common[@]}" -I "$mock_directory" -S "$output_directory/neon_probe.cpp" -o "$output_directory/neon.s"
python3 - "$output_directory" <<'PY'
from pathlib import Path
from collections import Counter
import re, sys
p = Path(sys.argv[1])
assembly = (p/'neon.s').read_text()
shuffles = re.findall(r'^\s*(?:rev64|rev32|rev16|tbl|tbx|rbit|ext)\.', assembly, re.M)
assert not shuffles, 'Unexpected vector shuffle in chunk-order kernel'
counts = Counter(re.findall(r'^\s*(and|eor|ushr|shl|add|sub|sri|bsl|bif|bit)\.16b', assembly, re.M))
assert all(counts[name] for name in ('and', 'eor', 'sri', 'add', 'sub'))
(p/'codegen.txt').write_text(
    'PASS: no vector REV, TBL, RBIT, or EXT instructions; chunk reversals use load addresses.\n'
    'XOR core: 4 operations. ADD forward: 5 operations (shift/add/SRI); inverse subtracts and restores high bits.\n'
    'Static probe opcode counts: ' + str(dict(counts)) + '\n')
PY

# Build everything before timing; do not compile concurrently with benchmarks.
"$output_directory/quirk-scalar" scalar "$output_directory" | tee "$output_directory/scalar.log"
"$output_directory/quirk-auto" auto "$output_directory" | tee "$output_directory/auto.log"
uptime >> "$output_directory/metadata.txt"

"$cxx" -std=c++20 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer \
    "$project_root/Tools/benchmark_quirk.cpp" "$mock_directory/TESTQuirkHigh.cpp" -o "$output_directory/quirk-sanitized"
"$output_directory/quirk-sanitized" --check | tee "$output_directory/sanitizers.log"
print "Results: $output_directory"
