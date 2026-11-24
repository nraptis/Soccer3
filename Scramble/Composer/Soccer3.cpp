//
//  Soccer3.cpp
//  Scramble
//
//  Created by Icarus Black on 8/1/26.
//

#include "Soccer3.hpp"
#include "SoccerFolding.hpp"
#include "TwistMix32.hpp"
#include "TwistMix64.hpp"

#include <cstdlib>
#include <cassert>

#include <algorithm>
#include <cstring>

#define BLOCK_COUNT (SOCCER_BLOCK_SIZE / S_BLOCK)

#define COMPLEXITY_STRONG 16
#define COMPLEXITY_NORMAL 8
#define COMPLEXITY_WEAK 4

#define WARM_UP_ROUNDS 5
#define WARM_UP_BLOCKS (WARM_UP_ROUNDS + 1)

#define READ_IN_MUTABLE_PARAMS_INTERNAL \
    std::uint64_t aIngress = *pIngress; \
    std::uint64_t aCarry = *pCarry; \
    std::uint64_t aWandererA = *pWandererA; \
    std::uint64_t aWandererB = *pWandererB; \
    std::uint64_t aWandererC = *pWandererC; \
    std::uint64_t aWandererD = *pWandererD; \
    std::uint64_t aWandererE = *pWandererE; \
    std::uint64_t aWandererF = *pWandererF; \
    std::uint64_t aWandererG = *pWandererG; \
    std::uint64_t aWandererH = *pWandererH; \
    std::uint64_t aWandererI = *pWandererI; \
    std::uint64_t aWandererJ = *pWandererJ; \
    std::uint64_t aWandererK = *pWandererK

namespace {

constexpr std::size_t kExpanderSeedCost = 3U;
constexpr std::size_t kExpanderTwistCost = 1U;
constexpr std::size_t kSeedEpilogueCost = 1U;

} // namespace

static_assert((SOCCER_BLOCK_SIZE % S_BLOCK) == 0U);
static_assert(BLOCK_COUNT >= WARM_UP_BLOCKS);

SoccerDelegate                                  *Soccer3::mDelegate = nullptr;
std::size_t                                     Soccer3::mSeedProgressCompleted = 0U;
std::size_t                                     Soccer3::mSeedProgressTotal = 0U;

