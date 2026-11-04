#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
RELEASE_DIR="${ROOT_DIR}/release"
CONFIG="Release"
REQUIRE_ALL=0
BUILT_TARGETS=()
SKIPPED_TARGETS=()

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

need_command() {
    command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

note_skip() {
    local target="$1"
    local reason="$2"
    SKIPPED_TARGETS+=("${target}: ${reason}")
    printf 'skip: %s (%s)\n' "${target}" "${reason}"
}

note_built() {
    BUILT_TARGETS+=("$1")
}

run_cmake_build() {
    local build_path="$1"
    local install_path="$2"
    shift 2

    cmake -S "${ROOT_DIR}" -B "${build_path}" "$@"
    cmake --build "${build_path}" --config "${CONFIG}"
    cmake --install "${build_path}" --config "${CONFIG}" --prefix "${install_path}"
}

build_mac() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        note_skip "libsoccer-Mac" "must be built on macOS"
        return
    fi

    local archs="${SOCCER_MAC_ARCHS:-arm64}"
    run_cmake_build \
        "${BUILD_DIR}/cmake-mac" \
        "${RELEASE_DIR}/libsoccer-Mac" \
        -DCMAKE_BUILD_TYPE="${CONFIG}" \
        -DCMAKE_OSX_ARCHITECTURES="${archs}"
    note_built "${RELEASE_DIR}/libsoccer-Mac"
}

build_linux() {
    if [[ "$(uname -s)" == "Linux" ]]; then
        run_cmake_build \
            "${BUILD_DIR}/cmake-linux" \
            "${RELEASE_DIR}/libsoccer-Linux" \
            -DCMAKE_BUILD_TYPE="${CONFIG}"
        note_built "${RELEASE_DIR}/libsoccer-Linux"
        return
    fi

    if [[ -z "${SOCCER_LINUX_TOOLCHAIN_FILE:-}" ]]; then
        note_skip "libsoccer-Linux" "requires Linux, or set SOCCER_LINUX_TOOLCHAIN_FILE to a CMake toolchain file"
        return
    fi
    [[ -f "${SOCCER_LINUX_TOOLCHAIN_FILE}" ]] || die "SOCCER_LINUX_TOOLCHAIN_FILE does not exist: ${SOCCER_LINUX_TOOLCHAIN_FILE}"

    run_cmake_build \
        "${BUILD_DIR}/cmake-linux" \
        "${RELEASE_DIR}/libsoccer-Linux" \
        -DCMAKE_BUILD_TYPE="${CONFIG}" \
        -DCMAKE_TOOLCHAIN_FILE="${SOCCER_LINUX_TOOLCHAIN_FILE}"
    note_built "${RELEASE_DIR}/libsoccer-Linux"
}

build_win64_mingw() {
    local toolchain_file="${BUILD_DIR}/toolchains/mingw-win64.cmake"
    mkdir -p "$(dirname "${toolchain_file}")"

    cat > "${toolchain_file}" <<'EOF'
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)
set(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)
EOF

    run_cmake_build \
        "${BUILD_DIR}/cmake-win64-mingw" \
        "${RELEASE_DIR}/libsoccer-Win64" \
        -DCMAKE_BUILD_TYPE="${CONFIG}" \
        -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
    note_built "${RELEASE_DIR}/libsoccer-Win64"
}

build_win64() {
    if [[ "${OS:-}" == "Windows_NT" ]]; then
        run_cmake_build \
            "${BUILD_DIR}/cmake-win64-msvc" \
            "${RELEASE_DIR}/libsoccer-Win64" \
            -G "Visual Studio 17 2022" \
            -A x64
        note_built "${RELEASE_DIR}/libsoccer-Win64"
        return
    fi

    if command -v x86_64-w64-mingw32-g++ >/dev/null 2>&1; then
        build_win64_mingw
        return
    fi

    if [[ -z "${SOCCER_WIN64_TOOLCHAIN_FILE:-}" ]]; then
        note_skip "libsoccer-Win64" "requires Windows with Visual Studio, MinGW-w64 (x86_64-w64-mingw32-g++), or set SOCCER_WIN64_TOOLCHAIN_FILE"
        return
    fi
    [[ -f "${SOCCER_WIN64_TOOLCHAIN_FILE}" ]] || die "SOCCER_WIN64_TOOLCHAIN_FILE does not exist: ${SOCCER_WIN64_TOOLCHAIN_FILE}"

    run_cmake_build \
        "${BUILD_DIR}/cmake-win64" \
        "${RELEASE_DIR}/libsoccer-Win64" \
        -DCMAKE_BUILD_TYPE="${CONFIG}" \
        -DCMAKE_TOOLCHAIN_FILE="${SOCCER_WIN64_TOOLCHAIN_FILE}"
    note_built "${RELEASE_DIR}/libsoccer-Win64"
}

main() {
    for arg in "$@"; do
        case "${arg}" in
            --require-all)
                REQUIRE_ALL=1
                ;;
            -h|--help)
                printf 'usage: ./build.sh [--require-all]\n'
                printf '\n'
                printf 'Builds any available libsoccer targets into release/.\n'
                printf 'Use --require-all to fail if Mac, Linux, and Win64 are not all built.\n'
                exit 0
                ;;
            *)
                die "unknown argument: ${arg}"
                ;;
        esac
    done

    need_command cmake
    mkdir -p "${RELEASE_DIR}"

    build_mac
    build_linux
    build_win64

    printf '\nBuilt release artifacts:\n'
    if [[ "${#BUILT_TARGETS[@]}" -eq 0 ]]; then
        printf '  none\n'
    else
        printf '  %s\n' "${BUILT_TARGETS[@]}"
    fi

    if [[ "${#SKIPPED_TARGETS[@]}" -gt 0 ]]; then
        printf '\nSkipped targets:\n'
        printf '  %s\n' "${SKIPPED_TARGETS[@]}"
    fi

    if [[ "${REQUIRE_ALL}" -eq 1 && "${#SKIPPED_TARGETS[@]}" -gt 0 ]]; then
        die "--require-all was set, but some targets were skipped"
    fi
}

main "$@"
