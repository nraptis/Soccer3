#include "Soccer3.hpp"

BitPlane                    Soccer3::mBitPlane{};
std::uint64_t               Soccer3::mBitPlaneWordA = 0U;
std::uint64_t               Soccer3::mBitPlaneWordB = 0U;
std::uint64_t               Soccer3::mBitPlaneWordC = 0U;
std::uint64_t               Soccer3::mFreeRotationWordA = 0U;
std::uint64_t               Soccer3::mFreeRotationWordB = 0U;
std::uint64_t               Soccer3::mFreeRotationWordC = 0U;
std::uint64_t               Soccer3::mFreeRotationWordD = 0U;
std::uint64_t               Soccer3::mFreeRotationWordE = 0U;
std::uint64_t               Soccer3::mFreeRotationWordF = 0U;
std::uint64_t               Soccer3::mFreeRotationWordG = 0U;
std::uint64_t               Soccer3::mFreeRotationWordH = 0U;
std::uint64_t               Soccer3::mFreeRotationWordI = 0U;
std::uint64_t               Soccer3::mFreeRotationWordJ = 0U;
std::uint64_t               Soccer3::mFreeRotationWordK = 0U;
std::uint64_t               Soccer3::mFreeRotationWordL = 0U;
std::uint64_t               Soccer3::mFreeRotationWordM = 0U;
std::uint64_t               Soccer3::mFreeRotationWordN = 0U;
std::uint64_t               Soccer3::mFreeRotationWordO = 0U;
std::uint64_t               Soccer3::mFreeRotationWordP = 0U;
std::int32_t                Soccer3::mShiftMaskedCipherRotationAA = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationAB = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationAC = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationAD = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationAE = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationAF = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationAG = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationAH = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationBA = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationBB = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationBC = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationBD = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationBE = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationBF = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationBG = 0;
std::int32_t                Soccer3::mShiftMaskedCipherRotationBH = 0;
WindowRotationPack          Soccer3::mWindowRotationPack{};
Cryptex                     Soccer3::mCryptex;
bool                        Soccer3::mEncryptionReady = false;
std::size_t                 Soccer3::mMaterialIndex = 0;

// These values are populated after farming and read directly by Cryptex::Build.
std::uint8_t                Soccer3::mBitRowAA = 0U;
std::uint8_t                Soccer3::mBitRowAB = 0U;
std::uint8_t                Soccer3::mBitRowAC = 0U;
std::uint8_t                Soccer3::mBitRowAD = 0U;
std::uint8_t                Soccer3::mBitRowAE = 0U;
std::uint8_t                Soccer3::mBitRowAF = 0U;
std::uint8_t                Soccer3::mBitRowAG = 0U;
std::uint8_t                Soccer3::mBitRowAH = 0U;
std::uint8_t                Soccer3::mBitRowBA = 0U;
std::uint8_t                Soccer3::mBitRowBB = 0U;
std::uint8_t                Soccer3::mBitRowBC = 0U;
std::uint8_t                Soccer3::mBitRowBD = 0U;
std::uint8_t                Soccer3::mBitRowBE = 0U;
std::uint8_t                Soccer3::mBitRowBF = 0U;
std::uint8_t                Soccer3::mBitRowBG = 0U;
std::uint8_t                Soccer3::mBitRowBH = 0U;
std::uint8_t                Soccer3::mBitRowCA = 0U;
std::uint8_t                Soccer3::mBitRowCB = 0U;
std::uint8_t                Soccer3::mBitRowCC = 0U;
std::uint8_t                Soccer3::mBitRowCD = 0U;
std::uint8_t                Soccer3::mBitRowCE = 0U;
std::uint8_t                Soccer3::mBitRowCF = 0U;
std::uint8_t                Soccer3::mBitRowCG = 0U;
std::uint8_t                Soccer3::mBitRowCH = 0U;
std::uint8_t                Soccer3::mBitRowDA = 0U;
std::uint8_t                Soccer3::mBitRowDB = 0U;
std::uint8_t                Soccer3::mBitRowDC = 0U;
std::uint8_t                Soccer3::mBitRowDD = 0U;
std::uint8_t                Soccer3::mBitRowDE = 0U;
std::uint8_t                Soccer3::mBitRowDF = 0U;
std::uint8_t                Soccer3::mBitRowDG = 0U;
std::uint8_t                Soccer3::mBitRowDH = 0U;
std::uint8_t                Soccer3::mRotationMaskA = 0U;
std::uint8_t                Soccer3::mRotationMaskB = 0U;
std::uint8_t                Soccer3::mRotationMaskC = 0U;
std::uint8_t                Soccer3::mRotationMaskD = 0U;
std::uint8_t                Soccer3::mRotationMaskE = 0U;
std::uint8_t                Soccer3::mRotationMaskF = 0U;
std::uint8_t                Soccer3::mRotationMaskG = 0U;
std::uint8_t                Soccer3::mRotationMaskH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAA = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAB = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAC = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAD = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAE = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAF = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAG = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAI = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAJ = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAK = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAL = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAM = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAN = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAO = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationAAP = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABA = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABB = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABC = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABD = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABE = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABF = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABG = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABI = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABJ = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABK = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABL = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABM = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABN = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABO = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationABP = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACA = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACB = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACC = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACD = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACE = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACF = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACG = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACI = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACJ = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACK = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACL = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACM = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACN = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACO = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationACP = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADA = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADB = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADC = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADD = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADE = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADF = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADG = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADI = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADJ = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADK = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADL = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADM = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADN = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADO = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationADP = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAA = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAB = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAC = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAD = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAE = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAF = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAG = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAI = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAJ = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAK = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAL = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAM = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAN = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAO = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBAP = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBA = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBB = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBC = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBD = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBE = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBF = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBG = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBI = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBJ = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBK = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBL = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBM = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBN = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBO = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBBP = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCA = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCB = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCC = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCD = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCE = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCF = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCG = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCI = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCJ = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCK = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCL = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCM = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCN = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCO = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBCP = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDA = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDB = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDC = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDD = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDE = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDF = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDG = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDH = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDI = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDJ = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDK = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDL = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDM = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDN = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDO = 0U;
std::uint16_t               Soccer3::mFlameToadCipherRotationBDP = 0U;
const std::uint8_t *        Soccer3::mMutateMaterialA = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialB = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialC = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialD = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialE = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialF = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialG = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialH = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialI = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialJ = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialK = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialL = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialM = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialN = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialO = nullptr;
const std::uint8_t *        Soccer3::mMutateMaterialP = nullptr;
std::uint8_t *              Soccer3::mPackedRows = nullptr;
std::size_t                 Soccer3::mPackedRowLength = 0U;

