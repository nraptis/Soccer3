#!/bin/zsh
set -euo pipefail

# Build and run the MAIN APP, not an XCTest or a replacement CLI kernel.
project_root="${0:A:h:h}"
benchmark_root="$project_root/BenchmarkResults"
derived_data="$benchmark_root/DerivedData"
output_directory="${1:-$benchmark_root/kernels-$(date +%Y%m%d-%H%M%S)}"
if [[ -e "$output_directory" ]]; then
    print -u2 "Output directory already exists: $output_directory"
    exit 1
fi
mkdir -p "$benchmark_root"
export DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
"$DEVELOPER_DIR/usr/bin/xcodebuild" \
    -project "$project_root/Scramble.xcodeproj" -scheme Scramble \
    -configuration Release -destination "platform=macOS,arch=$(uname -m)" \
    -derivedDataPath "$derived_data" \
    CLANG_ENABLE_CODE_COVERAGE=NO GCC_GENERATE_TEST_COVERAGE_FILES=NO \
    GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO CODE_SIGNING_ALLOWED=NO \
    build > "$benchmark_root/build.log" 2>&1 || {
        tail -n 60 "$benchmark_root/build.log"
        exit 1
    }
LLVM_PROFILE_FILE="$benchmark_root/profiling-runtime-%p.profraw" \
"$derived_data/Build/Products/Release/Scramble.app/Contents/MacOS/Scramble" \
    --benchmark-exit --benchmark-output "$output_directory"
