#ifndef TESTQuirkLowChecks_hpp
#define TESTQuirkLowChecks_hpp

#include "TESTQuirkHighChecks.hpp"
#include "TESTQuirkLow.hpp"
#include "TESTQuirkLowNEON.hpp"

namespace TESTQuirkLowChecks {
using TESTQuirkHighChecks::Require;
using TESTQuirkHighChecks::kUpdates;
using Update = TESTQuirkLow::Update;

inline std::array<TESTQuirkLow, 8> Plans(std::size_t a, std::size_t b, std::size_t c,
                                       Update pUpdate = TESTQuirkLow::kDefaultUpdate) {
    return {TestQuirkLowA(a,b,c,pUpdate), TestQuirkLowB(a,b,c,pUpdate),
            TestQuirkLowC(a,b,c,pUpdate), TestQuirkLowD(a,b,c,pUpdate),
            TestQuirkLowE(a,b,c,pUpdate), TestQuirkLowF(a,b,c,pUpdate),
            TestQuirkLowG(a,b,c,pUpdate), TestQuirkLowH(a,b,c,pUpdate)};
}

inline void Oracle(const TESTQuirkLow &pPlan, const std::uint8_t *pSource,
                    std::uint8_t *pDestination, std::size_t pLength, bool pInverse = false) {
    for (std::size_t i = 0U; i < pLength; ++i) {
        const unsigned a = pSource[TESTQuirkHighChecks::SampleIndex(i, pPlan.mWindowA, pPlan.mReverseA, pLength)] % 16U;
        const unsigned b = pSource[TESTQuirkHighChecks::SampleIndex(i, pPlan.mWindowB, pPlan.mReverseB, pLength)] % 16U;
        const unsigned c = pSource[TESTQuirkHighChecks::SampleIndex(i, pPlan.mWindowC, pPlan.mReverseC, pLength)] % 16U;
        const unsigned aKey = a ^ (b & c);
        const unsigned aOld = pSource[i] / 16U;
        const unsigned aChanged = pPlan.mUpdate == Update::kXor ? aOld ^ aKey :
            pInverse ? (aOld + 16U - aKey) % 16U : (aOld + aKey) % 16U;
        pDestination[i] = static_cast<std::uint8_t>(pSource[i] % 16U + 16U * aChanged);
    }
}

inline void CheckArithmetic() {
    std::array<std::uint8_t, 1024> aSource{}, aActual{}, aRecovered{};
    [[maybe_unused]] std::array<std::uint8_t, 1024> aSIMD{};
    for (auto aUpdate : kUpdates) {
        const auto aPlans = Plans(1U, 2U, 3U, aUpdate);
        for (unsigned a = 0U; a < 16U; ++a)
            for (unsigned b = 0U; b < 16U; ++b)
                for (unsigned c = 0U; c < 16U; ++c) {
                    for (unsigned i = 0U; i < 256U; ++i) {
                        aSource[i] = static_cast<std::uint8_t>(i);
                        aSource[256U+i] = static_cast<std::uint8_t>(a | (((i+1U) % 16U) << 4U));
                        aSource[512U+i] = static_cast<std::uint8_t>(b | (((i+7U) % 16U) << 4U));
                        aSource[768U+i] = static_cast<std::uint8_t>(c | (((i+11U) % 16U) << 4U));
                    }
                    for (const auto &aPlan : aPlans) {
                        Require(aPlan.SealData(aSource.data(), nullptr, aActual.data(), aSource.size()), "Low arithmetic rejected");
                        for (unsigned i = 0U; i < 256U; ++i) {
                            const unsigned aKey = a ^ (b & c);
                            const unsigned aNew = aUpdate == Update::kXor ? (i / 16U) ^ aKey : (i / 16U + aKey) % 16U;
                            Require(aActual[i] == i % 16U + 16U * aNew, "Low arithmetic mismatch");
                        }
                        Require(aPlan.UnsealData(aActual.data(), nullptr, aRecovered.data(), aActual.size()), "Low inverse rejected");
                        Require(aRecovered == aSource, "Low exhaustive round trip failed");
#if defined(__aarch64__)
                        Require(TESTQuirkLowNEON::SealData(aPlan, aSource.data(), aSIMD.data(), aSource.size()), "Low NEON arithmetic rejected");
                        Require(aSIMD == aActual, "Low NEON differs from scalar");
                        Require(TESTQuirkLowNEON::UnsealData(aPlan, aSIMD.data(), aRecovered.data(), aSIMD.size()), "Low NEON inverse rejected");
                        Require(aRecovered == aSource, "Low NEON exhaustive round trip failed");
#endif
                    }
                }
    }
}

inline void CheckBlocksAndSymmetry() {
    std::mt19937_64 aRandom(20261123U);
    constexpr auto kMax = std::numeric_limits<std::size_t>::max();
    const auto aSwap = [](std::uint8_t x) { return static_cast<std::uint8_t>((x >> 4U) | (unsigned(x) << 4U)); };
    for (std::size_t aLength : {256U,512U,768U,1280U,65536U,1048576U}) {
        std::vector<std::uint8_t> aInput(aLength+2U), aOutput(aLength+6U, 0xA5U);
        std::vector<std::uint8_t> aExpected(aLength), aRecovered(aLength), aSIMD(aLength), aSwapped(aLength), aHigh(aLength);
        auto *aSource = aInput.data()+1U;
        auto *aActual = aOutput.data()+3U;
        for (std::size_t i = 0U; i < aLength; ++i) {
            aSource[i] = static_cast<std::uint8_t>(aRandom());
            aSwapped[i] = aSwap(aSource[i]);
        }
        const auto aOriginal = aInput;
        for (auto aOffsets : {std::array<std::size_t,3>{0U,0U,0U}, {0U,1U,2U}, {127U,2671U,7903U}, {kMax,kMax-1U,7U}})
            for (auto aUpdate : kUpdates) {
                const auto aPlans = Plans(aOffsets[0], aOffsets[1], aOffsets[2], aUpdate);
                const auto aHighPlans = TESTQuirkHighChecks::Plans(aOffsets[0], aOffsets[1], aOffsets[2], aUpdate);
                for (unsigned v = 0U; v < 8U; ++v) {
                    const auto &aPlan = aPlans[v];
                    Require(aPlan.mReverseA == ((v&4U)!=0U) && aPlan.mReverseB == ((v&2U)!=0U) && aPlan.mReverseC == ((v&1U)!=0U), "Low preset direction mismatch");
                    for (bool aInverse : {false, true}) {
                        Oracle(aPlan, aSource, aExpected.data(), aLength, aInverse);
                        const auto aRun = [&](const std::uint8_t *src, std::uint8_t *dst) {
                            return aInverse ? aPlan.UnsealData(src,nullptr,dst,aLength) : aPlan.SealData(src,nullptr,dst,aLength);
                        };
                        Require(aRun(aSource,aActual), "Low valid block rejected");
                        Require(std::equal(aExpected.begin(),aExpected.end(),aActual), "Low oracle mismatch");
                        Require(aInput == aOriginal, "Low changed separate input");
                        std::copy_n(aSource,aLength,aRecovered.data());
                        Require(aRun(aRecovered.data(),aRecovered.data()), "Low in-place rejected");
                        Require(aRecovered == aExpected, "Low in-place mismatch");
                        const auto &aHighPlan = aHighPlans[v];
                        Require(aInverse ? aHighPlan.UnsealData(aSwapped.data(),nullptr,aHigh.data(),aLength) : aHighPlan.SealData(aSwapped.data(),nullptr,aHigh.data(),aLength), "High symmetry input rejected");
                        for (std::size_t i = 0U; i < aLength; ++i) {
                            Require(aActual[i] == aSwap(aHigh[i]), "Low does not mirror High under nibble swap");
                            Require(aActual[i] % 16U == aSource[i] % 16U, "Low changed protected bits");
                        }
#if defined(__aarch64__)
                        Require(aInverse ? TESTQuirkLowNEON::UnsealData(aPlan,aSource,aSIMD.data(),aLength) : TESTQuirkLowNEON::SealData(aPlan,aSource,aSIMD.data(),aLength), "Low NEON block rejected");
                        Require(aSIMD == aExpected, "Low NEON oracle mismatch");
                        std::copy_n(aSource,aLength,aSIMD.data());
                        Require(aInverse ? TESTQuirkLowNEON::UnsealData(aPlan,aSIMD.data(),aSIMD.data(),aLength) : TESTQuirkLowNEON::SealData(aPlan,aSIMD.data(),aSIMD.data(),aLength), "Low NEON in-place rejected");
                        Require(aSIMD == aExpected, "Low NEON in-place mismatch");
#endif
                    }
                    for (std::size_t i : {0U,1U,2U}) Require(aOutput[i] == 0xA5U && aOutput[aLength+3U+i] == 0xA5U, "Low wrote outside destination");
                }
            }
    }
}

inline void CheckValidation() {
    const auto aPlans = Plans(1U,2U,3U);
    for (const auto &aPlan : aPlans) {
        Require(aPlan.mUpdate == Update::kAdd, "Low default is not ADD");
        for (bool aInverse : {false,true}) {
            std::array<std::uint8_t,1025> aSource{};
            std::array<std::uint8_t,512> aOutput{};
            aOutput.fill(0xA5U);
            const auto aBefore = aOutput;
            const auto aRun = [&](const std::uint8_t *src, std::uint8_t *dst, std::size_t len) {
                const auto aResult = aInverse ? aPlan.UnsealData(src,nullptr,dst,len) : aPlan.SealData(src,nullptr,dst,len);
#if defined(__aarch64__)
                const auto aNEON = aInverse ? TESTQuirkLowNEON::UnsealData(aPlan,src,dst,len) : TESTQuirkLowNEON::SealData(aPlan,src,dst,len);
                Require(aNEON == aResult, "Low NEON validation differs");
#endif
                return aResult;
            };
            Require(aRun(nullptr,nullptr,0U), "Low zero length rejected");
            for (std::size_t len : {1U,16U,255U,257U,511U}) Require(!aRun(aSource.data(),aOutput.data(),len), "Low invalid length accepted");
            Require(!aRun(nullptr,aOutput.data(),256U) && !aRun(aSource.data(),nullptr,256U), "Low null buffer accepted");
            Require(!aRun(aSource.data(),aSource.data()+1U,512U) && !aRun(aSource.data()+1U,aSource.data(),512U), "Low partial overlap accepted");
            auto aInvalid = aPlan;
            aInvalid.mUpdate = static_cast<Update>(255U);
            Require(!(aInverse ? aInvalid.UnsealData(aSource.data(),nullptr,aOutput.data(),256U) : aInvalid.SealData(aSource.data(),nullptr,aOutput.data(),256U)), "Low invalid update accepted");
#if defined(__aarch64__)
            Require(!(aInverse ? TESTQuirkLowNEON::UnsealData(aInvalid,aSource.data(),aOutput.data(),256U) : TESTQuirkLowNEON::SealData(aInvalid,aSource.data(),aOutput.data(),256U)), "Low NEON invalid update accepted");
#endif
            Require(aOutput == aBefore, "Low rejected input changed output");
            Require(aRun(aSource.data(),aSource.data()+256U,256U), "Low adjacent buffers rejected");
        }
    }
}

inline void RunAll() {
    CheckArithmetic();
    CheckBlocksAndSymmetry();
    CheckValidation();
}
} // namespace TESTQuirkLowChecks
#endif
