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
#include "WindowRotationFarm.hpp"
#include "BitPlaneFarm.hpp"
#include "SoccerDelegate.hpp"

#include "Jelly.hpp"

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

class Soccer3Internal {
public:

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

    // Four complementary mask pairs, A/B through G/H, shared by both rounds.
    static std::uint8_t                             mRotationMaskA;
    static std::uint8_t                             mRotationMaskB;
    static std::uint8_t                             mRotationMaskC;
    static std::uint8_t                             mRotationMaskD;
    static std::uint8_t                             mRotationMaskE;
    static std::uint8_t                             mRotationMaskF;
    static std::uint8_t                             mRotationMaskG;
    static std::uint8_t                             mRotationMaskH;

    // Sixteen sampling windows per layer: four consecutive windows per FlameToad.
    static std::uint16_t                            mFlameToadCipherRotationAAA;
    static std::uint16_t                            mFlameToadCipherRotationAAB;
    static std::uint16_t                            mFlameToadCipherRotationAAC;
    static std::uint16_t                            mFlameToadCipherRotationAAD;
    static std::uint16_t                            mFlameToadCipherRotationAAE;
    static std::uint16_t                            mFlameToadCipherRotationAAF;
    static std::uint16_t                            mFlameToadCipherRotationAAG;
    static std::uint16_t                            mFlameToadCipherRotationAAH;
    static std::uint16_t                            mFlameToadCipherRotationAAI;
    static std::uint16_t                            mFlameToadCipherRotationAAJ;
    static std::uint16_t                            mFlameToadCipherRotationAAK;
    static std::uint16_t                            mFlameToadCipherRotationAAL;
    static std::uint16_t                            mFlameToadCipherRotationAAM;
    static std::uint16_t                            mFlameToadCipherRotationAAN;
    static std::uint16_t                            mFlameToadCipherRotationAAO;
    static std::uint16_t                            mFlameToadCipherRotationAAP;
    static std::uint16_t                            mFlameToadCipherRotationABA;
    static std::uint16_t                            mFlameToadCipherRotationABB;
    static std::uint16_t                            mFlameToadCipherRotationABC;
    static std::uint16_t                            mFlameToadCipherRotationABD;
    static std::uint16_t                            mFlameToadCipherRotationABE;
    static std::uint16_t                            mFlameToadCipherRotationABF;
    static std::uint16_t                            mFlameToadCipherRotationABG;
    static std::uint16_t                            mFlameToadCipherRotationABH;
    static std::uint16_t                            mFlameToadCipherRotationABI;
    static std::uint16_t                            mFlameToadCipherRotationABJ;
    static std::uint16_t                            mFlameToadCipherRotationABK;
    static std::uint16_t                            mFlameToadCipherRotationABL;
    static std::uint16_t                            mFlameToadCipherRotationABM;
    static std::uint16_t                            mFlameToadCipherRotationABN;
    static std::uint16_t                            mFlameToadCipherRotationABO;
    static std::uint16_t                            mFlameToadCipherRotationABP;
    static std::uint16_t                            mFlameToadCipherRotationACA;
    static std::uint16_t                            mFlameToadCipherRotationACB;
    static std::uint16_t                            mFlameToadCipherRotationACC;
    static std::uint16_t                            mFlameToadCipherRotationACD;
    static std::uint16_t                            mFlameToadCipherRotationACE;
    static std::uint16_t                            mFlameToadCipherRotationACF;
    static std::uint16_t                            mFlameToadCipherRotationACG;
    static std::uint16_t                            mFlameToadCipherRotationACH;
    static std::uint16_t                            mFlameToadCipherRotationACI;
    static std::uint16_t                            mFlameToadCipherRotationACJ;
    static std::uint16_t                            mFlameToadCipherRotationACK;
    static std::uint16_t                            mFlameToadCipherRotationACL;
    static std::uint16_t                            mFlameToadCipherRotationACM;
    static std::uint16_t                            mFlameToadCipherRotationACN;
    static std::uint16_t                            mFlameToadCipherRotationACO;
    static std::uint16_t                            mFlameToadCipherRotationACP;
    static std::uint16_t                            mFlameToadCipherRotationADA;
    static std::uint16_t                            mFlameToadCipherRotationADB;
    static std::uint16_t                            mFlameToadCipherRotationADC;
    static std::uint16_t                            mFlameToadCipherRotationADD;
    static std::uint16_t                            mFlameToadCipherRotationADE;
    static std::uint16_t                            mFlameToadCipherRotationADF;
    static std::uint16_t                            mFlameToadCipherRotationADG;
    static std::uint16_t                            mFlameToadCipherRotationADH;
    static std::uint16_t                            mFlameToadCipherRotationADI;
    static std::uint16_t                            mFlameToadCipherRotationADJ;
    static std::uint16_t                            mFlameToadCipherRotationADK;
    static std::uint16_t                            mFlameToadCipherRotationADL;
    static std::uint16_t                            mFlameToadCipherRotationADM;
    static std::uint16_t                            mFlameToadCipherRotationADN;
    static std::uint16_t                            mFlameToadCipherRotationADO;
    static std::uint16_t                            mFlameToadCipherRotationADP;
    static std::uint16_t                            mFlameToadCipherRotationBAA;
    static std::uint16_t                            mFlameToadCipherRotationBAB;
    static std::uint16_t                            mFlameToadCipherRotationBAC;
    static std::uint16_t                            mFlameToadCipherRotationBAD;
    static std::uint16_t                            mFlameToadCipherRotationBAE;
    static std::uint16_t                            mFlameToadCipherRotationBAF;
    static std::uint16_t                            mFlameToadCipherRotationBAG;
    static std::uint16_t                            mFlameToadCipherRotationBAH;
    static std::uint16_t                            mFlameToadCipherRotationBAI;
    static std::uint16_t                            mFlameToadCipherRotationBAJ;
    static std::uint16_t                            mFlameToadCipherRotationBAK;
    static std::uint16_t                            mFlameToadCipherRotationBAL;
    static std::uint16_t                            mFlameToadCipherRotationBAM;
    static std::uint16_t                            mFlameToadCipherRotationBAN;
    static std::uint16_t                            mFlameToadCipherRotationBAO;
    static std::uint16_t                            mFlameToadCipherRotationBAP;
    static std::uint16_t                            mFlameToadCipherRotationBBA;
    static std::uint16_t                            mFlameToadCipherRotationBBB;
    static std::uint16_t                            mFlameToadCipherRotationBBC;
    static std::uint16_t                            mFlameToadCipherRotationBBD;
    static std::uint16_t                            mFlameToadCipherRotationBBE;
    static std::uint16_t                            mFlameToadCipherRotationBBF;
    static std::uint16_t                            mFlameToadCipherRotationBBG;
    static std::uint16_t                            mFlameToadCipherRotationBBH;
    static std::uint16_t                            mFlameToadCipherRotationBBI;
    static std::uint16_t                            mFlameToadCipherRotationBBJ;
    static std::uint16_t                            mFlameToadCipherRotationBBK;
    static std::uint16_t                            mFlameToadCipherRotationBBL;
    static std::uint16_t                            mFlameToadCipherRotationBBM;
    static std::uint16_t                            mFlameToadCipherRotationBBN;
    static std::uint16_t                            mFlameToadCipherRotationBBO;
    static std::uint16_t                            mFlameToadCipherRotationBBP;
    static std::uint16_t                            mFlameToadCipherRotationBCA;
    static std::uint16_t                            mFlameToadCipherRotationBCB;
    static std::uint16_t                            mFlameToadCipherRotationBCC;
    static std::uint16_t                            mFlameToadCipherRotationBCD;
    static std::uint16_t                            mFlameToadCipherRotationBCE;
    static std::uint16_t                            mFlameToadCipherRotationBCF;
    static std::uint16_t                            mFlameToadCipherRotationBCG;
    static std::uint16_t                            mFlameToadCipherRotationBCH;
    static std::uint16_t                            mFlameToadCipherRotationBCI;
    static std::uint16_t                            mFlameToadCipherRotationBCJ;
    static std::uint16_t                            mFlameToadCipherRotationBCK;
    static std::uint16_t                            mFlameToadCipherRotationBCL;
    static std::uint16_t                            mFlameToadCipherRotationBCM;
    static std::uint16_t                            mFlameToadCipherRotationBCN;
    static std::uint16_t                            mFlameToadCipherRotationBCO;
    static std::uint16_t                            mFlameToadCipherRotationBCP;
    static std::uint16_t                            mFlameToadCipherRotationBDA;
    static std::uint16_t                            mFlameToadCipherRotationBDB;
    static std::uint16_t                            mFlameToadCipherRotationBDC;
    static std::uint16_t                            mFlameToadCipherRotationBDD;
    static std::uint16_t                            mFlameToadCipherRotationBDE;
    static std::uint16_t                            mFlameToadCipherRotationBDF;
    static std::uint16_t                            mFlameToadCipherRotationBDG;
    static std::uint16_t                            mFlameToadCipherRotationBDH;
    static std::uint16_t                            mFlameToadCipherRotationBDI;
    static std::uint16_t                            mFlameToadCipherRotationBDJ;
    static std::uint16_t                            mFlameToadCipherRotationBDK;
    static std::uint16_t                            mFlameToadCipherRotationBDL;
    static std::uint16_t                            mFlameToadCipherRotationBDM;
    static std::uint16_t                            mFlameToadCipherRotationBDN;
    static std::uint16_t                            mFlameToadCipherRotationBDO;
    static std::uint16_t                            mFlameToadCipherRotationBDP;

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