bool                        Soccer3::ValidateCryptexInputs(EncryptionStrength pStrength) {
    BitPlane aPlane{};
    aPlane.SetRow(0U, BitPlaneRow{{{mBitRowAA, mBitRowAB}, {mBitRowAC, mBitRowAD}, {mBitRowAE, mBitRowAF}, {mBitRowAG, mBitRowAH}}});
    aPlane.SetRow(1U, BitPlaneRow{{{mBitRowBA, mBitRowBB}, {mBitRowBC, mBitRowBD}, {mBitRowBE, mBitRowBF}, {mBitRowBG, mBitRowBH}}});
    aPlane.SetRow(2U, BitPlaneRow{{{mBitRowCA, mBitRowCB}, {mBitRowCC, mBitRowCD}, {mBitRowCE, mBitRowCF}, {mBitRowCG, mBitRowCH}}});
    aPlane.SetRow(3U, BitPlaneRow{{{mBitRowDA, mBitRowDB}, {mBitRowDC, mBitRowDD}, {mBitRowDE, mBitRowDF}, {mBitRowDG, mBitRowDH}}});
    if (!aPlane.IsValid()) return false;
    const std::uint8_t aMasks[] = {mRotationMaskA, mRotationMaskB, mRotationMaskC, mRotationMaskD, mRotationMaskE, mRotationMaskF, mRotationMaskG, mRotationMaskH};
    for (std::size_t aLayer = 0U; aLayer < 4U; ++aLayer) {
        std::uint8_t aFirst = 0U, aSecond = 0U;
        for (const auto &aPair : aPlane.GetRow(aLayer % 4U).mPairs) {
            aFirst |= static_cast<std::uint8_t>(1U << aPair.mBitA);
            aSecond |= static_cast<std::uint8_t>(1U << aPair.mBitB);
        }
        if (aMasks[2U * aLayer] != aFirst || aMasks[2U * aLayer + 1U] != aSecond) return false;
    }
    const std::int32_t aFreeRotations[WindowRotationFarm::kFreeRotationCount] = {
        mShiftMaskedCipherRotationAA, mShiftMaskedCipherRotationAB, mShiftMaskedCipherRotationAC, mShiftMaskedCipherRotationAD,
        mShiftMaskedCipherRotationAE, mShiftMaskedCipherRotationAF, mShiftMaskedCipherRotationAG, mShiftMaskedCipherRotationAH,
        mShiftMaskedCipherRotationBA, mShiftMaskedCipherRotationBB, mShiftMaskedCipherRotationBC, mShiftMaskedCipherRotationBD,
        mShiftMaskedCipherRotationBE, mShiftMaskedCipherRotationBF, mShiftMaskedCipherRotationBG, mShiftMaskedCipherRotationBH
    };
    for (const auto aRotation : aFreeRotations)
        if (aRotation <= 0 || aRotation >= static_cast<std::int32_t>(SOCCER_BLOCK_SIZE)) return false;
    WindowRotationPack aRotations{};
    aRotations.mPlaneA.mChunkA = {static_cast<std::uint16_t>(mShiftMaskedCipherRotationAA / 64), static_cast<std::uint16_t>(mShiftMaskedCipherRotationAB / 64),
        mFlameToadCipherRotationAAA, mFlameToadCipherRotationAAB, mFlameToadCipherRotationAAC, mFlameToadCipherRotationAAD, mFlameToadCipherRotationAAE, mFlameToadCipherRotationAAF, mFlameToadCipherRotationAAG, mFlameToadCipherRotationAAH, mFlameToadCipherRotationAAI, mFlameToadCipherRotationAAJ, mFlameToadCipherRotationAAK, mFlameToadCipherRotationAAL, mFlameToadCipherRotationAAM, mFlameToadCipherRotationAAN, mFlameToadCipherRotationAAO, mFlameToadCipherRotationAAP};
    aRotations.mPlaneA.mChunkB = {static_cast<std::uint16_t>(mShiftMaskedCipherRotationAC / 64), static_cast<std::uint16_t>(mShiftMaskedCipherRotationAD / 64),
        mFlameToadCipherRotationABA, mFlameToadCipherRotationABB, mFlameToadCipherRotationABC, mFlameToadCipherRotationABD, mFlameToadCipherRotationABE, mFlameToadCipherRotationABF, mFlameToadCipherRotationABG, mFlameToadCipherRotationABH, mFlameToadCipherRotationABI, mFlameToadCipherRotationABJ, mFlameToadCipherRotationABK, mFlameToadCipherRotationABL, mFlameToadCipherRotationABM, mFlameToadCipherRotationABN, mFlameToadCipherRotationABO, mFlameToadCipherRotationABP};
    aRotations.mPlaneA.mChunkC = {static_cast<std::uint16_t>(mShiftMaskedCipherRotationAE / 64), static_cast<std::uint16_t>(mShiftMaskedCipherRotationAF / 64),
        mFlameToadCipherRotationACA, mFlameToadCipherRotationACB, mFlameToadCipherRotationACC, mFlameToadCipherRotationACD, mFlameToadCipherRotationACE, mFlameToadCipherRotationACF, mFlameToadCipherRotationACG, mFlameToadCipherRotationACH, mFlameToadCipherRotationACI, mFlameToadCipherRotationACJ, mFlameToadCipherRotationACK, mFlameToadCipherRotationACL, mFlameToadCipherRotationACM, mFlameToadCipherRotationACN, mFlameToadCipherRotationACO, mFlameToadCipherRotationACP};
    aRotations.mPlaneA.mChunkD = {static_cast<std::uint16_t>(mShiftMaskedCipherRotationAG / 64), static_cast<std::uint16_t>(mShiftMaskedCipherRotationAH / 64),
        mFlameToadCipherRotationADA, mFlameToadCipherRotationADB, mFlameToadCipherRotationADC, mFlameToadCipherRotationADD, mFlameToadCipherRotationADE, mFlameToadCipherRotationADF, mFlameToadCipherRotationADG, mFlameToadCipherRotationADH, mFlameToadCipherRotationADI, mFlameToadCipherRotationADJ, mFlameToadCipherRotationADK, mFlameToadCipherRotationADL, mFlameToadCipherRotationADM, mFlameToadCipherRotationADN, mFlameToadCipherRotationADO, mFlameToadCipherRotationADP};
    aRotations.mPlaneB.mChunkA = {static_cast<std::uint16_t>(mShiftMaskedCipherRotationBA / 64), static_cast<std::uint16_t>(mShiftMaskedCipherRotationBB / 64),
        mFlameToadCipherRotationBAA, mFlameToadCipherRotationBAB, mFlameToadCipherRotationBAC, mFlameToadCipherRotationBAD, mFlameToadCipherRotationBAE, mFlameToadCipherRotationBAF, mFlameToadCipherRotationBAG, mFlameToadCipherRotationBAH, mFlameToadCipherRotationBAI, mFlameToadCipherRotationBAJ, mFlameToadCipherRotationBAK, mFlameToadCipherRotationBAL, mFlameToadCipherRotationBAM, mFlameToadCipherRotationBAN, mFlameToadCipherRotationBAO, mFlameToadCipherRotationBAP};
    aRotations.mPlaneB.mChunkB = {static_cast<std::uint16_t>(mShiftMaskedCipherRotationBC / 64), static_cast<std::uint16_t>(mShiftMaskedCipherRotationBD / 64),
        mFlameToadCipherRotationBBA, mFlameToadCipherRotationBBB, mFlameToadCipherRotationBBC, mFlameToadCipherRotationBBD, mFlameToadCipherRotationBBE, mFlameToadCipherRotationBBF, mFlameToadCipherRotationBBG, mFlameToadCipherRotationBBH, mFlameToadCipherRotationBBI, mFlameToadCipherRotationBBJ, mFlameToadCipherRotationBBK, mFlameToadCipherRotationBBL, mFlameToadCipherRotationBBM, mFlameToadCipherRotationBBN, mFlameToadCipherRotationBBO, mFlameToadCipherRotationBBP};
    aRotations.mPlaneB.mChunkC = {static_cast<std::uint16_t>(mShiftMaskedCipherRotationBE / 64), static_cast<std::uint16_t>(mShiftMaskedCipherRotationBF / 64),
        mFlameToadCipherRotationBCA, mFlameToadCipherRotationBCB, mFlameToadCipherRotationBCC, mFlameToadCipherRotationBCD, mFlameToadCipherRotationBCE, mFlameToadCipherRotationBCF, mFlameToadCipherRotationBCG, mFlameToadCipherRotationBCH, mFlameToadCipherRotationBCI, mFlameToadCipherRotationBCJ, mFlameToadCipherRotationBCK, mFlameToadCipherRotationBCL, mFlameToadCipherRotationBCM, mFlameToadCipherRotationBCN, mFlameToadCipherRotationBCO, mFlameToadCipherRotationBCP};
    aRotations.mPlaneB.mChunkD = {static_cast<std::uint16_t>(mShiftMaskedCipherRotationBG / 64), static_cast<std::uint16_t>(mShiftMaskedCipherRotationBH / 64),
        mFlameToadCipherRotationBDA, mFlameToadCipherRotationBDB, mFlameToadCipherRotationBDC, mFlameToadCipherRotationBDD, mFlameToadCipherRotationBDE, mFlameToadCipherRotationBDF, mFlameToadCipherRotationBDG, mFlameToadCipherRotationBDH, mFlameToadCipherRotationBDI, mFlameToadCipherRotationBDJ, mFlameToadCipherRotationBDK, mFlameToadCipherRotationBDL, mFlameToadCipherRotationBDM, mFlameToadCipherRotationBDN, mFlameToadCipherRotationBDO, mFlameToadCipherRotationBDP};
    if (!WindowRotationFarm::IsValid(aRotations, aFreeRotations)) return false;
    if (mPackedRows == nullptr || mPackedRowLength < SOCCER_BLOCK_SIZE / 4U) return false;
    const std::uint8_t *aMaterials[] = {mMutateMaterialA, mMutateMaterialB, mMutateMaterialC, mMutateMaterialD, mMutateMaterialE, mMutateMaterialF, mMutateMaterialG, mMutateMaterialH, mMutateMaterialI, mMutateMaterialJ, mMutateMaterialK, mMutateMaterialL, mMutateMaterialM, mMutateMaterialN, mMutateMaterialO, mMutateMaterialP};
    const std::size_t aMaterialCount = pStrength == EncryptionStrength::kWeak ? 4U :
                                     pStrength == EncryptionStrength::kStrong ? 16U : 8U;
    const auto aCache = reinterpret_cast<std::uintptr_t>(mPackedRows);
    for (std::size_t aIndex = 0U; aIndex < aMaterialCount; ++aIndex) {
        if (aMaterials[aIndex] == nullptr) return false;
        const auto aMaterial = reinterpret_cast<std::uintptr_t>(aMaterials[aIndex]);
        if (aCache <= aMaterial ? aMaterial - aCache < SOCCER_BLOCK_SIZE / 4U
                               : aCache - aMaterial < SOCCER_BLOCK_SIZE) return false;
    }
    return true;
}
