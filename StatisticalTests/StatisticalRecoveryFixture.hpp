#pragma once
#include "StatisticalRecoveryHarness.hpp"

// Stable random-fixture recipe shared by ManyShot and predictor capture.
// The campaign seed and zero-based fixture index reproduce password, nonce,
// template, flag positions, and the two separately seeded challenge streams.
namespace StatisticalRecovery { namespace {
struct RandomFixture {
    std::array<std::uint8_t,32U> mPassword{};
    std::uint64_t mNonce;
    std::uint64_t mChallengeSeed;
    std::uint64_t mConfirmSeed;
    Scenario mScenario;
};
RandomFixture MakeRandomFixture(std::uint64_t pSeed,std::size_t pIndex) {
    std::mt19937_64 aRandom(pSeed ^ (0x9E3779B97F4A7C15ULL * (pIndex + 1U)));
    RandomFixture aRandomFixture;
    for (auto &aByte : aRandomFixture.mPassword) aByte = static_cast<std::uint8_t>(aRandom());
    aRandomFixture.mNonce = aRandom();
    aRandomFixture.mChallengeSeed = aRandom();
    aRandomFixture.mConfirmSeed = aRandom();
    auto &aScenario = aRandomFixture.mScenario;
    aScenario.mTemplate.resize(kBlockBytes);
    Fill(aScenario.mTemplate,aRandom);
    // Rotate through contiguous, stride-8, and stride-64 unknown-byte clusters.
    // The other 32 flags span the entire MiB. Both halves cover each plane four times.
    const std::size_t aStrides[] = {1U,8U,64U};
    const auto aStride = aStrides[pIndex % 3U];
    const auto aCluster = (aRandom() % (kBlockBytes - 4096U)) & ~std::size_t{63U};
    for (std::size_t aFlag = 0U;aFlag < kFlags;++aFlag) {
        std::uint32_t aBit;
        do {
            const auto aByte = aFlag < 32U ? aCluster + aFlag * aStride :
                (aFlag - 32U) * (kBlockBytes / 32U) + aRandom() % (kBlockBytes / 32U);
            aBit = static_cast<std::uint32_t>(8U*aByte + aFlag % 8U);
        } while (std::find(aScenario.mBits.begin(),aScenario.mBits.begin()+aFlag,aBit) != aScenario.mBits.begin()+aFlag);
        aScenario.mBits[aFlag] = aBit;
        aScenario.mTemplate[aBit/8U] &= static_cast<std::uint8_t>(~(1U << (aBit%8U)));
    }
    return aRandomFixture;
}

} } // namespace StatisticalRecovery
