#ifndef SOCCER_QUIRK_CIPHER_CHECKS_HPP_
#define SOCCER_QUIRK_CIPHER_CHECKS_HPP_

#include "../../Scramble/Encrypter/Ciphers/QuirkHigh.hpp"
#include "../../Scramble/Encrypter/Ciphers/QuirkLow.hpp"
#include "../../Scramble/Encrypter/CryptexLayer.hpp"
#include "../__CipherMock/TESTQuirkLowChecks.hpp"
#include <memory>
#include <type_traits>

namespace QuirkCipherChecks {
using TESTQuirkHighChecks::Require;
using Ciphers = std::array<std::unique_ptr<Cipher>,16>;

inline Ciphers Make(std::size_t a, std::size_t b, std::size_t c) {
    return {std::make_unique<QuirkHighA>(a,b,c), std::make_unique<QuirkHighB>(a,b,c),
            std::make_unique<QuirkHighC>(a,b,c), std::make_unique<QuirkHighD>(a,b,c),
            std::make_unique<QuirkHighE>(a,b,c), std::make_unique<QuirkHighF>(a,b,c),
            std::make_unique<QuirkHighG>(a,b,c), std::make_unique<QuirkHighH>(a,b,c),
            std::make_unique<QuirkLowA>(a,b,c), std::make_unique<QuirkLowB>(a,b,c),
            std::make_unique<QuirkLowC>(a,b,c), std::make_unique<QuirkLowD>(a,b,c),
            std::make_unique<QuirkLowE>(a,b,c), std::make_unique<QuirkLowF>(a,b,c),
            std::make_unique<QuirkLowG>(a,b,c), std::make_unique<QuirkLowH>(a,b,c)};
}

inline constexpr std::array kTypes = {
    CipherType::kQuirkHighA, CipherType::kQuirkHighB, CipherType::kQuirkHighC, CipherType::kQuirkHighD,
    CipherType::kQuirkHighE, CipherType::kQuirkHighF, CipherType::kQuirkHighG, CipherType::kQuirkHighH,
    CipherType::kQuirkLowA, CipherType::kQuirkLowB, CipherType::kQuirkLowC, CipherType::kQuirkLowD,
    CipherType::kQuirkLowE, CipherType::kQuirkLowF, CipherType::kQuirkLowG, CipherType::kQuirkLowH};
static_assert(std::is_final_v<QuirkHighA> && std::is_final_v<QuirkLowH>);
static_assert(!std::is_same_v<QuirkHighA,QuirkHighB> && !std::is_same_v<QuirkHighA,QuirkLowA>);

inline void CheckArithmetic() {
    const auto aCiphers = Make(1U,2U,3U);
    const auto aHighPlans = TESTQuirkHighChecks::Plans(1U,2U,3U,TESTQuirkHigh::Update::kAdd);
    const auto aLowPlans = TESTQuirkLowChecks::Plans(1U,2U,3U,TESTQuirkLow::Update::kAdd);
    std::array<std::uint8_t,1024> aSource{}, aExpected{}, aActual{}, aRecovered{};
    for (unsigned aHalf = 0U; aHalf < 2U; ++aHalf)
        for (unsigned a = 0U; a < 16U; ++a)
            for (unsigned b = 0U; b < 16U; ++b)
                for (unsigned c = 0U; c < 16U; ++c) {
                    for (unsigned i = 0U; i < 256U; ++i) {
                        aSource[i] = static_cast<std::uint8_t>(i);
                        for (unsigned w = 0U; w < 3U; ++w) {
                            const unsigned aNibble = std::array{a,b,c}[w];
                            const unsigned aOther = (i+3U*w+1U)%16U;
                            aSource[256U*(w+1U)+i] = static_cast<std::uint8_t>(
                                aHalf == 0U ? 16U*aNibble+aOther : aNibble+16U*aOther);
                        }
                    }
                    for (unsigned v = 0U; v < 8U; ++v) {
                        const auto &aCipher = *aCiphers[8U*aHalf+v];
                        Require(aCipher.mType == kTypes[8U*aHalf+v], "Wrong production CipherType");
                        if (aHalf == 0U) TESTQuirkHighChecks::Oracle(aHighPlans[v],aSource.data(),aExpected.data(),aSource.size());
                        else TESTQuirkLowChecks::Oracle(aLowPlans[v],aSource.data(),aExpected.data(),aSource.size());
                        Require(aCipher.SealData(aSource.data(),nullptr,aActual.data(),aSource.size(),nullptr), "Production arithmetic rejected");
                        Require(aActual == aExpected, "Production arithmetic differs from independent oracle");
                        Require(aCipher.UnsealData(aActual.data(),nullptr,aRecovered.data(),aActual.size(),nullptr), "Production inverse rejected");
                        Require(aRecovered == aSource, "Production exhaustive round trip failed");
                    }
                }
}

inline void CheckBlocks() {
    std::mt19937_64 aRandom(20261123U);
    constexpr auto kMax = std::numeric_limits<std::size_t>::max();
    for (std::size_t aLength : {256U,512U,768U,1280U,65536U,1048576U}) {
        std::vector<std::uint8_t> aInput(aLength+2U), aOutput(aLength+6U,0xA5U);
        std::vector<std::uint8_t> aExpected(aLength), aRecovered(aLength), aInPlace(aLength);
        std::array<std::uint8_t,17> aWorker{};
        aWorker.fill(0x5AU);
        const auto aWorkerBefore = aWorker;
        auto *aSource = aInput.data()+1U;
        auto *aActual = aOutput.data()+3U;
        for (std::size_t i = 0U; i < aLength; ++i) aSource[i] = static_cast<std::uint8_t>(aRandom());
        const auto aOriginal = aInput;
        for (auto aOffsets : {std::array<std::size_t,3>{0U,0U,0U}, {0U,1U,2U}, {1U,1U,2U}, {127U,2671U,7903U}, {kMax,kMax-1U,7U}}) {
            const auto aCiphers = Make(aOffsets[0],aOffsets[1],aOffsets[2]);
            const auto aHigh = TESTQuirkHighChecks::Plans(aOffsets[0],aOffsets[1],aOffsets[2],TESTQuirkHigh::Update::kAdd);
            const auto aLow = TESTQuirkLowChecks::Plans(aOffsets[0],aOffsets[1],aOffsets[2],TESTQuirkLow::Update::kAdd);
            for (unsigned v = 0U; v < 16U; ++v) {
                const auto &aCipher = *aCiphers[v];
                for (bool aInverse : {false,true}) {
                    if (v < 8U) TESTQuirkHighChecks::Oracle(aHigh[v],aSource,aExpected.data(),aLength,aInverse);
                    else TESTQuirkLowChecks::Oracle(aLow[v-8U],aSource,aExpected.data(),aLength,aInverse);
                    const auto aRun = [&](const std::uint8_t *src, std::uint8_t *dst) {
                        return aInverse ? aCipher.UnsealData(src,aWorker.data(),dst,aLength,nullptr) : aCipher.SealData(src,aWorker.data(),dst,aLength,nullptr);
                    };
                    Require(aRun(aSource,aActual), "Production block rejected");
                    Require(std::equal(aExpected.begin(),aExpected.end(),aActual), "Production block oracle mismatch");
                    Require(aInput == aOriginal && aWorker == aWorkerBefore, "Production modified source or worker");
                    std::copy_n(aSource,aLength,aInPlace.data());
                    Require(aRun(aInPlace.data(),aInPlace.data()), "Production in-place rejected");
                    Require(aInPlace == aExpected, "Production in-place oracle mismatch");
                    Require(aInverse ? aCipher.SealData(aActual,nullptr,aRecovered.data(),aLength,nullptr) : aCipher.UnsealData(aActual,nullptr,aRecovered.data(),aLength,nullptr), "Production round trip rejected");
                    Require(std::equal(aRecovered.begin(),aRecovered.end(),aSource), "Production full-block round trip failed");
                    for (std::size_t i : {0U,1U,2U}) Require(aOutput[i] == 0xA5U && aOutput[aLength+3U+i] == 0xA5U, "Production wrote outside destination");
                }
            }
        }
    }
}

inline void CheckValidationAndZero() {
    const auto aCiphers = Make(1U,2U,3U);
    const auto aZeroCiphers = Make(0U,0U,0U);
    std::array<std::uint8_t,1025> aSource{};
    for (std::size_t i = 0U; i < aSource.size(); ++i) aSource[i] = static_cast<std::uint8_t>(17U*i+i/16U);
    for (unsigned v = 0U; v < 16U; ++v) {
        auto &aCipher = *aCiphers[v];
        Require(aCipher.mType == kTypes[v], "Production type catalog mismatch");
        for (bool aInverse : {false,true}) {
            std::array<std::uint8_t,512> aOutput{};
            aOutput.fill(0xA5U);
            const auto aBefore = aOutput;
            CipherErrorCode aError = CipherErrorCode::kInvalidParameter;
            const auto aRun = [&](const std::uint8_t *src, std::uint8_t *dst, std::size_t len) {
                return aInverse ? aCipher.UnsealData(src,nullptr,dst,len,&aError) : aCipher.SealData(src,nullptr,dst,len,&aError);
            };
            Require(aRun(nullptr,nullptr,0U) && aError == CipherErrorCode::kNone, "Production zero-length error");
            for (std::size_t len : {1U,16U,255U,257U,511U}) Require(!aRun(aSource.data(),aOutput.data(),len) && aError == CipherErrorCode::kInvalidLength, "Production length validation failed");
            Require(!aRun(nullptr,aOutput.data(),256U) && aError == CipherErrorCode::kNullBuffer, "Production null input accepted");
            Require(!aRun(aSource.data(),nullptr,256U) && aError == CipherErrorCode::kNullBuffer, "Production null output accepted");
            auto aOverlap = aSource;
            Require(!aRun(aOverlap.data(),aOverlap.data()+1U,512U) && aError == CipherErrorCode::kAliasedBuffer, "Production overlap accepted");
            Require(!aRun(aOverlap.data()+1U,aOverlap.data(),512U) && aError == CipherErrorCode::kAliasedBuffer, "Production reverse overlap accepted");
            Require(aOverlap == aSource && aOutput == aBefore, "Production validation wrote to rejected output");
            Require(aRun(aOverlap.data(),aOverlap.data()+256U,256U) && aError == CipherErrorCode::kNone, "Production adjacent buffers rejected");
        }
        aCipher.Zero();
        std::array<std::uint8_t,1024> aExpected{}, aActual{};
        Require(aZeroCiphers[v]->SealData(aSource.data(),nullptr,aExpected.data(),1024U,nullptr), "Zero comparison rejected");
        Require(aCipher.SealData(aSource.data(),nullptr,aActual.data(),1024U,nullptr), "Zeroed cipher rejected");
        Require(aActual == aExpected && aCipher.mType == kTypes[v], "Zero did not reset offsets or changed type");
    }
}

inline void CheckComposition() {
    constexpr std::size_t kLength = 8192U;
    std::mt19937_64 aRandom(20261123U);
    std::vector<std::uint8_t> aSource(kLength), aExpected(kLength), aTemp(kLength), aActual(kLength), aWorker(kLength), aRecovered(kLength);
    for (auto &aByte : aSource) aByte = static_cast<std::uint8_t>(aRandom());
    for (unsigned aCount : {15U,16U}) {
        CryptexLayer aLayer;
        auto aCiphers = Make(1U,7U,13U);
        const auto aHigh = TESTQuirkHighChecks::Plans(1U,7U,13U,TESTQuirkHigh::Update::kAdd);
        const auto aLow = TESTQuirkLowChecks::Plans(1U,7U,13U,TESTQuirkLow::Update::kAdd);
        aExpected = aSource;
        for (unsigned i = 0U; i < aCount; ++i) {
            const auto aIndex = 8U*(i%2U)+i/2U;
            aLayer.Add(aCiphers[aIndex].release());
            if (i%2U == 0U) TESTQuirkHighChecks::Oracle(aHigh[i/2U],aExpected.data(),aTemp.data(),kLength);
            else TESTQuirkLowChecks::Oracle(aLow[i/2U],aExpected.data(),aTemp.data(),kLength);
            aExpected.swap(aTemp);
            Require(aLayer.GetCipherType(i) == kTypes[aIndex], "Layer lost production type");
        }
        Require(aLayer.GetCipherCount() == aCount, "Layer lost cipher");
        Require(aLayer.SealData(aSource.data(),aWorker.data(),aActual.data(),kLength,nullptr), "Mixed High/Low layer seal rejected");
        Require(aActual == aExpected && aActual != aSource, "Mixed layer differs from oracle or canceled");
        Require(aLayer.UnsealData(aActual.data(),aWorker.data(),aRecovered.data(),kLength,nullptr), "Mixed High/Low layer inverse rejected");
        Require(aRecovered == aSource, "Mixed High/Low layer round trip failed");
    }
}

inline void RunAll() {
    CheckArithmetic();
    CheckBlocks();
    CheckValidationAndZero();
    CheckComposition();
}
} // namespace QuirkCipherChecks
#endif
