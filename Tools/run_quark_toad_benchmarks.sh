#!/bin/zsh
set -euo pipefail

project_root="${0:A:h:h}"
output_directory="${1:-$project_root/BenchmarkResults/quark-vs-toad-$(date +%Y%m%d-%H%M%S)}"
if [[ -e "$output_directory" ]]; then
    print -u2 "Output directory already exists: $output_directory"
    exit 1
fi
mkdir -p "$output_directory"
output_directory="${output_directory:A}"
cxx="${CXX:-clang++}"
common=(-std=c++20 -O3 -DNDEBUG -Wall -Wextra -Wpedantic)
includes=(-I "$project_root/Scramble/Composer" -I "$project_root/Scramble/Encrypter"
          -I "$project_root/Scramble/Encrypter/Kernels" -I "$project_root/Scramble/Expander/Core"
          -I "$project_root/Scramble/Expander/Family" -I "$project_root/Scramble/Public")
{
    "$cxx" --version
    uname -m
    print 'All: -std=c++20 -O3 -DNDEBUG, no LTO. Quark/serial FourToadKernel: caller only.'
    print 'FourCrowKernel at 1 MiB: caller + 3 persistent helpers.'
    print 'Current FourToadKernel and three-window variants: caller + 3 persistent helper threads.'
    print 'Serial build-only variant changes ONLY the worker threshold; production source untouched.'
    print 'Three-window build-only variant reuses key A in stripe D; production reference repeats offset A.'
    print '1 MiB, warm buffers, 11 samples x 32 passes. Seed/material generation excluded.'
    uptime
    shasum -a 256 "$project_root/Scramble/Encrypter/Kernels/FourToadKernel.cpp" \
        "$project_root/Scramble/Encrypter/Kernels/FourCrowKernel.cpp" \
        "$project_root/Scramble/Encrypter/Kernels/FourRavenKernel.cpp" \
        "$project_root/Scramble/Encrypter/Kernels/CorvidShift.cpp"
} > "$output_directory/metadata.txt"

# Generate explicit, reviewable experiment sources; never edit production ciphers.
python3 - "$project_root" "$output_directory" <<'PY'
from pathlib import Path
from collections import Counter
import json
import re
import sys
root, out = map(Path, sys.argv[1:])
original = (root/'Scramble/Encrypter/Kernels/FourToadKernel.cpp').read_text()
threshold = 'constexpr std::size_t kParallelBytes = 64U * 1024U;'
assert original.count(threshold) == 1
(out/'FourToadSerial.cpp').write_text(original.replace(threshold,
    'constexpr std::size_t kParallelBytes = static_cast<std::size_t>(-1);'))
loop = '''                for (std::size_t aLane = 0; aLane < 4; ++aLane) {
                    const auto aKey = vld1q_u8(pKeys + kKeysPerWindow * (aSamples[aLane] + aIndex));'''
replacement = '''                const auto aFirstKey = vld1q_u8(pKeys + kKeysPerWindow * (aSamples[0] + aIndex));
                for (std::size_t aLane = 0; aLane < 4; ++aLane) {
                    const auto aKey = (aLane == 0 || aLane == 3) ? aFirstKey :
                        vld1q_u8(pKeys + kKeysPerWindow * (aSamples[aLane] + aIndex));'''
assert original.count(loop) == 1
(out/'FourToadThreeWindow.cpp').write_text(original.replace(loop, replacement))
(out/'variant_bridge.cpp').write_text('''#include "FourToadKernel.hpp"
extern "C" Kernel *TOAD_FACTORY(const std::size_t *rows, const std::size_t *offsets,
                                std::uint8_t *cache, std::size_t length) {
    std::array<FourToadKernel::Stage, 4> stages;
    for (std::size_t i = 0; i < 4; ++i)
        stages[i] = {rows[2*i], rows[2*i+1], {offsets[4*i], offsets[4*i+1], offsets[4*i+2], offsets[4*i+3]}};
    return new FourToadKernel(stages[0], stages[1], stages[2], stages[3], {cache, length});
}
''')

