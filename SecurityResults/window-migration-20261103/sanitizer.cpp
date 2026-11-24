#include "WindowRotationFarm.hpp"
#include "SeedMaterialLayout.hpp"
#include <algorithm>
#include <cstdio>
#include <cstring>
#include <memory>
#include <random>
using namespace WindowRotationFarm;
int main() {
    auto aEntropy = std::make_unique<std::uint8_t[]>(SeedMaterialLayout::kRotationSourceBytes);
    Source aSources[kJobCount];
    for (std::size_t aJob = 0; aJob < kJobCount; ++aJob)
        aSources[aJob] = {aEntropy.get() + aJob * SeedMaterialLayout::kRotationJobBytes, SeedMaterialLayout::kRotationJobBytes};
    Buffers aBuffers{};
    Statistics aStatistics[kJobCount]{};
    std::mt19937_64 aRandom(0x18FA4DULL);
    std::size_t aMinimum = SeedMaterialLayout::kRotationJobBytes, aMaximum = 0;
    for (unsigned aTrial = 0; aTrial < 128; ++aTrial) {
        for (std::size_t aByte = 0; aByte < SeedMaterialLayout::kRotationSourceBytes; aByte += 8) {
            const auto aWord = aRandom();
            for (unsigned aLane = 0; aLane < 8; ++aLane)
                aEntropy[aByte + aLane] = static_cast<std::uint8_t>(aWord >> (8 * aLane));
        }
        WindowRotationPack aPack{};
        if (!FarmPack(aSources, aBuffers, aPack, aStatistics) || !IsValid(aPack)) return 1;
        for (const auto &aJob : aStatistics) {
            aMinimum = std::min(aMinimum, aJob.mEntropyBytesRead);
            aMaximum = std::max(aMaximum, aJob.mEntropyBytesRead);
        }
        auto aBad = aPack;
        aBad.mPlaneB.mChunkD.mWindowP = 65535;
        if (IsValid(aBad)) return 2;
        aBad = aPack; aBad.mPlaneB.mChunkD.mFreeB = -1;
        if (IsValid(aBad)) return 3;
    }
    std::printf("PASS: 128 full packs, 2304 jobs, bounded sources and independent validator; ASan/UBSan.\nEntropy bytes consumed per job: min=%zu max=%zu allocated=%zu\n", aMinimum, aMaximum, SeedMaterialLayout::kRotationJobBytes);
}
