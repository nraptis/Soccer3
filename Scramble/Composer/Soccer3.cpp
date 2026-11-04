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


std::uint16_t                                   Soccer3::mWindowRotationBase[WindowRotationFarm::kJobCount][WindowRotationFarm::kWindowCount];
std::size_t                                     Soccer3::mWindowRotationAvailable[WindowRotationFarm::kJobCount];
std::size_t                                     Soccer3::mWindowRotationShuffleBytes[WindowRotationFarm::kJobCount];
std::size_t                                     Soccer3::mRandomShuffleGeneration = 0U;
WindowRotationFarm::Buffers                     Soccer3::mWindowRotationFarmBuffers{};
WindowRotationFarm::Statistics                  Soccer3::mWindowRotationFarmStatistics[WindowRotationFarm::kJobCount]{};

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
    mFreeRotationWordA = 0U;
    mFreeRotationWordB = 0U;
    mFreeRotationWordC = 0U;
    mFreeRotationWordD = 0U;
    mFreeRotationWordE = 0U;
    mFreeRotationWordF = 0U;
    mFreeRotationWordG = 0U;
    mFreeRotationWordH = 0U;
    mFreeRotationWordI = 0U;
    mFreeRotationWordJ = 0U;
    mFreeRotationWordK = 0U;
    mFreeRotationWordL = 0U;
    mFreeRotationWordM = 0U;
    mFreeRotationWordN = 0U;
    mFreeRotationWordO = 0U;
    mFreeRotationWordP = 0U;
    mBitPlane = {};
    mShiftMaskedCipherRotationAA = 0;
    mShiftMaskedCipherRotationAB = 0;
    mShiftMaskedCipherRotationAC = 0;
    mShiftMaskedCipherRotationAD = 0;
    mShiftMaskedCipherRotationAE = 0;
    mShiftMaskedCipherRotationAF = 0;
    mShiftMaskedCipherRotationAG = 0;
    mShiftMaskedCipherRotationAH = 0;
    mShiftMaskedCipherRotationBA = 0;
    mShiftMaskedCipherRotationBB = 0;
    mShiftMaskedCipherRotationBC = 0;
    mShiftMaskedCipherRotationBD = 0;
    mShiftMaskedCipherRotationBE = 0;
    mShiftMaskedCipherRotationBF = 0;
    mShiftMaskedCipherRotationBG = 0;
    mShiftMaskedCipherRotationBH = 0;

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
    mRotationMaskA = 0U;
    mRotationMaskB = 0U;
    mRotationMaskC = 0U;
    mRotationMaskD = 0U;
    mRotationMaskE = 0U;
    mRotationMaskF = 0U;
    mRotationMaskG = 0U;
    mRotationMaskH = 0U;
    mFlameToadCipherRotationAAA = 0U;
    mFlameToadCipherRotationAAB = 0U;
    mFlameToadCipherRotationAAC = 0U;
    mFlameToadCipherRotationAAD = 0U;
    mFlameToadCipherRotationAAE = 0U;
    mFlameToadCipherRotationAAF = 0U;
    mFlameToadCipherRotationAAG = 0U;
    mFlameToadCipherRotationAAH = 0U;
    mFlameToadCipherRotationAAI = 0U;
    mFlameToadCipherRotationAAJ = 0U;
    mFlameToadCipherRotationAAK = 0U;
    mFlameToadCipherRotationAAL = 0U;
    mFlameToadCipherRotationAAM = 0U;
    mFlameToadCipherRotationAAN = 0U;
    mFlameToadCipherRotationAAO = 0U;
    mFlameToadCipherRotationAAP = 0U;
    mFlameToadCipherRotationABA = 0U;
    mFlameToadCipherRotationABB = 0U;
    mFlameToadCipherRotationABC = 0U;
    mFlameToadCipherRotationABD = 0U;
    mFlameToadCipherRotationABE = 0U;
    mFlameToadCipherRotationABF = 0U;
    mFlameToadCipherRotationABG = 0U;
    mFlameToadCipherRotationABH = 0U;
    mFlameToadCipherRotationABI = 0U;
    mFlameToadCipherRotationABJ = 0U;
    mFlameToadCipherRotationABK = 0U;
    mFlameToadCipherRotationABL = 0U;
    mFlameToadCipherRotationABM = 0U;
    mFlameToadCipherRotationABN = 0U;
    mFlameToadCipherRotationABO = 0U;
    mFlameToadCipherRotationABP = 0U;
    mFlameToadCipherRotationACA = 0U;
    mFlameToadCipherRotationACB = 0U;
    mFlameToadCipherRotationACC = 0U;
    mFlameToadCipherRotationACD = 0U;
    mFlameToadCipherRotationACE = 0U;
    mFlameToadCipherRotationACF = 0U;
    mFlameToadCipherRotationACG = 0U;
    mFlameToadCipherRotationACH = 0U;
    mFlameToadCipherRotationACI = 0U;
    mFlameToadCipherRotationACJ = 0U;
    mFlameToadCipherRotationACK = 0U;
    mFlameToadCipherRotationACL = 0U;
    mFlameToadCipherRotationACM = 0U;
    mFlameToadCipherRotationACN = 0U;
    mFlameToadCipherRotationACO = 0U;
    mFlameToadCipherRotationACP = 0U;
    mFlameToadCipherRotationADA = 0U;
    mFlameToadCipherRotationADB = 0U;
    mFlameToadCipherRotationADC = 0U;
    mFlameToadCipherRotationADD = 0U;
    mFlameToadCipherRotationADE = 0U;
    mFlameToadCipherRotationADF = 0U;
    mFlameToadCipherRotationADG = 0U;
    mFlameToadCipherRotationADH = 0U;
    mFlameToadCipherRotationADI = 0U;
    mFlameToadCipherRotationADJ = 0U;
    mFlameToadCipherRotationADK = 0U;
    mFlameToadCipherRotationADL = 0U;
    mFlameToadCipherRotationADM = 0U;
    mFlameToadCipherRotationADN = 0U;
    mFlameToadCipherRotationADO = 0U;
    mFlameToadCipherRotationADP = 0U;
    mFlameToadCipherRotationBAA = 0U;
    mFlameToadCipherRotationBAB = 0U;
    mFlameToadCipherRotationBAC = 0U;
    mFlameToadCipherRotationBAD = 0U;
    mFlameToadCipherRotationBAE = 0U;
    mFlameToadCipherRotationBAF = 0U;
    mFlameToadCipherRotationBAG = 0U;
    mFlameToadCipherRotationBAH = 0U;
    mFlameToadCipherRotationBAI = 0U;
    mFlameToadCipherRotationBAJ = 0U;
    mFlameToadCipherRotationBAK = 0U;
    mFlameToadCipherRotationBAL = 0U;
    mFlameToadCipherRotationBAM = 0U;
    mFlameToadCipherRotationBAN = 0U;
    mFlameToadCipherRotationBAO = 0U;
    mFlameToadCipherRotationBAP = 0U;
    mFlameToadCipherRotationBBA = 0U;
    mFlameToadCipherRotationBBB = 0U;
    mFlameToadCipherRotationBBC = 0U;
    mFlameToadCipherRotationBBD = 0U;
    mFlameToadCipherRotationBBE = 0U;
    mFlameToadCipherRotationBBF = 0U;
    mFlameToadCipherRotationBBG = 0U;
    mFlameToadCipherRotationBBH = 0U;
    mFlameToadCipherRotationBBI = 0U;
    mFlameToadCipherRotationBBJ = 0U;
    mFlameToadCipherRotationBBK = 0U;
    mFlameToadCipherRotationBBL = 0U;
    mFlameToadCipherRotationBBM = 0U;
    mFlameToadCipherRotationBBN = 0U;
    mFlameToadCipherRotationBBO = 0U;
    mFlameToadCipherRotationBBP = 0U;
    mFlameToadCipherRotationBCA = 0U;
    mFlameToadCipherRotationBCB = 0U;
    mFlameToadCipherRotationBCC = 0U;
    mFlameToadCipherRotationBCD = 0U;
    mFlameToadCipherRotationBCE = 0U;
    mFlameToadCipherRotationBCF = 0U;
    mFlameToadCipherRotationBCG = 0U;
    mFlameToadCipherRotationBCH = 0U;
    mFlameToadCipherRotationBCI = 0U;
    mFlameToadCipherRotationBCJ = 0U;
    mFlameToadCipherRotationBCK = 0U;
    mFlameToadCipherRotationBCL = 0U;
    mFlameToadCipherRotationBCM = 0U;
    mFlameToadCipherRotationBCN = 0U;
    mFlameToadCipherRotationBCO = 0U;
    mFlameToadCipherRotationBCP = 0U;
    mFlameToadCipherRotationBDA = 0U;
    mFlameToadCipherRotationBDB = 0U;
    mFlameToadCipherRotationBDC = 0U;
    mFlameToadCipherRotationBDD = 0U;
    mFlameToadCipherRotationBDE = 0U;
    mFlameToadCipherRotationBDF = 0U;
    mFlameToadCipherRotationBDG = 0U;
    mFlameToadCipherRotationBDH = 0U;
    mFlameToadCipherRotationBDI = 0U;
    mFlameToadCipherRotationBDJ = 0U;
    mFlameToadCipherRotationBDK = 0U;
    mFlameToadCipherRotationBDL = 0U;
    mFlameToadCipherRotationBDM = 0U;
    mFlameToadCipherRotationBDN = 0U;
    mFlameToadCipherRotationBDO = 0U;
    mFlameToadCipherRotationBDP = 0U;
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

    mWindowRotationPack = {};
    mWindowRotationFarmBuffers = {};
    std::memset(mWindowRotationFarmStatistics, 0, sizeof(mWindowRotationFarmStatistics));

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
    for (auto &aList : mWindowRotationBase)
        for (std::size_t aIndex = 0U; aIndex < WindowRotationFarm::kWindowCount; ++aIndex)
            aList[aIndex] = static_cast<std::uint16_t>(aIndex);
    std::memset(mWindowRotationAvailable, 0, sizeof(mWindowRotationAvailable));
    std::memset(mWindowRotationShuffleBytes, 0, sizeof(mWindowRotationShuffleBytes));
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


