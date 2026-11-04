//
//  WorkSpaceTools.hpp
//  ScrambleTests
//
//  Created by nicholas raptis on 7/17/26.
//

#ifndef WorkSpaceTools_hpp
#define WorkSpaceTools_hpp

#include "Random.hpp"
#include "TwistExpander.hpp"

#include <cstddef>
#include <cstdio>
#include <cstdint>

struct WorkSpaceBundle {
    TwistWorkSpace                          mWorkSpace;
    TwistDomainConstants                    mConstants = {};
    TwistDomainSaltSet                      mDomainSaltSet = {};
    
    std::uint8_t                            mSource[S_BLOCK] = {};
    std::uint8_t                            mSnow[S_BLOCK] = {};
    
    std::uint64_t                           mNonce = 0U;
    std::uint64_t                           mPrevious = 0U;
    std::uint64_t                           mIngress = 0U;
    std::uint64_t                           mCarry = 0U;
    
    std::uint64_t                           mWandererA = 0U;
    std::uint64_t                           mWandererB = 0U;
    std::uint64_t                           mWandererC = 0U;
    std::uint64_t                           mWandererD = 0U;
    std::uint64_t                           mWandererE = 0U;
    std::uint64_t                           mWandererF = 0U;
    std::uint64_t                           mWandererG = 0U;
    std::uint64_t                           mWandererH = 0U;
    std::uint64_t                           mWandererI = 0U;
    std::uint64_t                           mWandererJ = 0U;
    std::uint64_t                           mWandererK = 0U;
    
    WorkSpaceBundle Clone() const {
        return WorkSpaceBundle(*this);
    }
    
};

class WorkSpaceTools {
public:
    
    static WorkSpaceBundle MakeWorkSpaceBundle() {
        WorkSpaceBundle aResult;
        
        FillWorkSpace(&aResult.mWorkSpace);
        FillConstants(&aResult.mConstants);
        FillSaltSet(&aResult.mDomainSaltSet);
        FillBytes(aResult.mSource, S_BLOCK);
        FillBytes(aResult.mSnow, S_BLOCK);
        
        aResult.mNonce = Random::Get64();
        aResult.mPrevious = Random::Get64();
        aResult.mIngress = Random::Get64();
        aResult.mCarry = Random::Get64();
        
        aResult.mWandererA = Random::Get64();
        aResult.mWandererB = Random::Get64();
        aResult.mWandererC = Random::Get64();
        aResult.mWandererD = Random::Get64();
        aResult.mWandererE = Random::Get64();
        aResult.mWandererF = Random::Get64();
        aResult.mWandererG = Random::Get64();
        aResult.mWandererH = Random::Get64();
        aResult.mWandererI = Random::Get64();
        aResult.mWandererJ = Random::Get64();
        aResult.mWandererK = Random::Get64();
        
        return aResult;
    }

    
    
    static bool EnsureByteLaneIsNotEqual(const char *pFunctionName,
                                         const char *pLaneName,
                                         const std::uint8_t *pLaneA,
                                         const std::uint8_t *pLaneB) {
        if (ByteLanesAreEqual(pLaneA, pLaneB, nullptr)) {
            printf("Fail: %s, %s, expected *not equal*\n", pFunctionName, pLaneName);
            return false;
        }
        return true;
    }
    
    static bool EnsureByteLaneIsEqual(const char *pFunctionName,
                                      const char *pLaneName,
                                      const std::uint8_t *pLaneA,
                                      const std::uint8_t *pLaneB) {
        int aFailedIndex = 0;
        if (ByteLanesAreEqual(pLaneA, pLaneB, &aFailedIndex) == false) {
            printf("Fail: %s, %s, expected *equal* (failed at %d)\n", pFunctionName, pLaneName, aFailedIndex);
            return false;
        }
        return true;
    }
    
    static bool ByteLanesAreEqual(const std::uint8_t *pLaneA,
                                  const std::uint8_t *pLaneB,
                                  int *pFailedIndex) {
        for (int aIndex = 0; aIndex < S_BLOCK; aIndex += 1) {
            if (pLaneA[aIndex] != pLaneB[aIndex]) {
                if (pFailedIndex != nullptr) {
                    *pFailedIndex = aIndex;
                }
                return false;
            }
        }
        return true;
    }
    