    // A/B belong to layer 0, C/D to layer 1, through O/P on layer 7.
    // Keep the word inputs separate so their random positions can change independently.
    static std::uint64_t                            mFreeRotationWordA;
    static std::uint64_t                            mFreeRotationWordB;
    static std::uint64_t                            mFreeRotationWordC;
    static std::uint64_t                            mFreeRotationWordD;
    static std::uint64_t                            mFreeRotationWordE;
    static std::uint64_t                            mFreeRotationWordF;
    static std::uint64_t                            mFreeRotationWordG;
    static std::uint64_t                            mFreeRotationWordH;
    static std::uint64_t                            mFreeRotationWordI;
    static std::uint64_t                            mFreeRotationWordJ;
    static std::uint64_t                            mFreeRotationWordK;
    static std::uint64_t                            mFreeRotationWordL;
    static std::uint64_t                            mFreeRotationWordM;
    static std::uint64_t                            mFreeRotationWordN;
    static std::uint64_t                            mFreeRotationWordO;
    static std::uint64_t                            mFreeRotationWordP;

    // Final byte shifts: AA..AH for round A, BA..BH for round B.
    // Consecutive pairs feed each layer; pack chunks retain only window indices.
    static std::int32_t                             mShiftMaskedCipherRotationAA;
    static std::int32_t                             mShiftMaskedCipherRotationAB;
    static std::int32_t                             mShiftMaskedCipherRotationAC;
    static std::int32_t                             mShiftMaskedCipherRotationAD;
    static std::int32_t                             mShiftMaskedCipherRotationAE;
    static std::int32_t                             mShiftMaskedCipherRotationAF;
    static std::int32_t                             mShiftMaskedCipherRotationAG;
    static std::int32_t                             mShiftMaskedCipherRotationAH;
    static std::int32_t                             mShiftMaskedCipherRotationBA;
    static std::int32_t                             mShiftMaskedCipherRotationBB;
    static std::int32_t                             mShiftMaskedCipherRotationBC;
    static std::int32_t                             mShiftMaskedCipherRotationBD;
    static std::int32_t                             mShiftMaskedCipherRotationBE;
    static std::int32_t                             mShiftMaskedCipherRotationBF;
    static std::int32_t                             mShiftMaskedCipherRotationBG;
    static std::int32_t                             mShiftMaskedCipherRotationBH;

    // One data-only two-plane pack, populated by eighteen eight-value jobs.
    // Each base keeps its permutation across the 38 seed generations.
    static std::uint16_t                            mWindowRotationBase[WindowRotationFarm::kJobCount][WindowRotationFarm::kWindowCount];
    static std::size_t                              mWindowRotationAvailable[WindowRotationFarm::kJobCount];
    static std::size_t                              mWindowRotationShuffleBytes[WindowRotationFarm::kJobCount];
    static std::size_t                              mRandomShuffleGeneration;
    static void                                     ShuffleCROWUnit(std::uint16_t (&pRotationList)[WindowRotationFarm::kWindowCount],
                                                                    std::uint64_t &pBitPlaneWordA,
                                                                    std::uint64_t &pBitPlaneWordB,
                                                                    std::uint64_t &pBitPlaneWordC,
                                                                    std::size_t pRotationIndex,
                                                                    std::size_t pOffset);
    
    
    //static std::int32_t                             mWindowRotationListA[16384];
    
    
    static WindowRotationPack                       mWindowRotationPack;
    static WindowRotationFarm::Buffers              mWindowRotationFarmBuffers;
    static WindowRotationFarm::Statistics           mWindowRotationFarmStatistics[WindowRotationFarm::kJobCount];

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
