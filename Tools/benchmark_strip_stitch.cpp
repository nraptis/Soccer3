// From the repository root on an AArch64 Mac:
// clang++ -std=c++20 -O3 -DNDEBUG Tools/benchmark_strip_stitch.cpp -o /tmp/benchmark_strip_stitch
// /tmp/benchmark_strip_stitch
// Direct packing only: four offset streams, two rows, interleaved output.
// Does not measure gate/arithmetic, key caching, or the complete cipher.

#include "../ScrambleTests/__CipherMock/ByteStripStitchNEON.hpp"

#if defined(__aarch64__)
#include <algorithm>
#include <array>
#include <chrono>
#include <cstdio>
#include <random>
#include <vector>

namespace {
constexpr std::size_t kBytes = 1024 * 1024;
constexpr unsigned kSamples = 9;
constexpr unsigned kRepeats = 64;
// Keep physical offsets identical at both sizes; all are multiples of 64.
constexpr std::array<std::size_t, 4> kOffsets = {0, 127 * 64, 2671 * 64, 7903 * 64};

template<std::size_t WindowBytes>
__attribute__((noinline)) void PackBlock(const std::uint8_t *pSource,
                                        std::uint8_t *pDestination,
                                        const ByteStripStitchNEON::Plan &pPlan) {
    for (std::size_t aOffset = 0; aOffset < kBytes; aOffset += WindowBytes) {
        if constexpr (WindowBytes == 64) {
            uint8x16x4_t aPacked;
            for (std::size_t aWindow = 0; aWindow < 4; ++aWindow) {
                const auto aSourceOffset = (aOffset + kOffsets[aWindow]) & (kBytes - 1);
                aPacked.val[aWindow] = ByteStripStitchNEON::Pack64(pSource + aSourceOffset, pPlan);
            }
            vst4q_u8(pDestination + aOffset, aPacked);
        } else {
            uint8x8x4_t aPacked;
            for (std::size_t aWindow = 0; aWindow < 4; ++aWindow) {
                const auto aSourceOffset = (aOffset + kOffsets[aWindow]) & (kBytes - 1);
                aPacked.val[aWindow] = ByteStripStitchNEON::Pack32(pSource + aSourceOffset, pPlan);
            }
            vst4_u8(pDestination + aOffset, aPacked);
        }
    }
}
} // namespace

int main() {
    std::vector<std::uint8_t> aSource(kBytes), aOutput(kBytes), aComparison(kBytes);
    std::mt19937_64 aRandom(20261111);
    for (auto &aByte : aSource) aByte = static_cast<std::uint8_t>(aRandom());
    std::array<ByteStripStitchNEON::Plan, 4> aPlans;
    for (std::size_t aRotation = 0; aRotation < 4; ++aRotation) {
        aPlans[aRotation] = ByteStripStitchNEON::MakePlan(2, 5, aRotation);
        PackBlock<64>(aSource.data(), aOutput.data(), aPlans[aRotation]);
        PackBlock<32>(aSource.data(), aComparison.data(), aPlans[aRotation]);
        if (aOutput != aComparison) {
            std::fprintf(stderr, "32/64-byte output mismatch for stitch %zu\n", aRotation);
            return 1;
        }
    }

    std::array<std::array<double, kSamples>, 8> aTimings{};
    std::uint64_t aChecksum = 0;
    for (unsigned aSample = 0; aSample < kSamples; ++aSample) {
        // Vary measurement order so a single candidate is not always first.
        for (unsigned aStep = 0; aStep < 8; ++aStep) {
            const auto aCase = (aStep + 3 * aSample) % 8;
            const auto &aPlan = aPlans[aCase % 4];
            const auto aBegin = std::chrono::steady_clock::now();
            for (unsigned aRepeat = 0; aRepeat < kRepeats; ++aRepeat) {
                if (aCase < 4) PackBlock<64>(aSource.data(), aOutput.data(), aPlan);
                else PackBlock<32>(aSource.data(), aOutput.data(), aPlan);
                asm volatile("" ::: "memory");
            }
            const auto aEnd = std::chrono::steady_clock::now();
            const auto aSeconds = std::chrono::duration<double>(aEnd - aBegin).count();
            aTimings[aCase][aSample] = aSeconds * 1e9 / (kBytes * kRepeats);
            for (auto aByte : aOutput) aChecksum += aByte;
        }
    }
    std::puts("NEON direct pack; 1 MiB output/pass; 4 window offsets; rows 2,5.");
    std::puts("Plans built before timing; 9 samples x 64 passes; median (min..max).");
    std::puts("Window  Stitch  ns/output-byte          GiB output/s");
    for (unsigned aCase = 0; aCase < 8; ++aCase) {
        auto aSorted = aTimings[aCase];
        std::sort(aSorted.begin(), aSorted.end());
        const auto aMedian = aSorted[kSamples / 2];
        std::printf("%2u      %c       %.3f (%.3f..%.3f)     %.2f\n",
                    aCase < 4 ? 64 : 32, 'A' + aCase % 4, aMedian,
                    aSorted.front(), aSorted.back(), 1e9 / (aMedian * 1024 * 1024 * 1024));
    }
    std::printf("Checksum: %llu\n", static_cast<unsigned long long>(aChecksum));
}
#else
#include <cstdio>
int main() {
    std::fputs("This packing benchmark requires AArch64 NEON.\n", stderr);
    return 1;
}
#endif