void Soccer3::ShuffleCROWUnit(std::uint16_t (&pRotationList)[WindowRotationFarm::kWindowCount],
                            std::uint64_t &pBitPlaneWordA,
                            std::uint64_t &pBitPlaneWordB,
                            std::uint64_t &pBitPlaneWordC,
                            std::size_t pRotationIndex,
                            std::size_t pOffset) {
    const std::size_t aLaneCount = mStrength == EncryptionStrength::kWeak ? 4U :
                                  mStrength == EncryptionStrength::kStrong ? 16U : 8U;
    // Each accumulator gets a distinct 64-bit word from EVERY unit.
    mFreeRotationWordA += Load64LE(mRandom + pOffset + 0U);
    mFreeRotationWordB += Load64LE(mRandom + pOffset + 8U);
    mFreeRotationWordC += Load64LE(mRandom + pOffset + 16U);
    mFreeRotationWordD += Load64LE(mRandom + pOffset + 24U);
    mFreeRotationWordE += Load64LE(mRandom + pOffset + 32U);
    mFreeRotationWordF += Load64LE(mRandom + pOffset + 40U);
    mFreeRotationWordG += Load64LE(mRandom + pOffset + 48U);
    mFreeRotationWordH += Load64LE(mRandom + pOffset + 56U);
    mFreeRotationWordI += Load64LE(mRandom + pOffset + 64U);
    mFreeRotationWordJ += Load64LE(mRandom + pOffset + 72U);
    mFreeRotationWordK += Load64LE(mRandom + pOffset + 80U);
    mFreeRotationWordL += Load64LE(mRandom + pOffset + 88U);
    mFreeRotationWordM += Load64LE(mRandom + pOffset + 96U);
    mFreeRotationWordN += Load64LE(mRandom + pOffset + 104U);
    mFreeRotationWordO += Load64LE(mRandom + pOffset + 112U);
    mFreeRotationWordP += Load64LE(mRandom + pOffset + 120U);
    pBitPlaneWordA += Load64LE(mRandom + pOffset + RandomShuffleLayout::kFreeRotationBytes);
    pBitPlaneWordB += Load64LE(mRandom + pOffset + RandomShuffleLayout::kFreeRotationBytes + 8U);
    pBitPlaneWordC += Load64LE(mRandom + pOffset + RandomShuffleLayout::kFreeRotationBytes + 16U);

    // One forward pass per list per generation, bounded by this unit's budget.
    // The farmer prefers its completed prefix, then falls back to the remaining tail.
    if (mRandomShuffleGeneration < RandomShuffleLayout::kGenerationCount) {
        std::size_t aRead = 0U;
        TwistShuffle::ShuffleList16384(pRotationList, mRandom + RandomShuffleLayout::RotationBegin(pOffset),
            RandomShuffleLayout::RotationBytesPerList(aLaneCount), aRead, false,
            &mWindowRotationAvailable[pRotationIndex]);
        mWindowRotationShuffleBytes[pRotationIndex] += aRead;
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
    static_assert(RandomShuffleLayout::kUnitCount == WindowRotationFarm::kJobCount);
    for (std::size_t aUnit = 0U; aUnit < RandomShuffleLayout::kUnitCount; ++aUnit) {
        ShuffleCROWUnit(mWindowRotationBase[aUnit], mBitPlaneWordA, mBitPlaneWordB,
                        mBitPlaneWordC, aUnit, RandomShuffleLayout::UnitBegin(aUnit));
    }
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


bool Soccer3::SeedEpilogue_Regular_C() {
    BitPlaneFarm::Select(mBitPlaneWordA, mBitPlaneWordB, mBitPlaneWordC, &mBitPlane);

    // Farm windows using the completed offset-word sums so the farmer can
    // reject collisions in the final byte sums, including carries.
    const std::uint64_t aFreeRotationWords[2][WindowRotationFarm::kRotationsPerJob] = {
        {mFreeRotationWordA, mFreeRotationWordB, mFreeRotationWordC, mFreeRotationWordD,
         mFreeRotationWordE, mFreeRotationWordF, mFreeRotationWordG, mFreeRotationWordH},
        {mFreeRotationWordI, mFreeRotationWordJ, mFreeRotationWordK, mFreeRotationWordL,
         mFreeRotationWordM, mFreeRotationWordN, mFreeRotationWordO, mFreeRotationWordP}
    };
    WindowRotationFarm::PreparedSource aSources[WindowRotationFarm::kJobCount];
    for (std::size_t aJob = 0U; aJob < WindowRotationFarm::kJobCount; ++aJob) {
        const bool aFree = aJob % WindowRotationFarm::kJobsPerPlane == 0U;
        aSources[aJob] = {
            mWindowRotationBase[aJob], mWindowRotationAvailable[aJob], false,
            aFree ? aFreeRotationWords[aJob / WindowRotationFarm::kJobsPerPlane] : nullptr,
            mWindowRotationShuffleBytes[aJob]
        };
    }
    if (mRandomShuffleGeneration != RandomShuffleLayout::kGenerationCount) return false;
    WindowRotationFarm::FarmPreparedPack(aSources, mWindowRotationFarmBuffers,
                                         mWindowRotationPack, mWindowRotationFarmStatistics);

    // Each pack member remains a window index. Only these named Cryptex inputs
    // store byte shifts. Rebuild locally and publish only after full validation.
    const WindowRotationPackChunk *aChunks[] = {
        &mWindowRotationPack.mPlaneA.mChunkA,
        &mWindowRotationPack.mPlaneA.mChunkB,
        &mWindowRotationPack.mPlaneA.mChunkC,
        &mWindowRotationPack.mPlaneA.mChunkD,
        &mWindowRotationPack.mPlaneB.mChunkA,
        &mWindowRotationPack.mPlaneB.mChunkB,
        &mWindowRotationPack.mPlaneB.mChunkC,
        &mWindowRotationPack.mPlaneB.mChunkD,
    };
    const std::uint64_t aWords[] = {
        mFreeRotationWordA, mFreeRotationWordB, mFreeRotationWordC, mFreeRotationWordD,
        mFreeRotationWordE, mFreeRotationWordF, mFreeRotationWordG, mFreeRotationWordH,
        mFreeRotationWordI, mFreeRotationWordJ, mFreeRotationWordK, mFreeRotationWordL,
        mFreeRotationWordM, mFreeRotationWordN, mFreeRotationWordO, mFreeRotationWordP
    };
    std::int32_t *aDestinations[] = {
        &mShiftMaskedCipherRotationAA, &mShiftMaskedCipherRotationAB, &mShiftMaskedCipherRotationAC, &mShiftMaskedCipherRotationAD,
        &mShiftMaskedCipherRotationAE, &mShiftMaskedCipherRotationAF, &mShiftMaskedCipherRotationAG, &mShiftMaskedCipherRotationAH,
        &mShiftMaskedCipherRotationBA, &mShiftMaskedCipherRotationBB, &mShiftMaskedCipherRotationBC, &mShiftMaskedCipherRotationBD,
        &mShiftMaskedCipherRotationBE, &mShiftMaskedCipherRotationBF, &mShiftMaskedCipherRotationBG, &mShiftMaskedCipherRotationBH
    };
    std::int32_t aRotations[WindowRotationFarm::kFreeRotationCount]{};
    for (std::size_t aLayer = 0U; aLayer < 8U; ++aLayer) {
        const auto &aChunk = *aChunks[aLayer];
        const auto aFirst = 2U * aLayer;
        aRotations[aFirst] = 64U * aChunk.mWindowFreeA +
            WindowRotationFarm::FreeByteOffset(aWords[aFirst], false);
        aRotations[aFirst + 1U] = 64U * aChunk.mWindowFreeB +
            WindowRotationFarm::FreeByteOffset(aWords[aFirst + 1U], (aRotations[aFirst] & 1) == 0);
    }
    if (!WindowRotationFarm::IsValid(mWindowRotationPack, aRotations)) return false;
    for (std::size_t aIndex = 0U; aIndex < WindowRotationFarm::kFreeRotationCount; ++aIndex)
        *aDestinations[aIndex] = aRotations[aIndex];

    const std::size_t aMaterialCount = mStrength == EncryptionStrength::kWeak ? 4U :
                                     mStrength == EncryptionStrength::kStrong ? 16U : 8U;
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

bool Soccer3::SeedEpilogue_Regular_D() {
    if (!mBitPlane.IsValid()) return false;
    const auto aRowA = mBitPlane.GetRow(0U);
    mBitRowAA = aRowA.mPairs[0U].mBitA;
    mBitRowAB = aRowA.mPairs[0U].mBitB;
    mBitRowAC = aRowA.mPairs[1U].mBitA;
    mBitRowAD = aRowA.mPairs[1U].mBitB;
    mBitRowAE = aRowA.mPairs[2U].mBitA;
    mBitRowAF = aRowA.mPairs[2U].mBitB;
    mBitRowAG = aRowA.mPairs[3U].mBitA;
    mBitRowAH = aRowA.mPairs[3U].mBitB;
    const auto aRowB = mBitPlane.GetRow(1U);
    mBitRowBA = aRowB.mPairs[0U].mBitA;
    mBitRowBB = aRowB.mPairs[0U].mBitB;
    mBitRowBC = aRowB.mPairs[1U].mBitA;
    mBitRowBD = aRowB.mPairs[1U].mBitB;
    mBitRowBE = aRowB.mPairs[2U].mBitA;
    mBitRowBF = aRowB.mPairs[2U].mBitB;
    mBitRowBG = aRowB.mPairs[3U].mBitA;
    mBitRowBH = aRowB.mPairs[3U].mBitB;
    const auto aRowC = mBitPlane.GetRow(2U);
    mBitRowCA = aRowC.mPairs[0U].mBitA;
    mBitRowCB = aRowC.mPairs[0U].mBitB;
    mBitRowCC = aRowC.mPairs[1U].mBitA;
    mBitRowCD = aRowC.mPairs[1U].mBitB;
    mBitRowCE = aRowC.mPairs[2U].mBitA;
    mBitRowCF = aRowC.mPairs[2U].mBitB;
    mBitRowCG = aRowC.mPairs[3U].mBitA;
    mBitRowCH = aRowC.mPairs[3U].mBitB;
    const auto aRowD = mBitPlane.GetRow(3U);
    mBitRowDA = aRowD.mPairs[0U].mBitA;
    mBitRowDB = aRowD.mPairs[0U].mBitB;
    mBitRowDC = aRowD.mPairs[1U].mBitA;
    mBitRowDD = aRowD.mPairs[1U].mBitB;
    mBitRowDE = aRowD.mPairs[2U].mBitA;
    mBitRowDF = aRowD.mPairs[2U].mBitB;
    mBitRowDG = aRowD.mPairs[3U].mBitA;
    mBitRowDH = aRowD.mPairs[3U].mBitB;
    mRotationMaskA = static_cast<std::uint8_t>((1U << mBitRowAA) | (1U << mBitRowAC) | (1U << mBitRowAE) | (1U << mBitRowAG));
    mRotationMaskB = static_cast<std::uint8_t>((1U << mBitRowAB) | (1U << mBitRowAD) | (1U << mBitRowAF) | (1U << mBitRowAH));
    mFlameToadCipherRotationAAA = mWindowRotationPack.mPlaneA.mChunkA.mWindowA;
    mFlameToadCipherRotationAAB = mWindowRotationPack.mPlaneA.mChunkA.mWindowB;
    mFlameToadCipherRotationAAC = mWindowRotationPack.mPlaneA.mChunkA.mWindowC;
    mFlameToadCipherRotationAAD = mWindowRotationPack.mPlaneA.mChunkA.mWindowD;
    mFlameToadCipherRotationAAE = mWindowRotationPack.mPlaneA.mChunkA.mWindowE;
    mFlameToadCipherRotationAAF = mWindowRotationPack.mPlaneA.mChunkA.mWindowF;
    mFlameToadCipherRotationAAG = mWindowRotationPack.mPlaneA.mChunkA.mWindowG;
    mFlameToadCipherRotationAAH = mWindowRotationPack.mPlaneA.mChunkA.mWindowH;
    mFlameToadCipherRotationAAI = mWindowRotationPack.mPlaneA.mChunkA.mWindowI;
    mFlameToadCipherRotationAAJ = mWindowRotationPack.mPlaneA.mChunkA.mWindowJ;
    mFlameToadCipherRotationAAK = mWindowRotationPack.mPlaneA.mChunkA.mWindowK;
    mFlameToadCipherRotationAAL = mWindowRotationPack.mPlaneA.mChunkA.mWindowL;
    mFlameToadCipherRotationAAM = mWindowRotationPack.mPlaneA.mChunkA.mWindowM;
    mFlameToadCipherRotationAAN = mWindowRotationPack.mPlaneA.mChunkA.mWindowN;
    mFlameToadCipherRotationAAO = mWindowRotationPack.mPlaneA.mChunkA.mWindowO;
    mFlameToadCipherRotationAAP = mWindowRotationPack.mPlaneA.mChunkA.mWindowP;
    mRotationMaskC = static_cast<std::uint8_t>((1U << mBitRowBA) | (1U << mBitRowBC) | (1U << mBitRowBE) | (1U << mBitRowBG));
    mRotationMaskD = static_cast<std::uint8_t>((1U << mBitRowBB) | (1U << mBitRowBD) | (1U << mBitRowBF) | (1U << mBitRowBH));
    mFlameToadCipherRotationABA = mWindowRotationPack.mPlaneA.mChunkB.mWindowA;
    mFlameToadCipherRotationABB = mWindowRotationPack.mPlaneA.mChunkB.mWindowB;
    mFlameToadCipherRotationABC = mWindowRotationPack.mPlaneA.mChunkB.mWindowC;
    mFlameToadCipherRotationABD = mWindowRotationPack.mPlaneA.mChunkB.mWindowD;
    mFlameToadCipherRotationABE = mWindowRotationPack.mPlaneA.mChunkB.mWindowE;
    mFlameToadCipherRotationABF = mWindowRotationPack.mPlaneA.mChunkB.mWindowF;
    mFlameToadCipherRotationABG = mWindowRotationPack.mPlaneA.mChunkB.mWindowG;
    mFlameToadCipherRotationABH = mWindowRotationPack.mPlaneA.mChunkB.mWindowH;
    mFlameToadCipherRotationABI = mWindowRotationPack.mPlaneA.mChunkB.mWindowI;
    mFlameToadCipherRotationABJ = mWindowRotationPack.mPlaneA.mChunkB.mWindowJ;
    mFlameToadCipherRotationABK = mWindowRotationPack.mPlaneA.mChunkB.mWindowK;
    mFlameToadCipherRotationABL = mWindowRotationPack.mPlaneA.mChunkB.mWindowL;
    mFlameToadCipherRotationABM = mWindowRotationPack.mPlaneA.mChunkB.mWindowM;
    mFlameToadCipherRotationABN = mWindowRotationPack.mPlaneA.mChunkB.mWindowN;
    mFlameToadCipherRotationABO = mWindowRotationPack.mPlaneA.mChunkB.mWindowO;
    mFlameToadCipherRotationABP = mWindowRotationPack.mPlaneA.mChunkB.mWindowP;
    mRotationMaskE = static_cast<std::uint8_t>((1U << mBitRowCA) | (1U << mBitRowCC) | (1U << mBitRowCE) | (1U << mBitRowCG));
    mRotationMaskF = static_cast<std::uint8_t>((1U << mBitRowCB) | (1U << mBitRowCD) | (1U << mBitRowCF) | (1U << mBitRowCH));
    mFlameToadCipherRotationACA = mWindowRotationPack.mPlaneA.mChunkC.mWindowA;
    mFlameToadCipherRotationACB = mWindowRotationPack.mPlaneA.mChunkC.mWindowB;
    mFlameToadCipherRotationACC = mWindowRotationPack.mPlaneA.mChunkC.mWindowC;
    mFlameToadCipherRotationACD = mWindowRotationPack.mPlaneA.mChunkC.mWindowD;
    mFlameToadCipherRotationACE = mWindowRotationPack.mPlaneA.mChunkC.mWindowE;
    mFlameToadCipherRotationACF = mWindowRotationPack.mPlaneA.mChunkC.mWindowF;
    mFlameToadCipherRotationACG = mWindowRotationPack.mPlaneA.mChunkC.mWindowG;
    mFlameToadCipherRotationACH = mWindowRotationPack.mPlaneA.mChunkC.mWindowH;
    mFlameToadCipherRotationACI = mWindowRotationPack.mPlaneA.mChunkC.mWindowI;
    mFlameToadCipherRotationACJ = mWindowRotationPack.mPlaneA.mChunkC.mWindowJ;
    mFlameToadCipherRotationACK = mWindowRotationPack.mPlaneA.mChunkC.mWindowK;
    mFlameToadCipherRotationACL = mWindowRotationPack.mPlaneA.mChunkC.mWindowL;
    mFlameToadCipherRotationACM = mWindowRotationPack.mPlaneA.mChunkC.mWindowM;
    mFlameToadCipherRotationACN = mWindowRotationPack.mPlaneA.mChunkC.mWindowN;
    mFlameToadCipherRotationACO = mWindowRotationPack.mPlaneA.mChunkC.mWindowO;
    mFlameToadCipherRotationACP = mWindowRotationPack.mPlaneA.mChunkC.mWindowP;
    mRotationMaskG = static_cast<std::uint8_t>((1U << mBitRowDA) | (1U << mBitRowDC) | (1U << mBitRowDE) | (1U << mBitRowDG));
    mRotationMaskH = static_cast<std::uint8_t>((1U << mBitRowDB) | (1U << mBitRowDD) | (1U << mBitRowDF) | (1U << mBitRowDH));
    mFlameToadCipherRotationADA = mWindowRotationPack.mPlaneA.mChunkD.mWindowA;
    mFlameToadCipherRotationADB = mWindowRotationPack.mPlaneA.mChunkD.mWindowB;
    mFlameToadCipherRotationADC = mWindowRotationPack.mPlaneA.mChunkD.mWindowC;
    mFlameToadCipherRotationADD = mWindowRotationPack.mPlaneA.mChunkD.mWindowD;
    mFlameToadCipherRotationADE = mWindowRotationPack.mPlaneA.mChunkD.mWindowE;
    mFlameToadCipherRotationADF = mWindowRotationPack.mPlaneA.mChunkD.mWindowF;
    mFlameToadCipherRotationADG = mWindowRotationPack.mPlaneA.mChunkD.mWindowG;
    mFlameToadCipherRotationADH = mWindowRotationPack.mPlaneA.mChunkD.mWindowH;
    mFlameToadCipherRotationADI = mWindowRotationPack.mPlaneA.mChunkD.mWindowI;
    mFlameToadCipherRotationADJ = mWindowRotationPack.mPlaneA.mChunkD.mWindowJ;
    mFlameToadCipherRotationADK = mWindowRotationPack.mPlaneA.mChunkD.mWindowK;
    mFlameToadCipherRotationADL = mWindowRotationPack.mPlaneA.mChunkD.mWindowL;
    mFlameToadCipherRotationADM = mWindowRotationPack.mPlaneA.mChunkD.mWindowM;
    mFlameToadCipherRotationADN = mWindowRotationPack.mPlaneA.mChunkD.mWindowN;
    mFlameToadCipherRotationADO = mWindowRotationPack.mPlaneA.mChunkD.mWindowO;
    mFlameToadCipherRotationADP = mWindowRotationPack.mPlaneA.mChunkD.mWindowP;
    mFlameToadCipherRotationBAA = mWindowRotationPack.mPlaneB.mChunkA.mWindowA;
    mFlameToadCipherRotationBAB = mWindowRotationPack.mPlaneB.mChunkA.mWindowB;
    mFlameToadCipherRotationBAC = mWindowRotationPack.mPlaneB.mChunkA.mWindowC;
    mFlameToadCipherRotationBAD = mWindowRotationPack.mPlaneB.mChunkA.mWindowD;
    mFlameToadCipherRotationBAE = mWindowRotationPack.mPlaneB.mChunkA.mWindowE;
    mFlameToadCipherRotationBAF = mWindowRotationPack.mPlaneB.mChunkA.mWindowF;
    mFlameToadCipherRotationBAG = mWindowRotationPack.mPlaneB.mChunkA.mWindowG;
    mFlameToadCipherRotationBAH = mWindowRotationPack.mPlaneB.mChunkA.mWindowH;
    mFlameToadCipherRotationBAI = mWindowRotationPack.mPlaneB.mChunkA.mWindowI;
    mFlameToadCipherRotationBAJ = mWindowRotationPack.mPlaneB.mChunkA.mWindowJ;
    mFlameToadCipherRotationBAK = mWindowRotationPack.mPlaneB.mChunkA.mWindowK;
    mFlameToadCipherRotationBAL = mWindowRotationPack.mPlaneB.mChunkA.mWindowL;
    mFlameToadCipherRotationBAM = mWindowRotationPack.mPlaneB.mChunkA.mWindowM;
    mFlameToadCipherRotationBAN = mWindowRotationPack.mPlaneB.mChunkA.mWindowN;
    mFlameToadCipherRotationBAO = mWindowRotationPack.mPlaneB.mChunkA.mWindowO;
    mFlameToadCipherRotationBAP = mWindowRotationPack.mPlaneB.mChunkA.mWindowP;
    mFlameToadCipherRotationBBA = mWindowRotationPack.mPlaneB.mChunkB.mWindowA;
    mFlameToadCipherRotationBBB = mWindowRotationPack.mPlaneB.mChunkB.mWindowB;
    mFlameToadCipherRotationBBC = mWindowRotationPack.mPlaneB.mChunkB.mWindowC;
    mFlameToadCipherRotationBBD = mWindowRotationPack.mPlaneB.mChunkB.mWindowD;
    mFlameToadCipherRotationBBE = mWindowRotationPack.mPlaneB.mChunkB.mWindowE;
    mFlameToadCipherRotationBBF = mWindowRotationPack.mPlaneB.mChunkB.mWindowF;
    mFlameToadCipherRotationBBG = mWindowRotationPack.mPlaneB.mChunkB.mWindowG;
    mFlameToadCipherRotationBBH = mWindowRotationPack.mPlaneB.mChunkB.mWindowH;
    mFlameToadCipherRotationBBI = mWindowRotationPack.mPlaneB.mChunkB.mWindowI;
    mFlameToadCipherRotationBBJ = mWindowRotationPack.mPlaneB.mChunkB.mWindowJ;
    mFlameToadCipherRotationBBK = mWindowRotationPack.mPlaneB.mChunkB.mWindowK;
    mFlameToadCipherRotationBBL = mWindowRotationPack.mPlaneB.mChunkB.mWindowL;
    mFlameToadCipherRotationBBM = mWindowRotationPack.mPlaneB.mChunkB.mWindowM;
    mFlameToadCipherRotationBBN = mWindowRotationPack.mPlaneB.mChunkB.mWindowN;
    mFlameToadCipherRotationBBO = mWindowRotationPack.mPlaneB.mChunkB.mWindowO;
    mFlameToadCipherRotationBBP = mWindowRotationPack.mPlaneB.mChunkB.mWindowP;
    mFlameToadCipherRotationBCA = mWindowRotationPack.mPlaneB.mChunkC.mWindowA;
    mFlameToadCipherRotationBCB = mWindowRotationPack.mPlaneB.mChunkC.mWindowB;
    mFlameToadCipherRotationBCC = mWindowRotationPack.mPlaneB.mChunkC.mWindowC;
    mFlameToadCipherRotationBCD = mWindowRotationPack.mPlaneB.mChunkC.mWindowD;
    mFlameToadCipherRotationBCE = mWindowRotationPack.mPlaneB.mChunkC.mWindowE;
    mFlameToadCipherRotationBCF = mWindowRotationPack.mPlaneB.mChunkC.mWindowF;
    mFlameToadCipherRotationBCG = mWindowRotationPack.mPlaneB.mChunkC.mWindowG;
    mFlameToadCipherRotationBCH = mWindowRotationPack.mPlaneB.mChunkC.mWindowH;
    mFlameToadCipherRotationBCI = mWindowRotationPack.mPlaneB.mChunkC.mWindowI;
    mFlameToadCipherRotationBCJ = mWindowRotationPack.mPlaneB.mChunkC.mWindowJ;
    mFlameToadCipherRotationBCK = mWindowRotationPack.mPlaneB.mChunkC.mWindowK;
    mFlameToadCipherRotationBCL = mWindowRotationPack.mPlaneB.mChunkC.mWindowL;
    mFlameToadCipherRotationBCM = mWindowRotationPack.mPlaneB.mChunkC.mWindowM;
    mFlameToadCipherRotationBCN = mWindowRotationPack.mPlaneB.mChunkC.mWindowN;
    mFlameToadCipherRotationBCO = mWindowRotationPack.mPlaneB.mChunkC.mWindowO;
    mFlameToadCipherRotationBCP = mWindowRotationPack.mPlaneB.mChunkC.mWindowP;
    mFlameToadCipherRotationBDA = mWindowRotationPack.mPlaneB.mChunkD.mWindowA;
    mFlameToadCipherRotationBDB = mWindowRotationPack.mPlaneB.mChunkD.mWindowB;
    mFlameToadCipherRotationBDC = mWindowRotationPack.mPlaneB.mChunkD.mWindowC;
    mFlameToadCipherRotationBDD = mWindowRotationPack.mPlaneB.mChunkD.mWindowD;
    mFlameToadCipherRotationBDE = mWindowRotationPack.mPlaneB.mChunkD.mWindowE;
    mFlameToadCipherRotationBDF = mWindowRotationPack.mPlaneB.mChunkD.mWindowF;
    mFlameToadCipherRotationBDG = mWindowRotationPack.mPlaneB.mChunkD.mWindowG;
    mFlameToadCipherRotationBDH = mWindowRotationPack.mPlaneB.mChunkD.mWindowH;
    mFlameToadCipherRotationBDI = mWindowRotationPack.mPlaneB.mChunkD.mWindowI;
    mFlameToadCipherRotationBDJ = mWindowRotationPack.mPlaneB.mChunkD.mWindowJ;
    mFlameToadCipherRotationBDK = mWindowRotationPack.mPlaneB.mChunkD.mWindowK;
    mFlameToadCipherRotationBDL = mWindowRotationPack.mPlaneB.mChunkD.mWindowL;
    mFlameToadCipherRotationBDM = mWindowRotationPack.mPlaneB.mChunkD.mWindowM;
    mFlameToadCipherRotationBDN = mWindowRotationPack.mPlaneB.mChunkD.mWindowN;
    mFlameToadCipherRotationBDO = mWindowRotationPack.mPlaneB.mChunkD.mWindowO;
    mFlameToadCipherRotationBDP = mWindowRotationPack.mPlaneB.mChunkD.mWindowP;
    mMutateMaterialA = mMaterials[0U];
    mMutateMaterialB = mMaterials[1U];
    mMutateMaterialC = mMaterials[2U];
    mMutateMaterialD = mMaterials[3U];
    mMutateMaterialE = mMaterials[4U];
    mMutateMaterialF = mMaterials[5U];
    mMutateMaterialG = mMaterials[6U];
    mMutateMaterialH = mMaterials[7U];
    mMutateMaterialI = mMaterials[8U];
    mMutateMaterialJ = mMaterials[9U];
    mMutateMaterialK = mMaterials[10U];
    mMutateMaterialL = mMaterials[11U];
    mMutateMaterialM = mMaterials[12U];
    mMutateMaterialN = mMaterials[13U];
    mMutateMaterialO = mMaterials[14U];
    mMutateMaterialP = mMaterials[15U];
    // B/D route block data; C is a distinct cache, repacked by every FlameToad.
    mPackedRows = mCollapseLaneC;
    mPackedRowLength = SOCCER_BLOCK_SIZE / 4U;
    if (!mCryptex.Build(mStrength)) return false;
    mMaterialIndex = mCryptex.GetMaterialCount();
    mEncryptionReady = true;
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