    static void FillBytes(std::uint8_t *pBytes,
                          std::size_t pCount) {
        
        std::uint64_t *aLongLongs = (std::uint64_t *)pBytes;
        std::size_t aLongLongCount = pCount / 8;
        
        for (std::size_t aIndex=0; aIndex<aLongLongCount; aIndex++) {
            aLongLongs[aIndex] = Random::Get64();
        }
        
        std::size_t aLastLongLongIndex = aLongLongCount * 8;
        for (std::size_t aIndex=aLastLongLongIndex; aIndex<pCount; aIndex++) {
            pBytes[aIndex] = Random::GetByte();
        }
    }
    
    static void Fill64(std::uint64_t *pWords,
                       std::size_t pCount) {
        for (std::size_t aIndex = 0U; aIndex < pCount; aIndex += 1U) {
            pWords[aIndex] = Random::Get64();
        }
    }

    static std::uint64_t FlipBit(std::uint64_t pOriginal,
                                 std::size_t pBitIndex) {
        if (pBitIndex >= 64U) {
            return pOriginal;
        }
        return pOriginal ^ (std::uint64_t{1U} << pBitIndex);
    }
    
    static void FillConstants(TwistDomainConstants *pConstants) {
        pConstants->mIngress = Random::Get64();
        pConstants->mScatter = Random::Get64();
        pConstants->mCross = Random::Get64();
        
        pConstants->mMatrixSelectA = Random::Get64();
        pConstants->mMatrixSelectB = Random::Get64();
        
        pConstants->mMatrixUnrollA = Random::GetByte();
        pConstants->mMatrixUnrollB = Random::GetByte();
        
        pConstants->mMatrixArgA = Random::GetByte();
        pConstants->mMatrixArgB = Random::GetByte();
        pConstants->mMatrixArgC = Random::GetByte();
        pConstants->mMatrixArgD = Random::GetByte();
    }
    
    static void FillSeedRoundMaterial(TwistDomainSeedRoundMaterial *pMaterial) {
        Fill64(pMaterial->mSaltA, S_SALT);
        Fill64(pMaterial->mSaltB, S_SALT);
        Fill64(pMaterial->mSaltC, S_SALT);
        Fill64(pMaterial->mSaltD, S_SALT);
        Fill64(pMaterial->mSaltE, S_SALT);
        Fill64(pMaterial->mSaltF, S_SALT);
        Fill64(pMaterial->mSaltG, S_SALT);
        Fill64(pMaterial->mSaltH, S_SALT);
    }
    
    static void FillSaltSet(TwistDomainSaltSet *pSaltSet) {
        FillSeedRoundMaterial(&pSaltSet->mOrbiterAssign);
        FillSeedRoundMaterial(&pSaltSet->mOrbiterUpdate);
        FillSeedRoundMaterial(&pSaltSet->mWandererUpdate);
    }
    
    static void FillDomainBundle(TwistDomainBundle *pBundle) {
        FillSaltSet(&pBundle->mKeySpawnASalts);
        FillConstants(&pBundle->mKeySpawnAConstants);
        FillSaltSet(&pBundle->mKeySpawnBSalts);
        FillConstants(&pBundle->mKeySpawnBConstants);
        FillSaltSet(&pBundle->mSeedSalts);
        FillConstants(&pBundle->mSeedConstants);
        FillSaltSet(&pBundle->mTwistSalts);
        FillConstants(&pBundle->mTwistConstants);
        FillSaltSet(&pBundle->mKeyRotateASalts);
        FillConstants(&pBundle->mKeyRotateAConstants);
        FillSaltSet(&pBundle->mKeyRotateBSalts);
        FillConstants(&pBundle->mKeyRotateBConstants);
    }
    
