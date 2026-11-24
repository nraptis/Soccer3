#include "Soccer3.hpp"

std::uint32_t Soccer3::ShiftMaskedByteOffset(std::uint64_t pWord) {
    return static_cast<std::uint32_t>(1U + 2U * (pWord % 32U));
}

BitPlane                    Soccer3::mBitPlane{};
std::uint64_t               Soccer3::mBitPlaneWordA = 0U;
std::uint64_t               Soccer3::mBitPlaneWordB = 0U;
std::uint64_t               Soccer3::mBitPlaneWordC = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordAALeft = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordAARight = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordABLeft = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordABRight = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordACLeft = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordACRight = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordADLeft = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordADRight = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordBALeft = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordBARight = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordBBLeft = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordBBRight = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordBCLeft = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordBCRight = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordBDLeft = 0U;
std::uint64_t               Soccer3::mShiftMaskedRotationWordBDRight = 0U;
Soccer3::PlaneShift         Soccer3::mPlaneShiftAALeft{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftAARight{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftABLeft{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftABRight{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftACLeft{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftACRight{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftADLeft{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftADRight{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftBALeft{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftBARight{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftBBLeft{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftBBRight{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftBCLeft{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftBCRight{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftBDLeft{};
Soccer3::PlaneShift         Soccer3::mPlaneShiftBDRight{};
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
std::uint16_t               Soccer3::mToadCipherRotationAALeftA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAALeftB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAALeftC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAALeftD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAALeftE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAALeftF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAALeftG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAALeftH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAARightA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAARightB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAARightC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAARightD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAARightE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAARightF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAARightG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationAARightH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABLeftA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABLeftB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABLeftC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABLeftD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABLeftE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABLeftF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABLeftG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABLeftH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABRightA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABRightB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABRightC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABRightD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABRightE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABRightF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABRightG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationABRightH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACLeftA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACLeftB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACLeftC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACLeftD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACLeftE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACLeftF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACLeftG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACLeftH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACRightA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACRightB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACRightC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACRightD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACRightE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACRightF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACRightG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationACRightH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADLeftA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADLeftB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADLeftC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADLeftD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADLeftE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADLeftF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADLeftG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADLeftH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADRightA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADRightB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADRightC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADRightD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADRightE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADRightF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADRightG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationADRightH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBALeftA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBALeftB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBALeftC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBALeftD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBALeftE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBALeftF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBALeftG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBALeftH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBARightA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBARightB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBARightC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBARightD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBARightE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBARightF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBARightG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBARightH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBLeftA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBLeftB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBLeftC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBLeftD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBLeftE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBLeftF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBLeftG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBLeftH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBRightA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBRightB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBRightC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBRightD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBRightE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBRightF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBRightG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBBRightH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCLeftA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCLeftB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCLeftC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCLeftD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCLeftE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCLeftF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCLeftG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCLeftH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCRightA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCRightB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCRightC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCRightD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCRightE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCRightF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCRightG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBCRightH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDLeftA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDLeftB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDLeftC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDLeftD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDLeftE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDLeftF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDLeftG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDLeftH = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDRightA = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDRightB = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDRightC = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDRightD = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDRightE = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDRightF = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDRightG = 0U;
std::uint16_t               Soccer3::mToadCipherRotationBDRightH = 0U;
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
    const PlaneShift aPlaneShifts[2][kRotationsPerList] = {
        {
            mPlaneShiftAALeft,
            mPlaneShiftABLeft,
            mPlaneShiftACLeft,
            mPlaneShiftADLeft,
            mPlaneShiftBALeft,
            mPlaneShiftBBLeft,
            mPlaneShiftBCLeft,
            mPlaneShiftBDLeft,
        },
        {
            mPlaneShiftAARight,
            mPlaneShiftABRight,
            mPlaneShiftACRight,
            mPlaneShiftADRight,
            mPlaneShiftBARight,
            mPlaneShiftBBRight,
            mPlaneShiftBCRight,
            mPlaneShiftBDRight,
        },
    };
    const std::uint8_t aRowPairs[kRotationsPerList][4] = {
        {mBitRowAA, mBitRowAC, mBitRowAE, mBitRowAG},
        {mBitRowAB, mBitRowAD, mBitRowAF, mBitRowAH},
        {mBitRowAA, mBitRowAE, mBitRowAC, mBitRowAG},
        {mBitRowAB, mBitRowAF, mBitRowAD, mBitRowAH},
        {mBitRowAA, mBitRowAD, mBitRowAE, mBitRowAH},
        {mBitRowAB, mBitRowAC, mBitRowAF, mBitRowAG},
        {mBitRowAA, mBitRowAF, mBitRowAC, mBitRowAH},
        {mBitRowAB, mBitRowAE, mBitRowAD, mBitRowAG},
    };
    for (std::size_t aLayer = 0U; aLayer < kRotationsPerList; ++aLayer) {
        for (std::size_t aSide = 0U; aSide < 2U; ++aSide) {
            const auto aMask = static_cast<std::uint8_t>(
                (1U << aRowPairs[aLayer][2U * aSide]) | (1U << aRowPairs[aLayer][2U * aSide + 1U]));
            if (aPlaneShifts[aSide][aLayer].mMask != aMask) return false;
        }
    }
    const std::uint16_t aWindowRotations[kRotationListCount][kRotationsPerList] = {
        {
            mShiftMaskedRotationListChosenA[0], mShiftMaskedRotationListChosenA[1],
            mShiftMaskedRotationListChosenA[2], mShiftMaskedRotationListChosenA[3],
            mShiftMaskedRotationListChosenA[4], mShiftMaskedRotationListChosenA[5],
            mShiftMaskedRotationListChosenA[6], mShiftMaskedRotationListChosenA[7],
        },
        {
            mShiftMaskedRotationListChosenB[0], mShiftMaskedRotationListChosenB[1],
            mShiftMaskedRotationListChosenB[2], mShiftMaskedRotationListChosenB[3],
            mShiftMaskedRotationListChosenB[4], mShiftMaskedRotationListChosenB[5],
            mShiftMaskedRotationListChosenB[6], mShiftMaskedRotationListChosenB[7],
        },
        {
            mToadCipherRotationAALeftA, mToadCipherRotationAALeftB,
            mToadCipherRotationAALeftC, mToadCipherRotationAALeftD,
            mToadCipherRotationAALeftE, mToadCipherRotationAALeftF,
            mToadCipherRotationAALeftG, mToadCipherRotationAALeftH
        },
        {
            mToadCipherRotationAARightA, mToadCipherRotationAARightB,
            mToadCipherRotationAARightC, mToadCipherRotationAARightD,
            mToadCipherRotationAARightE, mToadCipherRotationAARightF,
            mToadCipherRotationAARightG, mToadCipherRotationAARightH
        },
        {
            mToadCipherRotationABLeftA, mToadCipherRotationABLeftB,
            mToadCipherRotationABLeftC, mToadCipherRotationABLeftD,
            mToadCipherRotationABLeftE, mToadCipherRotationABLeftF,
            mToadCipherRotationABLeftG, mToadCipherRotationABLeftH
        },
        {
            mToadCipherRotationABRightA, mToadCipherRotationABRightB,
            mToadCipherRotationABRightC, mToadCipherRotationABRightD,
            mToadCipherRotationABRightE, mToadCipherRotationABRightF,
            mToadCipherRotationABRightG, mToadCipherRotationABRightH
        },
        {
            mToadCipherRotationACLeftA, mToadCipherRotationACLeftB,
            mToadCipherRotationACLeftC, mToadCipherRotationACLeftD,
            mToadCipherRotationACLeftE, mToadCipherRotationACLeftF,
            mToadCipherRotationACLeftG, mToadCipherRotationACLeftH
        },
        {
            mToadCipherRotationACRightA, mToadCipherRotationACRightB,
            mToadCipherRotationACRightC, mToadCipherRotationACRightD,
            mToadCipherRotationACRightE, mToadCipherRotationACRightF,
            mToadCipherRotationACRightG, mToadCipherRotationACRightH
        },
        {
            mToadCipherRotationADLeftA, mToadCipherRotationADLeftB,
            mToadCipherRotationADLeftC, mToadCipherRotationADLeftD,
            mToadCipherRotationADLeftE, mToadCipherRotationADLeftF,
            mToadCipherRotationADLeftG, mToadCipherRotationADLeftH
        },
        {
            mToadCipherRotationADRightA, mToadCipherRotationADRightB,
            mToadCipherRotationADRightC, mToadCipherRotationADRightD,
            mToadCipherRotationADRightE, mToadCipherRotationADRightF,
            mToadCipherRotationADRightG, mToadCipherRotationADRightH
        },
        {
            mToadCipherRotationBALeftA, mToadCipherRotationBALeftB,
            mToadCipherRotationBALeftC, mToadCipherRotationBALeftD,
            mToadCipherRotationBALeftE, mToadCipherRotationBALeftF,
            mToadCipherRotationBALeftG, mToadCipherRotationBALeftH
        },
        {
            mToadCipherRotationBARightA, mToadCipherRotationBARightB,
            mToadCipherRotationBARightC, mToadCipherRotationBARightD,
            mToadCipherRotationBARightE, mToadCipherRotationBARightF,
            mToadCipherRotationBARightG, mToadCipherRotationBARightH
        },
        {
            mToadCipherRotationBBLeftA, mToadCipherRotationBBLeftB,
            mToadCipherRotationBBLeftC, mToadCipherRotationBBLeftD,
            mToadCipherRotationBBLeftE, mToadCipherRotationBBLeftF,
            mToadCipherRotationBBLeftG, mToadCipherRotationBBLeftH
        },
        {
            mToadCipherRotationBBRightA, mToadCipherRotationBBRightB,
            mToadCipherRotationBBRightC, mToadCipherRotationBBRightD,
            mToadCipherRotationBBRightE, mToadCipherRotationBBRightF,
            mToadCipherRotationBBRightG, mToadCipherRotationBBRightH
        },
        {
            mToadCipherRotationBCLeftA, mToadCipherRotationBCLeftB,
            mToadCipherRotationBCLeftC, mToadCipherRotationBCLeftD,
            mToadCipherRotationBCLeftE, mToadCipherRotationBCLeftF,
            mToadCipherRotationBCLeftG, mToadCipherRotationBCLeftH
        },
        {
            mToadCipherRotationBCRightA, mToadCipherRotationBCRightB,
            mToadCipherRotationBCRightC, mToadCipherRotationBCRightD,
            mToadCipherRotationBCRightE, mToadCipherRotationBCRightF,
            mToadCipherRotationBCRightG, mToadCipherRotationBCRightH
        },
        {
            mToadCipherRotationBDLeftA, mToadCipherRotationBDLeftB,
            mToadCipherRotationBDLeftC, mToadCipherRotationBDLeftD,
            mToadCipherRotationBDLeftE, mToadCipherRotationBDLeftF,
            mToadCipherRotationBDLeftG, mToadCipherRotationBDLeftH
        },
        {
            mToadCipherRotationBDRightA, mToadCipherRotationBDRightB,
            mToadCipherRotationBDRightC, mToadCipherRotationBDRightD,
            mToadCipherRotationBDRightE, mToadCipherRotationBDRightF,
            mToadCipherRotationBDRightG, mToadCipherRotationBDRightH
        },
    };
    bool aSingleBlocked[kRotationWindowCount] = {};
    aSingleBlocked[0U] = true;
    aSingleBlocked[kRotationWindowCount / 2U] = true;
    for (std::size_t aList = 0U; aList < kRotationListCount; ++aList) {
        const bool aMasked = aList < 2U;
        for (std::size_t aIndex = 0U; aIndex < kRotationsPerList; ++aIndex) {
            const std::size_t aWindow = aWindowRotations[aList][aIndex];
            if (aWindow >= kRotationWindowCount || aSingleBlocked[aWindow]) return false;
            if (aMasked) {
                const auto aShift = aPlaneShifts[aList][aIndex].mRotation;
                if (aShift == 0U || aShift >= SOCCER_BLOCK_SIZE ||
                    (aShift & 1) == 0 || aShift / kRotationWindowBytes != aWindow) return false;
            }
            aSingleBlocked[aWindow] = true;
            aSingleBlocked[kRotationWindowCount - aWindow] = true;
            if (aMasked) aSingleBlocked[kRotationWindowCount - 1U - aWindow] = true;
        }
        // Independently enumerate every subset instead of reusing the selector's
        // difference-blocking algorithm. Include the empty sum to detect zero sums.
        bool aSeenWindows[kRotationWindowCount] = {};
        std::uint32_t aByteSums[1U << kRotationsPerList] = {};
        for (std::size_t aSubset = 0U; aSubset < (1U << kRotationsPerList); ++aSubset) {
            std::uint32_t aWindowSum = 0U, aByteSum = 0U;
            for (std::size_t aIndex = 0U; aIndex < kRotationsPerList; ++aIndex) {
                if ((aSubset & (1U << aIndex)) == 0U) continue;
                aWindowSum += aWindowRotations[aList][aIndex];
                if (aMasked) aByteSum += static_cast<std::uint32_t>(aPlaneShifts[aList][aIndex].mRotation);
            }
            aWindowSum %= kRotationWindowCount;
            if (aSeenWindows[aWindowSum]) return false;
            aSeenWindows[aWindowSum] = true;
            if (aMasked) {
                aByteSum %= SOCCER_BLOCK_SIZE;
                for (std::size_t aPrevious = 0U; aPrevious < aSubset; ++aPrevious)
                    if (aByteSum == aByteSums[aPrevious]) return false;
                aByteSums[aSubset] = aByteSum;
            }
        }
    }
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
    // One shared row labels all corvid pairs. Each side has its own farmed window and odd byte offset.
    mPlaneShiftAALeft = {
        static_cast<std::uint8_t>((1U << mBitRowAA) | (1U << mBitRowAC)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenA[0U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordAALeft)};
    mPlaneShiftAARight = {
        static_cast<std::uint8_t>((1U << mBitRowAE) | (1U << mBitRowAG)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenB[0U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordAARight)};
    mPlaneShiftABLeft = {
        static_cast<std::uint8_t>((1U << mBitRowAB) | (1U << mBitRowAD)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenA[1U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordABLeft)};
    mPlaneShiftABRight = {
        static_cast<std::uint8_t>((1U << mBitRowAF) | (1U << mBitRowAH)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenB[1U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordABRight)};
    mPlaneShiftACLeft = {
        static_cast<std::uint8_t>((1U << mBitRowAA) | (1U << mBitRowAE)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenA[2U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordACLeft)};
    mPlaneShiftACRight = {
        static_cast<std::uint8_t>((1U << mBitRowAC) | (1U << mBitRowAG)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenB[2U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordACRight)};
    mPlaneShiftADLeft = {
        static_cast<std::uint8_t>((1U << mBitRowAB) | (1U << mBitRowAF)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenA[3U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordADLeft)};
    mPlaneShiftADRight = {
        static_cast<std::uint8_t>((1U << mBitRowAD) | (1U << mBitRowAH)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenB[3U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordADRight)};
    mPlaneShiftBALeft = {
        static_cast<std::uint8_t>((1U << mBitRowAA) | (1U << mBitRowAD)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenA[4U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordBALeft)};
    mPlaneShiftBARight = {
        static_cast<std::uint8_t>((1U << mBitRowAE) | (1U << mBitRowAH)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenB[4U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordBARight)};
    mPlaneShiftBBLeft = {
        static_cast<std::uint8_t>((1U << mBitRowAB) | (1U << mBitRowAC)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenA[5U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordBBLeft)};
    mPlaneShiftBBRight = {
        static_cast<std::uint8_t>((1U << mBitRowAF) | (1U << mBitRowAG)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenB[5U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordBBRight)};
    mPlaneShiftBCLeft = {
        static_cast<std::uint8_t>((1U << mBitRowAA) | (1U << mBitRowAF)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenA[6U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordBCLeft)};
    mPlaneShiftBCRight = {
        static_cast<std::uint8_t>((1U << mBitRowAC) | (1U << mBitRowAH)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenB[6U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordBCRight)};
    mPlaneShiftBDLeft = {
        static_cast<std::uint8_t>((1U << mBitRowAB) | (1U << mBitRowAE)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenA[7U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordBDLeft)};
    mPlaneShiftBDRight = {
        static_cast<std::uint8_t>((1U << mBitRowAD) | (1U << mBitRowAG)),
        kRotationWindowBytes * mShiftMaskedRotationListChosenB[7U] +
            ShiftMaskedByteOffset(mShiftMaskedRotationWordBDRight)};

    mToadCipherRotationAALeftA = mFlameToadRotationListChosenAALeft[0U];
    mToadCipherRotationAALeftB = mFlameToadRotationListChosenAALeft[1U];
    mToadCipherRotationAALeftC = mFlameToadRotationListChosenAALeft[2U];
    mToadCipherRotationAALeftD = mFlameToadRotationListChosenAALeft[3U];
    mToadCipherRotationAALeftE = mFlameToadRotationListChosenAALeft[4U];
    mToadCipherRotationAALeftF = mFlameToadRotationListChosenAALeft[5U];
    mToadCipherRotationAALeftG = mFlameToadRotationListChosenAALeft[6U];
    mToadCipherRotationAALeftH = mFlameToadRotationListChosenAALeft[7U];
    mToadCipherRotationAARightA = mFlameToadRotationListChosenAARight[0U];
    mToadCipherRotationAARightB = mFlameToadRotationListChosenAARight[1U];
    mToadCipherRotationAARightC = mFlameToadRotationListChosenAARight[2U];
    mToadCipherRotationAARightD = mFlameToadRotationListChosenAARight[3U];
    mToadCipherRotationAARightE = mFlameToadRotationListChosenAARight[4U];
    mToadCipherRotationAARightF = mFlameToadRotationListChosenAARight[5U];
    mToadCipherRotationAARightG = mFlameToadRotationListChosenAARight[6U];
    mToadCipherRotationAARightH = mFlameToadRotationListChosenAARight[7U];
    mToadCipherRotationABLeftA = mFlameToadRotationListChosenABLeft[0U];
    mToadCipherRotationABLeftB = mFlameToadRotationListChosenABLeft[1U];
    mToadCipherRotationABLeftC = mFlameToadRotationListChosenABLeft[2U];
    mToadCipherRotationABLeftD = mFlameToadRotationListChosenABLeft[3U];
    mToadCipherRotationABLeftE = mFlameToadRotationListChosenABLeft[4U];
    mToadCipherRotationABLeftF = mFlameToadRotationListChosenABLeft[5U];
    mToadCipherRotationABLeftG = mFlameToadRotationListChosenABLeft[6U];
    mToadCipherRotationABLeftH = mFlameToadRotationListChosenABLeft[7U];
    mToadCipherRotationABRightA = mFlameToadRotationListChosenABRight[0U];
    mToadCipherRotationABRightB = mFlameToadRotationListChosenABRight[1U];
    mToadCipherRotationABRightC = mFlameToadRotationListChosenABRight[2U];
    mToadCipherRotationABRightD = mFlameToadRotationListChosenABRight[3U];
    mToadCipherRotationABRightE = mFlameToadRotationListChosenABRight[4U];
    mToadCipherRotationABRightF = mFlameToadRotationListChosenABRight[5U];
    mToadCipherRotationABRightG = mFlameToadRotationListChosenABRight[6U];
    mToadCipherRotationABRightH = mFlameToadRotationListChosenABRight[7U];
    mToadCipherRotationACLeftA = mFlameToadRotationListChosenACLeft[0U];
    mToadCipherRotationACLeftB = mFlameToadRotationListChosenACLeft[1U];
    mToadCipherRotationACLeftC = mFlameToadRotationListChosenACLeft[2U];
    mToadCipherRotationACLeftD = mFlameToadRotationListChosenACLeft[3U];
    mToadCipherRotationACLeftE = mFlameToadRotationListChosenACLeft[4U];
    mToadCipherRotationACLeftF = mFlameToadRotationListChosenACLeft[5U];
    mToadCipherRotationACLeftG = mFlameToadRotationListChosenACLeft[6U];
    mToadCipherRotationACLeftH = mFlameToadRotationListChosenACLeft[7U];
    mToadCipherRotationACRightA = mFlameToadRotationListChosenACRight[0U];
    mToadCipherRotationACRightB = mFlameToadRotationListChosenACRight[1U];
    mToadCipherRotationACRightC = mFlameToadRotationListChosenACRight[2U];
    mToadCipherRotationACRightD = mFlameToadRotationListChosenACRight[3U];
    mToadCipherRotationACRightE = mFlameToadRotationListChosenACRight[4U];
    mToadCipherRotationACRightF = mFlameToadRotationListChosenACRight[5U];
    mToadCipherRotationACRightG = mFlameToadRotationListChosenACRight[6U];
    mToadCipherRotationACRightH = mFlameToadRotationListChosenACRight[7U];
    mToadCipherRotationADLeftA = mFlameToadRotationListChosenADLeft[0U];
    mToadCipherRotationADLeftB = mFlameToadRotationListChosenADLeft[1U];
    mToadCipherRotationADLeftC = mFlameToadRotationListChosenADLeft[2U];
    mToadCipherRotationADLeftD = mFlameToadRotationListChosenADLeft[3U];
    mToadCipherRotationADLeftE = mFlameToadRotationListChosenADLeft[4U];
    mToadCipherRotationADLeftF = mFlameToadRotationListChosenADLeft[5U];
    mToadCipherRotationADLeftG = mFlameToadRotationListChosenADLeft[6U];
    mToadCipherRotationADLeftH = mFlameToadRotationListChosenADLeft[7U];
    mToadCipherRotationADRightA = mFlameToadRotationListChosenADRight[0U];
    mToadCipherRotationADRightB = mFlameToadRotationListChosenADRight[1U];
    mToadCipherRotationADRightC = mFlameToadRotationListChosenADRight[2U];
    mToadCipherRotationADRightD = mFlameToadRotationListChosenADRight[3U];
    mToadCipherRotationADRightE = mFlameToadRotationListChosenADRight[4U];
    mToadCipherRotationADRightF = mFlameToadRotationListChosenADRight[5U];
    mToadCipherRotationADRightG = mFlameToadRotationListChosenADRight[6U];
    mToadCipherRotationADRightH = mFlameToadRotationListChosenADRight[7U];
    mToadCipherRotationBALeftA = mFlameToadRotationListChosenBALeft[0U];
    mToadCipherRotationBALeftB = mFlameToadRotationListChosenBALeft[1U];
    mToadCipherRotationBALeftC = mFlameToadRotationListChosenBALeft[2U];
    mToadCipherRotationBALeftD = mFlameToadRotationListChosenBALeft[3U];
    mToadCipherRotationBALeftE = mFlameToadRotationListChosenBALeft[4U];
    mToadCipherRotationBALeftF = mFlameToadRotationListChosenBALeft[5U];
    mToadCipherRotationBALeftG = mFlameToadRotationListChosenBALeft[6U];
    mToadCipherRotationBALeftH = mFlameToadRotationListChosenBALeft[7U];
    mToadCipherRotationBARightA = mFlameToadRotationListChosenBARight[0U];
    mToadCipherRotationBARightB = mFlameToadRotationListChosenBARight[1U];
    mToadCipherRotationBARightC = mFlameToadRotationListChosenBARight[2U];
    mToadCipherRotationBARightD = mFlameToadRotationListChosenBARight[3U];
    mToadCipherRotationBARightE = mFlameToadRotationListChosenBARight[4U];
    mToadCipherRotationBARightF = mFlameToadRotationListChosenBARight[5U];
    mToadCipherRotationBARightG = mFlameToadRotationListChosenBARight[6U];
    mToadCipherRotationBARightH = mFlameToadRotationListChosenBARight[7U];
    mToadCipherRotationBBLeftA = mFlameToadRotationListChosenBBLeft[0U];
    mToadCipherRotationBBLeftB = mFlameToadRotationListChosenBBLeft[1U];
    mToadCipherRotationBBLeftC = mFlameToadRotationListChosenBBLeft[2U];
    mToadCipherRotationBBLeftD = mFlameToadRotationListChosenBBLeft[3U];
    mToadCipherRotationBBLeftE = mFlameToadRotationListChosenBBLeft[4U];
    mToadCipherRotationBBLeftF = mFlameToadRotationListChosenBBLeft[5U];
    mToadCipherRotationBBLeftG = mFlameToadRotationListChosenBBLeft[6U];
    mToadCipherRotationBBLeftH = mFlameToadRotationListChosenBBLeft[7U];
    mToadCipherRotationBBRightA = mFlameToadRotationListChosenBBRight[0U];
    mToadCipherRotationBBRightB = mFlameToadRotationListChosenBBRight[1U];
    mToadCipherRotationBBRightC = mFlameToadRotationListChosenBBRight[2U];
    mToadCipherRotationBBRightD = mFlameToadRotationListChosenBBRight[3U];
    mToadCipherRotationBBRightE = mFlameToadRotationListChosenBBRight[4U];
    mToadCipherRotationBBRightF = mFlameToadRotationListChosenBBRight[5U];
    mToadCipherRotationBBRightG = mFlameToadRotationListChosenBBRight[6U];
    mToadCipherRotationBBRightH = mFlameToadRotationListChosenBBRight[7U];
    mToadCipherRotationBCLeftA = mFlameToadRotationListChosenBCLeft[0U];
    mToadCipherRotationBCLeftB = mFlameToadRotationListChosenBCLeft[1U];
    mToadCipherRotationBCLeftC = mFlameToadRotationListChosenBCLeft[2U];
    mToadCipherRotationBCLeftD = mFlameToadRotationListChosenBCLeft[3U];
    mToadCipherRotationBCLeftE = mFlameToadRotationListChosenBCLeft[4U];
    mToadCipherRotationBCLeftF = mFlameToadRotationListChosenBCLeft[5U];
    mToadCipherRotationBCLeftG = mFlameToadRotationListChosenBCLeft[6U];
    mToadCipherRotationBCLeftH = mFlameToadRotationListChosenBCLeft[7U];
    mToadCipherRotationBCRightA = mFlameToadRotationListChosenBCRight[0U];
    mToadCipherRotationBCRightB = mFlameToadRotationListChosenBCRight[1U];
    mToadCipherRotationBCRightC = mFlameToadRotationListChosenBCRight[2U];
    mToadCipherRotationBCRightD = mFlameToadRotationListChosenBCRight[3U];
    mToadCipherRotationBCRightE = mFlameToadRotationListChosenBCRight[4U];
    mToadCipherRotationBCRightF = mFlameToadRotationListChosenBCRight[5U];
    mToadCipherRotationBCRightG = mFlameToadRotationListChosenBCRight[6U];
    mToadCipherRotationBCRightH = mFlameToadRotationListChosenBCRight[7U];
    mToadCipherRotationBDLeftA = mFlameToadRotationListChosenBDLeft[0U];
    mToadCipherRotationBDLeftB = mFlameToadRotationListChosenBDLeft[1U];
    mToadCipherRotationBDLeftC = mFlameToadRotationListChosenBDLeft[2U];
    mToadCipherRotationBDLeftD = mFlameToadRotationListChosenBDLeft[3U];
    mToadCipherRotationBDLeftE = mFlameToadRotationListChosenBDLeft[4U];
    mToadCipherRotationBDLeftF = mFlameToadRotationListChosenBDLeft[5U];
    mToadCipherRotationBDLeftG = mFlameToadRotationListChosenBDLeft[6U];
    mToadCipherRotationBDLeftH = mFlameToadRotationListChosenBDLeft[7U];
    mToadCipherRotationBDRightA = mFlameToadRotationListChosenBDRight[0U];
    mToadCipherRotationBDRightB = mFlameToadRotationListChosenBDRight[1U];
    mToadCipherRotationBDRightC = mFlameToadRotationListChosenBDRight[2U];
    mToadCipherRotationBDRightD = mFlameToadRotationListChosenBDRight[3U];
    mToadCipherRotationBDRightE = mFlameToadRotationListChosenBDRight[4U];
    mToadCipherRotationBDRightF = mFlameToadRotationListChosenBDRight[5U];
    mToadCipherRotationBDRightG = mFlameToadRotationListChosenBDRight[6U];
    mToadCipherRotationBDRightH = mFlameToadRotationListChosenBDRight[7U];
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

