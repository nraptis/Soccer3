#!/bin/zsh
set -euo pipefail

# Standalone build: no app launch, seed generation, or Family source compilation.
project_root="${0:A:h:h}"
output_directory="${1:-$project_root/BenchmarkResults/quark-$(date +%Y%m%d-%H%M%S)}"
if [[ -e "$output_directory" ]]; then
    print -u2 "Output directory already exists: $output_directory"
    exit 1
fi
mkdir -p "$output_directory"
mock_directory="$project_root/ScrambleTests/__CipherMock"
cxx="${CXX:-clang++}"
common=(-std=c++20 -O3 -DNDEBUG -Wall -Wextra -Wpedantic)
{
    "$cxx" --version
    uname -m
    print 'Reference scalar: -O3 -fno-vectorize -fno-slp-vectorize; auto reference: -O3.'
    print 'NEON benchmark: -O3; one caller thread; no LTO; 11 samples x 32 passes, 1 MiB.'
} > "$output_directory/metadata.txt"

# Explicitly prevent vectorization only in the actual scalar classes.
for stage in High Low; do
    "$cxx" "${common[@]}" -fno-vectorize -fno-slp-vectorize -c \
        "$mock_directory/TESTQuark${stage}.cpp" -o "$output_directory/scalar-${stage}.o"
    "$cxx" "${common[@]}" -c "$mock_directory/TESTQuark${stage}.cpp" \
        -o "$output_directory/auto-${stage}.o"
    "$cxx" "${common[@]}" -S "$mock_directory/TESTQuark${stage}.cpp" \
        -o "$output_directory/auto-${stage}.s"
done
"$cxx" "${common[@]}" -c "$project_root/Tools/benchmark_quark.cpp" -o "$output_directory/benchmark.o"
"$cxx" "${common[@]}" "$output_directory/benchmark.o" \
    "$output_directory/scalar-High.o" "$output_directory/scalar-Low.o" -o "$output_directory/quark-scalar"
"$cxx" "${common[@]}" "$output_directory/benchmark.o" \
    "$output_directory/auto-High.o" "$output_directory/auto-Low.o" -o "$output_directory/quark-auto"
"$cxx" "${common[@]}" -S "$project_root/Tools/benchmark_quark.cpp" -o "$output_directory/benchmark.s"

"$output_directory/quark-scalar" scalar "$output_directory" | tee "$output_directory/scalar.log"
"$output_directory/quark-auto" auto "$output_directory" | tee "$output_directory/auto.log"

# The same correctness suite under address and undefined-behavior sanitizers.
"$cxx" -std=c++20 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer \
    "$project_root/Tools/benchmark_quark.cpp" "$mock_directory/TESTQuarkHigh.cpp" \
    "$mock_directory/TESTQuarkLow.cpp" -o "$output_directory/quark-sanitized"
"$output_directory/quark-sanitized" --check | tee "$output_directory/sanitizers.log"
print "Results: $output_directory"