    static void FillWorkSpace(TwistWorkSpace *pWorkSpace) {
        
        FillBytes(&pWorkSpace->mKeyBoxA[0][0], S_KEY);
        FillBytes(&pWorkSpace->mKeyBoxB[0][0], S_KEY);
        
        FillBytes(pWorkSpace->mSourceLane, S_BLOCK);
        FillBytes(pWorkSpace->mNonceLane, S_BLOCK);
        
        for (std::size_t aIndex=0; aIndex<256; aIndex++) {
            pWorkSpace->mIndexList256A[aIndex] = aIndex;
            pWorkSpace->mIndexList256B[aIndex] = aIndex;
            pWorkSpace->mIndexList256C[aIndex] = aIndex;
            pWorkSpace->mIndexList256D[aIndex] = aIndex;
        }
        
        for (std::size_t i = 1U; i < 256; ++i) {
            const std::size_t aSwapIndex = static_cast<std::size_t>(Random::Get(static_cast<int>(i + 1U)));
            std::swap(pWorkSpace->mIndexList256A[i], pWorkSpace->mIndexList256A[aSwapIndex]);
        }
        for (std::size_t i = 1U; i < 256; ++i) {
            const std::size_t aSwapIndex = static_cast<std::size_t>(Random::Get(static_cast<int>(i + 1U)));
            std::swap(pWorkSpace->mIndexList256B[i], pWorkSpace->mIndexList256B[aSwapIndex]);
        }
        for (std::size_t i = 1U; i < 256; ++i) {
            const std::size_t aSwapIndex = static_cast<std::size_t>(Random::Get(static_cast<int>(i + 1U)));
            std::swap(pWorkSpace->mIndexList256C[i], pWorkSpace->mIndexList256C[aSwapIndex]);
        }
        for (std::size_t i = 1U; i < 256; ++i) {
            const std::size_t aSwapIndex = static_cast<std::size_t>(Random::Get(static_cast<int>(i + 1U)));
            std::swap(pWorkSpace->mIndexList256D[i], pWorkSpace->mIndexList256D[aSwapIndex]);
        }
        
        FillBytes(pWorkSpace->mEarthLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mEarthLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mEarthLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mEarthLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mFireLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mFireLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mFireLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mFireLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mWindLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mWindLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mWindLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mWindLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mWaterLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mWaterLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mWaterLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mWaterLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mRainbowLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mRainbowLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mRainbowLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mRainbowLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mLightningLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mLightningLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mLightningLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mLightningLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mIceLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mIceLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mIceLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mIceLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mPlasmaLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mPlasmaLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mPlasmaLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mPlasmaLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mShadowLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mShadowLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mShadowLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mShadowLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mCrystalLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mCrystalLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mCrystalLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mCrystalLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mAetherLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mAetherLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mAetherLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mAetherLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mCelestialLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mCelestialLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mCelestialLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mCelestialLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mVaporLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mVaporLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mVaporLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mVaporLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mKineticLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mKineticLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mKineticLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mKineticLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mSonicLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mSonicLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mSonicLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mSonicLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mPlanarLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mPlanarLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mPlanarLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mPlanarLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mFrostLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mFrostLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mFrostLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mFrostLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mArcaneLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mArcaneLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mArcaneLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mArcaneLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mLunarLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mLunarLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mLunarLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mLunarLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mRunicLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mRunicLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mRunicLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mRunicLaneD, S_BLOCK);

        FillBytes(pWorkSpace->mSpiritLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mSpiritLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mSpiritLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mSpiritLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mGloomLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mGloomLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mGloomLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mGloomLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mAbjurationLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mAbjurationLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mAbjurationLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mAbjurationLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mDivinationLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mDivinationLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mDivinationLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mDivinationLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mEvocationLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mEvocationLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mEvocationLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mEvocationLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mStasisLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mStasisLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mStasisLaneC, S_BLOCK);
        //FillBytes(pWorkSpace->mStasisLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mAlchemyLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mAlchemyLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mAlchemyLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mAlchemyLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mAuguryLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mAuguryLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mAuguryLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mAuguryLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mPsychicLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mPsychicLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mPsychicLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mPsychicLaneD, S_BLOCK);
        
        FillBytes(pWorkSpace->mVoodooLaneA, S_BLOCK);
        FillBytes(pWorkSpace->mVoodooLaneB, S_BLOCK);
        FillBytes(pWorkSpace->mVoodooLaneC, S_BLOCK);
        FillBytes(pWorkSpace->mVoodooLaneD, S_BLOCK);

        FillDomainBundle(&pWorkSpace->mDomainBundle);
    }
};


#endif /* WorkSpaceTools_hpp */
