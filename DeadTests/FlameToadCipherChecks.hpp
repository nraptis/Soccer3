#ifndef SOCCER_FLAME_TOAD_CHECKS_HPP_
#define SOCCER_FLAME_TOAD_CHECKS_HPP_
#include "FlameToadCipher.hpp"
#include <array>
#include <limits>
#include <random>
#include <vector>

namespace FlameToadChecks {
using Bytes = std::vector<std::uint8_t>;
inline unsigned Extract(std::uint8_t pValue, unsigned pProtected) {
    unsigned aResult = 0U, aIndex = 0U;
    for (unsigned b = 0U; b < 8U; ++b) if ((pProtected & (1U << b)) == 0U)
        aResult |= ((pValue >> b) & 1U) << aIndex++;
    return aResult;
}
inline unsigned Deposit(unsigned pValue, unsigned pProtected) {
    unsigned aResult = 0U, aIndex = 0U;
    for (unsigned b = 0U; b < 8U; ++b) if ((pProtected & (1U << b)) == 0U)
        aResult |= ((pValue >> aIndex++) & 1U) << b;
    return aResult;
}
// Independent reference: explicitly gather six destination bits, do arithmetic
// modulo 64, scatter them back. No carry-through-holes implementation trick.
inline Bytes Reference(const Bytes &pInput, unsigned pRowA, unsigned pRowB,
                       const std::array<std::size_t,4> &pRotations, bool pInverse = false) {
    Bytes aOutput(pInput.size());
    const unsigned aProtected = (1U << pRowA) | (1U << pRowB);
    unsigned aLowest = 0U; while (aProtected & (1U << aLowest)) ++aLowest;
    const auto aWindows = pInput.size()/64U;
    for (std::size_t w = 0U; w < aWindows; ++w) for (std::size_t s = 0U; s < 4U; ++s) {
        const auto aSource = ((w + pRotations[s] % aWindows) % aWindows)*64U;
        for (std::size_t g = 0U; g < 16U; ++g) {
            unsigned aPacked = 0U;
            for (unsigned j = 0U; j < 4U; ++j) {
                const auto aValue = pInput[aSource + 4U*g+j];
                aPacked |= ((aValue >> pRowA)&1U) << (2U*j);
                aPacked |= ((aValue >> pRowB)&1U) << (2U*j+1U);
            }
            if (((aPacked >> pRowA)&1U) && ((aPacked >> pRowB)&1U)) aPacked ^= 1U << aLowest;
            const auto aKey = Extract(static_cast<std::uint8_t>(aPacked), aProtected);
            const auto aIndex = 64U*w + 4U*g+s;
            const auto aValue = Extract(pInput[aIndex], aProtected);
            const auto aChanged = pInverse ? (aValue + 64U - aKey)&63U : (aValue + aKey)&63U;
            aOutput[aIndex] = static_cast<std::uint8_t>(Deposit(aChanged, aProtected) | (pInput[aIndex]&aProtected));
        }
    }
    return aOutput;
}
inline const char *CheckReferenceAndInverse() {
    std::mt19937_64 aRandom(0xF1A0E20261103ULL);
    for (unsigned a = 0U; a < 8U; ++a) for (unsigned b = 0U; b < 8U; ++b) if (a != b) {
        for (std::size_t aLength : {64U,128U,192U,448U,4096U}) {
            Bytes aSource(aLength), aOutput(aLength), aRestored(aLength);
            for (auto &aByte : aSource) aByte = static_cast<std::uint8_t>(aRandom());
            const std::array<std::size_t,4> aRotations{0U,1U,aLength/64U-1U,std::numeric_limits<std::size_t>::max()};
            FlameToadCipher aCipher(a,b,aRotations[0],aRotations[1],aRotations[2],aRotations[3]);
            if (!aCipher.SealData(aSource.data(),nullptr,aOutput.data(),aLength,nullptr)) return "seal failed";
            if (aOutput != Reference(aSource,a,b,aRotations)) return "forward reference mismatch";
            if (Reference(aOutput,a,b,aRotations,true) != aSource) return "reference inverse mismatch";
            if (!aCipher.UnsealData(aOutput.data(),nullptr,aRestored.data(),aLength,nullptr) || aRestored != aSource)
                return "inverse mismatch";
            Bytes aPacked(aLength/4U+8U,0xA5U), aCachedOutput(aLength);
            FlameToadCipher aCached(a,b,aRotations[0],aRotations[1],aRotations[2],aRotations[3],
                std::span<std::uint8_t>{aPacked.data()+3U,aLength/4U});
            if (!aCached.SealData(aSource.data(),nullptr,aCachedOutput.data(),aLength,nullptr) || aCachedOutput != aOutput)
                return "cached forward differs from direct/reference";
            // Decryption must rebuild from ciphertext; no prior cache contents
            // or immediately preceding encryption may be required.
            std::fill(aPacked.begin()+3U,aPacked.begin()+3U+aLength/4U,0x37U);
            if (!aCached.UnsealData(aCachedOutput.data(),nullptr,aRestored.data(),aLength,nullptr) || aRestored != aSource)
                return "cached inverse depends on old cache";
            for (std::size_t i=0U;i<aPacked.size();++i)
                if ((i<3U || i>=3U+aLength/4U) && aPacked[i]!=0xA5U) return "packed cache guard overwritten";
            for (std::size_t i=0U;i<aLength;++i) if ((aSource[i]^aOutput[i]) & ((1U<<a)|(1U<<b)))
                return "protected row changed";
        }
    }
    return nullptr;
}
inline const char *CheckCachedBuffers() {
    constexpr std::size_t kLength = 1048576U;
    Bytes aSource(kLength+16U,0xA5U), aOutput(kLength+16U,0xA5U), aRestored(kLength+16U,0xA5U);
    Bytes aPacked(kLength/4U+16U,0xA5U), aExpected(kLength);
    std::mt19937_64 aRandom(0xCA03E20261103ULL);
    for (std::size_t i=0U;i<kLength;++i) aSource[i+1U]=static_cast<std::uint8_t>(aRandom());
    const auto aSaved=aSource;
    FlameToadCipher aCached(0U,3U,2053U,6151U,10007U,14009U,{aPacked.data()+5U,kLength/4U});
    FlameToadCipher aDirect(0U,3U,2053U,6151U,10007U,14009U);
    if (!aDirect.SealData(aSource.data()+1U,nullptr,aExpected.data(),kLength,nullptr) ||
        !aCached.SealData(aSource.data()+1U,nullptr,aOutput.data()+3U,kLength,nullptr) ||
        !std::equal(aExpected.begin(),aExpected.end(),aOutput.begin()+3U)) return "cached unaligned 1 MiB mismatch";
    std::fill(aPacked.begin()+5U,aPacked.begin()+5U+kLength/4U,0x73U);
    if (!aCached.UnsealData(aOutput.data()+3U,nullptr,aRestored.data()+7U,kLength,nullptr) ||
        !std::equal(aSource.begin()+1U,aSource.begin()+1U+kLength,aRestored.begin()+7U)) return "cached full inverse";
    if (aSaved!=aSource) return "cached source modified";
    for (std::size_t i=0U;i<aPacked.size();++i)
        if ((i<5U || i>=5U+kLength/4U) && aPacked[i]!=0xA5U) return "full cache guard overwritten";
    for (std::size_t i=0U;i<aOutput.size();++i) {
        if ((i<3U || i>=3U+kLength) && aOutput[i]!=0xA5U) return "cached output guard overwritten";
        if ((i<7U || i>=7U+kLength) && aRestored[i]!=0xA5U) return "cached inverse guard overwritten";
    }
    for (bool aInverse : {false,true}) {
        for (auto aCache : {std::span<std::uint8_t>{aPacked.data(),15U},
                           std::span<std::uint8_t>{aSource.data(),16U},
                           std::span<std::uint8_t>{aSource.data()+63U,16U},
                           std::span<std::uint8_t>{aOutput.data(),16U}}) {
            FlameToadCipher aInvalid(0U,3U,0U,1U,2U,3U,aCache);
            const auto aBefore=aOutput;
            CipherErrorCode aError;
            const bool aSuccess=aInverse ? aInvalid.UnsealData(aSource.data(),nullptr,aOutput.data(),64U,&aError) :
                                           aInvalid.SealData(aSource.data(),nullptr,aOutput.data(),64U,&aError);
            const auto aExpectedError=aCache.size()<16U?CipherErrorCode::kInvalidParameter:CipherErrorCode::kAliasedBuffer;
            if (aSuccess || aError!=aExpectedError || aBefore!=aOutput) return "invalid cache accepted or output modified";
        }
    }
    return nullptr;
}
inline const char *CheckBuffers() {
    FlameToadCipher aCipher(0U,3U,2053U,6151U,10007U,14009U);
    constexpr std::size_t aLength = 1048576U;
    Bytes aSource(aLength+16U,0xA5U), aOutput(aLength+16U,0xA5U), aRestored(aLength+16U,0xA5U);
    for (std::size_t i=0U;i<aLength;++i) aSource[1U+i]=static_cast<std::uint8_t>((i*37U)^(i>>9U));
    const auto aSaved = aSource;
    std::array<std::uint8_t,64> aWorker{}; aWorker.fill(0x37U); const auto aSavedWorker=aWorker;
    if (!aCipher.SealData(aSource.data()+1U,aWorker.data(),aOutput.data()+3U,aLength,nullptr) ||
        !aCipher.UnsealData(aOutput.data()+3U,nullptr,aRestored.data()+5U,aLength,nullptr) ||
        !std::equal(aSource.begin()+1U,aSource.begin()+1U+aLength,aRestored.begin()+5U)) return "unaligned 1 MiB roundtrip";
    if (aSource != aSaved || aWorker != aSavedWorker) return "source/worker modified";
    for (std::size_t i=0U;i<aOutput.size();++i) {
        if ((i<3U || i>=aLength+3U) && aOutput[i]!=0xA5U) return "output guard overwritten";
        if ((i<5U || i>=aLength+5U) && aRestored[i]!=0xA5U) return "inverse guard overwritten";
    }
    for (bool aInverse : {false,true}) {
        const auto aApply = [&](const std::uint8_t *pSource,std::uint8_t *pOutput,std::size_t pLength,CipherErrorCode *pError) {
            return aInverse ? aCipher.UnsealData(pSource,nullptr,pOutput,pLength,pError) :
                              aCipher.SealData(pSource,nullptr,pOutput,pLength,pError);
        };
        CipherErrorCode aError;
        if (!aApply(nullptr,nullptr,0U,&aError) || aError!=CipherErrorCode::kNone) return "zero length";
        if (aApply(nullptr,aOutput.data(),64U,&aError) || aError!=CipherErrorCode::kNullBuffer) return "null input";
        if (aApply(aSource.data(),nullptr,64U,&aError) || aError!=CipherErrorCode::kNullBuffer) return "null output";
        for (std::size_t n : {1U,63U,65U,127U})
            if (aApply(aSource.data(),aOutput.data(),n,&aError) || aError!=CipherErrorCode::kInvalidLength) return "invalid length";
        for (std::size_t d : {0U,1U,16U,63U})
            if (aApply(aSource.data(),aSource.data()+d,64U,&aError) || aError!=CipherErrorCode::kAliasedBuffer ||
                aApply(aSource.data()+d,aSource.data(),64U,&aError) || aError!=CipherErrorCode::kAliasedBuffer) return "overlap";
        for (std::size_t row : {std::size_t{0},std::size_t{8},std::numeric_limits<std::size_t>::max()}) {
            FlameToadCipher aInvalid(0,row,0,1,2,3);
            const bool aSuccess = aInverse ? aInvalid.UnsealData(aSource.data(),nullptr,aOutput.data(),64U,&aError) :
                aInvalid.SealData(aSource.data(),nullptr,aOutput.data(),64U,&aError);
            if (aSuccess || aError!=CipherErrorCode::kInvalidParameter) return "invalid rows";
        }
    }
    return nullptr;
}
} // namespace FlameToadChecks
#endif