# Audit the masks actually published by Soccer3, independent of cipher names.
schedule = (root/'Scramble/Composer/Soccer3Cryptex.cpp').read_text()
layers = {}
for layer, side, body in re.findall(r'mCorvidShift([AB][ABCD])(Left|Right)\s*=\s*\{(.*?)\};', schedule, re.S):
    bits = re.findall(r'1U\s*<<\s*mBitRowA([A-H])', body)
    assert len(bits) == 2
    layers.setdefault(layer, {})[side] = bits
order = ['AA', 'AB', 'AC', 'AD', 'BA', 'BB', 'BC', 'BD']
counts = Counter()
for layer in order:
    bits = layers[layer]['Left'] + layers[layer]['Right']
    assert len(set(bits)) == 4
    counts.update(bits)
assert counts == Counter({bit: 4 for bit in 'ABCDEFGH'})
for i in range(0, 8, 2):
    covered = set(sum([layers[layer]['Left'] + layers[layer]['Right'] for layer in order[i:i+2]], []))
    assert covered == set('ABCDEFGH')
(out/'corvid-coverage.json').write_text(json.dumps({
    'layers': layers, 'shift_counts': dict(counts),
    'layer_pairs_1_2__3_4__5_6__7_8_cover_all_planes': True}, indent=2) + '\n')
PY

# Compile the actual mixer sources; no Family implementation files are built.
"$cxx" "${common[@]}" "${includes[@]}" -c "$project_root/Scramble/Encrypter/Kernels/FourToadKernel.cpp" -o "$output_directory/toad.o"
"$cxx" "${common[@]}" "${includes[@]}" -c "$project_root/Scramble/Encrypter/Kernels/CorvidShift.cpp" -o "$output_directory/corvid.o"
"$cxx" "${common[@]}" "${includes[@]}" -c "$project_root/Scramble/Encrypter/Kernels/FourCrowKernel.cpp" -o "$output_directory/crow.o"
"$cxx" "${common[@]}" "${includes[@]}" -c "$project_root/Scramble/Encrypter/Kernels/FourRavenKernel.cpp" -o "$output_directory/raven.o"
for variant in Serial ThreeWindow; do
    if [[ "$variant" == Serial ]]; then factory=CreateSerialToad; else factory=CreateThreeWindowToad; fi
    "$cxx" "${common[@]}" "${includes[@]}" -DFourToad=FourToadKernel${variant} \
        -c "$output_directory/FourToadKernel${variant}.cpp" -o "$output_directory/${variant}.o"
    "$cxx" "${common[@]}" "${includes[@]}" -DFourToad=FourToadKernel${variant} -DTOAD_FACTORY=$factory \
        -c "$output_directory/variant_bridge.cpp" -o "$output_directory/${variant}-bridge.o"
done
for stage in High Low; do
    "$cxx" "${common[@]}" -c "$project_root/ScrambleTests/__CipherMock/TESTQuark${stage}.cpp" \
        -o "$output_directory/quark-${stage}.o"
done
"$cxx" "${common[@]}" "${includes[@]}" -DQUARK_COMPARE_TOAD \
    -c "$project_root/Tools/benchmark_quark.cpp" -o "$output_directory/benchmark.o"
objects=("$output_directory/toad.o" "$output_directory/corvid.o" "$output_directory/Serial.o"
         "$output_directory/crow.o" "$output_directory/raven.o"
         "$output_directory/Serial-bridge.o" "$output_directory/ThreeWindow.o" "$output_directory/ThreeWindow-bridge.o"
         "$output_directory/quark-High.o" "$output_directory/quark-Low.o" "$output_directory/benchmark.o")
"$cxx" "${common[@]}" "${objects[@]}" -o "$output_directory/compare"
"$output_directory/compare" comparison "$output_directory" | tee "$output_directory/comparison.log"
uptime >> "$output_directory/metadata.txt"
print "Results: $output_directory"
