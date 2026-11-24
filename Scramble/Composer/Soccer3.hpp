//
//  Soccer3.hpp
//  Scramble
//
//  Created by Icarus Black on 8/1/26.
//

#ifndef Soccer3_hpp
#define Soccer3_hpp

#include "TwistWorkSpace.hpp"
#include "TwistShuffle.hpp"
#include "TwistFunctional.hpp"
#include "SoccerTypes.hpp"
#include "RandomShuffleLayout.hpp"
#include "Cryptex.hpp"
#include "BitPlaneFarm.hpp"
#include "SoccerDelegate.hpp"

/*
we have 1 bit-plan, for all the rotations

[a b] [c d] [e f] [g h]

layer 1: [a c] rotates [e g] rotates
layer 2: [b d] rotates [f h] rotates

layer 3: [a e] rotates [c g] rotates
layer 4: [b f] rotates [d h] rotates

layer 5: [a d] rotates [e h] rotates
layer 6: [b c] rotates [f g] rotates

layer 7: [a f] rotates [c h] rotates
layer 8: [b e] rotates [d g] rotates

All 16 pairs are unique. Each bit appears four times.
Layers 1+2, 3+4, 5+6, and 7+8 each shift all eight planes.
 
 weak:
 layer 1:
 layer 2: mutate

 layer 3:
 layer 4: mutate

 layer 5:
 layer 6: mutate

 layer 7:
 layer 8: mutate
 
 normal: (all 8 mutate)
 strong: (all 8 mutate twice)

 Active corvid usage, with one XOR included in each Raven:
 weak:   FourCrowKernel, FourRavenKernel, FourCrowKernel, FourRavenKernel,
         FourCrowKernel, FourRavenKernel, FourCrowKernel, FourRavenKernel
 normal: FourRavenKernel on every layer
 strong: FourRavenKernel on every layer, plus a separate PasswordXORKernel
         before each FourToadKernel to separate the two mutates with nonlinear work

*/

#ifndef IGNORE_SIMD
#define IGNORE_SIMD 0
#endif

#if !IGNORE_SIMD && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#define SOCCER_USE_NEON 1
#else
#define SOCCER_USE_NEON 0
#endif

#if !IGNORE_SIMD && (defined(__AVX2__) || defined(__SSSE3__))
#define SOCCER_USE_SIMD 1
#else
#define SOCCER_USE_SIMD 0
#endif

#if SOCCER_USE_NEON
#include <arm_neon.h>
#endif

#if SOCCER_USE_SIMD
#include <immintrin.h>
#endif

#define SOCCER_BLOCK_SIZE 1048576
#define SOCCER_BLOCK_QUARTER 262144

#include "TwistExpander_Aldebaran.hpp"
#include "TwistExpander_Altair.hpp"
#include "TwistExpander_Antares.hpp"
#include "TwistExpander_Arcturus.hpp"
#include "TwistExpander_Bellatrix.hpp"
#include "TwistExpander_Betelgeuse.hpp"
#include "TwistExpander_Capella.hpp"
#include "TwistExpander_Castor.hpp"
#include "TwistExpander_Mimosa.hpp"
#include "TwistExpander_Polaris.hpp"
#include "TwistExpander_Pollux.hpp"
#include "TwistExpander_Procyon.hpp"
#include "TwistExpander_Regulus.hpp"
#include "TwistExpander_Rigel.hpp"
#include "TwistExpander_Saiph.hpp"
#include "TwistExpander_Sirius.hpp"
#include "TwistExpander_Vega.hpp"

#include <atomic>
#include <cstddef>
#include <cstdint>

#define SOCCER_EXPANDER_COUNT 16

#define SOCCER_PRELUDE_RAND mCollapseLaneB
#define SOCCER_SCRATCH_WORKER_A mCollapseLaneB
#define SOCCER_WORKER_B mCollapseLaneD

static_assert(SOCCER_BLOCK_SIZE == Kernel::kBlockBytes);

class Soccer3Internal {
public:
    // Planning metadata only. Crow and Raven each own their kernel Shift type.
    struct PlaneShift {
        std::uint8_t mMask;
        std::size_t mRotation;
    };

