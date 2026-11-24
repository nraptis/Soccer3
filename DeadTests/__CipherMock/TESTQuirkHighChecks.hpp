#ifndef TESTQuirkHighChecks_hpp
#define TESTQuirkHighChecks_hpp

#include "TESTQuirkHigh.hpp"
#include "TESTQuirkHighNEON.hpp"

#include <algorithm>
#include <array>
#include <limits>
#include <random>
#include <stdexcept>
#include <vector>

namespace TESTQuirkHighChecks {
using Update = TESTQuirkHigh::Update;
inline constexpr std::array kUpdates = {Update::kXor, Update::kAdd};
inline void Require(bool pCondition, const char *pMessage) {
    if (!pCondition) throw std::runtime_error(pMessage);
}

inline std::array<TESTQuirkHigh, 8> Plans(std::size_t a, std::size_t b, std::size_t c,
                                        Update pUpdate = TESTQuirkHigh::kDefaultUpdate) {
    return {TestQuirkHighA(a,b,c,pUpdate), TestQuirkHighB(a,b,c,pUpdate), TestQuirkHighC(a,b,c,pUpdate), TestQuirkHighD(a,b,c,pUpdate),
            TestQuirkHighE(a,b,c,pUpdate), TestQuirkHighF(a,b,c,pUpdate), TestQuirkHighG(a,b,c,pUpdate), TestQuirkHighH(a,b,c,pUpdate)};
}

inline void CheckPresets() {
    const auto aPlans = Plans(1U, 2U, 3U);
    for (unsigned i = 0U; i < aPlans.size(); ++i) {
        Require(aPlans[i].mReverseA == ((i & 4U) != 0U), "Wrong preset A direction");
        Require(aPlans[i].mReverseB == ((i & 2U) != 0U), "Wrong preset B direction");
        Require(aPlans[i].mReverseC == ((i & 1U) != 0U), "Wrong preset C direction");
        Require(aPlans[i].mUpdate == TESTQuirkHigh::kDefaultUpdate, "Wrong preset update default");
    }
}

// Independent byte-index oracle: reversing 16-byte chunk order toggles only
// local index bits 4..7. The low four lane bits stay in their original order.
inline std::size_t SampleIndex(std::size_t i, std::size_t pOffset,
                               bool pReverse, std::size_t pLength) {
    const auto aCount = pLength / 256U;
    const auto aWindow = (i / 256U + pOffset % aCount) % aCount;
    const auto aLocal = i % 256U;
    return 256U * aWindow + (pReverse ? aLocal ^ 0xF0U : aLocal);
}

inline void Oracle(const TESTQuirkHigh &pPlan, const std::uint8_t *pSource,
                    std::uint8_t *pDestination, std::size_t pLength, bool pInverse = false) {
    for (std::size_t i = 0U; i < pLength; ++i) {
        const unsigned a = pSource[SampleIndex(i, pPlan.mWindowA, pPlan.mReverseA, pLength)] >> 4U;
        const unsigned b = pSource[SampleIndex(i, pPlan.mWindowB, pPlan.mReverseB, pLength)] >> 4U;
        const unsigned c = pSource[SampleIndex(i, pPlan.mWindowC, pPlan.mReverseC, pLength)] >> 4U;
        const unsigned aKey = a ^ (b & c);
        const unsigned aLow = pSource[i] % 16U;
        const unsigned aChanged = pPlan.mUpdate == Update::kXor ? aLow ^ aKey :
            pInverse ? (aLow + 16U - aKey) % 16U : (aLow + aKey) % 16U;
        pDestination[i] = static_cast<std::uint8_t>((pSource[i] & 240U) + aChanged);
    }
}

inline void CheckArithmetic() {
    std::array<std::uint8_t, 1024> aSource{}, aActual{}, aRecovered{};
    [[maybe_unused]] std::array<std::uint8_t, 1024> aSIMD{};
    // All 4096 sampled-nibble triples and all 256 current byte values, for
    // every variant and operation: 16,777,216 arithmetic cases plus inverses.
    // Batch all 256 current values into the first window of each call.
    for (auto aUpdate : kUpdates) {
        const auto aPlans = Plans(1U, 2U, 3U, aUpdate);
        for (unsigned a = 0U; a < 16U; ++a)
            for (unsigned b = 0U; b < 16U; ++b)
                for (unsigned c = 0U; c < 16U; ++c) {
                    for (unsigned i = 0U; i < 256U; ++i) {
                        aSource[i] = static_cast<std::uint8_t>(i);
                        aSource[256U + i] = static_cast<std::uint8_t>((a << 4U) | ((i + 1U) & 15U));
                        aSource[512U + i] = static_cast<std::uint8_t>((b << 4U) | ((i + 7U) & 15U));
                        aSource[768U + i] = static_cast<std::uint8_t>((c << 4U) | ((i + 11U) & 15U));
                    }
                    for (const auto &aPlan : aPlans) {
                        aActual.fill(0xA5U);
                        Require(aPlan.SealData(aSource.data(), nullptr, aActual.data(), aSource.size()), "Arithmetic input rejected");
                        for (unsigned i = 0U; i < 256U; ++i) {
                            const unsigned aKey = a ^ (b & c);
                            const unsigned aExpectedLow = aUpdate == Update::kXor ? (i % 16U) ^ aKey : (i % 16U + aKey) % 16U;
                            Require(aActual[i] == ((i & 240U) | aExpectedLow), "Nibble arithmetic mismatch");
                        }
                        for (unsigned i = 0U; i < aSource.size(); ++i)
                            Require((aActual[i] & 240U) == (aSource[i] & 240U), "Changed a protected high nibble");
                        Require(aPlan.UnsealData(aActual.data(), nullptr, aRecovered.data(), aActual.size()), "Arithmetic inverse rejected");
                        Require(aRecovered == aSource, "Scalar exhaustive round trip failed");
#if defined(__aarch64__)
                        Require(TESTQuirkHighNEON::SealData(aPlan, aSource.data(), aSIMD.data(), aSource.size()), "NEON arithmetic input rejected");
                        Require(aSIMD == aActual, "NEON arithmetic differs from scalar");
                        Require(TESTQuirkHighNEON::UnsealData(aPlan, aSIMD.data(), aRecovered.data(), aSIMD.size()), "NEON arithmetic inverse rejected");
                        Require(aRecovered == aSource, "NEON exhaustive round trip failed");
#endif
                    }
                }
    }
}

inline void CheckChunkDirections() {
    std::array<std::uint8_t, 1024> aSource{}, aActual{};
    for (auto aUpdate : kUpdates) {
        const auto aPlans = Plans(1U, 2U, 3U, aUpdate);
        for (unsigned aStream = 0U; aStream < 3U; ++aStream) {
            aSource.fill(0U);
            // Isolate A directly, B with C=15, or C with B=15.
            if (aStream == 1U) std::fill_n(aSource.data() + 768U, 256U, 0xF0U);
            if (aStream == 2U) std::fill_n(aSource.data() + 512U, 256U, 0xF0U);
            for (unsigned i = 0U; i < 256U; ++i) {
                const auto aTag = (i / 16U + i % 16U) % 16U;
                aSource[256U * (aStream + 1U) + i] = static_cast<std::uint8_t>(aTag << 4U);
            }
            for (const auto &aPlan : aPlans) {
                Require(aPlan.SealData(aSource.data(), nullptr, aActual.data(), aSource.size()), "Tagged input rejected");
                const bool aReverse = aStream == 0U ? aPlan.mReverseA : aStream == 1U ? aPlan.mReverseB : aPlan.mReverseC;
                for (unsigned i = 0U; i < 256U; ++i) {
                    const auto aChunk = aReverse ? 15U - i / 16U : i / 16U;
                    Require(aActual[i] == (aChunk + i % 16U) % 16U, "Chunk reversal changed within-chunk byte order");
                }
            }
        }
    }
}

inline void CheckBlocks() {
    std::mt19937_64 aRandom(20261123U);
    constexpr auto kMax = std::numeric_limits<std::size_t>::max();
    for (std::size_t aLength : {256U, 512U, 768U, 1280U, 65536U, 1048576U}) {
        // Deliberately unaligned starts, with sentinels before and after output.
        std::vector<std::uint8_t> aInputStorage(aLength + 2U), aOutputStorage(aLength + 6U, 0xA5U);
        std::vector<std::uint8_t> aExpected(aLength), aInverseExpected(aLength), aInPlace(aLength), aSIMD(aLength), aRecovered(aLength);
        auto *aSource = aInputStorage.data() + 1U;
        auto *aOutput = aOutputStorage.data() + 3U;
        for (std::size_t i = 0U; i < aLength; ++i) aSource[i] = static_cast<std::uint8_t>(aRandom());
        const auto aOriginal = aInputStorage;
        for (auto aOffsets : {std::array<std::size_t, 3>{0U,0U,0U}, {0U,1U,2U}, {1U,2U,3U}, {127U,2671U,7903U}, {kMax,kMax-1U,7U}}) {
            for (auto aUpdate : kUpdates) {
                for (const auto &aPlan : Plans(aOffsets[0], aOffsets[1], aOffsets[2], aUpdate)) {
                    Oracle(aPlan, aSource, aExpected.data(), aLength);
                    Require(aPlan.SealData(aSource, nullptr, aOutput, aLength), "Valid block rejected");
                    Require(std::equal(aExpected.begin(), aExpected.end(), aOutput), "Byte-index oracle mismatch");
                    Require(aInputStorage == aOriginal, "Separate-output call changed input");
                    Require(aPlan.UnsealData(aOutput, nullptr, aRecovered.data(), aLength), "Scalar block inverse rejected");
                    Require(std::equal(aRecovered.begin(), aRecovered.end(), aSource), "Scalar block round trip failed");
                    Oracle(aPlan, aSource, aInverseExpected.data(), aLength, true);
                    Require(aPlan.UnsealData(aSource, nullptr, aRecovered.data(), aLength), "Arbitrary inverse rejected");
                    Require(aRecovered == aInverseExpected, "Scalar inverse oracle mismatch");
                    std::copy_n(aSource, aLength, aInPlace.data());
                    Require(aPlan.SealData(aInPlace.data(), nullptr, aInPlace.data(), aLength), "In-place input rejected");
                    Require(aInPlace == aExpected, "In-place scalar mismatch");
                    Require(aPlan.UnsealData(aInPlace.data(), nullptr, aInPlace.data(), aLength), "In-place scalar inverse rejected");
                    Require(std::equal(aInPlace.begin(), aInPlace.end(), aSource), "In-place scalar round trip failed");
#if defined(__aarch64__)
                    Require(TESTQuirkHighNEON::SealData(aPlan, aSource, aSIMD.data(), aLength), "NEON block rejected");
                    Require(aSIMD == aExpected, "NEON byte-index oracle mismatch");
                    Require(TESTQuirkHighNEON::UnsealData(aPlan, aSIMD.data(), aRecovered.data(), aLength), "NEON inverse rejected");
                    Require(std::equal(aRecovered.begin(), aRecovered.end(), aSource), "NEON block round trip failed");
                    Require(TESTQuirkHighNEON::UnsealData(aPlan, aSource, aSIMD.data(), aLength), "NEON arbitrary inverse rejected");
                    Require(aSIMD == aInverseExpected, "NEON inverse oracle mismatch");
                    std::copy_n(aSource, aLength, aSIMD.data());
                    Require(TESTQuirkHighNEON::SealData(aPlan, aSIMD.data(), aSIMD.data(), aLength), "NEON in-place input rejected");
                    Require(aSIMD == aExpected, "NEON in-place mismatch");
                    Require(TESTQuirkHighNEON::UnsealData(aPlan, aSIMD.data(), aSIMD.data(), aLength), "NEON in-place inverse rejected");
                    Require(std::equal(aSIMD.begin(), aSIMD.end(), aSource), "NEON in-place round trip failed");
#endif
                    for (std::size_t i : {0U,1U,2U})
                        Require(aOutputStorage[i] == 0xA5U && aOutputStorage[aLength + 3U + i] == 0xA5U,
                                "Write outside destination");
                }
            }
        }
    }
}

inline void CheckValidation() {
    const TESTQuirkHigh aPlan(1U, 2U, 3U, true, false, true);
    std::array<std::uint8_t, 1025> aSource{};
    std::array<std::uint8_t, 512> aOutput{};
    const auto aRun = [&](bool pInverse, const std::uint8_t *src, std::uint8_t *dst, std::size_t len) {
        const auto aResult = pInverse ? aPlan.UnsealData(src, nullptr, dst, len) : aPlan.SealData(src, nullptr, dst, len);
#if defined(__aarch64__)
        const auto aNEON = pInverse ? TESTQuirkHighNEON::UnsealData(aPlan, src, dst, len) : TESTQuirkHighNEON::SealData(aPlan, src, dst, len);
        Require(aNEON == aResult, "NEON validation differs");
#endif
        return aResult;
    };
    aOutput.fill(0xA5U);
    const auto aBefore = aOutput;
    for (bool aInverse : {false, true}) {
        Require(aRun(aInverse, nullptr, nullptr, 0U), "Zero length rejected");
        for (std::size_t aLength : {1U,16U,32U,255U,257U,511U})
            Require(!aRun(aInverse, aSource.data(), aOutput.data(), aLength), "Invalid length accepted");
        Require(!aRun(aInverse, nullptr, aOutput.data(), 256U), "Null input accepted");
        Require(!aRun(aInverse, aSource.data(), nullptr, 256U), "Null output accepted");
        Require(aOutput == aBefore, "Rejected input changed destination");
        const auto aOriginal = aSource;
        Require(!aRun(aInverse, aSource.data(), aSource.data() + 1U, 512U), "Partial overlap accepted");
        Require(!aRun(aInverse, aSource.data() + 1U, aSource.data(), 512U), "Reverse partial overlap accepted");
        Require(aSource == aOriginal, "Rejected overlap changed input");
        Require(aRun(aInverse, aSource.data(), aSource.data() + 256U, 256U), "Adjacent buffers rejected");
    }
    auto aInvalid = aPlan;
    aInvalid.mUpdate = static_cast<Update>(255U);
    Require(!aInvalid.SealData(aSource.data(), nullptr, aOutput.data(), 256U), "Invalid update accepted");
    Require(!aInvalid.UnsealData(aSource.data(), nullptr, aOutput.data(), 256U), "Invalid inverse update accepted");
#if defined(__aarch64__)
    Require(!TESTQuirkHighNEON::SealData(aInvalid, aSource.data(), aOutput.data(), 256U), "NEON invalid update accepted");
    Require(!TESTQuirkHighNEON::UnsealData(aInvalid, aSource.data(), aOutput.data(), 256U), "NEON invalid inverse update accepted");
#endif
    Require(aOutput == aBefore, "Invalid update changed destination");
}

inline void CheckReversibility() {
    std::mt19937_64 aRandom(20261123U);
    std::array<std::uint8_t, 8192> aSource{}, aDifferentLow{}, aFirst{}, aSecond{}, aExpected{}, aRecovered{};
    for (std::size_t i = 0U; i < aSource.size(); ++i) {
        aSource[i] = static_cast<std::uint8_t>(aRandom());
        aDifferentLow[i] = aSource[i] ^ 0x0FU;
    }
    for (auto aUpdate : kUpdates) {
        auto aPlans = Plans(1U, 2U, 3U, aUpdate);
        for (const auto &aPlan : aPlans) {
            Require(aPlan.SealData(aSource.data(), nullptr, aExpected.data(), aSource.size()), "Reversibility input rejected");
            Require(aPlan.SealData(aDifferentLow.data(), nullptr, aSecond.data(), aSource.size()), "Different-low input rejected");
            for (std::size_t i = 0U; i < aSource.size(); ++i)
                Require(aSecond[i] != aExpected[i], "Old low-nibble data was lost");
            Require(aPlan.UnsealData(aExpected.data(), nullptr, aRecovered.data(), aExpected.size()), "Reversibility inverse rejected");
            Require(aRecovered == aSource, "Single-stage round trip failed");
            if (aUpdate == Update::kXor) {
                Require(aPlan.SealData(aExpected.data(), nullptr, aSecond.data(), aExpected.size()), "Second XOR application failed");
                Require(aSecond == aSource, "XOR mode is not self-inverse");
            }
        }
        // Give each stage distinct geometry, then undo the complete sequence.
        for (std::size_t i = 0U; i < aPlans.size(); ++i) {
            aPlans[i].mWindowA += 3U * i;
            aPlans[i].mWindowB += 7U * i;
            aPlans[i].mWindowC += 11U * i;
        }
        aFirst = aSource;
        for (const auto &aPlan : aPlans) {
            Require(aPlan.SealData(aFirst.data(), nullptr, aSecond.data(), aFirst.size()), "Sequence seal failed");
            aFirst.swap(aSecond);
        }
        Require(aFirst != aSource, "Sequence fixture canceled to identity");
        for (auto i = aPlans.size(); i-- > 0U;) {
            Require(aPlans[i].UnsealData(aFirst.data(), nullptr, aSecond.data(), aFirst.size()), "Sequence inverse failed");
            aFirst.swap(aSecond);
        }
        Require(aFirst == aSource, "Sequence round trip failed");
    }
}

inline void RunAll() {
    CheckPresets();
    CheckArithmetic();
    CheckChunkDirections();
    CheckBlocks();
    CheckValidation();
    CheckReversibility();
}
} // namespace TESTQuirkHighChecks

#endif /* TESTQuirkHighChecks_hpp */
