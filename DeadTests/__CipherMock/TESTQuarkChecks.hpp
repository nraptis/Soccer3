#ifndef TESTQuarkChecks_hpp
#define TESTQuarkChecks_hpp

#include "TESTQuarkHigh.hpp"
#include "TESTQuarkLow.hpp"

#include <algorithm>
#include <array>
#include <limits>
#include <random>
#include <stdexcept>
#include <vector>

namespace TESTQuarkChecks {
inline void Require(bool pCondition, const char *pMessage) {
    if (!pCondition) throw std::runtime_error(pMessage);
}

template<class Stage, bool SampleHigh>
void CheckArithmetic() {
    constexpr std::size_t kWindow = Stage::kWindowBytes;
    constexpr unsigned kProtected = SampleHigh ? 0xF0U : 0x0FU;
    const Stage aStage(1U, 2U);
    std::array<std::uint8_t, 3U * kWindow> aSource{}, aOutput{}, aRecovered{};
    for (unsigned a = 0U; a < 16U; ++a) {
        for (unsigned b = 0U; b < 16U; ++b) {
            for (unsigned x = 0U; x < 256U; ++x) {
                std::fill_n(aSource.data(), kWindow, static_cast<std::uint8_t>(x));
                std::fill_n(aSource.data() + kWindow, kWindow, static_cast<std::uint8_t>(
                    SampleHigh ? (a << 4U) | ((x + 3U) & 15U) : ((x & 15U) << 4U) | a));
                std::fill_n(aSource.data() + 2U * kWindow, kWindow, static_cast<std::uint8_t>(
                    SampleHigh ? (b << 4U) | ((x + 9U) & 15U) : (((x + 7U) & 15U) << 4U) | b));
                aOutput.fill(0xA5U); // No preinitialization with CW is required.
                Require(aStage.SealData(aSource.data(), nullptr, aOutput.data(), aSource.size()),
                        "Quark exhaustive seal rejected valid input");
                const unsigned aField = SampleHigh ? x & 15U : x >> 4U;
                const unsigned aChanged = (aField + (a ^ b)) % 16U;
                const unsigned aExpected = SampleHigh ? (x & 240U) | aChanged : (x & 15U) | (aChanged << 4U);
                for (std::size_t i = 0U; i < aOutput.size(); ++i) {
                    Require((aOutput[i] & kProtected) == (aSource[i] & kProtected),
                            "Quark changed a protected sample nibble");
                    if (i < kWindow) Require(aOutput[i] == aExpected, "Quark nibble arithmetic mismatch");
                }
                Require(aStage.UnsealData(aOutput.data(), nullptr, aRecovered.data(), aOutput.size()),
                        "Quark exhaustive unseal rejected valid input");
                Require(aSource == aRecovered, "Quark exhaustive round trip failed");
            }
        }
    }
}

inline void CheckRoundTrips() {
    std::mt19937_64 aRandom(20261122U);
    constexpr auto kMax = std::numeric_limits<std::size_t>::max();
    for (std::size_t aLength : {32U, 96U, 1024U, 65536U, 1048576U}) {
        std::vector<std::uint8_t> aSource(aLength), aWorker(aLength), aOutput(aLength), aRecovered(aLength);
        for (auto &aByte : aSource) aByte = static_cast<std::uint8_t>(aRandom());
        for (auto aOffsets : {std::array<std::size_t, 2>{0U, 0U}, {0U, 1U}, {127U, 2671U}, {kMax, 7U}}) {
            const TESTQuarkHigh aHigh(aOffsets[0], aOffsets[1]);
            const TESTQuarkLow aLow(aOffsets[1] + (aOffsets[1] != kMax), aOffsets[0]);
            Require(aHigh.SealData(aSource.data(), nullptr, aWorker.data(), aLength), "High seal failed");
            auto aInPlace = aSource;
            Require(aHigh.SealData(aInPlace.data(), nullptr, aInPlace.data(), aLength), "High in-place seal failed");
            Require(aInPlace == aWorker, "High in-place result mismatch");
            Require(aLow.SealData(aWorker.data(), nullptr, aOutput.data(), aLength), "Low seal failed");
            Require(aLow.SealData(aInPlace.data(), nullptr, aInPlace.data(), aLength), "Low in-place seal failed");
            Require(aInPlace == aOutput, "Pair in-place result mismatch");
            // Undo Low first, then High. Low must sample High's completed output.
            Require(aLow.UnsealData(aOutput.data(), nullptr, aWorker.data(), aLength), "Low unseal failed");
            Require(aHigh.UnsealData(aWorker.data(), nullptr, aRecovered.data(), aLength), "High unseal failed");
            Require(aSource == aRecovered, "High/Low pair round trip failed");
            Require(aLow.UnsealData(aInPlace.data(), nullptr, aInPlace.data(), aLength), "Low in-place unseal failed");
            Require(aHigh.UnsealData(aInPlace.data(), nullptr, aInPlace.data(), aLength), "High in-place unseal failed");
            Require(aInPlace == aSource, "Pair in-place inverse mismatch");
        }
    }
}

template<class Stage>
void CheckValidation() {
    const Stage aStage(1U, 2U);
    std::array<std::uint8_t, 129U> aSource{};
    std::array<std::uint8_t, 64U> aOutput{};
    aOutput.fill(0xA5U);
    const auto aBefore = aOutput;
    Require(aStage.SealData(nullptr, nullptr, nullptr, 0U), "Zero length should succeed");
    Require(aStage.UnsealData(nullptr, nullptr, nullptr, 0U), "Zero inverse length should succeed");
    for (std::size_t aLength : {1U, 16U, 31U, 33U, 63U}) {
        Require(!aStage.SealData(aSource.data(), nullptr, aOutput.data(), aLength), "Invalid length accepted");
        Require(!aStage.UnsealData(aSource.data(), nullptr, aOutput.data(), aLength), "Invalid inverse length accepted");
    }
    Require(!aStage.SealData(nullptr, nullptr, aOutput.data(), 64U), "Null input accepted");
    Require(!aStage.UnsealData(aSource.data(), nullptr, nullptr, 64U), "Null output accepted");
    Require(aOutput == aBefore, "Rejected call changed destination");
    const auto aOriginal = aSource;
    Require(!aStage.SealData(aSource.data(), nullptr, aSource.data() + 1U, 64U), "Partial overlap accepted");
    Require(!aStage.UnsealData(aSource.data() + 1U, nullptr, aSource.data(), 64U), "Reverse partial overlap accepted");
    Require(aSource == aOriginal, "Rejected overlap changed input");
}

inline void RunAll() {
    CheckArithmetic<TESTQuarkHigh, true>();
    CheckArithmetic<TESTQuarkLow, false>();
    CheckRoundTrips();
    CheckValidation<TESTQuarkHigh>();
    CheckValidation<TESTQuarkLow>();
}
} // namespace TESTQuarkChecks

#endif /* TESTQuarkChecks_hpp */