std::uint8_t                                    Soccer3::mMaterialA[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialB[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialC[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialD[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialE[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialF[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialG[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialH[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialI[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialJ[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialK[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialL[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialM[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialN[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialO[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mMaterialP[SOCCER_BLOCK_SIZE];

TwistExpander_Betelgeuse                        Soccer3::mStarter;

TwistExpander_Aldebaran                         Soccer3::mAldebaran; // 1
TwistExpander_Altair                            Soccer3::mAltair; // 2
TwistExpander_Antares                           Soccer3::mAntares; // 3
TwistExpander_Arcturus                          Soccer3::mArcturus; // 4
TwistExpander_Bellatrix                         Soccer3::mBellatrix; // 5
TwistExpander_Capella                           Soccer3::mCapella; // 6
TwistExpander_Castor                            Soccer3::mCastor; // 7
TwistExpander_Mimosa                            Soccer3::mMimosa; // 8
TwistExpander_Polaris                           Soccer3::mPolaris; // 9
TwistExpander_Pollux                            Soccer3::mPollux; // 10
TwistExpander_Procyon                           Soccer3::mProcyon; // 11
TwistExpander_Regulus                           Soccer3::mRegulus; // 12
TwistExpander_Rigel                             Soccer3::mRigel; // 13
TwistExpander_Saiph                             Soccer3::mSaiph; // 14
TwistExpander_Sirius                            Soccer3::mSirius; // 15
TwistExpander_Vega                              Soccer3::mVega; // 16

TwistWorkSpace                                  Soccer3::mWorkSpaceA;
TwistWorkSpace                                  Soccer3::mWorkSpaceB;
TwistWorkSpace                                  Soccer3::mWorkSpaceC;
TwistWorkSpace                                  Soccer3::mWorkSpaceD;
TwistWorkSpace                                  Soccer3::mWorkSpaceE;
TwistWorkSpace                                  Soccer3::mWorkSpaceF;
TwistWorkSpace                                  Soccer3::mWorkSpaceG;
TwistWorkSpace                                  Soccer3::mWorkSpaceH;
TwistWorkSpace                                  Soccer3::mWorkSpaceI;
TwistWorkSpace                                  Soccer3::mWorkSpaceJ;
TwistWorkSpace                                  Soccer3::mWorkSpaceK;
TwistWorkSpace                                  Soccer3::mWorkSpaceL;
TwistWorkSpace                                  Soccer3::mWorkSpaceM;
TwistWorkSpace                                  Soccer3::mWorkSpaceN;
TwistWorkSpace                                  Soccer3::mWorkSpaceO;
TwistWorkSpace                                  Soccer3::mWorkSpaceP;

std::uint8_t                                    Soccer3::mRandom[S_BLOCK];

std::uint8_t                                    Soccer3::mCollapseLaneA[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mCollapseLaneB[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mCollapseLaneC[SOCCER_BLOCK_SIZE];
std::uint8_t                                    Soccer3::mCollapseLaneD[SOCCER_BLOCK_SIZE];

std::uint8_t                                    Soccer3::mCondenseLaneA[SOCCER_BLOCK_QUARTER];
std::uint8_t                                    Soccer3::mCondenseLaneB[SOCCER_BLOCK_QUARTER];
std::uint8_t                                    Soccer3::mCondenseLaneC[SOCCER_BLOCK_QUARTER];
std::uint8_t                                    Soccer3::mCondenseLaneD[SOCCER_BLOCK_QUARTER];


std::uint16_t                                   Soccer3::mShiftMaskedRotationListBaseA[kRotationWindowCount];
std::uint16_t                                   Soccer3::mShiftMaskedRotationListChosenA[kRotationsPerList];
std::size_t                                     Soccer3::mShiftMaskedRotationListAvailableA = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseAALeft[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenAALeft[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableAALeft = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseAARight[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenAARight[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableAARight = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseABLeft[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenABLeft[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableABLeft = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseABRight[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenABRight[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableABRight = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseACLeft[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenACLeft[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableACLeft = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseACRight[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenACRight[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableACRight = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseADLeft[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenADLeft[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableADLeft = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseADRight[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenADRight[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableADRight = 0U;

std::uint16_t                                   Soccer3::mShiftMaskedRotationListBaseB[kRotationWindowCount];
std::uint16_t                                   Soccer3::mShiftMaskedRotationListChosenB[kRotationsPerList];
std::size_t                                     Soccer3::mShiftMaskedRotationListAvailableB = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseBALeft[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenBALeft[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableBALeft = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseBARight[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenBARight[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableBARight = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseBBLeft[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenBBLeft[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableBBLeft = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseBBRight[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenBBRight[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableBBRight = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseBCLeft[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenBCLeft[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableBCLeft = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseBCRight[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenBCRight[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableBCRight = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseBDLeft[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenBDLeft[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableBDLeft = 0U;

std::uint16_t                                   Soccer3::mFlameToadRotationListBaseBDRight[kRotationWindowCount];
std::uint16_t                                   Soccer3::mFlameToadRotationListChosenBDRight[kRotationsPerList];
std::size_t                                     Soccer3::mFlameToadRotationListAvailableBDRight = 0U;

bool                                            Soccer3::mRotationWindowBlocked[kRotationWindowCount];
bool                                            Soccer3::mRotationWindowSingleBlocked[kRotationWindowCount];
std::size_t                                     Soccer3::mRotationCandidatesRead = 0U;
std::size_t                                     Soccer3::mRotationFallbackCandidatesRead = 0U;
std::size_t                                     Soccer3::mRotationShuffleBytesRead = 0U;
std::size_t                                     Soccer3::mRandomShuffleGeneration = 0U;

std::uint8_t                                    *Soccer3::mMaterials[16];
TwistExpander                                   *Soccer3::mExpanders[SOCCER_EXPANDER_COUNT];
TwistWorkSpace                                  *Soccer3::mWorkSpaces[16];
std::uint8_t                                    *Soccer3::mSources[16];
std::uint8_t                                    *Soccer3::mCross[4][16];

std::uint8_t                                    *Soccer3::mCrossPool[16][64];
std::size_t                                     Soccer3::mCrossPoolCount[16];
std::uint8_t                                    Soccer3::mCrossPermutations[16][64];

bool                                            Soccer3::mClaimed[SOCCER_EXPANDER_COUNT];

TwistExpander                                   *Soccer3::mClaimedExpanders[16];
std::size_t                                     Soccer3::mClaimedExpanderCount;

std::uint8_t                                    *Soccer3::mClaimedMaterials[16];
std::size_t                                     Soccer3::mClaimedMaterialCount;

TwistWorkSpace                                  *Soccer3::mClaimedWorkSpaces[16];
std::size_t                                     Soccer3::mClaimedWorkSpaceCount;


std::uint8_t                                    *Soccer3::mShuffleMaterials[16];
TwistExpander                                   *Soccer3::mShuffleExpanders[SOCCER_EXPANDER_COUNT];
TwistWorkSpace                                  *Soccer3::mShuffleWorkSpaces[16];


EncryptionStrength                              Soccer3::mStrength = EncryptionStrength::kNormal;

uint32_t                                        Soccer3::mTestBlockLength = SOCCER_BLOCK_SIZE;


void Soccer3::UnrollNonceAndPasswordToScratch_Test(std::uint8_t *pPassword,
                                                   std::size_t pPasswordByteLength,
                                                   std::uint64_t pNonce) {
    std::uint8_t aNonceBytes[8];
    aNonceBytes[0] = static_cast<std::uint8_t>(pNonce >>  0); aNonceBytes[1] = static_cast<std::uint8_t>(pNonce >>  8);
    aNonceBytes[2] = static_cast<std::uint8_t>(pNonce >> 16); aNonceBytes[3] = static_cast<std::uint8_t>(pNonce >> 24);
    aNonceBytes[4] = static_cast<std::uint8_t>(pNonce >> 32); aNonceBytes[5] = static_cast<std::uint8_t>(pNonce >> 40);
    aNonceBytes[6] = static_cast<std::uint8_t>(pNonce >> 48); aNonceBytes[7] = static_cast<std::uint8_t>(pNonce >> 56);
    
    std::size_t aScratchIndex = 0;
    while (aScratchIndex < SOCCER_BLOCK_SIZE) {
        std::size_t aPasswordIndex = 0;
        while ((aPasswordIndex < pPasswordByteLength) && (aScratchIndex < SOCCER_BLOCK_SIZE)) {
            SOCCER_SCRATCH_WORKER_A[aScratchIndex] = pPassword[aPasswordIndex];
            aScratchIndex++;
            aPasswordIndex++;
        }
        std::size_t aNonceIndex = 0;
        while ((aNonceIndex < 8) && (aScratchIndex < SOCCER_BLOCK_SIZE)) {
            SOCCER_SCRATCH_WORKER_A[aScratchIndex] = aNonceBytes[aNonceIndex];
            aScratchIndex++;
            aNonceIndex++;
        }
    }
}

void Soccer3::UnrollNonceAndPasswordToScratch_Regular(std::uint8_t *pPassword,
                                                      std::size_t pPasswordByteLength,
                                                      std::uint64_t pNonce) {
    std::uint8_t aNonceBytes[8];
    aNonceBytes[0] = static_cast<std::uint8_t>(pNonce >>  0); aNonceBytes[1] = static_cast<std::uint8_t>(pNonce >>  8);
    aNonceBytes[2] = static_cast<std::uint8_t>(pNonce >> 16); aNonceBytes[3] = static_cast<std::uint8_t>(pNonce >> 24);
    aNonceBytes[4] = static_cast<std::uint8_t>(pNonce >> 32); aNonceBytes[5] = static_cast<std::uint8_t>(pNonce >> 40);
    aNonceBytes[6] = static_cast<std::uint8_t>(pNonce >> 48); aNonceBytes[7] = static_cast<std::uint8_t>(pNonce >> 56);
    
    std::size_t aScratchIndex = 0;
    while (aScratchIndex < S_BLOCK) {
        std::size_t aPasswordIndex = 0;
        while ((aPasswordIndex < pPasswordByteLength) && (aScratchIndex < S_BLOCK)) {
            SOCCER_SCRATCH_WORKER_A[aScratchIndex] = pPassword[aPasswordIndex];
            aScratchIndex++;
            aPasswordIndex++;
        }
        std::size_t aNonceIndex = 0;
        while ((aNonceIndex < 8) && (aScratchIndex < S_BLOCK)) {
            SOCCER_SCRATCH_WORKER_A[aScratchIndex] = aNonceBytes[aNonceIndex];
            aScratchIndex++;
            aNonceIndex++;
        }
    }
}

void Soccer3::Zero() {
    mCryptex.Zero();
    mEncryptionReady = false;
    mMaterialIndex = 0U;

    mBitPlaneWordA = 0U;
    mBitPlaneWordB = 0U;
    mBitPlaneWordC = 0U;
    mShiftMaskedRotationWordAALeft = 0U;
    mShiftMaskedRotationWordAARight = 0U;
    mShiftMaskedRotationWordABLeft = 0U;
    mShiftMaskedRotationWordABRight = 0U;
    mShiftMaskedRotationWordACLeft = 0U;
    mShiftMaskedRotationWordACRight = 0U;
    mShiftMaskedRotationWordADLeft = 0U;
    mShiftMaskedRotationWordADRight = 0U;
    mShiftMaskedRotationWordBALeft = 0U;
    mShiftMaskedRotationWordBARight = 0U;
    mShiftMaskedRotationWordBBLeft = 0U;
    mShiftMaskedRotationWordBBRight = 0U;
    mShiftMaskedRotationWordBCLeft = 0U;
    mShiftMaskedRotationWordBCRight = 0U;
    mShiftMaskedRotationWordBDLeft = 0U;
    mShiftMaskedRotationWordBDRight = 0U;
    mBitPlane = {};
    mPlaneShiftAALeft = {};
    mPlaneShiftAARight = {};
    mPlaneShiftABLeft = {};
    mPlaneShiftABRight = {};
    mPlaneShiftACLeft = {};
    mPlaneShiftACRight = {};
    mPlaneShiftADLeft = {};
    mPlaneShiftADRight = {};
    mPlaneShiftBALeft = {};
    mPlaneShiftBARight = {};
    mPlaneShiftBBLeft = {};
    mPlaneShiftBBRight = {};
    mPlaneShiftBCLeft = {};
    mPlaneShiftBCRight = {};
    mPlaneShiftBDLeft = {};
    mPlaneShiftBDRight = {};

    mBitRowAA = 0U;
    mBitRowAB = 0U;
    mBitRowAC = 0U;
    mBitRowAD = 0U;
    mBitRowAE = 0U;
    mBitRowAF = 0U;
    mBitRowAG = 0U;
    mBitRowAH = 0U;
    mBitRowBA = 0U;
    mBitRowBB = 0U;
    mBitRowBC = 0U;
    mBitRowBD = 0U;
    mBitRowBE = 0U;
    mBitRowBF = 0U;
    mBitRowBG = 0U;
    mBitRowBH = 0U;
    mBitRowCA = 0U;
    mBitRowCB = 0U;
    mBitRowCC = 0U;
    mBitRowCD = 0U;
    mBitRowCE = 0U;
    mBitRowCF = 0U;
    mBitRowCG = 0U;
    mBitRowCH = 0U;
    mBitRowDA = 0U;
    mBitRowDB = 0U;
    mBitRowDC = 0U;
    mBitRowDD = 0U;
    mBitRowDE = 0U;
    mBitRowDF = 0U;
    mBitRowDG = 0U;
    mBitRowDH = 0U;
    mToadCipherRotationAALeftA = 0U;
    mToadCipherRotationAALeftB = 0U;
    mToadCipherRotationAALeftC = 0U;
    mToadCipherRotationAALeftD = 0U;
    mToadCipherRotationAALeftE = 0U;
    mToadCipherRotationAALeftF = 0U;
    mToadCipherRotationAALeftG = 0U;
    mToadCipherRotationAALeftH = 0U;
    mToadCipherRotationAARightA = 0U;
    mToadCipherRotationAARightB = 0U;
    mToadCipherRotationAARightC = 0U;
    mToadCipherRotationAARightD = 0U;
    mToadCipherRotationAARightE = 0U;
    mToadCipherRotationAARightF = 0U;
    mToadCipherRotationAARightG = 0U;
    mToadCipherRotationAARightH = 0U;
    mToadCipherRotationABLeftA = 0U;
    mToadCipherRotationABLeftB = 0U;
    mToadCipherRotationABLeftC = 0U;
    mToadCipherRotationABLeftD = 0U;
    mToadCipherRotationABLeftE = 0U;
    mToadCipherRotationABLeftF = 0U;
    mToadCipherRotationABLeftG = 0U;
    mToadCipherRotationABLeftH = 0U;
    mToadCipherRotationABRightA = 0U;
    mToadCipherRotationABRightB = 0U;
    mToadCipherRotationABRightC = 0U;
    mToadCipherRotationABRightD = 0U;
    mToadCipherRotationABRightE = 0U;
    mToadCipherRotationABRightF = 0U;
    mToadCipherRotationABRightG = 0U;
    mToadCipherRotationABRightH = 0U;
    mToadCipherRotationACLeftA = 0U;
    mToadCipherRotationACLeftB = 0U;
    mToadCipherRotationACLeftC = 0U;
    mToadCipherRotationACLeftD = 0U;
    mToadCipherRotationACLeftE = 0U;
    mToadCipherRotationACLeftF = 0U;
    mToadCipherRotationACLeftG = 0U;
    mToadCipherRotationACLeftH = 0U;
    mToadCipherRotationACRightA = 0U;
    mToadCipherRotationACRightB = 0U;
    mToadCipherRotationACRightC = 0U;
    mToadCipherRotationACRightD = 0U;
    mToadCipherRotationACRightE = 0U;
    mToadCipherRotationACRightF = 0U;
    mToadCipherRotationACRightG = 0U;
    mToadCipherRotationACRightH = 0U;
    mToadCipherRotationADLeftA = 0U;
    mToadCipherRotationADLeftB = 0U;
    mToadCipherRotationADLeftC = 0U;
    mToadCipherRotationADLeftD = 0U;
    mToadCipherRotationADLeftE = 0U;
    mToadCipherRotationADLeftF = 0U;
    mToadCipherRotationADLeftG = 0U;
    mToadCipherRotationADLeftH = 0U;
    mToadCipherRotationADRightA = 0U;
    mToadCipherRotationADRightB = 0U;
    mToadCipherRotationADRightC = 0U;
    mToadCipherRotationADRightD = 0U;
    mToadCipherRotationADRightE = 0U;
    mToadCipherRotationADRightF = 0U;
    mToadCipherRotationADRightG = 0U;
    mToadCipherRotationADRightH = 0U;
    mToadCipherRotationBALeftA = 0U;
    mToadCipherRotationBALeftB = 0U;
    mToadCipherRotationBALeftC = 0U;
    mToadCipherRotationBALeftD = 0U;
    mToadCipherRotationBALeftE = 0U;
    mToadCipherRotationBALeftF = 0U;
    mToadCipherRotationBALeftG = 0U;
    mToadCipherRotationBALeftH = 0U;
    mToadCipherRotationBARightA = 0U;
    mToadCipherRotationBARightB = 0U;
    mToadCipherRotationBARightC = 0U;
    mToadCipherRotationBARightD = 0U;
    mToadCipherRotationBARightE = 0U;
    mToadCipherRotationBARightF = 0U;
    mToadCipherRotationBARightG = 0U;
    mToadCipherRotationBARightH = 0U;
    mToadCipherRotationBBLeftA = 0U;
    mToadCipherRotationBBLeftB = 0U;
    mToadCipherRotationBBLeftC = 0U;
    mToadCipherRotationBBLeftD = 0U;
    mToadCipherRotationBBLeftE = 0U;
    mToadCipherRotationBBLeftF = 0U;
    mToadCipherRotationBBLeftG = 0U;
    mToadCipherRotationBBLeftH = 0U;
    mToadCipherRotationBBRightA = 0U;
    mToadCipherRotationBBRightB = 0U;
    mToadCipherRotationBBRightC = 0U;
    mToadCipherRotationBBRightD = 0U;
    mToadCipherRotationBBRightE = 0U;
    mToadCipherRotationBBRightF = 0U;
    mToadCipherRotationBBRightG = 0U;
    mToadCipherRotationBBRightH = 0U;
    mToadCipherRotationBCLeftA = 0U;
    mToadCipherRotationBCLeftB = 0U;
    mToadCipherRotationBCLeftC = 0U;
    mToadCipherRotationBCLeftD = 0U;
    mToadCipherRotationBCLeftE = 0U;
    mToadCipherRotationBCLeftF = 0U;
    mToadCipherRotationBCLeftG = 0U;
    mToadCipherRotationBCLeftH = 0U;
    mToadCipherRotationBCRightA = 0U;
    mToadCipherRotationBCRightB = 0U;
    mToadCipherRotationBCRightC = 0U;
    mToadCipherRotationBCRightD = 0U;
    mToadCipherRotationBCRightE = 0U;
    mToadCipherRotationBCRightF = 0U;
    mToadCipherRotationBCRightG = 0U;
    mToadCipherRotationBCRightH = 0U;
    mToadCipherRotationBDLeftA = 0U;
    mToadCipherRotationBDLeftB = 0U;
    mToadCipherRotationBDLeftC = 0U;
    mToadCipherRotationBDLeftD = 0U;
    mToadCipherRotationBDLeftE = 0U;
    mToadCipherRotationBDLeftF = 0U;
    mToadCipherRotationBDLeftG = 0U;
    mToadCipherRotationBDLeftH = 0U;
    mToadCipherRotationBDRightA = 0U;
    mToadCipherRotationBDRightB = 0U;
    mToadCipherRotationBDRightC = 0U;
    mToadCipherRotationBDRightD = 0U;
    mToadCipherRotationBDRightE = 0U;
    mToadCipherRotationBDRightF = 0U;
    mToadCipherRotationBDRightG = 0U;
    mToadCipherRotationBDRightH = 0U;
    mMutateMaterialA = nullptr;
    mMutateMaterialB = nullptr;
    mMutateMaterialC = nullptr;
    mMutateMaterialD = nullptr;
    mMutateMaterialE = nullptr;
    mMutateMaterialF = nullptr;
    mMutateMaterialG = nullptr;
    mMutateMaterialH = nullptr;
    mMutateMaterialI = nullptr;
    mMutateMaterialJ = nullptr;
    mMutateMaterialK = nullptr;
    mMutateMaterialL = nullptr;
    mMutateMaterialM = nullptr;
    mMutateMaterialN = nullptr;
    mMutateMaterialO = nullptr;
    mMutateMaterialP = nullptr;
    mPackedRows = nullptr;
    mPackedRowLength = 0U;


    std::memset(mMaterialA, 0, sizeof(mMaterialA));
    std::memset(mMaterialB, 0, sizeof(mMaterialB));
    std::memset(mMaterialC, 0, sizeof(mMaterialC));
    std::memset(mMaterialD, 0, sizeof(mMaterialD));
    std::memset(mMaterialE, 0, sizeof(mMaterialE));
    std::memset(mMaterialF, 0, sizeof(mMaterialF));
    std::memset(mMaterialG, 0, sizeof(mMaterialG));
    std::memset(mMaterialH, 0, sizeof(mMaterialH));
    std::memset(mMaterialI, 0, sizeof(mMaterialI));
    std::memset(mMaterialJ, 0, sizeof(mMaterialJ));
    std::memset(mMaterialK, 0, sizeof(mMaterialK));
    std::memset(mMaterialL, 0, sizeof(mMaterialL));
    std::memset(mMaterialM, 0, sizeof(mMaterialM));
    std::memset(mMaterialN, 0, sizeof(mMaterialN));
    std::memset(mMaterialO, 0, sizeof(mMaterialO));
    std::memset(mMaterialP, 0, sizeof(mMaterialP));

    std::memset(mRandom, 0, sizeof(mRandom));
    std::memset(mCollapseLaneA, 0, sizeof(mCollapseLaneA));
    std::memset(mCollapseLaneB, 0, sizeof(mCollapseLaneB));
    std::memset(mCollapseLaneC, 0, sizeof(mCollapseLaneC));
    std::memset(mCollapseLaneD, 0, sizeof(mCollapseLaneD));
    std::memset(mCondenseLaneA, 0, sizeof(mCondenseLaneA));
    std::memset(mCondenseLaneB, 0, sizeof(mCondenseLaneB));
    std::memset(mCondenseLaneC, 0, sizeof(mCondenseLaneC));
    std::memset(mCondenseLaneD, 0, sizeof(mCondenseLaneD));
    for (std::size_t aIndex = 0U; aIndex < kRotationWindowCount; ++aIndex) {
        mShiftMaskedRotationListBaseA[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseAALeft[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseAARight[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseABLeft[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseABRight[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseACLeft[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseACRight[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseADLeft[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseADRight[aIndex] = static_cast<std::uint16_t>(aIndex);
        mShiftMaskedRotationListBaseB[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseBALeft[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseBARight[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseBBLeft[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseBBRight[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseBCLeft[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseBCRight[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseBDLeft[aIndex] = static_cast<std::uint16_t>(aIndex);
        mFlameToadRotationListBaseBDRight[aIndex] = static_cast<std::uint16_t>(aIndex);
    }
    std::memset(mShiftMaskedRotationListChosenA, 0, sizeof(mShiftMaskedRotationListChosenA));
    mShiftMaskedRotationListAvailableA = 0U;
    std::memset(mFlameToadRotationListChosenAALeft, 0, sizeof(mFlameToadRotationListChosenAALeft));
    mFlameToadRotationListAvailableAALeft = 0U;
    std::memset(mFlameToadRotationListChosenAARight, 0, sizeof(mFlameToadRotationListChosenAARight));
    mFlameToadRotationListAvailableAARight = 0U;
    std::memset(mFlameToadRotationListChosenABLeft, 0, sizeof(mFlameToadRotationListChosenABLeft));
    mFlameToadRotationListAvailableABLeft = 0U;
    std::memset(mFlameToadRotationListChosenABRight, 0, sizeof(mFlameToadRotationListChosenABRight));
    mFlameToadRotationListAvailableABRight = 0U;
    std::memset(mFlameToadRotationListChosenACLeft, 0, sizeof(mFlameToadRotationListChosenACLeft));
    mFlameToadRotationListAvailableACLeft = 0U;
    std::memset(mFlameToadRotationListChosenACRight, 0, sizeof(mFlameToadRotationListChosenACRight));
    mFlameToadRotationListAvailableACRight = 0U;
    std::memset(mFlameToadRotationListChosenADLeft, 0, sizeof(mFlameToadRotationListChosenADLeft));
    mFlameToadRotationListAvailableADLeft = 0U;
    std::memset(mFlameToadRotationListChosenADRight, 0, sizeof(mFlameToadRotationListChosenADRight));
    mFlameToadRotationListAvailableADRight = 0U;
    std::memset(mShiftMaskedRotationListChosenB, 0, sizeof(mShiftMaskedRotationListChosenB));
    mShiftMaskedRotationListAvailableB = 0U;
    std::memset(mFlameToadRotationListChosenBALeft, 0, sizeof(mFlameToadRotationListChosenBALeft));
    mFlameToadRotationListAvailableBALeft = 0U;
    std::memset(mFlameToadRotationListChosenBARight, 0, sizeof(mFlameToadRotationListChosenBARight));
    mFlameToadRotationListAvailableBARight = 0U;
    std::memset(mFlameToadRotationListChosenBBLeft, 0, sizeof(mFlameToadRotationListChosenBBLeft));
    mFlameToadRotationListAvailableBBLeft = 0U;
    std::memset(mFlameToadRotationListChosenBBRight, 0, sizeof(mFlameToadRotationListChosenBBRight));
    mFlameToadRotationListAvailableBBRight = 0U;
    std::memset(mFlameToadRotationListChosenBCLeft, 0, sizeof(mFlameToadRotationListChosenBCLeft));
    mFlameToadRotationListAvailableBCLeft = 0U;
    std::memset(mFlameToadRotationListChosenBCRight, 0, sizeof(mFlameToadRotationListChosenBCRight));
    mFlameToadRotationListAvailableBCRight = 0U;
    std::memset(mFlameToadRotationListChosenBDLeft, 0, sizeof(mFlameToadRotationListChosenBDLeft));
    mFlameToadRotationListAvailableBDLeft = 0U;
    std::memset(mFlameToadRotationListChosenBDRight, 0, sizeof(mFlameToadRotationListChosenBDRight));
    mFlameToadRotationListAvailableBDRight = 0U;
    std::memset(mRotationWindowBlocked, 0, sizeof(mRotationWindowBlocked));
    std::memset(mRotationWindowSingleBlocked, 0, sizeof(mRotationWindowSingleBlocked));
    mRotationCandidatesRead = 0U;
    mRotationFallbackCandidatesRead = 0U;
    mRotationShuffleBytesRead = 0U;
    mRandomShuffleGeneration = 0U;

    mWorkSpaceA.Zero();
    mWorkSpaceB.Zero();
    mWorkSpaceC.Zero();
    mWorkSpaceD.Zero();
    mWorkSpaceE.Zero();
    mWorkSpaceF.Zero();
    mWorkSpaceG.Zero();
    mWorkSpaceH.Zero();
    mWorkSpaceI.Zero();
    mWorkSpaceJ.Zero();
    mWorkSpaceK.Zero();
    mWorkSpaceL.Zero();
    mWorkSpaceM.Zero();
    mWorkSpaceN.Zero();
    mWorkSpaceO.Zero();
    mWorkSpaceP.Zero();
    
    mStarter.Zero();
    
    mAldebaran.Zero();
    mAltair.Zero();
    mAntares.Zero();
    mArcturus.Zero();
    mBellatrix.Zero();
    mCapella.Zero();
    mCastor.Zero();
    mMimosa.Zero();
    mPolaris.Zero();
    mPollux.Zero();
    mProcyon.Zero();
    mRegulus.Zero();
    mRigel.Zero();
    mSaiph.Zero();
    mSirius.Zero();
    mVega.Zero();
    

    for (std::size_t aIndex=0U; aIndex<SOCCER_EXPANDER_COUNT; aIndex++) {
        mClaimed[aIndex] = false;
        mShuffleExpanders[aIndex] = nullptr;
    }

    for (std::size_t aIndex=0U; aIndex<16U; aIndex++) {
        mSources[aIndex] = nullptr;

        mClaimedExpanders[aIndex] = nullptr;
        mClaimedMaterials[aIndex] = nullptr;
        mClaimedWorkSpaces[aIndex] = nullptr;

        mShuffleMaterials[aIndex] = nullptr;
        mShuffleWorkSpaces[aIndex] = nullptr;
    }

    for (std::size_t aCrossIndex=0U; aCrossIndex<4U; aCrossIndex++) {
        for (std::size_t aLaneIndex=0U; aLaneIndex<16U; aLaneIndex++) {
            mCross[aCrossIndex][aLaneIndex] = nullptr;
        }
    }

    for (std::size_t aLaneIndex=0U; aLaneIndex<16U; aLaneIndex++) {
        mCrossPoolCount[aLaneIndex] = 0U;
        for (std::size_t aPoolIndex=0U; aPoolIndex<64U; aPoolIndex++) {
            mCrossPool[aLaneIndex][aPoolIndex] = nullptr;
            mCrossPermutations[aLaneIndex][aPoolIndex] = static_cast<std::uint8_t>(aPoolIndex);
        }
    }

    mClaimedExpanderCount = 0U;
    mClaimedMaterialCount = 0U;
    mClaimedWorkSpaceCount = 0U;

    mTestBlockLength = SOCCER_BLOCK_SIZE;

    mSeedProgressCompleted = 0U;
    mSeedProgressTotal = 0U;

    mStrength = EncryptionStrength::kNormal;

    // Baseline order for a new seed.
    mExpanders[ 0] = &mAldebaran; mExpanders[ 1] = &mAltair;   mExpanders[ 2] = &mAntares;  mExpanders[ 3] = &mArcturus;
    mExpanders[ 4] = &mBellatrix; mExpanders[ 5] = &mCapella;  mExpanders[ 6] = &mCastor;   mExpanders[ 7] = &mMimosa;
    mExpanders[ 8] = &mPolaris;   mExpanders[ 9] = &mPollux;   mExpanders[10] = &mProcyon;  mExpanders[11] = &mRegulus;
    mExpanders[12] = &mRigel;     mExpanders[13] = &mSaiph;    mExpanders[14] = &mSirius;   mExpanders[15] = &mVega;

    mWorkSpaces[ 0] = &mWorkSpaceA; mWorkSpaces[ 1] = &mWorkSpaceB; mWorkSpaces[ 2] = &mWorkSpaceC; mWorkSpaces[ 3] = &mWorkSpaceD;
    mWorkSpaces[ 4] = &mWorkSpaceE; mWorkSpaces[ 5] = &mWorkSpaceF; mWorkSpaces[ 6] = &mWorkSpaceG; mWorkSpaces[ 7] = &mWorkSpaceH;
    mWorkSpaces[ 8] = &mWorkSpaceI; mWorkSpaces[ 9] = &mWorkSpaceJ; mWorkSpaces[10] = &mWorkSpaceK; mWorkSpaces[11] = &mWorkSpaceL;
    mWorkSpaces[12] = &mWorkSpaceM; mWorkSpaces[13] = &mWorkSpaceN; mWorkSpaces[14] = &mWorkSpaceO; mWorkSpaces[15] = &mWorkSpaceP;

    mMaterials[ 0] = mMaterialA; mMaterials[ 1] = mMaterialB; mMaterials[ 2] = mMaterialC; mMaterials[ 3] = mMaterialD;
    mMaterials[ 4] = mMaterialE; mMaterials[ 5] = mMaterialF; mMaterials[ 6] = mMaterialG; mMaterials[ 7] = mMaterialH;
    mMaterials[ 8] = mMaterialI; mMaterials[ 9] = mMaterialJ; mMaterials[10] = mMaterialK; mMaterials[11] = mMaterialL;
    mMaterials[12] = mMaterialM; mMaterials[13] = mMaterialN; mMaterials[14] = mMaterialO; mMaterials[15] = mMaterialP;
}


void Soccer3::ShuffleCROWUnit(std::uint16_t (&pRotationList)[kRotationWindowCount],
                            std::uint64_t &pBitPlaneWordA,
                            std::uint64_t &pBitPlaneWordB,
                            std::uint64_t &pBitPlaneWordC,
                            std::size_t &pAvailable,
                            std::size_t pOffset) {
    const std::size_t aLaneCount = mStrength == EncryptionStrength::kWeak ? 4U :
                                  mStrength == EncryptionStrength::kStrong ? 16U : 8U;
    // Each accumulator gets a distinct 64-bit word from EVERY unit.
    mShiftMaskedRotationWordAALeft += Load64LE(mRandom + pOffset + 0U);
    mShiftMaskedRotationWordAARight += Load64LE(mRandom + pOffset + 8U);
    mShiftMaskedRotationWordABLeft += Load64LE(mRandom + pOffset + 16U);
    mShiftMaskedRotationWordABRight += Load64LE(mRandom + pOffset + 24U);
    mShiftMaskedRotationWordACLeft += Load64LE(mRandom + pOffset + 32U);
    mShiftMaskedRotationWordACRight += Load64LE(mRandom + pOffset + 40U);
    mShiftMaskedRotationWordADLeft += Load64LE(mRandom + pOffset + 48U);
    mShiftMaskedRotationWordADRight += Load64LE(mRandom + pOffset + 56U);
    mShiftMaskedRotationWordBALeft += Load64LE(mRandom + pOffset + 64U);
    mShiftMaskedRotationWordBARight += Load64LE(mRandom + pOffset + 72U);
    mShiftMaskedRotationWordBBLeft += Load64LE(mRandom + pOffset + 80U);
    mShiftMaskedRotationWordBBRight += Load64LE(mRandom + pOffset + 88U);
    mShiftMaskedRotationWordBCLeft += Load64LE(mRandom + pOffset + 96U);
    mShiftMaskedRotationWordBCRight += Load64LE(mRandom + pOffset + 104U);
    mShiftMaskedRotationWordBDLeft += Load64LE(mRandom + pOffset + 112U);
    mShiftMaskedRotationWordBDRight += Load64LE(mRandom + pOffset + 120U);
    pBitPlaneWordA += Load64LE(mRandom + pOffset + RandomShuffleLayout::kFreeRotationBytes);
    pBitPlaneWordB += Load64LE(mRandom + pOffset + RandomShuffleLayout::kFreeRotationBytes + 8U);
    pBitPlaneWordC += Load64LE(mRandom + pOffset + RandomShuffleLayout::kFreeRotationBytes + 16U);

    // One forward pass per list per generation, bounded by this unit's budget.
    // Selection prefers its completed prefix, then falls back to the remaining tail.
    if (mRandomShuffleGeneration < RandomShuffleLayout::kGenerationCount) {
        std::size_t aRead = 0U;
        TwistShuffle::ShuffleList16384(pRotationList, mRandom + RandomShuffleLayout::RotationBegin(pOffset),
            RandomShuffleLayout::RotationBytesPerList(aLaneCount), aRead, false,
            &pAvailable);
        mRotationShuffleBytesRead += aRead;
    }
    const auto aShuffleActive = [&](auto *pList, std::size_t pBegin) {
        const auto aEnd = pBegin + RandomShuffleLayout::OrderingBytes(aLaneCount);
        if (aLaneCount == 4U) TwistShuffle::ShuffleList4(pList, mRandom, pBegin, aEnd, 1U);
        else if (aLaneCount == 16U) TwistShuffle::ShuffleList16(pList, mRandom, pBegin, aEnd, 1U);
        else TwistShuffle::ShuffleList8(pList, mRandom, pBegin, aEnd, 1U);
    };
    aShuffleActive(mMaterials, RandomShuffleLayout::MaterialsBegin(pOffset, aLaneCount));
    aShuffleActive(mSources, RandomShuffleLayout::SourcesBegin(pOffset, aLaneCount));
    aShuffleActive(mWorkSpaces, RandomShuffleLayout::WorkSpacesBegin(pOffset, aLaneCount));
    const auto aExpandersBegin = RandomShuffleLayout::ExpandersBegin(pOffset, aLaneCount);
    TwistShuffle::ShuffleList16(mExpanders, mRandom, aExpandersBegin,
                               aExpandersBegin + RandomShuffleLayout::kExpandersBytes, 1U);
    // The unit's cross-list range is consumed later by Shuffle_CROPER,
    // after the caller has assembled that generation's cross pool.
}

void Soccer3::Shuffle_CROWSCIMASSORMATEX() {
    static_assert(RandomShuffleLayout::kRandomBytes == S_BLOCK);
    static_assert(RandomShuffleLayout::kGenerationCount == BLOCK_COUNT + WARM_UP_BLOCKS);
    static_assert(RandomShuffleLayout::kUnitCount == kRotationListCount);
    ShuffleCROWUnit(mShiftMaskedRotationListBaseA, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mShiftMaskedRotationListAvailableA, RandomShuffleLayout::UnitBegin(0U));
    ShuffleCROWUnit(mFlameToadRotationListBaseAALeft, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableAALeft, RandomShuffleLayout::UnitBegin(1U));
    ShuffleCROWUnit(mFlameToadRotationListBaseAARight, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableAARight, RandomShuffleLayout::UnitBegin(2U));
    ShuffleCROWUnit(mFlameToadRotationListBaseABLeft, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableABLeft, RandomShuffleLayout::UnitBegin(3U));
    ShuffleCROWUnit(mFlameToadRotationListBaseABRight, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableABRight, RandomShuffleLayout::UnitBegin(4U));
    ShuffleCROWUnit(mFlameToadRotationListBaseACLeft, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableACLeft, RandomShuffleLayout::UnitBegin(5U));
    ShuffleCROWUnit(mFlameToadRotationListBaseACRight, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableACRight, RandomShuffleLayout::UnitBegin(6U));
    ShuffleCROWUnit(mFlameToadRotationListBaseADLeft, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableADLeft, RandomShuffleLayout::UnitBegin(7U));
    ShuffleCROWUnit(mFlameToadRotationListBaseADRight, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableADRight, RandomShuffleLayout::UnitBegin(8U));
    ShuffleCROWUnit(mShiftMaskedRotationListBaseB, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mShiftMaskedRotationListAvailableB, RandomShuffleLayout::UnitBegin(9U));
    ShuffleCROWUnit(mFlameToadRotationListBaseBALeft, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableBALeft, RandomShuffleLayout::UnitBegin(10U));
    ShuffleCROWUnit(mFlameToadRotationListBaseBARight, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableBARight, RandomShuffleLayout::UnitBegin(11U));
    ShuffleCROWUnit(mFlameToadRotationListBaseBBLeft, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableBBLeft, RandomShuffleLayout::UnitBegin(12U));
    ShuffleCROWUnit(mFlameToadRotationListBaseBBRight, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableBBRight, RandomShuffleLayout::UnitBegin(13U));
    ShuffleCROWUnit(mFlameToadRotationListBaseBCLeft, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableBCLeft, RandomShuffleLayout::UnitBegin(14U));
    ShuffleCROWUnit(mFlameToadRotationListBaseBCRight, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableBCRight, RandomShuffleLayout::UnitBegin(15U));
    ShuffleCROWUnit(mFlameToadRotationListBaseBDLeft, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableBDLeft, RandomShuffleLayout::UnitBegin(16U));
    ShuffleCROWUnit(mFlameToadRotationListBaseBDRight, mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC,
                    mFlameToadRotationListAvailableBDRight, RandomShuffleLayout::UnitBegin(17U));
    if (mRandomShuffleGeneration < RandomShuffleLayout::kGenerationCount) ++mRandomShuffleGeneration;
}

void Soccer3::Shuffle_CROPER(std::size_t pPermutationCount) {
    const auto aGeneration = mRandomShuffleGeneration == 0U ? 0U : mRandomShuffleGeneration - 1U;
    const std::size_t aLaneCount = mStrength == EncryptionStrength::kWeak ? 4U :
                                  mStrength == EncryptionStrength::kStrong ? 16U : 8U;
    assert(pPermutationCount <= 4U * aLaneCount);
    for (std::size_t aUnit = 0U; aUnit < RandomShuffleLayout::kUnitCount; ++aUnit) {
        // Rotate which lanes receive the two extra unit slots across generations.
        const auto aLane = RandomShuffleLayout::CrossLane(aGeneration, aUnit, aLaneCount);
        const auto aBegin = RandomShuffleLayout::CrossBegin(RandomShuffleLayout::UnitBegin(aUnit), aLaneCount);
        const auto aEnd = aBegin + RandomShuffleLayout::kWordsPerEntry * pPermutationCount;
        if (pPermutationCount == 4U)
            TwistShuffle::ShuffleList4(mCrossPermutations[aLane], mRandom, aBegin, aEnd, 1U);
        else if (pPermutationCount == 8U)
            TwistShuffle::ShuffleList8(mCrossPermutations[aLane], mRandom, aBegin, aEnd, 1U);
        else if (pPermutationCount == 16U)
            TwistShuffle::ShuffleList16(mCrossPermutations[aLane], mRandom, aBegin, aEnd, 1U);
        else if (pPermutationCount == 32U)
            TwistShuffle::ShuffleList32(mCrossPermutations[aLane], mRandom, aBegin, aEnd, 1U);
        else
            TwistShuffle::ShuffleList64(mCrossPermutations[aLane], mRandom, aBegin, aEnd, 1U);
    }
}

bool Soccer3::TwistRound(std::size_t pBlockIndex,
                         bool pIsWarmUpRound,
                         MUTABLE_PARAMS,
                         const std::atomic<bool> *pCancelled) {
    
    std::size_t aComplexity = COMPLEXITY_NORMAL;
    std::size_t aReverseCount = 2U;
    if (mStrength == EncryptionStrength::kWeak) {
        aComplexity = COMPLEXITY_WEAK;
        aReverseCount = 1U;
    } else if (mStrength == EncryptionStrength::kStrong) {
        aComplexity = COMPLEXITY_STRONG;
        aReverseCount = 4U;
    }
    
    static_assert(BLOCK_COUNT >= H_KEY);
    const bool aStifleKey =
        (!pIsWarmUpRound) && (pBlockIndex >= (BLOCK_COUNT - H_KEY));
    
    READ_IN_MUTABLE_PARAMS_INTERNAL;
    const std::size_t aDestinationByteIndex = pBlockIndex * S_BLOCK;
    for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
        mExpanders[aLaneIndex]->TwistBlock(mWorkSpaces[aLaneIndex],
                                           mSources[aLaneIndex],
                                           mCross[0][aLaneIndex],
                                           mCross[1][aLaneIndex],
                                           mCross[2][aLaneIndex],
                                           mCross[3][aLaneIndex],
                                           &mMaterials[aLaneIndex][aDestinationByteIndex],
                                           aStifleKey,
                                           ARX_STATE_VARS);
        
        if (pCancelled != nullptr) {
            if (pCancelled->load(std::memory_order_relaxed)) {
                return false;
            }
        }
        
        AdvanceSeedProgress(kExpanderTwistCost);
    }

    for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
        mSources[aLaneIndex] = &mMaterials[aLaneIndex][aDestinationByteIndex];
    }
    
    if (mStrength == EncryptionStrength::kWeak) {
        FoldMaterialsIntoRandomForBlock_4(pBlockIndex);
    } else if (mStrength == EncryptionStrength::kStrong) {
        FoldMaterialsIntoRandomForBlock_16(pBlockIndex);
    } else {
        FoldMaterialsIntoRandomForBlock_8(pBlockIndex);
    }
    
    for (std::size_t aMaterialIndex=0U; aMaterialIndex<aReverseCount; aMaterialIndex++) {
        std::reverse(mMaterials[aMaterialIndex] + aDestinationByteIndex,
                     mMaterials[aMaterialIndex] + aDestinationByteIndex + S_BLOCK);
    }
    
    Shuffle_CROWSCIMASSORMATEX();
    
    WRITE_OUT_MUTABLE_PARAMS;
    
    return true;
}

bool Soccer3::SeedPrologue_Regular_A(std::uint8_t *pPassword,
                                     std::size_t pPasswordByteLength,
                                     std::uint64_t pNonce,
                                     MUTABLE_PARAMS,
                                     const std::atomic<bool> *pCancelled) {
    
    std::size_t aPower = 0U;
    if (mStrength == EncryptionStrength::kWeak) {
        aPower = 1U;
    } else if (mStrength == EncryptionStrength::kStrong) {
        aPower = 4U;
    } else {
        aPower = 2U;
    }
    
    const std::size_t aWarmUpStartIndex = (BLOCK_COUNT - WARM_UP_BLOCKS) * S_BLOCK;
    
    READ_IN_MUTABLE_PARAMS_INTERNAL;
    
    for (std::size_t aSpanIndex=0U; aSpanIndex<4U; aSpanIndex++) {
        for (std::size_t aPowerIndex=0U; aPowerIndex<aPower; aPowerIndex++) {
            const std::size_t aClaimedIndex = mClaimedMaterialCount;

            mClaimedExpanders[aClaimedIndex] = mExpanders[aPowerIndex];
            mClaimedExpanderCount++;

            mClaimedMaterials[aClaimedIndex] = mMaterials[aPowerIndex];
            mClaimedMaterialCount++;

            mClaimedWorkSpaces[aClaimedIndex] = mWorkSpaces[aPowerIndex];
            mClaimedWorkSpaceCount++;

            mClaimedExpanders[aClaimedIndex]->Seed(mClaimedWorkSpaces[aClaimedIndex],
                                                   pNonce,
                                                   pPassword,
                                                   pPasswordByteLength,
                                                   &mClaimedMaterials[aClaimedIndex][aWarmUpStartIndex],
                                                   ARX_STATE_VARS);
            AdvanceSeedProgress(kExpanderSeedCost);
            
            if (pCancelled != nullptr) {
                if (pCancelled->load(std::memory_order_relaxed)) {
                    return false;
                }
            }
            
        }

        if (aSpanIndex < 3U) {
            Shuffle_MEWBlockZero(&mClaimedMaterials[mClaimedMaterialCount - 1U][aWarmUpStartIndex]);
        }
    }
    
    WRITE_OUT_MUTABLE_PARAMS;
    
    return true;
}

void Soccer3::SeedPrologue_Regular_B() {
    for (std::size_t aIndex=0U; aIndex<mClaimedMaterialCount; aIndex++) {
        mMaterials[aIndex] = mClaimedMaterials[aIndex];
    }

    std::size_t aMaterialWriteIndex = mClaimedMaterialCount;
    for (std::size_t aShuffledIndex=0U; aShuffledIndex<16U; aShuffledIndex++) {
        bool aIsClaimed = false;
        for (std::size_t aClaimedIndex=0U; aClaimedIndex<mClaimedMaterialCount; aClaimedIndex++) {
            if (mShuffleMaterials[aShuffledIndex] == mClaimedMaterials[aClaimedIndex]) {
                aIsClaimed = true;
                break;
            }
        }
        if (!aIsClaimed) {
            mMaterials[aMaterialWriteIndex] = mShuffleMaterials[aShuffledIndex];
            aMaterialWriteIndex++;
        }
    }

    for (std::size_t aIndex=0U; aIndex<mClaimedExpanderCount; aIndex++) {
        mExpanders[aIndex] = mClaimedExpanders[aIndex];
    }

    std::size_t aExpanderWriteIndex = mClaimedExpanderCount;
    for (std::size_t aShuffledIndex=0U; aShuffledIndex<SOCCER_EXPANDER_COUNT; aShuffledIndex++) {
        bool aIsClaimed = false;
        for (std::size_t aClaimedIndex=0U; aClaimedIndex<mClaimedExpanderCount; aClaimedIndex++) {
            if (mShuffleExpanders[aShuffledIndex] == mClaimedExpanders[aClaimedIndex]) {
                aIsClaimed = true;
                break;
            }
        }
        if (!aIsClaimed) {
            mExpanders[aExpanderWriteIndex] = mShuffleExpanders[aShuffledIndex];
            aExpanderWriteIndex++;
        }
    }

    for (std::size_t aIndex=0U; aIndex<mClaimedWorkSpaceCount; aIndex++) {
        mWorkSpaces[aIndex] = mClaimedWorkSpaces[aIndex];
    }

    std::size_t aWorkSpaceWriteIndex = mClaimedWorkSpaceCount;
    for (std::size_t aShuffledIndex=0U; aShuffledIndex<16U; aShuffledIndex++) {
        bool aIsClaimed = false;
        for (std::size_t aClaimedIndex=0U; aClaimedIndex<mClaimedWorkSpaceCount; aClaimedIndex++) {
            if (mShuffleWorkSpaces[aShuffledIndex] == mClaimedWorkSpaces[aClaimedIndex]) {
                aIsClaimed = true;
                break;
            }
        }
        if (!aIsClaimed) {
            mWorkSpaces[aWorkSpaceWriteIndex] = mShuffleWorkSpaces[aShuffledIndex];
            aWorkSpaceWriteIndex++;
        }
    }

    const std::size_t aFirstWarmUpBlockIndex = BLOCK_COUNT - WARM_UP_BLOCKS;
    const std::size_t aFirstWarmUpByteIndex = aFirstWarmUpBlockIndex * S_BLOCK;
    if (mStrength == EncryptionStrength::kWeak) {
        FoldMaterialsIntoRandomForBlock_4(aFirstWarmUpBlockIndex);
        
        for (std::size_t aIndex=0U; aIndex<COMPLEXITY_WEAK; aIndex++) {
            mSources[aIndex] = &mMaterials[aIndex][aFirstWarmUpByteIndex];
        }
        
    } else if (mStrength == EncryptionStrength::kStrong) {
        FoldMaterialsIntoRandomForBlock_16(aFirstWarmUpBlockIndex);
        
        for (std::size_t aIndex=0U; aIndex<COMPLEXITY_STRONG; aIndex++) {
            mSources[aIndex] = &mMaterials[aIndex][aFirstWarmUpByteIndex];
        }
    } else {
        FoldMaterialsIntoRandomForBlock_8(aFirstWarmUpBlockIndex);
        
        for (std::size_t aIndex=0U; aIndex<COMPLEXITY_NORMAL; aIndex++) {
            mSources[aIndex] = &mMaterials[aIndex][aFirstWarmUpByteIndex];
        }
    }
}

void Soccer3::ArrangeCrossPool(std::size_t pComplexity) {
    constexpr std::size_t aCrossCount = 4U;
    constexpr std::size_t aCrossPoolCapacity = 64U;

    for (std::size_t aLaneIndex=0U; aLaneIndex<pComplexity; aLaneIndex++) {
        const std::size_t aPoolCount = mCrossPoolCount[aLaneIndex];
        if ((aPoolCount < aCrossCount) || (aPoolCount > aCrossPoolCapacity)) {
            std::abort();
        }

        for (std::size_t aCrossIndex=0U; aCrossIndex<aCrossCount; aCrossIndex++) {
            const std::size_t aPoolIndex =
                mCrossPermutations[aLaneIndex][aCrossIndex];
            if (aPoolIndex >= aPoolCount) {
                std::abort();
            }
            mCross[aCrossIndex][aLaneIndex] = mCrossPool[aLaneIndex][aPoolIndex];
        }
    }
}


// Per-round reset: each rebuilt pool starts a fresh permutation before
// Shuffle_CROPER selects from it. This is separate from new-seed initialization.
void Soccer3::InitializeCrossPermutations() {
    for (std::size_t aLaneIndex=0U; aLaneIndex<16U; aLaneIndex++) {
        for (std::size_t aPoolIndex=0U; aPoolIndex<64U; aPoolIndex++) {
            mCrossPermutations[aLaneIndex][aPoolIndex] = aPoolIndex;
        }
    }
}

void Soccer3::BuildCrossPool_WarmUp1(std::size_t pComplexity,
                                     std::size_t pCurrentByteIndex) {
    static_assert((COMPLEXITY_STRONG * 2U) == 32U);

    InitializeCrossPermutations();

    for (std::size_t aLaneIndex=0U; aLaneIndex<pComplexity; aLaneIndex++) {
        mCrossPoolCount[aLaneIndex] = 0U;
        for (std::size_t aPoolIndex=0U; aPoolIndex<64U; aPoolIndex++) {
            mCrossPool[aLaneIndex][aPoolIndex] = nullptr;
        }

        for (std::size_t aMaterialIndex=0U;
             aMaterialIndex<pComplexity;
             aMaterialIndex++) {
            std::uint8_t *aCandidate =
                &mMaterials[aMaterialIndex][pCurrentByteIndex];
            if (aCandidate != mSources[aLaneIndex]) {
                mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = aCandidate;
                mCrossPoolCount[aLaneIndex]++;
            }
        }

        mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = SOCCER_PRELUDE_RAND;
        mCrossPoolCount[aLaneIndex]++;
    }
}

void Soccer3::BuildCrossPool_WarmUp2(std::size_t pComplexity,
                                     std::size_t pPreviousByteIndex,
                                     std::size_t pCurrentByteIndex) {
    InitializeCrossPermutations();

    for (std::size_t aLaneIndex=0U; aLaneIndex<pComplexity; aLaneIndex++) {
        mCrossPoolCount[aLaneIndex] = 0U;
        for (std::size_t aPoolIndex=0U; aPoolIndex<64U; aPoolIndex++) {
            mCrossPool[aLaneIndex][aPoolIndex] = nullptr;
        }

        for (std::size_t aMaterialIndex=0U;
             aMaterialIndex<pComplexity;
             aMaterialIndex++) {
            mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] =
                &mMaterials[aMaterialIndex][pPreviousByteIndex];
            mCrossPoolCount[aLaneIndex]++;
        }

        for (std::size_t aMaterialIndex=0U;
             aMaterialIndex<pComplexity;
             aMaterialIndex++) {
            std::uint8_t *aCandidate =
                &mMaterials[aMaterialIndex][pCurrentByteIndex];
            if (aCandidate != mSources[aLaneIndex]) {
                mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = aCandidate;
                mCrossPoolCount[aLaneIndex]++;
            }
        }

        mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = SOCCER_PRELUDE_RAND;
        mCrossPoolCount[aLaneIndex]++;
    }
}

void Soccer3::BuildCrossPool_WarmUp4(std::size_t pComplexity,
                                     std::size_t pThreeRoundsBackByteIndex,
                                     std::size_t pTwoRoundsBackByteIndex,
                                     std::size_t pOneRoundBackByteIndex) {
    static_assert((COMPLEXITY_STRONG * 4U) == 64U);

    InitializeCrossPermutations();

    for (std::size_t aLaneIndex=0U; aLaneIndex<pComplexity; aLaneIndex++) {
        mCrossPoolCount[aLaneIndex] = 0U;
        for (std::size_t aPoolIndex=0U; aPoolIndex<64U; aPoolIndex++) {
            mCrossPool[aLaneIndex][aPoolIndex] = nullptr;
        }

        for (std::size_t aMaterialIndex=0U;
             aMaterialIndex<pComplexity;
             aMaterialIndex++) {
            if (mSources[aMaterialIndex] != mSources[aLaneIndex]) {
                mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] =
                    mSources[aMaterialIndex];
                mCrossPoolCount[aLaneIndex]++;
            }
        }

        mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = SOCCER_PRELUDE_RAND;
        mCrossPoolCount[aLaneIndex]++;

        for (std::size_t aMaterialIndex=0U; aMaterialIndex<pComplexity; aMaterialIndex++) {
            mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = &mMaterials[aMaterialIndex][pThreeRoundsBackByteIndex];
            mCrossPoolCount[aLaneIndex]++;
        }

        for (std::size_t aMaterialIndex=0U; aMaterialIndex<pComplexity; aMaterialIndex++) {
            mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = &mMaterials[aMaterialIndex][pTwoRoundsBackByteIndex];
            mCrossPoolCount[aLaneIndex]++;
        }

        for (std::size_t aMaterialIndex=0U; aMaterialIndex<pComplexity; aMaterialIndex++) {
            mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = &mMaterials[aMaterialIndex][pOneRoundBackByteIndex];
            mCrossPoolCount[aLaneIndex]++;
        }
    }
}

void Soccer3::BuildCrossPool_Regular(std::size_t pComplexity,
                                     std::size_t pFourRoundsBackByteIndex,
                                     std::size_t pThreeRoundsBackByteIndex,
                                     std::size_t pTwoRoundsBackByteIndex,
                                     std::size_t pOneRoundBackByteIndex) {
    static_assert((COMPLEXITY_STRONG * 4U) == 64U);

    InitializeCrossPermutations();

    for (std::size_t aLaneIndex=0U; aLaneIndex<pComplexity; aLaneIndex++) {
        mCrossPoolCount[aLaneIndex] = 0U;
        for (std::size_t aPoolIndex=0U; aPoolIndex<64U; aPoolIndex++) {
            mCrossPool[aLaneIndex][aPoolIndex] = nullptr;
        }
        
        for (std::size_t aMaterialIndex=0U; aMaterialIndex<pComplexity; aMaterialIndex++) {
            if (mSources[aMaterialIndex] != mSources[aLaneIndex]) {
                mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] =
                    mSources[aMaterialIndex];
                mCrossPoolCount[aLaneIndex]++;
            }
        }

        mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = &mMaterials[aLaneIndex][pFourRoundsBackByteIndex];
        mCrossPoolCount[aLaneIndex]++;

        for (std::size_t aMaterialIndex=0U; aMaterialIndex<pComplexity; aMaterialIndex++) {
            mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = &mMaterials[aMaterialIndex][pThreeRoundsBackByteIndex];
            mCrossPoolCount[aLaneIndex]++;
        }

        for (std::size_t aMaterialIndex=0U; aMaterialIndex<pComplexity; aMaterialIndex++) {
            mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = &mMaterials[aMaterialIndex][pTwoRoundsBackByteIndex];
            mCrossPoolCount[aLaneIndex]++;
        }

        for (std::size_t aMaterialIndex=0U; aMaterialIndex<pComplexity; aMaterialIndex++) {
            mCrossPool[aLaneIndex][mCrossPoolCount[aLaneIndex]] = &mMaterials[aMaterialIndex][pOneRoundBackByteIndex];
            mCrossPoolCount[aLaneIndex]++;
        }
    }
}

bool Soccer3::SeedPrologue_Regular_C(std::uint32_t *pAckWord,
                                     bool pForwardDeploy,
                                     MUTABLE_PARAMS,
                                     const std::atomic<bool> *pCancelled) {
    
    std::size_t aComplexity = COMPLEXITY_NORMAL;
    if (mStrength == EncryptionStrength::kWeak) {
        aComplexity = COMPLEXITY_WEAK;
    } else if (mStrength == EncryptionStrength::kStrong) {
        aComplexity = COMPLEXITY_STRONG;
    }

    static_assert(WARM_UP_ROUNDS == 5U);
    static_assert(WARM_UP_BLOCKS == 6U);
    const std::size_t aWarmUpSeedBlockIndex = BLOCK_COUNT - WARM_UP_BLOCKS;
    const std::size_t aWarmUpSeedByteIndex = aWarmUpSeedBlockIndex * S_BLOCK;
    const std::size_t aWarmUp1ByteIndex = (aWarmUpSeedBlockIndex + 1U) * S_BLOCK;
    const std::size_t aWarmUp2ByteIndex = (aWarmUpSeedBlockIndex + 2U) * S_BLOCK;
    const std::size_t aWarmUp3ByteIndex = (aWarmUpSeedBlockIndex + 3U) * S_BLOCK;
    
    READ_IN_MUTABLE_PARAMS_INTERNAL;

    Shuffle_CROWSCIMASSORMATEX();

    BuildCrossPool_WarmUp1(aComplexity, aWarmUpSeedByteIndex);
    Shuffle_CROPER(mCrossPoolCount[0]);
    ArrangeCrossPool(aComplexity);
    if (!TwistRound(aWarmUpSeedBlockIndex + 1U, true, ARX_STATE_VARS, pCancelled)) {
        return false;
    }

    BuildCrossPool_WarmUp2(aComplexity,
                           aWarmUpSeedByteIndex,
                           aWarmUp1ByteIndex);
    Shuffle_CROPER(mCrossPoolCount[0]);
    ArrangeCrossPool(aComplexity);
    if (!TwistRound(aWarmUpSeedBlockIndex + 2U, true, ARX_STATE_VARS, pCancelled)) {
        return false;
    }

    BuildCrossPool_WarmUp2(aComplexity,
                           aWarmUp1ByteIndex,
                           aWarmUp2ByteIndex);
    Shuffle_CROPER(mCrossPoolCount[0]);
    ArrangeCrossPool(aComplexity);
    if (!TwistRound(aWarmUpSeedBlockIndex + 3U, true, ARX_STATE_VARS, pCancelled)) {
        return false;
    }

    BuildCrossPool_WarmUp4(aComplexity,
                           aWarmUpSeedByteIndex,
                           aWarmUp1ByteIndex,
                           aWarmUp2ByteIndex);
    Shuffle_CROPER(mCrossPoolCount[0]);
    ArrangeCrossPool(aComplexity);
    if (!TwistRound(aWarmUpSeedBlockIndex + 4U, true, ARX_STATE_VARS, pCancelled)) {
        return false;
    }

    BuildCrossPool_Regular(aComplexity,
                           aWarmUpSeedByteIndex,
                           aWarmUp1ByteIndex,
                           aWarmUp2ByteIndex,
                           aWarmUp3ByteIndex);
    Shuffle_CROPER(mCrossPoolCount[0]);
    ArrangeCrossPool(aComplexity);
    if (!TwistRound(aWarmUpSeedBlockIndex + 5U, true, ARX_STATE_VARS, pCancelled)) {
        return false;
    }
    
    WRITE_OUT_MUTABLE_PARAMS;

    const std::size_t aAckByteIndex = SOCCER_BLOCK_SIZE - 1U;
    std::uint32_t aGeneratedAckWord = 0U;
    if (mStrength == EncryptionStrength::kWeak) {
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[0][aAckByteIndex]) <<  0U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[1][aAckByteIndex]) <<  8U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[2][aAckByteIndex]) << 16U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[3][aAckByteIndex]) << 24U;
    } else if (mStrength == EncryptionStrength::kStrong) {
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[ 3][aAckByteIndex]) <<  0U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[ 7][aAckByteIndex]) <<  8U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[11][aAckByteIndex]) << 16U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[15][aAckByteIndex]) << 24U;
    } else {
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[1][aAckByteIndex]) <<  0U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[3][aAckByteIndex]) <<  8U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[5][aAckByteIndex]) << 16U;
        aGeneratedAckWord |= static_cast<std::uint32_t>(mMaterials[7][aAckByteIndex]) << 24U;
    }

    if (pForwardDeploy) {
        *pAckWord = aGeneratedAckWord;
        return true;
    }

    return aGeneratedAckWord == *pAckWord;
}

bool Soccer3::SeedPrologue_Regular_D(MUTABLE_PARAMS,
                                     const std::atomic<bool> *pCancelled) {
    std::size_t aComplexity = COMPLEXITY_NORMAL;
    if (mStrength == EncryptionStrength::kWeak) {
        aComplexity = COMPLEXITY_WEAK;
    } else if (mStrength == EncryptionStrength::kStrong) {
        aComplexity = COMPLEXITY_STRONG;
    }
    
    READ_IN_MUTABLE_PARAMS_INTERNAL;

    for (std::size_t aRoundIndex=0U; aRoundIndex<BLOCK_COUNT; aRoundIndex++) {
        const std::size_t aFourRoundsBackBlockIndex = (aRoundIndex + BLOCK_COUNT - 5U) % BLOCK_COUNT;
        const std::size_t aThreeRoundsBackBlockIndex = (aRoundIndex + BLOCK_COUNT - 4U) % BLOCK_COUNT;
        const std::size_t aTwoRoundsBackBlockIndex = (aRoundIndex + BLOCK_COUNT - 3U) % BLOCK_COUNT;
        const std::size_t aOneRoundBackBlockIndex = (aRoundIndex + BLOCK_COUNT - 2U) % BLOCK_COUNT;
        BuildCrossPool_Regular(aComplexity,
                               aFourRoundsBackBlockIndex * S_BLOCK,
                               aThreeRoundsBackBlockIndex * S_BLOCK,
                               aTwoRoundsBackBlockIndex * S_BLOCK,
                               aOneRoundBackBlockIndex * S_BLOCK);
        Shuffle_CROPER(mCrossPoolCount[0]);
        ArrangeCrossPool(aComplexity);
        if (!TwistRound(aRoundIndex, false, ARX_STATE_VARS, pCancelled)) {
            return false;
        }
    }
    
    WRITE_OUT_MUTABLE_PARAMS;
    
    return true;
}

void Soccer3::FoldMaterialsIntoRandomForBlock_4(std::size_t pBlockIndex) {
    const std::size_t aStartIndex = pBlockIndex * S_BLOCK;
    for (std::size_t aByteIndex=0U; aByteIndex<S_BLOCK; aByteIndex++) {
        const std::size_t aMaterialIndex = aStartIndex + aByteIndex;
        const std::uint32_t aRandomIngress =
            (static_cast<std::uint32_t>(mMaterials[0][aMaterialIndex]) <<  0U) |
            (static_cast<std::uint32_t>(mMaterials[1][aMaterialIndex]) <<  8U) |
            (static_cast<std::uint32_t>(mMaterials[2][aMaterialIndex]) << 16U) |
            (static_cast<std::uint32_t>(mMaterials[3][aMaterialIndex]) << 24U);

        mRandom[aByteIndex] = static_cast<std::uint8_t>(TwistMix32::DiffuseA(aRandomIngress));
    }
}

void Soccer3::FoldMaterialsIntoRandomForBlock_8(std::size_t pBlockIndex) {
    const std::size_t aStartIndex = pBlockIndex * S_BLOCK;
    for (std::size_t aByteIndex=0U; aByteIndex<S_BLOCK; aByteIndex++) {
        const std::size_t aMaterialIndex = aStartIndex + aByteIndex;
        const std::uint64_t aRandomIngress =
            (static_cast<std::uint64_t>(mMaterials[0][aMaterialIndex]) <<  0U) |
            (static_cast<std::uint64_t>(mMaterials[1][aMaterialIndex]) <<  8U) |
            (static_cast<std::uint64_t>(mMaterials[2][aMaterialIndex]) << 16U) |
            (static_cast<std::uint64_t>(mMaterials[3][aMaterialIndex]) << 24U) |
            (static_cast<std::uint64_t>(mMaterials[4][aMaterialIndex]) << 32U) |
            (static_cast<std::uint64_t>(mMaterials[5][aMaterialIndex]) << 40U) |
            (static_cast<std::uint64_t>(mMaterials[6][aMaterialIndex]) << 48U) |
            (static_cast<std::uint64_t>(mMaterials[7][aMaterialIndex]) << 56U);

        mRandom[aByteIndex] = static_cast<std::uint8_t>(TwistMix64::DiffuseA(aRandomIngress));
    }
}

void Soccer3::FoldMaterialsIntoRandomForBlock_16(std::size_t pBlockIndex) {
    const std::size_t aStartIndex = pBlockIndex * S_BLOCK;
    for (std::size_t aByteIndex=0U; aByteIndex<S_BLOCK; aByteIndex++) {
        const std::size_t aMaterialIndex = aStartIndex + aByteIndex;

        const std::uint32_t aCrushIngressA =
            (static_cast<std::uint32_t>(mMaterials[ 0][aMaterialIndex]) <<  0U) |
            (static_cast<std::uint32_t>(mMaterials[ 1][aMaterialIndex]) <<  8U) |
            (static_cast<std::uint32_t>(mMaterials[ 2][aMaterialIndex]) << 16U) |
            (static_cast<std::uint32_t>(mMaterials[ 3][aMaterialIndex]) << 24U);
        const std::uint8_t aCrushA = static_cast<std::uint8_t>(TwistMix32::DiffuseA(aCrushIngressA));

        const std::uint32_t aCrushIngressB =
            (static_cast<std::uint32_t>(mMaterials[ 4][aMaterialIndex]) <<  0U) |
            (static_cast<std::uint32_t>(mMaterials[ 5][aMaterialIndex]) <<  8U) |
            (static_cast<std::uint32_t>(mMaterials[ 6][aMaterialIndex]) << 16U) |
            (static_cast<std::uint32_t>(mMaterials[ 7][aMaterialIndex]) << 24U);
        const std::uint8_t aCrushB = static_cast<std::uint8_t>(TwistMix32::DiffuseA(aCrushIngressB));

        const std::uint32_t aCrushIngressC =
            (static_cast<std::uint32_t>(mMaterials[ 8][aMaterialIndex]) <<  0U) |
            (static_cast<std::uint32_t>(mMaterials[ 9][aMaterialIndex]) <<  8U) |
            (static_cast<std::uint32_t>(mMaterials[10][aMaterialIndex]) << 16U) |
            (static_cast<std::uint32_t>(mMaterials[11][aMaterialIndex]) << 24U);
        const std::uint8_t aCrushC = static_cast<std::uint8_t>(TwistMix32::DiffuseA(aCrushIngressC));

        const std::uint32_t aCrushIngressD =
            (static_cast<std::uint32_t>(mMaterials[12][aMaterialIndex]) <<  0U) |
            (static_cast<std::uint32_t>(mMaterials[13][aMaterialIndex]) <<  8U) |
            (static_cast<std::uint32_t>(mMaterials[14][aMaterialIndex]) << 16U) |
            (static_cast<std::uint32_t>(mMaterials[15][aMaterialIndex]) << 24U);
        const std::uint8_t aCrushD = static_cast<std::uint8_t>(TwistMix32::DiffuseA(aCrushIngressD));

        const std::uint32_t aRandomIngress =
            (static_cast<std::uint32_t>(aCrushA) <<  0U) |
            (static_cast<std::uint32_t>(aCrushB) <<  8U) |
            (static_cast<std::uint32_t>(aCrushC) << 16U) |
            (static_cast<std::uint32_t>(aCrushD) << 24U);

        mRandom[aByteIndex] = static_cast<std::uint8_t>(TwistMix32::DiffuseA(aRandomIngress));
    }
}

bool Soccer3::AttemptSeed_Encrypt(EncryptionStrength pStrength,
                                  std::uint8_t *pPassword,
                                  std::size_t pPasswordByteLength,
                                  std::uint64_t pNonce,
                                  std::uint32_t *pAckWord,
                                  std::uint64_t pVersion,
                                  const std::atomic<bool> *pCancelled) {

    Zero();
    mStrength = pStrength;
    BeginSeedProgress(pStrength);
    
    if ((pPassword == nullptr) || (pPasswordByteLength == 0U) || (pAckWord == nullptr)) {
        return FinishSeedProgress(false);
    }

    std::uint32_t aAckWord = 0U;
    
    if (pStrength == EncryptionStrength::kTest) {
        if (!SeedPrelude_Test(pPassword, pPasswordByteLength, pNonce)) {
            return FinishSeedProgress(false);
        }
        aAckWord |= static_cast<std::uint32_t>(mMaterialA[S_BLOCK * 1]) <<  0U;
        aAckWord |= static_cast<std::uint32_t>(mMaterialA[S_BLOCK * 2]) <<  8U;
        aAckWord |= static_cast<std::uint32_t>(mMaterialA[S_BLOCK * 3]) << 16U;
        aAckWord |= static_cast<std::uint32_t>(mMaterialA[S_BLOCK * 4]) << 24U;
        *pAckWord = aAckWord;
        
        if (pCancelled != nullptr) {
            if (pCancelled->load(std::memory_order_relaxed)) {
                return FinishSeedProgress(false);
            } else {
                return FinishSeedProgress(true);
            }
        } else {
            return FinishSeedProgress(true);
        }
    }
    
    std::uint64_t aIngress = 0xE025CAEA83AB99CFULL;
    std::uint64_t aCarry = 0x6530BC4A53A443B8ULL;
    std::uint64_t aWandererA = 0x4E06885276D20E3DULL;
    std::uint64_t aWandererB = 0xEBF1E1AB6DF26920ULL;
    std::uint64_t aWandererC = 0x99478E05E833FBB1ULL;
    std::uint64_t aWandererD = 0x73A9F7B5B01778B2ULL;
    std::uint64_t aWandererE = 0xB9AB363EA936D1EDULL;
    std::uint64_t aWandererF = 0x847430D62AD62F79ULL;
    std::uint64_t aWandererG = 0x0D6FE89E3169B0E1ULL;
    std::uint64_t aWandererH = 0xD22934C37E3EE9B7ULL;
    std::uint64_t aWandererI = 0x648E293C4DCD6ED1ULL;
    std::uint64_t aWandererJ = 0xA31C40A884CAD927ULL;
    std::uint64_t aWandererK = 0x183169CC43C8BCE3ULL;
    
    // Chapter I - Prelude
    SeedPrelude_Regular_A(pPassword, pPasswordByteLength, pNonce);
    SeedPrelude_Regular_B(pNonce, ARX_STATE_VARS);
    SeedPrelude_Regular_C();
    
    if (pCancelled != nullptr) {
        if (pCancelled->load(std::memory_order_relaxed)) {
            return FinishSeedProgress(false);
        }
    }
    
    // Chapter II - Prologue
    if (!SeedPrologue_Regular_A(pPassword, pPasswordByteLength, pNonce, ARX_STATE_VARS, pCancelled)) {
        return FinishSeedProgress(false);
    }
    SeedPrologue_Regular_B();
    if (!SeedPrologue_Regular_C(pAckWord, true, ARX_STATE_VARS, pCancelled)) {
        return FinishSeedProgress(false);
    }
    if (!SeedPrologue_Regular_D(ARX_STATE_VARS, pCancelled)) {
        return FinishSeedProgress(false);
    }
    
    // Chapter III - Epilogue
    SeedEpilogue_Regular_A();
    if (!SeedEpilogue_Regular_C()) return FinishSeedProgress(false);
    if (!SeedEpilogue_Regular_D()) {
        return FinishSeedProgress(false);
    }
    
    if (pCancelled != nullptr) {
        if (pCancelled->load(std::memory_order_relaxed)) {
            return FinishSeedProgress(false);
        } else {
            return FinishSeedProgress(true);
        }
    } else {
        return FinishSeedProgress(true);
    }
}

bool Soccer3::AttemptSeed_Decrypt(EncryptionStrength pStrength,
                                  std::uint8_t *pPassword,
                                  std::size_t pPasswordByteLength,
                                  std::uint64_t pNonce,
                                  std::uint32_t pAckWord,
                                  std::uint64_t pVersion,
                                  const std::atomic<bool> *pCancelled) {

    Zero();
    mStrength = pStrength;
    BeginSeedProgress(pStrength);
    
    if ((pPassword == nullptr) || (pPasswordByteLength == 0U)) {
        return FinishSeedProgress(false);
    }

    
    if (pStrength == EncryptionStrength::kTest) {
        if (!SeedPrelude_Test(pPassword, pPasswordByteLength, pNonce)) {
            return FinishSeedProgress(false);
        }
        if (mMaterialA[S_BLOCK * 1] != static_cast<std::uint8_t>(((pAckWord >>  0) & 0xFFU))) { return FinishSeedProgress(false); }
        if (mMaterialA[S_BLOCK * 2] != static_cast<std::uint8_t>(((pAckWord >>  8) & 0xFFU))) { return FinishSeedProgress(false); }
        if (mMaterialA[S_BLOCK * 3] != static_cast<std::uint8_t>(((pAckWord >> 16) & 0xFFU))) { return FinishSeedProgress(false); }
        if (mMaterialA[S_BLOCK * 4] != static_cast<std::uint8_t>(((pAckWord >> 24) & 0xFFU))) { return FinishSeedProgress(false); }
        
        if (pCancelled != nullptr) {
            if (pCancelled->load(std::memory_order_relaxed)) {
                return FinishSeedProgress(false);
            } else {
                return FinishSeedProgress(true);
            }
        } else {
            return FinishSeedProgress(true);
        }
    }
    
    std::uint64_t aIngress = 0xE025CAEA83AB99CFULL;
    std::uint64_t aCarry = 0x6530BC4A53A443B8ULL;
    std::uint64_t aWandererA = 0x4E06885276D20E3DULL;
    std::uint64_t aWandererB = 0xEBF1E1AB6DF26920ULL;
    std::uint64_t aWandererC = 0x99478E05E833FBB1ULL;
    std::uint64_t aWandererD = 0x73A9F7B5B01778B2ULL;
    std::uint64_t aWandererE = 0xB9AB363EA936D1EDULL;
    std::uint64_t aWandererF = 0x847430D62AD62F79ULL;
    std::uint64_t aWandererG = 0x0D6FE89E3169B0E1ULL;
    std::uint64_t aWandererH = 0xD22934C37E3EE9B7ULL;
    std::uint64_t aWandererI = 0x648E293C4DCD6ED1ULL;
    std::uint64_t aWandererJ = 0xA31C40A884CAD927ULL;
    std::uint64_t aWandererK = 0x183169CC43C8BCE3ULL;
    
    // Chapter I - Prelude
    SeedPrelude_Regular_A(pPassword, pPasswordByteLength, pNonce);
    SeedPrelude_Regular_B(pNonce, ARX_STATE_VARS);
    SeedPrelude_Regular_C();
    
    if (pCancelled != nullptr) {
        if (pCancelled->load(std::memory_order_relaxed)) {
            FinishSeedProgress(false);
            return false;
        }
    }
    
    // Chapter II - Prologue
    std::uint32_t aAckWord = pAckWord;
    if (!SeedPrologue_Regular_A(pPassword, pPasswordByteLength, pNonce, ARX_STATE_VARS, pCancelled)) {
        return FinishSeedProgress(false);
    }
    SeedPrologue_Regular_B();
    if (!SeedPrologue_Regular_C(&aAckWord, false, ARX_STATE_VARS, pCancelled)) {
        return FinishSeedProgress(false);
    }
    if (!SeedPrologue_Regular_D(ARX_STATE_VARS, pCancelled)) {
        return FinishSeedProgress(false);
    }
    
    // Chapter III - Epilogue
    SeedEpilogue_Regular_A();
    if (!SeedEpilogue_Regular_C()) return FinishSeedProgress(false);
    if (!SeedEpilogue_Regular_D()) {
        return FinishSeedProgress(false);
    }
    
    if (pCancelled != nullptr) {
        if (pCancelled->load(std::memory_order_relaxed)) {
            return FinishSeedProgress(false);
        } else {
            return FinishSeedProgress(true);
        }
    } else {
        return FinishSeedProgress(true);
    }
}

void Soccer3::SetDelegate(SoccerDelegate *pDelegate) {
    mDelegate = pDelegate;
}

void Soccer3::BeginSeedProgress(EncryptionStrength pStrength) {
    if (pStrength != EncryptionStrength::kTest) {
        std::size_t aComplexity = COMPLEXITY_NORMAL;
        if (pStrength == EncryptionStrength::kWeak) {
            aComplexity = COMPLEXITY_WEAK;
        } else if (pStrength == EncryptionStrength::kStrong) {
            aComplexity = COMPLEXITY_STRONG;
        }

        // One starter seed, one seed per active lane, then every warm-up and
        // main TwistBlock. Reserve the final unit for epilogue A through D.
        const std::size_t aSeedCount = 1U + aComplexity;
        const std::size_t aTwistCount = aComplexity * (WARM_UP_ROUNDS + BLOCK_COUNT);
        mSeedProgressTotal = (aSeedCount * kExpanderSeedCost) +
                             (aTwistCount * kExpanderTwistCost) +
                             kSeedEpilogueCost;
    }

    if (mDelegate != nullptr) {
        mDelegate->SeedProgress(0.0);
    }
}

void Soccer3::AdvanceSeedProgress(std::size_t pCost) {
    // Test-strength seeding has no weighted progress stages.
    if (mSeedProgressTotal == 0U) {
        return;
    }

    mSeedProgressCompleted += pCost;
    if (mDelegate != nullptr) {
        const double aPercent = 100.0 * static_cast<double>(mSeedProgressCompleted) /
                                static_cast<double>(mSeedProgressTotal);
        mDelegate->SeedProgress(aPercent);
    }
}

bool Soccer3::FinishSeedProgress(bool pSuccess) {
    if (mDelegate != nullptr) {
        mDelegate->SeedProgress(100.0);
    }
    return pSuccess;
}

void Soccer3::ConfigureTestBuffers(std::uint32_t pTestBlockLength) {
    mTestBlockLength = pTestBlockLength;
}

bool Soccer3::EncryptBlock(std::uint8_t *pSource,
                           std::uint8_t *pDestination) {
    if ((pSource == nullptr) || (pDestination == nullptr)) {
        return false;
    }
    
    if (mStrength == EncryptionStrength::kTest) {
        for (std::size_t aIndex=0; aIndex<mTestBlockLength; aIndex++) {
            pDestination[aIndex] = pSource[aIndex] ^ mMaterialA[aIndex];
        }
        return true;
    }

    if (!mEncryptionReady || !mCryptex.IsBuilt()) return false;
    return mCryptex.SealData(pSource, SOCCER_SCRATCH_WORKER_A,
                                    SOCCER_WORKER_B, pDestination, SOCCER_BLOCK_SIZE, nullptr);
}

bool Soccer3::DecryptBlock(std::uint8_t *pSource,
                           std::uint8_t *pDestination) {
    if ((pSource == nullptr) || (pDestination == nullptr)) {
        return false;
    }

    if (mStrength == EncryptionStrength::kTest) {
        for (std::size_t aIndex=0; aIndex<mTestBlockLength; aIndex++) {
            pDestination[aIndex] = pSource[aIndex] ^ mMaterialA[aIndex];
        }
        return true;
    }

    if (!mEncryptionReady || !mCryptex.IsBuilt()) return false;
    return mCryptex.UnsealData(pSource, SOCCER_SCRATCH_WORKER_A,
                                      SOCCER_WORKER_B, pDestination, SOCCER_BLOCK_SIZE, nullptr);
}

bool Soccer3::SeedPrelude_Test(std::uint8_t *pPassword,
                               std::size_t pPasswordByteLength,
                               std::uint64_t pNonce) {
    UnrollNonceAndPasswordToScratch_Test(pPassword, pPasswordByteLength, pNonce);
    std::uint64_t aValue = 0x00;
    for (std::size_t aIndex=0; aIndex<SOCCER_BLOCK_SIZE; aIndex++) {
        aValue = RotL64(aValue, 3);
        aValue ^= static_cast<std::uint64_t>(SOCCER_SCRATCH_WORKER_A[aIndex]);
        aValue = (aValue * 3333333333333333333ULL);
        mMaterialA[aIndex] = static_cast<std::uint8_t>(aValue);
    }
    return true;
}

void Soccer3::SeedPrelude_Regular_A(std::uint8_t *pPassword,
                                    std::size_t pPasswordByteLength,
                                    std::uint64_t pNonce) {
    UnrollNonceAndPasswordToScratch_Regular(pPassword, pPasswordByteLength, pNonce);
}

void Soccer3::SeedPrelude_Regular_B(std::uint64_t pNonce, MUTABLE_PARAMS) {
    READ_IN_MUTABLE_PARAMS_INTERNAL;
    mStarter.Seed(&mWorkSpaceA, pNonce, SOCCER_SCRATCH_WORKER_A, S_BLOCK, mCollapseLaneB, ARX_STATE_VARS);
    AdvanceSeedProgress(kExpanderSeedCost);
    WRITE_OUT_MUTABLE_PARAMS;
}

void Soccer3::SeedPrelude_Regular_C() {
    TwistShuffle::ShuffleList16(mExpanders,     SOCCER_PRELUDE_RAND,  4096,  8192, 4);
    TwistShuffle::ShuffleList16(mWorkSpaces,    SOCCER_PRELUDE_RAND,  8192, 12288, 4);
    TwistShuffle::ShuffleList16(mMaterials,     SOCCER_PRELUDE_RAND, 12288, 16384, 4);
    
    TwistShuffle::ShuffleList16(mExpanders,     SOCCER_PRELUDE_RAND, 20480, 24576, 4);
    TwistShuffle::ShuffleList16(mWorkSpaces,    SOCCER_PRELUDE_RAND, 24576, 28672, 4);
    TwistShuffle::ShuffleList16(mMaterials,     SOCCER_PRELUDE_RAND, 28672, 32768, 4);
}

void Soccer3::SeedEpilogue_Regular_A() {
    const std::uint8_t *aShrinkSourceA = nullptr;
    const std::uint8_t *aShrinkSourceB = nullptr;
    const std::uint8_t *aShrinkSourceC = nullptr;
    const std::uint8_t *aShrinkSourceD = nullptr;
    
    if (mStrength == EncryptionStrength::kWeak) {
        aShrinkSourceA = mMaterials[0];
        aShrinkSourceB = mMaterials[1];
        aShrinkSourceC = mMaterials[2];
        aShrinkSourceD = mMaterials[3];
    } else if (mStrength == EncryptionStrength::kStrong) {
        SoccerFolding::Collapse_Stage3_Outer_16(mMaterials[0], mMaterials[1], mMaterials[2], mMaterials[3],
                                                mMaterials[4], mMaterials[5], mMaterials[6], mMaterials[7],
                                                mMaterials[8], mMaterials[9], mMaterials[10], mMaterials[11],
                                                mMaterials[12], mMaterials[13], mMaterials[14], mMaterials[15],
                                                mCollapseLaneA, mCollapseLaneB, mCollapseLaneC, mCollapseLaneD);
        
        aShrinkSourceA = mCollapseLaneA;
        aShrinkSourceB = mCollapseLaneB;
        aShrinkSourceC = mCollapseLaneC;
        aShrinkSourceD = mCollapseLaneD;
    } else {
        SoccerFolding::Collapse_Stage3_Outer_8(mMaterials[0], mMaterials[1], mMaterials[2], mMaterials[3],
                                               mMaterials[4], mMaterials[5], mMaterials[6], mMaterials[7],
                                               mCollapseLaneA, mCollapseLaneB, mCollapseLaneC, mCollapseLaneD);
        
        aShrinkSourceA = mCollapseLaneA;
        aShrinkSourceB = mCollapseLaneB;
        aShrinkSourceC = mCollapseLaneC;
        aShrinkSourceD = mCollapseLaneD;
    }
    
    SoccerFolding::Collapse_Stage2_4(aShrinkSourceA, aShrinkSourceB, aShrinkSourceC, aShrinkSourceD,
                                     mCondenseLaneA, mCondenseLaneB, mCondenseLaneC, mCondenseLaneD);
    
    // Shrink has consumed the collapse lanes, so alternate back into them.
    SoccerFolding::Collapse_Stage1_4(mCondenseLaneA, mCondenseLaneB, mCondenseLaneC, mCondenseLaneD,
                                     mCollapseLaneA, mCollapseLaneB, mCollapseLaneC, mCollapseLaneD);
    
    // Stage1 supplies material shuffles; free-byte offsets use accumulated words.
    // Keep the Stage0 implementation on disk for historical experiments.
    
}

std::uint64_t Soccer3::ReadShuffleWord(std::size_t pIndex) {
    assert(pIndex < RandomShuffleLayout::kMaterialSourceWords);
    const std::uint8_t *aLanes[] = {mCollapseLaneA, mCollapseLaneB, mCollapseLaneC, mCollapseLaneD};
    return TwistMix64::DiffuseA(Load64LE(aLanes[pIndex / RandomShuffleLayout::kMaterialWordsPerLane] +
                                       (pIndex % RandomShuffleLayout::kMaterialWordsPerLane) * 8U));
}


void Soccer3::SelectEightRotations(const std::uint16_t *pRotationList,
                                  std::size_t pAvailable,
                                  std::uint16_t (&pChosenRotations)[kRotationsPerList],
                                  const std::uint64_t *pOffsetWords) {
    constexpr std::uint32_t kWindowMask = kRotationWindowCount - 1U;
    constexpr std::uint32_t kByteMask = SOCCER_BLOCK_SIZE - 1U;
    static_assert(kRotationWindowCount * kRotationWindowBytes == SOCCER_BLOCK_SIZE);
    static_assert(kRotationsPerList == 8U);
    // Before choice eight, each subset-difference map bans at most 3^7 values.
    // Even counting both maps and every shared exclusion from all active
    // lists, numeric fallback has candidates left. It never relaxes the rules.
    static_assert(2U * 2187U + 3U * kRotationsPerList * kRotationListCount + 2U < kRotationWindowCount);

    std::memset(mRotationWindowBlocked, 0, sizeof(mRotationWindowBlocked));
    mRotationWindowSingleBlocked[0U] = true;
    mRotationWindowSingleBlocked[kRotationWindowCount / 2U] = true;
    const std::size_t aAvailable = pRotationList == nullptr ? 0U : std::min(pAvailable, kRotationWindowCount);
    std::size_t aCursor = 0U;
    std::uint32_t aWindowSums[1U << kRotationsPerList] = {};
    std::uint32_t aByteSums[1U << kRotationsPerList] = {};
    std::size_t aSumCount = 1U;

    for (std::size_t aIndex = 0U; aIndex < kRotationsPerList; ++aIndex) {
        const std::uint32_t aOffset = pOffsetWords == nullptr ? 0U :
            ShiftMaskedByteOffset(pOffsetWords[aIndex]);
        std::size_t aDefaultWindow = 1U;
        for (;;) {
            std::uint32_t aWindow;
            if (pRotationList != nullptr && aCursor < kRotationWindowCount) {
                const std::size_t aPosition = aCursor++;
                if (aPosition < aAvailable) {
                    aWindow = pRotationList[aPosition];
                } else {
                    // Read the unused tail backwards; no position is read twice.
                    aWindow = pRotationList[kRotationWindowCount - 1U - (aPosition - aAvailable)];
                    ++mRotationFallbackCandidatesRead;
                }
                ++mRotationCandidatesRead;
                if (aWindow >= kRotationWindowCount) continue;
            } else {
                // A missing or malformed base still produces eight valid windows.
                // For the active seed selections, the bound above guarantees
                // completion before this numeric scan can wrap.
                if (aDefaultWindow == kRotationWindowCount) aDefaultWindow = 1U;
                aWindow = static_cast<std::uint32_t>(aDefaultWindow++);
                ++mRotationFallbackCandidatesRead;
            }
            if (mRotationWindowSingleBlocked[aWindow] || mRotationWindowBlocked[aWindow]) continue;
            const std::uint32_t aByte = kRotationWindowBytes * aWindow + aOffset;
            bool aByteCollision = false;
            if (pOffsetWords != nullptr) {
                for (std::size_t aNew = 0U; aNew < aSumCount && !aByteCollision; ++aNew) {
                    const std::uint32_t aSum = (aByteSums[aNew] + aByte) & kByteMask;
                    for (std::size_t aOld = 0U; aOld < aSumCount; ++aOld) {
                        if (aSum == aByteSums[aOld]) {
                            aByteCollision = true;
                            break;
                        }
                    }
                }
            }
            if (aByteCollision) continue;

            // Block both signs of every new difference of subset sums. This
            // prevents duplicate sums as well as sums that cancel to zero.
            for (std::size_t aNew = 0U; aNew < aSumCount; ++aNew) {
                const std::uint32_t aSum = (aWindowSums[aNew] + aWindow) & kWindowMask;
                aWindowSums[aSumCount + aNew] = aSum;
                aByteSums[aSumCount + aNew] = (aByteSums[aNew] + aByte) & kByteMask;
                for (std::size_t aOld = 0U; aOld < aSumCount; ++aOld) {
                    const std::uint32_t aDifference = (aSum - aWindowSums[aOld]) & kWindowMask;
                    mRotationWindowBlocked[aDifference] = true;
                    mRotationWindowBlocked[(0U - aDifference) & kWindowMask] = true;
                }
            }
            aSumCount *= 2U;
            mRotationWindowSingleBlocked[aWindow] = true;
            mRotationWindowSingleBlocked[(0U - aWindow) & kWindowMask] = true;
            // Inverting a byte shift with a nonzero offset borrows one window.
            if (pOffsetWords != nullptr)
                mRotationWindowSingleBlocked[((0U - aByte) & kByteMask) / kRotationWindowBytes] = true;
            pChosenRotations[aIndex] = static_cast<std::uint16_t>(aWindow);
            break;
        }
    }
}

bool Soccer3::SeedEpilogue_Regular_C() {
    BitPlaneFarm::Select(mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC, &mBitPlane);
    
    if (mRandomShuffleGeneration != RandomShuffleLayout::kGenerationCount) return false;
    
    // Window selection also checks actual masked-shift sums with these offsets.
    // Stage D uses the identical conversion when publishing the cipher inputs.
    const std::uint64_t aShiftMaskedWordsA[kRotationsPerList] = {
        mShiftMaskedRotationWordAALeft, mShiftMaskedRotationWordABLeft,
        mShiftMaskedRotationWordACLeft, mShiftMaskedRotationWordADLeft,
        mShiftMaskedRotationWordBALeft, mShiftMaskedRotationWordBBLeft,
        mShiftMaskedRotationWordBCLeft, mShiftMaskedRotationWordBDLeft,
    };

    const std::uint64_t aShiftMaskedWordsB[kRotationsPerList] = {
        mShiftMaskedRotationWordAARight,
        mShiftMaskedRotationWordABRight,
        mShiftMaskedRotationWordACRight,
        mShiftMaskedRotationWordADRight,
        mShiftMaskedRotationWordBARight,
        mShiftMaskedRotationWordBBRight,
        mShiftMaskedRotationWordBCRight,
        mShiftMaskedRotationWordBDRight,
    };

    SelectEightRotations(mShiftMaskedRotationListBaseA, mShiftMaskedRotationListAvailableA, mShiftMaskedRotationListChosenA, aShiftMaskedWordsA);
    SelectEightRotations(mShiftMaskedRotationListBaseB, mShiftMaskedRotationListAvailableB, mShiftMaskedRotationListChosenB, aShiftMaskedWordsB);
    SelectEightRotations(mFlameToadRotationListBaseAALeft, mFlameToadRotationListAvailableAALeft, mFlameToadRotationListChosenAALeft);
    SelectEightRotations(mFlameToadRotationListBaseAARight, mFlameToadRotationListAvailableAARight, mFlameToadRotationListChosenAARight);
    SelectEightRotations(mFlameToadRotationListBaseABLeft, mFlameToadRotationListAvailableABLeft, mFlameToadRotationListChosenABLeft);
    SelectEightRotations(mFlameToadRotationListBaseABRight, mFlameToadRotationListAvailableABRight, mFlameToadRotationListChosenABRight);
    SelectEightRotations(mFlameToadRotationListBaseACLeft, mFlameToadRotationListAvailableACLeft, mFlameToadRotationListChosenACLeft);
    SelectEightRotations(mFlameToadRotationListBaseACRight, mFlameToadRotationListAvailableACRight, mFlameToadRotationListChosenACRight);
    SelectEightRotations(mFlameToadRotationListBaseADLeft, mFlameToadRotationListAvailableADLeft, mFlameToadRotationListChosenADLeft);
    SelectEightRotations(mFlameToadRotationListBaseADRight, mFlameToadRotationListAvailableADRight, mFlameToadRotationListChosenADRight);
    
    SelectEightRotations(mFlameToadRotationListBaseBALeft, mFlameToadRotationListAvailableBALeft, mFlameToadRotationListChosenBALeft);
    SelectEightRotations(mFlameToadRotationListBaseBARight, mFlameToadRotationListAvailableBARight, mFlameToadRotationListChosenBARight);
    SelectEightRotations(mFlameToadRotationListBaseBBLeft, mFlameToadRotationListAvailableBBLeft, mFlameToadRotationListChosenBBLeft);
    SelectEightRotations(mFlameToadRotationListBaseBBRight, mFlameToadRotationListAvailableBBRight, mFlameToadRotationListChosenBBRight);
    SelectEightRotations(mFlameToadRotationListBaseBCLeft, mFlameToadRotationListAvailableBCLeft, mFlameToadRotationListChosenBCLeft);
    SelectEightRotations(mFlameToadRotationListBaseBCRight, mFlameToadRotationListAvailableBCRight, mFlameToadRotationListChosenBCRight);
    SelectEightRotations(mFlameToadRotationListBaseBDLeft, mFlameToadRotationListAvailableBDLeft, mFlameToadRotationListChosenBDLeft);
    SelectEightRotations(mFlameToadRotationListBaseBDRight, mFlameToadRotationListAvailableBDRight, mFlameToadRotationListChosenBDRight);
    
    std::size_t aMaterialCount = 8U;
    if (mStrength == EncryptionStrength::kWeak) { aMaterialCount = 4U; }
    if (mStrength == EncryptionStrength::kStrong) { aMaterialCount = 16U; }
    
    const auto aMaterialIndexMask = aMaterialCount - 1U;
    for (std::size_t i = RandomShuffleLayout::kMaterialShuffleBegin; i < RandomShuffleLayout::kMaterialShuffleEnd; ++i) {
        const auto aWord = ReadShuffleWord(i);
        std::swap(mMaterials[static_cast<std::uint32_t>(aWord) & aMaterialIndexMask],
                  mMaterials[static_cast<std::uint32_t>(aWord >> 32U) & aMaterialIndexMask]);
    }
    const std::size_t aReverseCount = aMaterialCount / 2U;
    bool aReverseMaterial[16] = {};
    for (std::size_t i = 0U; i < aReverseCount; ++i) {
        aReverseMaterial[ReadShuffleWord(RandomShuffleLayout::kMaterialReverseBegin + i) & aMaterialIndexMask] = true;
    }
    for (std::size_t i = 0U; i < aMaterialCount; ++i) {
        if (aReverseMaterial[i]) { std::reverse(mMaterials[i], mMaterials[i] + SOCCER_BLOCK_SIZE); }
    }

    return true;
}

void Soccer3::Shuffle_MEWBlockZero(std::uint8_t *pMaterial) {
    
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        mShuffleMaterials[aIndex] = mMaterials[aIndex];
    }
    for (std::size_t aIndex=0; aIndex<SOCCER_EXPANDER_COUNT; aIndex++) {
        mShuffleExpanders[aIndex] = mExpanders[aIndex];
    }
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        mShuffleWorkSpaces[aIndex] = mWorkSpaces[aIndex];
    }
    
    TwistShuffle::ShuffleList16(mShuffleMaterials,  pMaterial,     0U,  3600U, 1U);
    TwistShuffle::ShuffleList16(mShuffleExpanders,  pMaterial,  3600U,  7200U, 1U);
    TwistShuffle::ShuffleList16(mShuffleWorkSpaces, pMaterial,  7200U, 10800U, 1U);

    TwistShuffle::ShuffleList16(mShuffleMaterials,  pMaterial, 10800U, 14400U, 1U);
    TwistShuffle::ShuffleList16(mShuffleExpanders,  pMaterial, 14400U, 18000U, 1U);
    TwistShuffle::ShuffleList16(mShuffleWorkSpaces, pMaterial, 18000U, 21600U, 1U);

    TwistShuffle::ShuffleList16(mShuffleMaterials,  pMaterial, 21600U, 25200U, 1U);
    TwistShuffle::ShuffleList16(mShuffleExpanders,  pMaterial, 25200U, 28800U, 1U);
    TwistShuffle::ShuffleList16(mShuffleWorkSpaces, pMaterial, 28800U, 32400U, 1U);

    // Move claimed materials to the back.
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        mClaimed[aIndex] = false;
        for (std::size_t aClaimedIndex=0; aClaimedIndex<mClaimedMaterialCount; aClaimedIndex++) {
            if (mShuffleMaterials[aIndex] == mClaimedMaterials[aClaimedIndex]) {
                mClaimed[aIndex] = true;
                break;
            }
        }
    }

    TwistShuffle::MoveClaimedToEnd16(mClaimed, mShuffleMaterials);

    // Move claimed expanders to the back.
    for (std::size_t aIndex=0; aIndex<SOCCER_EXPANDER_COUNT; aIndex++) {
        mClaimed[aIndex] = false;
        for (std::size_t aClaimedIndex=0; aClaimedIndex<mClaimedExpanderCount; aClaimedIndex++) {
            if (mShuffleExpanders[aIndex] == mClaimedExpanders[aClaimedIndex]) {
                mClaimed[aIndex] = true;
                break;
            }
        }
    }

    TwistShuffle::MoveClaimedToEnd16(mClaimed, mShuffleExpanders);

    // Move claimed work spaces to the back.
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        mClaimed[aIndex] = false;
        for (std::size_t aClaimedIndex=0; aClaimedIndex<mClaimedWorkSpaceCount; aClaimedIndex++) {
            if (mShuffleWorkSpaces[aIndex] == mClaimedWorkSpaces[aClaimedIndex]) {
                mClaimed[aIndex] = true;
                break;
            }
        }
    }

    TwistShuffle::MoveClaimedToEnd16(mClaimed, mShuffleWorkSpaces);

    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        mMaterials[aIndex] = mShuffleMaterials[aIndex];
    }
    for (std::size_t aIndex=0; aIndex<SOCCER_EXPANDER_COUNT; aIndex++) {
        mExpanders[aIndex] = mShuffleExpanders[aIndex];
    }
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        mWorkSpaces[aIndex] = mShuffleWorkSpaces[aIndex];
    }
}
