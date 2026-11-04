#include "Cryptex.hpp"
#include "Soccer3.hpp"
#include "FlameToadCipher.hpp"
#include "PasswordXORCipher.hpp"
#include "ShiftMaskedCipher.hpp"
#include "BitReverseCipher.hpp"
#include "Jelly.hpp"

void Cryptex::Clear() {
    mLayerAA.Clear();
    mLayerAB.Clear();
    mLayerAC.Clear();
    mLayerAD.Clear();
    mLayerBA.Clear();
    mLayerBB.Clear();
    mLayerBC.Clear();
    mLayerBD.Clear();
    mMaterialCount = 0U;
    mBuilt = false;
}

void Cryptex::Zero() {
    mLayerAA.Zero();
    mLayerAB.Zero();
    mLayerAC.Zero();
    mLayerAD.Zero();
    mLayerBA.Zero();
    mLayerBB.Zero();
    mLayerBC.Zero();
    mLayerBD.Zero();
    Clear();
    mStrength = EncryptionStrength::kNormal;
}

bool Cryptex::Build(EncryptionStrength pStrength) {
    mStrength = pStrength;
    if (!Soccer3::ValidateCryptexInputs(pStrength)) return false;

    if (mStrength == EncryptionStrength::kWeak) {
        // Layer AA
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAA, Soccer3::mBitRowAB,
            Soccer3::mFlameToadCipherRotationAAA, Soccer3::mFlameToadCipherRotationAAB, Soccer3::mFlameToadCipherRotationAAC, Soccer3::mFlameToadCipherRotationAAD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAC, Soccer3::mBitRowAD,
            Soccer3::mFlameToadCipherRotationAAE, Soccer3::mFlameToadCipherRotationAAF, Soccer3::mFlameToadCipherRotationAAG, Soccer3::mFlameToadCipherRotationAAH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAE, Soccer3::mBitRowAF,
            Soccer3::mFlameToadCipherRotationAAI, Soccer3::mFlameToadCipherRotationAAJ, Soccer3::mFlameToadCipherRotationAAK, Soccer3::mFlameToadCipherRotationAAL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAG, Soccer3::mBitRowAH,
            Soccer3::mFlameToadCipherRotationAAM, Soccer3::mFlameToadCipherRotationAAN, Soccer3::mFlameToadCipherRotationAAO, Soccer3::mFlameToadCipherRotationAAP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskA, Soccer3::mShiftMaskedCipherRotationAA));
        mLayerAA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskB, Soccer3::mShiftMaskedCipherRotationAB));

        // Layer AB
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBA, Soccer3::mBitRowBB,
            Soccer3::mFlameToadCipherRotationABA, Soccer3::mFlameToadCipherRotationABB, Soccer3::mFlameToadCipherRotationABC, Soccer3::mFlameToadCipherRotationABD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBC, Soccer3::mBitRowBD,
            Soccer3::mFlameToadCipherRotationABE, Soccer3::mFlameToadCipherRotationABF, Soccer3::mFlameToadCipherRotationABG, Soccer3::mFlameToadCipherRotationABH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBE, Soccer3::mBitRowBF,
            Soccer3::mFlameToadCipherRotationABI, Soccer3::mFlameToadCipherRotationABJ, Soccer3::mFlameToadCipherRotationABK, Soccer3::mFlameToadCipherRotationABL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBG, Soccer3::mBitRowBH,
            Soccer3::mFlameToadCipherRotationABM, Soccer3::mFlameToadCipherRotationABN, Soccer3::mFlameToadCipherRotationABO, Soccer3::mFlameToadCipherRotationABP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskC, Soccer3::mShiftMaskedCipherRotationAC));
        mLayerAB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskD, Soccer3::mShiftMaskedCipherRotationAD));

        // Layer AC
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCA, Soccer3::mBitRowCB,
            Soccer3::mFlameToadCipherRotationACA, Soccer3::mFlameToadCipherRotationACB, Soccer3::mFlameToadCipherRotationACC, Soccer3::mFlameToadCipherRotationACD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCC, Soccer3::mBitRowCD,
            Soccer3::mFlameToadCipherRotationACE, Soccer3::mFlameToadCipherRotationACF, Soccer3::mFlameToadCipherRotationACG, Soccer3::mFlameToadCipherRotationACH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCE, Soccer3::mBitRowCF,
            Soccer3::mFlameToadCipherRotationACI, Soccer3::mFlameToadCipherRotationACJ, Soccer3::mFlameToadCipherRotationACK, Soccer3::mFlameToadCipherRotationACL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCG, Soccer3::mBitRowCH,
            Soccer3::mFlameToadCipherRotationACM, Soccer3::mFlameToadCipherRotationACN, Soccer3::mFlameToadCipherRotationACO, Soccer3::mFlameToadCipherRotationACP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskE, Soccer3::mShiftMaskedCipherRotationAE));
        mLayerAC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskF, Soccer3::mShiftMaskedCipherRotationAF));
        mLayerAC.Add(new PasswordXORCipher(Soccer3::mMutateMaterialA));

        // Layer AD
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDA, Soccer3::mBitRowDB,
            Soccer3::mFlameToadCipherRotationADA, Soccer3::mFlameToadCipherRotationADB, Soccer3::mFlameToadCipherRotationADC, Soccer3::mFlameToadCipherRotationADD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDC, Soccer3::mBitRowDD,
            Soccer3::mFlameToadCipherRotationADE, Soccer3::mFlameToadCipherRotationADF, Soccer3::mFlameToadCipherRotationADG, Soccer3::mFlameToadCipherRotationADH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDE, Soccer3::mBitRowDF,
            Soccer3::mFlameToadCipherRotationADI, Soccer3::mFlameToadCipherRotationADJ, Soccer3::mFlameToadCipherRotationADK, Soccer3::mFlameToadCipherRotationADL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDG, Soccer3::mBitRowDH,
            Soccer3::mFlameToadCipherRotationADM, Soccer3::mFlameToadCipherRotationADN, Soccer3::mFlameToadCipherRotationADO, Soccer3::mFlameToadCipherRotationADP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskG, Soccer3::mShiftMaskedCipherRotationAG));
        mLayerAD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskH, Soccer3::mShiftMaskedCipherRotationAH));
        mLayerAD.Add(new PasswordXORCipher(Soccer3::mMutateMaterialB));
        mLayerAD.Add(new BitReverseCipher{});

        // Layer BA
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAA, Soccer3::mBitRowAB,
            Soccer3::mFlameToadCipherRotationBAA, Soccer3::mFlameToadCipherRotationBAB, Soccer3::mFlameToadCipherRotationBAC, Soccer3::mFlameToadCipherRotationBAD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAC, Soccer3::mBitRowAD,
            Soccer3::mFlameToadCipherRotationBAE, Soccer3::mFlameToadCipherRotationBAF, Soccer3::mFlameToadCipherRotationBAG, Soccer3::mFlameToadCipherRotationBAH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAE, Soccer3::mBitRowAF,
            Soccer3::mFlameToadCipherRotationBAI, Soccer3::mFlameToadCipherRotationBAJ, Soccer3::mFlameToadCipherRotationBAK, Soccer3::mFlameToadCipherRotationBAL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAG, Soccer3::mBitRowAH,
            Soccer3::mFlameToadCipherRotationBAM, Soccer3::mFlameToadCipherRotationBAN, Soccer3::mFlameToadCipherRotationBAO, Soccer3::mFlameToadCipherRotationBAP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskA, Soccer3::mShiftMaskedCipherRotationBA));
        mLayerBA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskB, Soccer3::mShiftMaskedCipherRotationBB));

        // Layer BB
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBA, Soccer3::mBitRowBB,
            Soccer3::mFlameToadCipherRotationBBA, Soccer3::mFlameToadCipherRotationBBB, Soccer3::mFlameToadCipherRotationBBC, Soccer3::mFlameToadCipherRotationBBD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBC, Soccer3::mBitRowBD,
            Soccer3::mFlameToadCipherRotationBBE, Soccer3::mFlameToadCipherRotationBBF, Soccer3::mFlameToadCipherRotationBBG, Soccer3::mFlameToadCipherRotationBBH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBE, Soccer3::mBitRowBF,
            Soccer3::mFlameToadCipherRotationBBI, Soccer3::mFlameToadCipherRotationBBJ, Soccer3::mFlameToadCipherRotationBBK, Soccer3::mFlameToadCipherRotationBBL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBG, Soccer3::mBitRowBH,
            Soccer3::mFlameToadCipherRotationBBM, Soccer3::mFlameToadCipherRotationBBN, Soccer3::mFlameToadCipherRotationBBO, Soccer3::mFlameToadCipherRotationBBP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskC, Soccer3::mShiftMaskedCipherRotationBC));
        mLayerBB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskD, Soccer3::mShiftMaskedCipherRotationBD));

        // Layer BC
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCA, Soccer3::mBitRowCB,
            Soccer3::mFlameToadCipherRotationBCA, Soccer3::mFlameToadCipherRotationBCB, Soccer3::mFlameToadCipherRotationBCC, Soccer3::mFlameToadCipherRotationBCD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCC, Soccer3::mBitRowCD,
            Soccer3::mFlameToadCipherRotationBCE, Soccer3::mFlameToadCipherRotationBCF, Soccer3::mFlameToadCipherRotationBCG, Soccer3::mFlameToadCipherRotationBCH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCE, Soccer3::mBitRowCF,
            Soccer3::mFlameToadCipherRotationBCI, Soccer3::mFlameToadCipherRotationBCJ, Soccer3::mFlameToadCipherRotationBCK, Soccer3::mFlameToadCipherRotationBCL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCG, Soccer3::mBitRowCH,
            Soccer3::mFlameToadCipherRotationBCM, Soccer3::mFlameToadCipherRotationBCN, Soccer3::mFlameToadCipherRotationBCO, Soccer3::mFlameToadCipherRotationBCP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskE, Soccer3::mShiftMaskedCipherRotationBE));
        mLayerBC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskF, Soccer3::mShiftMaskedCipherRotationBF));
        mLayerBC.Add(new PasswordXORCipher(Soccer3::mMutateMaterialC));

        // Layer BD
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDA, Soccer3::mBitRowDB,
            Soccer3::mFlameToadCipherRotationBDA, Soccer3::mFlameToadCipherRotationBDB, Soccer3::mFlameToadCipherRotationBDC, Soccer3::mFlameToadCipherRotationBDD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDC, Soccer3::mBitRowDD,
            Soccer3::mFlameToadCipherRotationBDE, Soccer3::mFlameToadCipherRotationBDF, Soccer3::mFlameToadCipherRotationBDG, Soccer3::mFlameToadCipherRotationBDH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDE, Soccer3::mBitRowDF,
            Soccer3::mFlameToadCipherRotationBDI, Soccer3::mFlameToadCipherRotationBDJ, Soccer3::mFlameToadCipherRotationBDK, Soccer3::mFlameToadCipherRotationBDL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDG, Soccer3::mBitRowDH,
            Soccer3::mFlameToadCipherRotationBDM, Soccer3::mFlameToadCipherRotationBDN, Soccer3::mFlameToadCipherRotationBDO, Soccer3::mFlameToadCipherRotationBDP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskG, Soccer3::mShiftMaskedCipherRotationBG));
        mLayerBD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskH, Soccer3::mShiftMaskedCipherRotationBH));
        mLayerBD.Add(new PasswordXORCipher(Soccer3::mMutateMaterialD));

        mMaterialCount = 4U;
    } else if (mStrength == EncryptionStrength::kStrong) {
        // Layer AA
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAA, Soccer3::mBitRowAB,
            Soccer3::mFlameToadCipherRotationAAA, Soccer3::mFlameToadCipherRotationAAB, Soccer3::mFlameToadCipherRotationAAC, Soccer3::mFlameToadCipherRotationAAD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAC, Soccer3::mBitRowAD,
            Soccer3::mFlameToadCipherRotationAAE, Soccer3::mFlameToadCipherRotationAAF, Soccer3::mFlameToadCipherRotationAAG, Soccer3::mFlameToadCipherRotationAAH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAE, Soccer3::mBitRowAF,
            Soccer3::mFlameToadCipherRotationAAI, Soccer3::mFlameToadCipherRotationAAJ, Soccer3::mFlameToadCipherRotationAAK, Soccer3::mFlameToadCipherRotationAAL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAG, Soccer3::mBitRowAH,
            Soccer3::mFlameToadCipherRotationAAM, Soccer3::mFlameToadCipherRotationAAN, Soccer3::mFlameToadCipherRotationAAO, Soccer3::mFlameToadCipherRotationAAP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new PasswordXORCipher(Soccer3::mMutateMaterialA));
        mLayerAA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskA, Soccer3::mShiftMaskedCipherRotationAA));
        mLayerAA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskB, Soccer3::mShiftMaskedCipherRotationAB));
        mLayerAA.Add(new PasswordXORCipher(Soccer3::mMutateMaterialB));

        // Layer AB
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBA, Soccer3::mBitRowBB,
            Soccer3::mFlameToadCipherRotationABA, Soccer3::mFlameToadCipherRotationABB, Soccer3::mFlameToadCipherRotationABC, Soccer3::mFlameToadCipherRotationABD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBC, Soccer3::mBitRowBD,
            Soccer3::mFlameToadCipherRotationABE, Soccer3::mFlameToadCipherRotationABF, Soccer3::mFlameToadCipherRotationABG, Soccer3::mFlameToadCipherRotationABH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBE, Soccer3::mBitRowBF,
            Soccer3::mFlameToadCipherRotationABI, Soccer3::mFlameToadCipherRotationABJ, Soccer3::mFlameToadCipherRotationABK, Soccer3::mFlameToadCipherRotationABL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBG, Soccer3::mBitRowBH,
            Soccer3::mFlameToadCipherRotationABM, Soccer3::mFlameToadCipherRotationABN, Soccer3::mFlameToadCipherRotationABO, Soccer3::mFlameToadCipherRotationABP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new PasswordXORCipher(Soccer3::mMutateMaterialC));
        mLayerAB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskC, Soccer3::mShiftMaskedCipherRotationAC));
        mLayerAB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskD, Soccer3::mShiftMaskedCipherRotationAD));
        mLayerAB.Add(new PasswordXORCipher(Soccer3::mMutateMaterialD));

        // Layer AC
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCA, Soccer3::mBitRowCB,
            Soccer3::mFlameToadCipherRotationACA, Soccer3::mFlameToadCipherRotationACB, Soccer3::mFlameToadCipherRotationACC, Soccer3::mFlameToadCipherRotationACD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCC, Soccer3::mBitRowCD,
            Soccer3::mFlameToadCipherRotationACE, Soccer3::mFlameToadCipherRotationACF, Soccer3::mFlameToadCipherRotationACG, Soccer3::mFlameToadCipherRotationACH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCE, Soccer3::mBitRowCF,
            Soccer3::mFlameToadCipherRotationACI, Soccer3::mFlameToadCipherRotationACJ, Soccer3::mFlameToadCipherRotationACK, Soccer3::mFlameToadCipherRotationACL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCG, Soccer3::mBitRowCH,
            Soccer3::mFlameToadCipherRotationACM, Soccer3::mFlameToadCipherRotationACN, Soccer3::mFlameToadCipherRotationACO, Soccer3::mFlameToadCipherRotationACP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new PasswordXORCipher(Soccer3::mMutateMaterialE));
        mLayerAC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskE, Soccer3::mShiftMaskedCipherRotationAE));
        mLayerAC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskF, Soccer3::mShiftMaskedCipherRotationAF));
        mLayerAC.Add(new PasswordXORCipher(Soccer3::mMutateMaterialF));

        // Layer AD
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDA, Soccer3::mBitRowDB,
            Soccer3::mFlameToadCipherRotationADA, Soccer3::mFlameToadCipherRotationADB, Soccer3::mFlameToadCipherRotationADC, Soccer3::mFlameToadCipherRotationADD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDC, Soccer3::mBitRowDD,
            Soccer3::mFlameToadCipherRotationADE, Soccer3::mFlameToadCipherRotationADF, Soccer3::mFlameToadCipherRotationADG, Soccer3::mFlameToadCipherRotationADH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDE, Soccer3::mBitRowDF,
            Soccer3::mFlameToadCipherRotationADI, Soccer3::mFlameToadCipherRotationADJ, Soccer3::mFlameToadCipherRotationADK, Soccer3::mFlameToadCipherRotationADL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDG, Soccer3::mBitRowDH,
            Soccer3::mFlameToadCipherRotationADM, Soccer3::mFlameToadCipherRotationADN, Soccer3::mFlameToadCipherRotationADO, Soccer3::mFlameToadCipherRotationADP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new PasswordXORCipher(Soccer3::mMutateMaterialG));
        mLayerAD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskG, Soccer3::mShiftMaskedCipherRotationAG));
        mLayerAD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskH, Soccer3::mShiftMaskedCipherRotationAH));
        mLayerAD.Add(new PasswordXORCipher(Soccer3::mMutateMaterialH));
        mLayerAD.Add(new BitReverseCipher{});

        // Layer BA
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAA, Soccer3::mBitRowAB,
            Soccer3::mFlameToadCipherRotationBAA, Soccer3::mFlameToadCipherRotationBAB, Soccer3::mFlameToadCipherRotationBAC, Soccer3::mFlameToadCipherRotationBAD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAC, Soccer3::mBitRowAD,
            Soccer3::mFlameToadCipherRotationBAE, Soccer3::mFlameToadCipherRotationBAF, Soccer3::mFlameToadCipherRotationBAG, Soccer3::mFlameToadCipherRotationBAH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAE, Soccer3::mBitRowAF,
            Soccer3::mFlameToadCipherRotationBAI, Soccer3::mFlameToadCipherRotationBAJ, Soccer3::mFlameToadCipherRotationBAK, Soccer3::mFlameToadCipherRotationBAL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAG, Soccer3::mBitRowAH,
            Soccer3::mFlameToadCipherRotationBAM, Soccer3::mFlameToadCipherRotationBAN, Soccer3::mFlameToadCipherRotationBAO, Soccer3::mFlameToadCipherRotationBAP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new PasswordXORCipher(Soccer3::mMutateMaterialI));
        mLayerBA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskA, Soccer3::mShiftMaskedCipherRotationBA));
        mLayerBA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskB, Soccer3::mShiftMaskedCipherRotationBB));
        mLayerBA.Add(new PasswordXORCipher(Soccer3::mMutateMaterialJ));

        // Layer BB
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBA, Soccer3::mBitRowBB,
            Soccer3::mFlameToadCipherRotationBBA, Soccer3::mFlameToadCipherRotationBBB, Soccer3::mFlameToadCipherRotationBBC, Soccer3::mFlameToadCipherRotationBBD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBC, Soccer3::mBitRowBD,
            Soccer3::mFlameToadCipherRotationBBE, Soccer3::mFlameToadCipherRotationBBF, Soccer3::mFlameToadCipherRotationBBG, Soccer3::mFlameToadCipherRotationBBH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBE, Soccer3::mBitRowBF,
            Soccer3::mFlameToadCipherRotationBBI, Soccer3::mFlameToadCipherRotationBBJ, Soccer3::mFlameToadCipherRotationBBK, Soccer3::mFlameToadCipherRotationBBL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBG, Soccer3::mBitRowBH,
            Soccer3::mFlameToadCipherRotationBBM, Soccer3::mFlameToadCipherRotationBBN, Soccer3::mFlameToadCipherRotationBBO, Soccer3::mFlameToadCipherRotationBBP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new PasswordXORCipher(Soccer3::mMutateMaterialK));
        mLayerBB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskC, Soccer3::mShiftMaskedCipherRotationBC));
        mLayerBB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskD, Soccer3::mShiftMaskedCipherRotationBD));
        mLayerBB.Add(new PasswordXORCipher(Soccer3::mMutateMaterialL));

        // Layer BC
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCA, Soccer3::mBitRowCB,
            Soccer3::mFlameToadCipherRotationBCA, Soccer3::mFlameToadCipherRotationBCB, Soccer3::mFlameToadCipherRotationBCC, Soccer3::mFlameToadCipherRotationBCD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCC, Soccer3::mBitRowCD,
            Soccer3::mFlameToadCipherRotationBCE, Soccer3::mFlameToadCipherRotationBCF, Soccer3::mFlameToadCipherRotationBCG, Soccer3::mFlameToadCipherRotationBCH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCE, Soccer3::mBitRowCF,
            Soccer3::mFlameToadCipherRotationBCI, Soccer3::mFlameToadCipherRotationBCJ, Soccer3::mFlameToadCipherRotationBCK, Soccer3::mFlameToadCipherRotationBCL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCG, Soccer3::mBitRowCH,
            Soccer3::mFlameToadCipherRotationBCM, Soccer3::mFlameToadCipherRotationBCN, Soccer3::mFlameToadCipherRotationBCO, Soccer3::mFlameToadCipherRotationBCP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new PasswordXORCipher(Soccer3::mMutateMaterialM));
        mLayerBC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskE, Soccer3::mShiftMaskedCipherRotationBE));
        mLayerBC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskF, Soccer3::mShiftMaskedCipherRotationBF));
        mLayerBC.Add(new PasswordXORCipher(Soccer3::mMutateMaterialN));

        // Layer BD
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDA, Soccer3::mBitRowDB,
            Soccer3::mFlameToadCipherRotationBDA, Soccer3::mFlameToadCipherRotationBDB, Soccer3::mFlameToadCipherRotationBDC, Soccer3::mFlameToadCipherRotationBDD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDC, Soccer3::mBitRowDD,
            Soccer3::mFlameToadCipherRotationBDE, Soccer3::mFlameToadCipherRotationBDF, Soccer3::mFlameToadCipherRotationBDG, Soccer3::mFlameToadCipherRotationBDH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDE, Soccer3::mBitRowDF,
            Soccer3::mFlameToadCipherRotationBDI, Soccer3::mFlameToadCipherRotationBDJ, Soccer3::mFlameToadCipherRotationBDK, Soccer3::mFlameToadCipherRotationBDL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDG, Soccer3::mBitRowDH,
            Soccer3::mFlameToadCipherRotationBDM, Soccer3::mFlameToadCipherRotationBDN, Soccer3::mFlameToadCipherRotationBDO, Soccer3::mFlameToadCipherRotationBDP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new PasswordXORCipher(Soccer3::mMutateMaterialO));
        mLayerBD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskG, Soccer3::mShiftMaskedCipherRotationBG));
        mLayerBD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskH, Soccer3::mShiftMaskedCipherRotationBH));
        mLayerBD.Add(new PasswordXORCipher(Soccer3::mMutateMaterialP));

        mMaterialCount = 16U;
    } else { // Normal, including unrecognized strength values.
        mStrength = EncryptionStrength::kNormal;
        // Layer AA
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAA, Soccer3::mBitRowAB,
            Soccer3::mFlameToadCipherRotationAAA, Soccer3::mFlameToadCipherRotationAAB, Soccer3::mFlameToadCipherRotationAAC, Soccer3::mFlameToadCipherRotationAAD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAC, Soccer3::mBitRowAD,
            Soccer3::mFlameToadCipherRotationAAE, Soccer3::mFlameToadCipherRotationAAF, Soccer3::mFlameToadCipherRotationAAG, Soccer3::mFlameToadCipherRotationAAH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAE, Soccer3::mBitRowAF,
            Soccer3::mFlameToadCipherRotationAAI, Soccer3::mFlameToadCipherRotationAAJ, Soccer3::mFlameToadCipherRotationAAK, Soccer3::mFlameToadCipherRotationAAL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FlameToadCipher(Soccer3::mBitRowAG, Soccer3::mBitRowAH,
            Soccer3::mFlameToadCipherRotationAAM, Soccer3::mFlameToadCipherRotationAAN, Soccer3::mFlameToadCipherRotationAAO, Soccer3::mFlameToadCipherRotationAAP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskA, Soccer3::mShiftMaskedCipherRotationAA));
        mLayerAA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskB, Soccer3::mShiftMaskedCipherRotationAB));
        mLayerAA.Add(new PasswordXORCipher(Soccer3::mMutateMaterialA));

        // Layer AB
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBA, Soccer3::mBitRowBB,
            Soccer3::mFlameToadCipherRotationABA, Soccer3::mFlameToadCipherRotationABB, Soccer3::mFlameToadCipherRotationABC, Soccer3::mFlameToadCipherRotationABD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBC, Soccer3::mBitRowBD,
            Soccer3::mFlameToadCipherRotationABE, Soccer3::mFlameToadCipherRotationABF, Soccer3::mFlameToadCipherRotationABG, Soccer3::mFlameToadCipherRotationABH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBE, Soccer3::mBitRowBF,
            Soccer3::mFlameToadCipherRotationABI, Soccer3::mFlameToadCipherRotationABJ, Soccer3::mFlameToadCipherRotationABK, Soccer3::mFlameToadCipherRotationABL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FlameToadCipher(Soccer3::mBitRowBG, Soccer3::mBitRowBH,
            Soccer3::mFlameToadCipherRotationABM, Soccer3::mFlameToadCipherRotationABN, Soccer3::mFlameToadCipherRotationABO, Soccer3::mFlameToadCipherRotationABP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskC, Soccer3::mShiftMaskedCipherRotationAC));
        mLayerAB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskD, Soccer3::mShiftMaskedCipherRotationAD));
        mLayerAB.Add(new PasswordXORCipher(Soccer3::mMutateMaterialB));

        // Layer AC
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCA, Soccer3::mBitRowCB,
            Soccer3::mFlameToadCipherRotationACA, Soccer3::mFlameToadCipherRotationACB, Soccer3::mFlameToadCipherRotationACC, Soccer3::mFlameToadCipherRotationACD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCC, Soccer3::mBitRowCD,
            Soccer3::mFlameToadCipherRotationACE, Soccer3::mFlameToadCipherRotationACF, Soccer3::mFlameToadCipherRotationACG, Soccer3::mFlameToadCipherRotationACH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCE, Soccer3::mBitRowCF,
            Soccer3::mFlameToadCipherRotationACI, Soccer3::mFlameToadCipherRotationACJ, Soccer3::mFlameToadCipherRotationACK, Soccer3::mFlameToadCipherRotationACL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FlameToadCipher(Soccer3::mBitRowCG, Soccer3::mBitRowCH,
            Soccer3::mFlameToadCipherRotationACM, Soccer3::mFlameToadCipherRotationACN, Soccer3::mFlameToadCipherRotationACO, Soccer3::mFlameToadCipherRotationACP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskE, Soccer3::mShiftMaskedCipherRotationAE));
        mLayerAC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskF, Soccer3::mShiftMaskedCipherRotationAF));
        mLayerAC.Add(new PasswordXORCipher(Soccer3::mMutateMaterialC));

        // Layer AD
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDA, Soccer3::mBitRowDB,
            Soccer3::mFlameToadCipherRotationADA, Soccer3::mFlameToadCipherRotationADB, Soccer3::mFlameToadCipherRotationADC, Soccer3::mFlameToadCipherRotationADD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDC, Soccer3::mBitRowDD,
            Soccer3::mFlameToadCipherRotationADE, Soccer3::mFlameToadCipherRotationADF, Soccer3::mFlameToadCipherRotationADG, Soccer3::mFlameToadCipherRotationADH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDE, Soccer3::mBitRowDF,
            Soccer3::mFlameToadCipherRotationADI, Soccer3::mFlameToadCipherRotationADJ, Soccer3::mFlameToadCipherRotationADK, Soccer3::mFlameToadCipherRotationADL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FlameToadCipher(Soccer3::mBitRowDG, Soccer3::mBitRowDH,
            Soccer3::mFlameToadCipherRotationADM, Soccer3::mFlameToadCipherRotationADN, Soccer3::mFlameToadCipherRotationADO, Soccer3::mFlameToadCipherRotationADP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskG, Soccer3::mShiftMaskedCipherRotationAG));
        mLayerAD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskH, Soccer3::mShiftMaskedCipherRotationAH));
        mLayerAD.Add(new PasswordXORCipher(Soccer3::mMutateMaterialD));
        mLayerAD.Add(new BitReverseCipher{});

        // Layer BA
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAA, Soccer3::mBitRowAB,
            Soccer3::mFlameToadCipherRotationBAA, Soccer3::mFlameToadCipherRotationBAB, Soccer3::mFlameToadCipherRotationBAC, Soccer3::mFlameToadCipherRotationBAD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAC, Soccer3::mBitRowAD,
            Soccer3::mFlameToadCipherRotationBAE, Soccer3::mFlameToadCipherRotationBAF, Soccer3::mFlameToadCipherRotationBAG, Soccer3::mFlameToadCipherRotationBAH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAE, Soccer3::mBitRowAF,
            Soccer3::mFlameToadCipherRotationBAI, Soccer3::mFlameToadCipherRotationBAJ, Soccer3::mFlameToadCipherRotationBAK, Soccer3::mFlameToadCipherRotationBAL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FlameToadCipher(Soccer3::mBitRowAG, Soccer3::mBitRowAH,
            Soccer3::mFlameToadCipherRotationBAM, Soccer3::mFlameToadCipherRotationBAN, Soccer3::mFlameToadCipherRotationBAO, Soccer3::mFlameToadCipherRotationBAP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskA, Soccer3::mShiftMaskedCipherRotationBA));
        mLayerBA.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskB, Soccer3::mShiftMaskedCipherRotationBB));
        mLayerBA.Add(new PasswordXORCipher(Soccer3::mMutateMaterialE));

        // Layer BB
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBA, Soccer3::mBitRowBB,
            Soccer3::mFlameToadCipherRotationBBA, Soccer3::mFlameToadCipherRotationBBB, Soccer3::mFlameToadCipherRotationBBC, Soccer3::mFlameToadCipherRotationBBD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBC, Soccer3::mBitRowBD,
            Soccer3::mFlameToadCipherRotationBBE, Soccer3::mFlameToadCipherRotationBBF, Soccer3::mFlameToadCipherRotationBBG, Soccer3::mFlameToadCipherRotationBBH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBE, Soccer3::mBitRowBF,
            Soccer3::mFlameToadCipherRotationBBI, Soccer3::mFlameToadCipherRotationBBJ, Soccer3::mFlameToadCipherRotationBBK, Soccer3::mFlameToadCipherRotationBBL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FlameToadCipher(Soccer3::mBitRowBG, Soccer3::mBitRowBH,
            Soccer3::mFlameToadCipherRotationBBM, Soccer3::mFlameToadCipherRotationBBN, Soccer3::mFlameToadCipherRotationBBO, Soccer3::mFlameToadCipherRotationBBP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskC, Soccer3::mShiftMaskedCipherRotationBC));
        mLayerBB.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskD, Soccer3::mShiftMaskedCipherRotationBD));
        mLayerBB.Add(new PasswordXORCipher(Soccer3::mMutateMaterialF));

        // Layer BC
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCA, Soccer3::mBitRowCB,
            Soccer3::mFlameToadCipherRotationBCA, Soccer3::mFlameToadCipherRotationBCB, Soccer3::mFlameToadCipherRotationBCC, Soccer3::mFlameToadCipherRotationBCD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCC, Soccer3::mBitRowCD,
            Soccer3::mFlameToadCipherRotationBCE, Soccer3::mFlameToadCipherRotationBCF, Soccer3::mFlameToadCipherRotationBCG, Soccer3::mFlameToadCipherRotationBCH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCE, Soccer3::mBitRowCF,
            Soccer3::mFlameToadCipherRotationBCI, Soccer3::mFlameToadCipherRotationBCJ, Soccer3::mFlameToadCipherRotationBCK, Soccer3::mFlameToadCipherRotationBCL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FlameToadCipher(Soccer3::mBitRowCG, Soccer3::mBitRowCH,
            Soccer3::mFlameToadCipherRotationBCM, Soccer3::mFlameToadCipherRotationBCN, Soccer3::mFlameToadCipherRotationBCO, Soccer3::mFlameToadCipherRotationBCP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskE, Soccer3::mShiftMaskedCipherRotationBE));
        mLayerBC.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskF, Soccer3::mShiftMaskedCipherRotationBF));
        mLayerBC.Add(new PasswordXORCipher(Soccer3::mMutateMaterialG));

        // Layer BD
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDA, Soccer3::mBitRowDB,
            Soccer3::mFlameToadCipherRotationBDA, Soccer3::mFlameToadCipherRotationBDB, Soccer3::mFlameToadCipherRotationBDC, Soccer3::mFlameToadCipherRotationBDD,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDC, Soccer3::mBitRowDD,
            Soccer3::mFlameToadCipherRotationBDE, Soccer3::mFlameToadCipherRotationBDF, Soccer3::mFlameToadCipherRotationBDG, Soccer3::mFlameToadCipherRotationBDH,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDE, Soccer3::mBitRowDF,
            Soccer3::mFlameToadCipherRotationBDI, Soccer3::mFlameToadCipherRotationBDJ, Soccer3::mFlameToadCipherRotationBDK, Soccer3::mFlameToadCipherRotationBDL,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FlameToadCipher(Soccer3::mBitRowDG, Soccer3::mBitRowDH,
            Soccer3::mFlameToadCipherRotationBDM, Soccer3::mFlameToadCipherRotationBDN, Soccer3::mFlameToadCipherRotationBDO, Soccer3::mFlameToadCipherRotationBDP,
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskG, Soccer3::mShiftMaskedCipherRotationBG));
        mLayerBD.Add(new ShiftMaskedCipher(Soccer3::mRotationMaskH, Soccer3::mShiftMaskedCipherRotationBH));
        mLayerBD.Add(new PasswordXORCipher(Soccer3::mMutateMaterialH));

        mMaterialCount = 8U;
    }
    mBuilt = true;
    return true;
}