    static SoccerDelegate                           *mDelegate;

    static std::uint8_t                             mMaterialA[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialB[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialC[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialD[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialE[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialF[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialG[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialH[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialI[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialJ[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialK[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialL[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialM[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialN[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialO[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mMaterialP[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             *mMaterials[16];

    static std::uint8_t                             *mClaimedMaterials[16];
    static std::size_t                              mClaimedMaterialCount;

    static TwistWorkSpace                           mWorkSpaceA;
    static TwistWorkSpace                           mWorkSpaceB;
    static TwistWorkSpace                           mWorkSpaceC;
    static TwistWorkSpace                           mWorkSpaceD;
    static TwistWorkSpace                           mWorkSpaceE;
    static TwistWorkSpace                           mWorkSpaceF;
    static TwistWorkSpace                           mWorkSpaceG;
    static TwistWorkSpace                           mWorkSpaceH;
    static TwistWorkSpace                           mWorkSpaceI;
    static TwistWorkSpace                           mWorkSpaceJ;
    static TwistWorkSpace                           mWorkSpaceK;
    static TwistWorkSpace                           mWorkSpaceL;
    static TwistWorkSpace                           mWorkSpaceM;
    static TwistWorkSpace                           mWorkSpaceN;
    static TwistWorkSpace                           mWorkSpaceO;
    static TwistWorkSpace                           mWorkSpaceP;
    static TwistWorkSpace                           *mWorkSpaces[16];
    static TwistWorkSpace                           *mClaimedWorkSpaces[16];
    static std::size_t                              mClaimedWorkSpaceCount;


    static TwistExpander_Betelgeuse                 mStarter;
    static TwistExpander_Aldebaran                  mAldebaran; // 1
    static TwistExpander_Altair                     mAltair; // 2
    static TwistExpander_Antares                    mAntares; // 3
    static TwistExpander_Arcturus                   mArcturus; // 4
    static TwistExpander_Bellatrix                  mBellatrix; // 5
    static TwistExpander_Capella                    mCapella; // 6
    static TwistExpander_Castor                     mCastor; // 7
    static TwistExpander_Mimosa                     mMimosa; // 8
    static TwistExpander_Polaris                    mPolaris; // 9
    static TwistExpander_Pollux                     mPollux; // 10
    static TwistExpander_Procyon                    mProcyon; // 11
    static TwistExpander_Regulus                    mRegulus; // 12
    static TwistExpander_Rigel                      mRigel; // 13
    static TwistExpander_Saiph                      mSaiph; // 14
    static TwistExpander_Sirius                     mSirius; // 15
    static TwistExpander_Vega                       mVega; // 16

    static TwistExpander                            *mExpanders[SOCCER_EXPANDER_COUNT];
    static TwistExpander                            *mClaimedExpanders[16];
    static std::size_t                              mClaimedExpanderCount;

    static std::uint8_t                             mRandom[S_BLOCK];

    static std::uint8_t                             mCollapseLaneA[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mCollapseLaneB[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mCollapseLaneC[SOCCER_BLOCK_SIZE];
    static std::uint8_t                             mCollapseLaneD[SOCCER_BLOCK_SIZE];

    static std::uint8_t                             mCondenseLaneA[SOCCER_BLOCK_QUARTER];
    static std::uint8_t                             mCondenseLaneB[SOCCER_BLOCK_QUARTER];
    static std::uint8_t                             mCondenseLaneC[SOCCER_BLOCK_QUARTER];
    static std::uint8_t                             mCondenseLaneD[SOCCER_BLOCK_QUARTER];


    // Shared by both four-layer rounds; accumulated from fresh mRandom blocks.
    static BitPlane                                 mBitPlane;
    static std::uint64_t                            mBitPlaneWordA;
    static std::uint64_t                            mBitPlaneWordB;
    static std::uint64_t                            mBitPlaneWordC;

    // Direct Cryptex inputs: bit rows A..D are reused in the second four layers.
    static std::uint8_t                             mBitRowAA;
    static std::uint8_t                             mBitRowAB;
    static std::uint8_t                             mBitRowAC;
    static std::uint8_t                             mBitRowAD;
    static std::uint8_t                             mBitRowAE;
    static std::uint8_t                             mBitRowAF;
    static std::uint8_t                             mBitRowAG;
    static std::uint8_t                             mBitRowAH;
    static std::uint8_t                             mBitRowBA;
    static std::uint8_t                             mBitRowBB;
    static std::uint8_t                             mBitRowBC;
    static std::uint8_t                             mBitRowBD;
    static std::uint8_t                             mBitRowBE;
    static std::uint8_t                             mBitRowBF;
    static std::uint8_t                             mBitRowBG;
    static std::uint8_t                             mBitRowBH;
    static std::uint8_t                             mBitRowCA;
    static std::uint8_t                             mBitRowCB;
    static std::uint8_t                             mBitRowCC;
    static std::uint8_t                             mBitRowCD;
    static std::uint8_t                             mBitRowCE;
    static std::uint8_t                             mBitRowCF;
    static std::uint8_t                             mBitRowCG;
    static std::uint8_t                             mBitRowCH;
    static std::uint8_t                             mBitRowDA;
    static std::uint8_t                             mBitRowDB;
    static std::uint8_t                             mBitRowDC;
    static std::uint8_t                             mBitRowDD;
    static std::uint8_t                             mBitRowDE;
    static std::uint8_t                             mBitRowDF;
    static std::uint8_t                             mBitRowDG;
    static std::uint8_t                             mBitRowDH;

    // Sixteen sampling windows per layer: four consecutive windows per FlameToad.
    static std::uint16_t                            mToadCipherRotationAALeftA;
    static std::uint16_t                            mToadCipherRotationAALeftB;
    static std::uint16_t                            mToadCipherRotationAALeftC;
    static std::uint16_t                            mToadCipherRotationAALeftD;
    static std::uint16_t                            mToadCipherRotationAALeftE;
    static std::uint16_t                            mToadCipherRotationAALeftF;
    static std::uint16_t                            mToadCipherRotationAALeftG;
    static std::uint16_t                            mToadCipherRotationAALeftH;
    static std::uint16_t                            mToadCipherRotationAARightA;
    static std::uint16_t                            mToadCipherRotationAARightB;
    static std::uint16_t                            mToadCipherRotationAARightC;
    static std::uint16_t                            mToadCipherRotationAARightD;
    static std::uint16_t                            mToadCipherRotationAARightE;
    static std::uint16_t                            mToadCipherRotationAARightF;
    static std::uint16_t                            mToadCipherRotationAARightG;
    static std::uint16_t                            mToadCipherRotationAARightH;
    static std::uint16_t                            mToadCipherRotationABLeftA;
    static std::uint16_t                            mToadCipherRotationABLeftB;
    static std::uint16_t                            mToadCipherRotationABLeftC;
    static std::uint16_t                            mToadCipherRotationABLeftD;
    static std::uint16_t                            mToadCipherRotationABLeftE;
    static std::uint16_t                            mToadCipherRotationABLeftF;
    static std::uint16_t                            mToadCipherRotationABLeftG;
    static std::uint16_t                            mToadCipherRotationABLeftH;
    static std::uint16_t                            mToadCipherRotationABRightA;
    static std::uint16_t                            mToadCipherRotationABRightB;
    static std::uint16_t                            mToadCipherRotationABRightC;
    static std::uint16_t                            mToadCipherRotationABRightD;
    static std::uint16_t                            mToadCipherRotationABRightE;
    static std::uint16_t                            mToadCipherRotationABRightF;
    static std::uint16_t                            mToadCipherRotationABRightG;
    static std::uint16_t                            mToadCipherRotationABRightH;
    static std::uint16_t                            mToadCipherRotationACLeftA;
    static std::uint16_t                            mToadCipherRotationACLeftB;
    static std::uint16_t                            mToadCipherRotationACLeftC;
    static std::uint16_t                            mToadCipherRotationACLeftD;
    static std::uint16_t                            mToadCipherRotationACLeftE;
    static std::uint16_t                            mToadCipherRotationACLeftF;
    static std::uint16_t                            mToadCipherRotationACLeftG;
    static std::uint16_t                            mToadCipherRotationACLeftH;
    static std::uint16_t                            mToadCipherRotationACRightA;
    static std::uint16_t                            mToadCipherRotationACRightB;
    static std::uint16_t                            mToadCipherRotationACRightC;
    static std::uint16_t                            mToadCipherRotationACRightD;
    static std::uint16_t                            mToadCipherRotationACRightE;
    static std::uint16_t                            mToadCipherRotationACRightF;
    static std::uint16_t                            mToadCipherRotationACRightG;
    static std::uint16_t                            mToadCipherRotationACRightH;
    static std::uint16_t                            mToadCipherRotationADLeftA;
    static std::uint16_t                            mToadCipherRotationADLeftB;
    static std::uint16_t                            mToadCipherRotationADLeftC;
    static std::uint16_t                            mToadCipherRotationADLeftD;
    static std::uint16_t                            mToadCipherRotationADLeftE;
    static std::uint16_t                            mToadCipherRotationADLeftF;
    static std::uint16_t                            mToadCipherRotationADLeftG;
    static std::uint16_t                            mToadCipherRotationADLeftH;
    static std::uint16_t                            mToadCipherRotationADRightA;
    static std::uint16_t                            mToadCipherRotationADRightB;
    static std::uint16_t                            mToadCipherRotationADRightC;
    static std::uint16_t                            mToadCipherRotationADRightD;
    static std::uint16_t                            mToadCipherRotationADRightE;
    static std::uint16_t                            mToadCipherRotationADRightF;
    static std::uint16_t                            mToadCipherRotationADRightG;
    static std::uint16_t                            mToadCipherRotationADRightH;
    static std::uint16_t                            mToadCipherRotationBALeftA;
    static std::uint16_t                            mToadCipherRotationBALeftB;
    static std::uint16_t                            mToadCipherRotationBALeftC;
    static std::uint16_t                            mToadCipherRotationBALeftD;
    static std::uint16_t                            mToadCipherRotationBALeftE;
    static std::uint16_t                            mToadCipherRotationBALeftF;
    static std::uint16_t                            mToadCipherRotationBALeftG;
    static std::uint16_t                            mToadCipherRotationBALeftH;
    static std::uint16_t                            mToadCipherRotationBARightA;
    static std::uint16_t                            mToadCipherRotationBARightB;
    static std::uint16_t                            mToadCipherRotationBARightC;
    static std::uint16_t                            mToadCipherRotationBARightD;
    static std::uint16_t                            mToadCipherRotationBARightE;
    static std::uint16_t                            mToadCipherRotationBARightF;
    static std::uint16_t                            mToadCipherRotationBARightG;
    static std::uint16_t                            mToadCipherRotationBARightH;
    static std::uint16_t                            mToadCipherRotationBBLeftA;
    static std::uint16_t                            mToadCipherRotationBBLeftB;
    static std::uint16_t                            mToadCipherRotationBBLeftC;
    static std::uint16_t                            mToadCipherRotationBBLeftD;
    static std::uint16_t                            mToadCipherRotationBBLeftE;
    static std::uint16_t                            mToadCipherRotationBBLeftF;
    static std::uint16_t                            mToadCipherRotationBBLeftG;
    static std::uint16_t                            mToadCipherRotationBBLeftH;
    static std::uint16_t                            mToadCipherRotationBBRightA;
    static std::uint16_t                            mToadCipherRotationBBRightB;
    static std::uint16_t                            mToadCipherRotationBBRightC;
    static std::uint16_t                            mToadCipherRotationBBRightD;
    static std::uint16_t                            mToadCipherRotationBBRightE;
    static std::uint16_t                            mToadCipherRotationBBRightF;
    static std::uint16_t                            mToadCipherRotationBBRightG;
    static std::uint16_t                            mToadCipherRotationBBRightH;
    static std::uint16_t                            mToadCipherRotationBCLeftA;
    static std::uint16_t                            mToadCipherRotationBCLeftB;
    static std::uint16_t                            mToadCipherRotationBCLeftC;
    static std::uint16_t                            mToadCipherRotationBCLeftD;
    static std::uint16_t                            mToadCipherRotationBCLeftE;
    static std::uint16_t                            mToadCipherRotationBCLeftF;
    static std::uint16_t                            mToadCipherRotationBCLeftG;
    static std::uint16_t                            mToadCipherRotationBCLeftH;
    static std::uint16_t                            mToadCipherRotationBCRightA;
    static std::uint16_t                            mToadCipherRotationBCRightB;
    static std::uint16_t                            mToadCipherRotationBCRightC;
    static std::uint16_t                            mToadCipherRotationBCRightD;
    static std::uint16_t                            mToadCipherRotationBCRightE;
    static std::uint16_t                            mToadCipherRotationBCRightF;
    static std::uint16_t                            mToadCipherRotationBCRightG;
    static std::uint16_t                            mToadCipherRotationBCRightH;
    static std::uint16_t                            mToadCipherRotationBDLeftA;
    static std::uint16_t                            mToadCipherRotationBDLeftB;
    static std::uint16_t                            mToadCipherRotationBDLeftC;
    static std::uint16_t                            mToadCipherRotationBDLeftD;
    static std::uint16_t                            mToadCipherRotationBDLeftE;
    static std::uint16_t                            mToadCipherRotationBDLeftF;
    static std::uint16_t                            mToadCipherRotationBDLeftG;
    static std::uint16_t                            mToadCipherRotationBDLeftH;
    static std::uint16_t                            mToadCipherRotationBDRightA;
    static std::uint16_t                            mToadCipherRotationBDRightB;
    static std::uint16_t                            mToadCipherRotationBDRightC;
    static std::uint16_t                            mToadCipherRotationBDRightD;
    static std::uint16_t                            mToadCipherRotationBDRightE;
    static std::uint16_t                            mToadCipherRotationBDRightF;
    static std::uint16_t                            mToadCipherRotationBDRightG;
    static std::uint16_t                            mToadCipherRotationBDRightH;

    // Ordered material pointers and the shared, disposable packed-row cache.
    static const std::uint8_t *                     mMutateMaterialA;
    static const std::uint8_t *                     mMutateMaterialB;
    static const std::uint8_t *                     mMutateMaterialC;
    static const std::uint8_t *                     mMutateMaterialD;
    static const std::uint8_t *                     mMutateMaterialE;
    static const std::uint8_t *                     mMutateMaterialF;
    static const std::uint8_t *                     mMutateMaterialG;
    static const std::uint8_t *                     mMutateMaterialH;
    static const std::uint8_t *                     mMutateMaterialI;
    static const std::uint8_t *                     mMutateMaterialJ;
    static const std::uint8_t *                     mMutateMaterialK;
    static const std::uint8_t *                     mMutateMaterialL;
    static const std::uint8_t *                     mMutateMaterialM;
    static const std::uint8_t *                     mMutateMaterialN;
    static const std::uint8_t *                     mMutateMaterialO;
    static const std::uint8_t *                     mMutateMaterialP;
    static std::uint8_t *                           mPackedRows;
    static std::size_t                              mPackedRowLength;

    static bool                                     ValidateCryptexInputs(EncryptionStrength pStrength);

    // Left and Right words supply the two corvid shifts at each layer.
    // Keep the word inputs separate so their random positions can change independently.
    static std::uint64_t                            mShiftMaskedRotationWordAALeft;
    static std::uint64_t                            mShiftMaskedRotationWordAARight;
    static std::uint64_t                            mShiftMaskedRotationWordABLeft;
    static std::uint64_t                            mShiftMaskedRotationWordABRight;
    static std::uint64_t                            mShiftMaskedRotationWordACLeft;
    static std::uint64_t                            mShiftMaskedRotationWordACRight;
    static std::uint64_t                            mShiftMaskedRotationWordADLeft;
    static std::uint64_t                            mShiftMaskedRotationWordADRight;
    static std::uint64_t                            mShiftMaskedRotationWordBALeft;
    static std::uint64_t                            mShiftMaskedRotationWordBARight;
    static std::uint64_t                            mShiftMaskedRotationWordBBLeft;
    static std::uint64_t                            mShiftMaskedRotationWordBBRight;
    static std::uint64_t                            mShiftMaskedRotationWordBCLeft;
    static std::uint64_t                            mShiftMaskedRotationWordBCRight;
    static std::uint64_t                            mShiftMaskedRotationWordBDLeft;
    static std::uint64_t                            mShiftMaskedRotationWordBDRight;

    // Two independent two-bit shifts per layer, derived from the first bit-plane row.
    static PlaneShift                              mPlaneShiftAALeft;
    static PlaneShift                              mPlaneShiftAARight;
    static PlaneShift                              mPlaneShiftABLeft;
    static PlaneShift                              mPlaneShiftABRight;
    static PlaneShift                              mPlaneShiftACLeft;
    static PlaneShift                              mPlaneShiftACRight;
    static PlaneShift                              mPlaneShiftADLeft;
    static PlaneShift                              mPlaneShiftADRight;
    static PlaneShift                              mPlaneShiftBALeft;
    static PlaneShift                              mPlaneShiftBARight;
    static PlaneShift                              mPlaneShiftBBLeft;
    static PlaneShift                              mPlaneShiftBBRight;
    static PlaneShift                              mPlaneShiftBCLeft;
    static PlaneShift                              mPlaneShiftBCRight;
    static PlaneShift                              mPlaneShiftBDLeft;
    static PlaneShift                              mPlaneShiftBDRight;

    static constexpr std::size_t                    kRotationWindowCount = 16384U;
    static constexpr std::size_t                    kRotationWindowBytes = 64U;
    static constexpr std::size_t                    kRotationListCount = 18U; // Two corvid shift lists and sixteen FourToadKernel lists.
    static constexpr std::size_t                    kRotationsPerList = 8U;

    // Two eight-window lists per layer: Left feeds frogs 1/2, Right feeds frogs 3/4.
    // ShiftMasked A/B supply each layer's Left/Right corvid shift windows.
    // Bases retain their permutations across all seed shuffle generations.
    static std::uint16_t                            mShiftMaskedRotationListBaseA[kRotationWindowCount];
    static std::uint16_t                            mShiftMaskedRotationListChosenA[kRotationsPerList];
    static std::size_t                              mShiftMaskedRotationListAvailableA;

    static std::uint16_t                            mFlameToadRotationListBaseAALeft[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenAALeft[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableAALeft;

    static std::uint16_t                            mFlameToadRotationListBaseAARight[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenAARight[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableAARight;

    static std::uint16_t                            mFlameToadRotationListBaseABLeft[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenABLeft[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableABLeft;

    static std::uint16_t                            mFlameToadRotationListBaseABRight[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenABRight[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableABRight;

    static std::uint16_t                            mFlameToadRotationListBaseACLeft[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenACLeft[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableACLeft;

    static std::uint16_t                            mFlameToadRotationListBaseACRight[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenACRight[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableACRight;

    static std::uint16_t                            mFlameToadRotationListBaseADLeft[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenADLeft[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableADLeft;

    static std::uint16_t                            mFlameToadRotationListBaseADRight[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenADRight[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableADRight;

    static std::uint16_t                            mShiftMaskedRotationListBaseB[kRotationWindowCount];
    static std::uint16_t                            mShiftMaskedRotationListChosenB[kRotationsPerList];
    static std::size_t                              mShiftMaskedRotationListAvailableB;

    static std::uint16_t                            mFlameToadRotationListBaseBALeft[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenBALeft[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableBALeft;

    static std::uint16_t                            mFlameToadRotationListBaseBARight[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenBARight[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableBARight;

    static std::uint16_t                            mFlameToadRotationListBaseBBLeft[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenBBLeft[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableBBLeft;

    static std::uint16_t                            mFlameToadRotationListBaseBBRight[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenBBRight[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableBBRight;

    static std::uint16_t                            mFlameToadRotationListBaseBCLeft[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenBCLeft[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableBCLeft;

    static std::uint16_t                            mFlameToadRotationListBaseBCRight[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenBCRight[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableBCRight;

    static std::uint16_t                            mFlameToadRotationListBaseBDLeft[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenBDLeft[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableBDLeft;

    static std::uint16_t                            mFlameToadRotationListBaseBDRight[kRotationWindowCount];
    static std::uint16_t                            mFlameToadRotationListChosenBDRight[kRotationsPerList];
    static std::size_t                              mFlameToadRotationListAvailableBDRight;

    // Selection scratch. Only the single/complement map spans lists.
    static bool                                     mRotationWindowBlocked[kRotationWindowCount];
    static bool                                     mRotationWindowSingleBlocked[kRotationWindowCount];
    static std::size_t                              mRotationCandidatesRead;
    static std::size_t                              mRotationFallbackCandidatesRead;
    static std::size_t                              mRotationShuffleBytesRead;
    static std::size_t                              mRandomShuffleGeneration;

    // A non-null base has kRotationWindowCount entries. Prefer pAvailable entries,
    // then the opposite tail, then numeric candidates. Always fills all eight.
    // Null pOffsetWords selects whole-window rotations; otherwise eight words
    // also constrain the eventual masked BYTE shifts. Writes window indices
    // directly into the caller's eight-entry chosen list.
    static void                                     SelectEightRotations(const std::uint16_t *pRotationList,
                                                                         std::size_t pAvailable,
                                                                         std::uint16_t (&pChosenRotations)[kRotationsPerList],
                                                                         const std::uint64_t *pOffsetWords = nullptr);
    static std::uint32_t                             ShiftMaskedByteOffset(std::uint64_t pWord);
    static void                                     ShuffleCROWUnit(std::uint16_t (&pRotationList)[kRotationWindowCount],
                                                                    std::uint64_t &pBitPlaneWordA,
                                                                    std::uint64_t &pBitPlaneWordB,
                                                                    std::uint64_t &pBitPlaneWordC,
                                                                    std::size_t &pAvailable,
                                                                    std::size_t pOffset);

    static std::uint8_t                             *mSources[16];


    static std::uint8_t                             *mCross[4][16];
    static std::uint8_t                             *mCrossPool[16][64];
    static std::size_t                              mCrossPoolCount[16];
    static std::uint8_t                             mCrossPermutations[16][64];

    static bool                                     mClaimed[SOCCER_EXPANDER_COUNT];

    static Cryptex                                  mCryptex;
    static bool                                     mEncryptionReady;

    static std::uint8_t                             *mShuffleMaterials[16];
    static TwistExpander                            *mShuffleExpanders[SOCCER_EXPANDER_COUNT];
    static TwistWorkSpace                           *mShuffleWorkSpaces[16];

    static EncryptionStrength                       mStrength;

    static uint32_t                                 mTestBlockLength;

    static std::uint64_t                            ReadShuffleWord(std::size_t pIndex);

    static std::size_t                              mMaterialIndex;

    static void                                     Zero();

    static void                                     SetDelegate(SoccerDelegate *pDelegate);

    static void                                     ConfigureTestBuffers(std::uint32_t pTestBlockLength); // SOCCER_BLOCK_SIZE (L3 size)

    // Optional caller-owned flag; keep alive until return and only set true
    // during an attempt. Polls use relaxed loads and never modify the flag.
    static bool                                     AttemptSeed_Encrypt(EncryptionStrength pStrength,
                                                                        std::uint8_t *pPassword,
                                                                        std::size_t pPasswordByteLength,
                                                                        std::uint64_t pNonce,
                                                                        std::uint32_t *pAckWord,
                                                                        std::uint64_t pVersion,
                                                                        const std::atomic<bool> *pCancelled);

    static bool                                     AttemptSeed_Decrypt(EncryptionStrength pStrength,
                                                                        std::uint8_t *pPassword,
                                                                        std::size_t pPasswordByteLength,
                                                                        std::uint64_t pNonce,
                                                                        std::uint32_t pAckWord,
                                                                        std::uint64_t pVersion,
                                                                        const std::atomic<bool> *pCancelled);

    static bool                                     EncryptBlock(std::uint8_t *pSource,
                                                             std::uint8_t *pDestination);
    static bool                                     DecryptBlock(std::uint8_t *pSource,
                                                             std::uint8_t *pDestination);


    static void                                     UnrollNonceAndPasswordToScratch_Test(std::uint8_t *pPassword,
                                                                                     std::size_t pPasswordByteLength,
                                                                                     std::uint64_t pNonce);
    static void                                     UnrollNonceAndPasswordToScratch_Regular(std::uint8_t *pPassword,
                                                                                        std::size_t pPasswordByteLength,
                                                                                        std::uint64_t pNonce);


    static bool                                     SeedPrelude_Test(std::uint8_t *pPassword,
                                                                 std::size_t pPasswordByteLength,
                                                                 std::uint64_t pNonce);
    static void                                     SeedPrelude_Regular_A(std::uint8_t *pPassword,
                                                                      std::size_t pPasswordByteLength,
                                                                      std::uint64_t pNonce);
    static void                                     SeedPrelude_Regular_B(std::uint64_t pNonce, MUTABLE_PARAMS);
    static void                                     SeedPrelude_Regular_C();


    static bool                                     SeedPrologue_Regular_A(std::uint8_t *pPassword,
                                                                       std::size_t pPasswordByteLength,
                                                                       std::uint64_t pNonce,
                                                                       MUTABLE_PARAMS,
                                                                       const std::atomic<bool> *pCancelled);
    static void                                     SeedPrologue_Regular_B();
    static bool                                     SeedPrologue_Regular_C(std::uint32_t *pAckWord,
                                                                       bool pForwardDeploy,
                                                                       MUTABLE_PARAMS,
                                                                       const std::atomic<bool> *pCancelled);
    static bool                                     SeedPrologue_Regular_D(MUTABLE_PARAMS,
                                                                       const std::atomic<bool> *pCancelled);
    
    static bool                                     TwistRound(std::size_t pBlockIndex,
                                                           bool pIsWarmUpRound,
                                                           MUTABLE_PARAMS,
                                                           const std::atomic<bool> *pCancelled);


    static void                                     ArrangeCrossPool(std::size_t pComplexity);
    // Reinitialized for every cross-pool rebuild, including warm-up rounds.
    static void                                     InitializeCrossPermutations();
    static void                                     BuildCrossPool_WarmUp1(std::size_t pComplexity,
                                                                       std::size_t pCurrentByteIndex);
    static void                                     BuildCrossPool_WarmUp2(std::size_t pComplexity,
                                                                       std::size_t pPreviousByteIndex,
                                                                       std::size_t pCurrentByteIndex);
    static void                                     BuildCrossPool_WarmUp4(std::size_t pComplexity,
                                                                       std::size_t pThreeRoundsBackByteIndex,
                                                                       std::size_t pTwoRoundsBackByteIndex,
                                                                       std::size_t pOneRoundBackByteIndex);
    static void                                     BuildCrossPool_Regular(std::size_t pComplexity,
                                                                       std::size_t pFourRoundsBackByteIndex,
                                                                       std::size_t pThreeRoundsBackByteIndex,
                                                                       std::size_t pTwoRoundsBackByteIndex,
                                                                       std::size_t pOneRoundBackByteIndex);

    static void                                     SeedEpilogue_Regular_A();
    static bool                                     SeedEpilogue_Regular_C();
    static bool                                     SeedEpilogue_Regular_D();
    
    static void                                     Shuffle_MEWBlockZero(std::uint8_t *pMaterial);

    // Disjoint mRandom ranges: ordering lists, cross permutations, rotations.
    static void                                     Shuffle_CROWSCIMASSORMATEX();
    static void                                     Shuffle_CROPER(std::size_t pPermutationCount);

    static void                                     FoldMaterialsIntoRandomForBlock_4(std::size_t pBlockIndex);
    static void                                     FoldMaterialsIntoRandomForBlock_8(std::size_t pBlockIndex);
    static void                                     FoldMaterialsIntoRandomForBlock_16(std::size_t pBlockIndex);
    
private:
    static std::size_t                              mSeedProgressCompleted;
    static std::size_t                              mSeedProgressTotal;

    static void                                     BeginSeedProgress(EncryptionStrength pStrength);
    static void                                     AdvanceSeedProgress(std::size_t pCost);
    static bool                                     FinishSeedProgress(bool pSuccess);

};

#ifndef SOCCER3_DISABLE_COMPAT_ALIAS
using Soccer3 = Soccer3Internal;
#endif

#endif /* Soccer3_hpp */
