#ifndef SeedMaterialTestSupport_hpp
#define SeedMaterialTestSupport_hpp
#include "Soccer3.hpp"
#include "TwistMix64.hpp"
#include <array>
#include <cassert>
#include <random>

namespace SeedMaterialTestSupport {
using Layout = SeedMaterialLayout;
inline std::array<std::uint8_t*,4> Lanes() {
    return {Soccer3::mCollapseLaneA,Soccer3::mCollapseLaneB,Soccer3::mCollapseLaneC,Soccer3::mCollapseLaneD};
}
inline std::uint8_t *Source(std::size_t pWord) {
    return Lanes()[pWord/Layout::kWordsPerLane]+8U*(pWord%Layout::kWordsPerLane);
}
inline void Store(std::size_t pWord,std::uint64_t pValue) {
    for(unsigned i=0;i<8;++i)Source(pWord)[i]=static_cast<std::uint8_t>(pValue>>(8U*i));
}
inline std::uint64_t Read(std::size_t pWord) {
    std::uint64_t aValue=0;
    for(unsigned i=0;i<8;++i)aValue|=std::uint64_t{Source(pWord)[i]}<<(8U*i);
    return aValue;
}
inline std::uint64_t Choice(std::size_t pIndex) {return TwistMix64::DiffuseA(Read(pIndex));}
inline std::uint64_t UndoShift(std::uint64_t x,unsigned shift) {
    auto y=x;for(unsigned i=shift;i<64;i+=shift)y^=x>>i;return y;
}
inline std::uint64_t InverseOdd(std::uint64_t x) {
    std::uint64_t y=1;for(unsigned i=0;i<6;++i)y*=2-x*y;return y;
}
inline std::uint64_t Undiffuse(std::uint64_t x) {
    x=UndoShift(x,31)*InverseOdd(0x94D049BB133111EBULL);
    x=UndoShift(x,27)*InverseOdd(0xBF58476D1CE4E5B9ULL);return UndoShift(x,30);
}
inline void SetChoice(std::size_t pIndex,std::uint64_t pChoice) {Store(pIndex,Undiffuse(pChoice));}
inline std::array<std::uint64_t*,16> FreeRotationWords() {
    return {
        &Soccer3::mFreeRotationWordA,&Soccer3::mFreeRotationWordB,&Soccer3::mFreeRotationWordC,&Soccer3::mFreeRotationWordD,
        &Soccer3::mFreeRotationWordE,&Soccer3::mFreeRotationWordF,&Soccer3::mFreeRotationWordG,&Soccer3::mFreeRotationWordH,
        &Soccer3::mFreeRotationWordI,&Soccer3::mFreeRotationWordJ,&Soccer3::mFreeRotationWordK,&Soccer3::mFreeRotationWordL,
        &Soccer3::mFreeRotationWordM,&Soccer3::mFreeRotationWordN,&Soccer3::mFreeRotationWordO,&Soccer3::mFreeRotationWordP
    };
}
inline std::array<std::int32_t*,16> FreeRotations() {
    return {
        &Soccer3::mShiftMaskedCipherRotationAA,&Soccer3::mShiftMaskedCipherRotationAB,&Soccer3::mShiftMaskedCipherRotationAC,&Soccer3::mShiftMaskedCipherRotationAD,
        &Soccer3::mShiftMaskedCipherRotationAE,&Soccer3::mShiftMaskedCipherRotationAF,&Soccer3::mShiftMaskedCipherRotationAG,&Soccer3::mShiftMaskedCipherRotationAH,
        &Soccer3::mShiftMaskedCipherRotationBA,&Soccer3::mShiftMaskedCipherRotationBB,&Soccer3::mShiftMaskedCipherRotationBC,&Soccer3::mShiftMaskedCipherRotationBD,
        &Soccer3::mShiftMaskedCipherRotationBE,&Soccer3::mShiftMaskedCipherRotationBF,&Soccer3::mShiftMaskedCipherRotationBG,&Soccer3::mShiftMaskedCipherRotationBH
    };
}
inline void PreparedRotationSources(WindowRotationFarm::PreparedSource (&pSources)[WindowRotationFarm::kJobCount],
                                    std::uint64_t (&pOffsetWords)[2][8]) {
    const auto aWords = FreeRotationWords();
    for (std::size_t aIndex = 0U; aIndex < aWords.size(); ++aIndex)
        pOffsetWords[aIndex / 8U][aIndex % 8U] = *aWords[aIndex];
    for (std::size_t aJob = 0U; aJob < WindowRotationFarm::kJobCount; ++aJob) {
        const bool aFree = aJob % WindowRotationFarm::kJobsPerPlane == 0U;
        pSources[aJob] = {Soccer3::mWindowRotationBase[aJob], Soccer3::mWindowRotationAvailable[aJob],
            false,
            aFree ? pOffsetWords[aJob / WindowRotationFarm::kJobsPerPlane] : nullptr,
            Soccer3::mWindowRotationShuffleBytes[aJob]};
    }
}
inline void Prepare(std::uint64_t pSeed=0x384C011AULL) {
    std::mt19937_64 aRandom(pSeed);
    for(unsigned i=0;i<Layout::kSourceWords;++i)Store(i,aRandom());
    Soccer3::Zero();
    Soccer3::mBitPlaneWordA = 0U;
    Soccer3::mBitPlaneWordB = 0U;
    Soccer3::mBitPlaneWordC = 0U;
    for (auto *aWord : FreeRotationWords()) *aWord = 0U;
    for (auto *aRotation : FreeRotations()) *aRotation = 0;
    for (std::size_t aGeneration=0U;aGeneration<RandomShuffleLayout::kGenerationCount;++aGeneration) {
        for (auto &aByte : Soccer3::mRandom) aByte=static_cast<std::uint8_t>(aRandom());
        Soccer3::Shuffle_CROWSCIMASSORMATEX();
    }

}
}
#endif