bool Cryptex::SealData(const std::uint8_t *pSource, std::uint8_t *pWorkerA,
                       std::uint8_t *pWorkerB, std::uint8_t *pDestination,
                       std::size_t pLength, CipherErrorCode *pErrorCode) const {
    return Apply(false, pSource, pWorkerA, pWorkerB, pDestination, pLength, pErrorCode);
}

bool Cryptex::UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorkerA,
                         std::uint8_t *pWorkerB, std::uint8_t *pDestination,
                         std::size_t pLength, CipherErrorCode *pErrorCode) const {
    return Apply(true, pSource, pWorkerA, pWorkerB, pDestination, pLength, pErrorCode);
}

bool Cryptex::Apply(bool pUnseal, const std::uint8_t *pSource, std::uint8_t *pWorkerA,
                    std::uint8_t *pWorkerB, std::uint8_t *pDestination,
                    std::size_t pLength, CipherErrorCode *pErrorCode) const {
    const CryptexLayer *aLayers[kLayerCount] = {
        &mLayerAA, &mLayerAB, &mLayerAC, &mLayerAD,
        &mLayerBA, &mLayerBB, &mLayerBC, &mLayerBD
    };
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    
    const std::uint8_t *aBuffers[] = {pSource, pWorkerA, pWorkerB, pDestination};
    for (const auto *aBuffer : aBuffers) {
        if (aBuffer == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
    }
    for (std::size_t aFirst = 0U; aFirst < 4U; ++aFirst) {
        for (std::size_t aSecond = aFirst + 1U; aSecond < 4U; ++aSecond) {
            const auto aFirstAddress = reinterpret_cast<std::uintptr_t>(aBuffers[aFirst]);
            const auto aSecondAddress = reinterpret_cast<std::uintptr_t>(aBuffers[aSecond]);
            const auto aDistance = aFirstAddress < aSecondAddress
                ? aSecondAddress - aFirstAddress : aFirstAddress - aSecondAddress;
            if (aDistance < pLength) {
                SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
                return false;
            }
        }
    }

    const std::uint8_t *aInput = pSource;
    for (std::size_t aStep = 0U; aStep < kLayerCount; ++aStep) {
        const bool aLast = aStep + 1U == kLayerCount;
        std::uint8_t *aOutput = aLast ? pDestination : ((aStep & 1U) == 0U ? pWorkerA : pWorkerB);
        // Keep three distinct buffers available to each CryptexLayer.
        // Destination is temporary scratch until the final layer writes it.
        std::uint8_t *aScratch = aStep == 0U ? pWorkerB
            : (aLast ? (aInput == pWorkerA ? pWorkerB : pWorkerA) : pDestination);
        const auto *aLayer = aLayers[pUnseal ? kLayerCount - 1U - aStep : aStep];
        const bool aSuccess = pUnseal
            ? aLayer->UnsealData(aInput, aScratch, aOutput, pLength, pErrorCode)
            : aLayer->SealData(aInput, aScratch, aOutput, pLength, pErrorCode);
        if (!aSuccess) return false;
        aInput = aOutput;
    }
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
}
