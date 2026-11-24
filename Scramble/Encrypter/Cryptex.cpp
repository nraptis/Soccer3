#include "Cryptex.hpp"
#include "../Composer/Soccer3.hpp"
#include "FourToadKernel.hpp"
#include "PasswordXORKernel.hpp"
#include "FourCrowKernel.hpp"
#include "FourRavenKernel.hpp"
#include "BitReverseKernel.hpp"

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
        mLayerAA.Add(new FourToadKernel(
            {Soccer3::mBitRowAA, Soccer3::mBitRowAB,
             {Soccer3::mToadCipherRotationAALeftA, Soccer3::mToadCipherRotationAALeftB, Soccer3::mToadCipherRotationAALeftC, Soccer3::mToadCipherRotationAALeftD}},
            {Soccer3::mBitRowAC, Soccer3::mBitRowAD,
             {Soccer3::mToadCipherRotationAALeftE, Soccer3::mToadCipherRotationAALeftF, Soccer3::mToadCipherRotationAALeftG, Soccer3::mToadCipherRotationAALeftH}},
            {Soccer3::mBitRowAE, Soccer3::mBitRowAF,
             {Soccer3::mToadCipherRotationAARightA, Soccer3::mToadCipherRotationAARightB, Soccer3::mToadCipherRotationAARightC, Soccer3::mToadCipherRotationAARightD}},
            {Soccer3::mBitRowAG, Soccer3::mBitRowAH,
             {Soccer3::mToadCipherRotationAARightE, Soccer3::mToadCipherRotationAARightF, Soccer3::mToadCipherRotationAARightG, Soccer3::mToadCipherRotationAARightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FourCrowKernel(
            Soccer3::mPlaneShiftAALeft, Soccer3::mPlaneShiftAARight));

        // Layer AB
        mLayerAB.Add(new FourToadKernel(
            {Soccer3::mBitRowBA, Soccer3::mBitRowBB,
             {Soccer3::mToadCipherRotationABLeftA, Soccer3::mToadCipherRotationABLeftB, Soccer3::mToadCipherRotationABLeftC, Soccer3::mToadCipherRotationABLeftD}},
            {Soccer3::mBitRowBC, Soccer3::mBitRowBD,
             {Soccer3::mToadCipherRotationABLeftE, Soccer3::mToadCipherRotationABLeftF, Soccer3::mToadCipherRotationABLeftG, Soccer3::mToadCipherRotationABLeftH}},
            {Soccer3::mBitRowBE, Soccer3::mBitRowBF,
             {Soccer3::mToadCipherRotationABRightA, Soccer3::mToadCipherRotationABRightB, Soccer3::mToadCipherRotationABRightC, Soccer3::mToadCipherRotationABRightD}},
            {Soccer3::mBitRowBG, Soccer3::mBitRowBH,
             {Soccer3::mToadCipherRotationABRightE, Soccer3::mToadCipherRotationABRightF, Soccer3::mToadCipherRotationABRightG, Soccer3::mToadCipherRotationABRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftABLeft, Soccer3::mPlaneShiftABRight,
            Soccer3::mMutateMaterialA));

        // Layer AC
        mLayerAC.Add(new FourToadKernel(
            {Soccer3::mBitRowCA, Soccer3::mBitRowCB,
             {Soccer3::mToadCipherRotationACLeftA, Soccer3::mToadCipherRotationACLeftB, Soccer3::mToadCipherRotationACLeftC, Soccer3::mToadCipherRotationACLeftD}},
            {Soccer3::mBitRowCC, Soccer3::mBitRowCD,
             {Soccer3::mToadCipherRotationACLeftE, Soccer3::mToadCipherRotationACLeftF, Soccer3::mToadCipherRotationACLeftG, Soccer3::mToadCipherRotationACLeftH}},
            {Soccer3::mBitRowCE, Soccer3::mBitRowCF,
             {Soccer3::mToadCipherRotationACRightA, Soccer3::mToadCipherRotationACRightB, Soccer3::mToadCipherRotationACRightC, Soccer3::mToadCipherRotationACRightD}},
            {Soccer3::mBitRowCG, Soccer3::mBitRowCH,
             {Soccer3::mToadCipherRotationACRightE, Soccer3::mToadCipherRotationACRightF, Soccer3::mToadCipherRotationACRightG, Soccer3::mToadCipherRotationACRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FourCrowKernel(
            Soccer3::mPlaneShiftACLeft, Soccer3::mPlaneShiftACRight));

        // Layer AD
        mLayerAD.Add(new FourToadKernel(
            {Soccer3::mBitRowDA, Soccer3::mBitRowDB,
             {Soccer3::mToadCipherRotationADLeftA, Soccer3::mToadCipherRotationADLeftB, Soccer3::mToadCipherRotationADLeftC, Soccer3::mToadCipherRotationADLeftD}},
            {Soccer3::mBitRowDC, Soccer3::mBitRowDD,
             {Soccer3::mToadCipherRotationADLeftE, Soccer3::mToadCipherRotationADLeftF, Soccer3::mToadCipherRotationADLeftG, Soccer3::mToadCipherRotationADLeftH}},
            {Soccer3::mBitRowDE, Soccer3::mBitRowDF,
             {Soccer3::mToadCipherRotationADRightA, Soccer3::mToadCipherRotationADRightB, Soccer3::mToadCipherRotationADRightC, Soccer3::mToadCipherRotationADRightD}},
            {Soccer3::mBitRowDG, Soccer3::mBitRowDH,
             {Soccer3::mToadCipherRotationADRightE, Soccer3::mToadCipherRotationADRightF, Soccer3::mToadCipherRotationADRightG, Soccer3::mToadCipherRotationADRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftADLeft, Soccer3::mPlaneShiftADRight,
            Soccer3::mMutateMaterialB));
        mLayerAD.Add(new BitReverseKernel{});

        // Layer BA
        mLayerBA.Add(new FourToadKernel(
            {Soccer3::mBitRowAA, Soccer3::mBitRowAB,
             {Soccer3::mToadCipherRotationBALeftA, Soccer3::mToadCipherRotationBALeftB, Soccer3::mToadCipherRotationBALeftC, Soccer3::mToadCipherRotationBALeftD}},
            {Soccer3::mBitRowAC, Soccer3::mBitRowAD,
             {Soccer3::mToadCipherRotationBALeftE, Soccer3::mToadCipherRotationBALeftF, Soccer3::mToadCipherRotationBALeftG, Soccer3::mToadCipherRotationBALeftH}},
            {Soccer3::mBitRowAE, Soccer3::mBitRowAF,
             {Soccer3::mToadCipherRotationBARightA, Soccer3::mToadCipherRotationBARightB, Soccer3::mToadCipherRotationBARightC, Soccer3::mToadCipherRotationBARightD}},
            {Soccer3::mBitRowAG, Soccer3::mBitRowAH,
             {Soccer3::mToadCipherRotationBARightE, Soccer3::mToadCipherRotationBARightF, Soccer3::mToadCipherRotationBARightG, Soccer3::mToadCipherRotationBARightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FourCrowKernel(
            Soccer3::mPlaneShiftBALeft, Soccer3::mPlaneShiftBARight));

        // Layer BB
        mLayerBB.Add(new FourToadKernel(
            {Soccer3::mBitRowBA, Soccer3::mBitRowBB,
             {Soccer3::mToadCipherRotationBBLeftA, Soccer3::mToadCipherRotationBBLeftB, Soccer3::mToadCipherRotationBBLeftC, Soccer3::mToadCipherRotationBBLeftD}},
            {Soccer3::mBitRowBC, Soccer3::mBitRowBD,
             {Soccer3::mToadCipherRotationBBLeftE, Soccer3::mToadCipherRotationBBLeftF, Soccer3::mToadCipherRotationBBLeftG, Soccer3::mToadCipherRotationBBLeftH}},
            {Soccer3::mBitRowBE, Soccer3::mBitRowBF,
             {Soccer3::mToadCipherRotationBBRightA, Soccer3::mToadCipherRotationBBRightB, Soccer3::mToadCipherRotationBBRightC, Soccer3::mToadCipherRotationBBRightD}},
            {Soccer3::mBitRowBG, Soccer3::mBitRowBH,
             {Soccer3::mToadCipherRotationBBRightE, Soccer3::mToadCipherRotationBBRightF, Soccer3::mToadCipherRotationBBRightG, Soccer3::mToadCipherRotationBBRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBBLeft, Soccer3::mPlaneShiftBBRight,
            Soccer3::mMutateMaterialC));

        // Layer BC
        mLayerBC.Add(new FourToadKernel(
            {Soccer3::mBitRowCA, Soccer3::mBitRowCB,
             {Soccer3::mToadCipherRotationBCLeftA, Soccer3::mToadCipherRotationBCLeftB, Soccer3::mToadCipherRotationBCLeftC, Soccer3::mToadCipherRotationBCLeftD}},
            {Soccer3::mBitRowCC, Soccer3::mBitRowCD,
             {Soccer3::mToadCipherRotationBCLeftE, Soccer3::mToadCipherRotationBCLeftF, Soccer3::mToadCipherRotationBCLeftG, Soccer3::mToadCipherRotationBCLeftH}},
            {Soccer3::mBitRowCE, Soccer3::mBitRowCF,
             {Soccer3::mToadCipherRotationBCRightA, Soccer3::mToadCipherRotationBCRightB, Soccer3::mToadCipherRotationBCRightC, Soccer3::mToadCipherRotationBCRightD}},
            {Soccer3::mBitRowCG, Soccer3::mBitRowCH,
             {Soccer3::mToadCipherRotationBCRightE, Soccer3::mToadCipherRotationBCRightF, Soccer3::mToadCipherRotationBCRightG, Soccer3::mToadCipherRotationBCRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FourCrowKernel(
            Soccer3::mPlaneShiftBCLeft, Soccer3::mPlaneShiftBCRight));

        // Layer BD
        mLayerBD.Add(new FourToadKernel(
            {Soccer3::mBitRowDA, Soccer3::mBitRowDB,
             {Soccer3::mToadCipherRotationBDLeftA, Soccer3::mToadCipherRotationBDLeftB, Soccer3::mToadCipherRotationBDLeftC, Soccer3::mToadCipherRotationBDLeftD}},
            {Soccer3::mBitRowDC, Soccer3::mBitRowDD,
             {Soccer3::mToadCipherRotationBDLeftE, Soccer3::mToadCipherRotationBDLeftF, Soccer3::mToadCipherRotationBDLeftG, Soccer3::mToadCipherRotationBDLeftH}},
            {Soccer3::mBitRowDE, Soccer3::mBitRowDF,
             {Soccer3::mToadCipherRotationBDRightA, Soccer3::mToadCipherRotationBDRightB, Soccer3::mToadCipherRotationBDRightC, Soccer3::mToadCipherRotationBDRightD}},
            {Soccer3::mBitRowDG, Soccer3::mBitRowDH,
             {Soccer3::mToadCipherRotationBDRightE, Soccer3::mToadCipherRotationBDRightF, Soccer3::mToadCipherRotationBDRightG, Soccer3::mToadCipherRotationBDRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBDLeft, Soccer3::mPlaneShiftBDRight,
            Soccer3::mMutateMaterialD));

        mMaterialCount = 4U;
    } else if (mStrength == EncryptionStrength::kStrong) {
        // Layer AA
        mLayerAA.Add(new PasswordXORKernel(Soccer3::mMutateMaterialA));
        mLayerAA.Add(new FourToadKernel(
            {Soccer3::mBitRowAA, Soccer3::mBitRowAB,
             {Soccer3::mToadCipherRotationAALeftA, Soccer3::mToadCipherRotationAALeftB, Soccer3::mToadCipherRotationAALeftC, Soccer3::mToadCipherRotationAALeftD}},
            {Soccer3::mBitRowAC, Soccer3::mBitRowAD,
             {Soccer3::mToadCipherRotationAALeftE, Soccer3::mToadCipherRotationAALeftF, Soccer3::mToadCipherRotationAALeftG, Soccer3::mToadCipherRotationAALeftH}},
            {Soccer3::mBitRowAE, Soccer3::mBitRowAF,
             {Soccer3::mToadCipherRotationAARightA, Soccer3::mToadCipherRotationAARightB, Soccer3::mToadCipherRotationAARightC, Soccer3::mToadCipherRotationAARightD}},
            {Soccer3::mBitRowAG, Soccer3::mBitRowAH,
             {Soccer3::mToadCipherRotationAARightE, Soccer3::mToadCipherRotationAARightF, Soccer3::mToadCipherRotationAARightG, Soccer3::mToadCipherRotationAARightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftAALeft, Soccer3::mPlaneShiftAARight,
            Soccer3::mMutateMaterialB));

        // Layer AB
        mLayerAB.Add(new PasswordXORKernel(Soccer3::mMutateMaterialC));
        mLayerAB.Add(new FourToadKernel(
            {Soccer3::mBitRowBA, Soccer3::mBitRowBB,
             {Soccer3::mToadCipherRotationABLeftA, Soccer3::mToadCipherRotationABLeftB, Soccer3::mToadCipherRotationABLeftC, Soccer3::mToadCipherRotationABLeftD}},
            {Soccer3::mBitRowBC, Soccer3::mBitRowBD,
             {Soccer3::mToadCipherRotationABLeftE, Soccer3::mToadCipherRotationABLeftF, Soccer3::mToadCipherRotationABLeftG, Soccer3::mToadCipherRotationABLeftH}},
            {Soccer3::mBitRowBE, Soccer3::mBitRowBF,
             {Soccer3::mToadCipherRotationABRightA, Soccer3::mToadCipherRotationABRightB, Soccer3::mToadCipherRotationABRightC, Soccer3::mToadCipherRotationABRightD}},
            {Soccer3::mBitRowBG, Soccer3::mBitRowBH,
             {Soccer3::mToadCipherRotationABRightE, Soccer3::mToadCipherRotationABRightF, Soccer3::mToadCipherRotationABRightG, Soccer3::mToadCipherRotationABRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftABLeft, Soccer3::mPlaneShiftABRight,
            Soccer3::mMutateMaterialD));

        // Layer AC
        mLayerAC.Add(new PasswordXORKernel(Soccer3::mMutateMaterialE));
        mLayerAC.Add(new FourToadKernel(
            {Soccer3::mBitRowCA, Soccer3::mBitRowCB,
             {Soccer3::mToadCipherRotationACLeftA, Soccer3::mToadCipherRotationACLeftB, Soccer3::mToadCipherRotationACLeftC, Soccer3::mToadCipherRotationACLeftD}},
            {Soccer3::mBitRowCC, Soccer3::mBitRowCD,
             {Soccer3::mToadCipherRotationACLeftE, Soccer3::mToadCipherRotationACLeftF, Soccer3::mToadCipherRotationACLeftG, Soccer3::mToadCipherRotationACLeftH}},
            {Soccer3::mBitRowCE, Soccer3::mBitRowCF,
             {Soccer3::mToadCipherRotationACRightA, Soccer3::mToadCipherRotationACRightB, Soccer3::mToadCipherRotationACRightC, Soccer3::mToadCipherRotationACRightD}},
            {Soccer3::mBitRowCG, Soccer3::mBitRowCH,
             {Soccer3::mToadCipherRotationACRightE, Soccer3::mToadCipherRotationACRightF, Soccer3::mToadCipherRotationACRightG, Soccer3::mToadCipherRotationACRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftACLeft, Soccer3::mPlaneShiftACRight,
            Soccer3::mMutateMaterialF));

        // Layer AD
        mLayerAD.Add(new PasswordXORKernel(Soccer3::mMutateMaterialG));
        mLayerAD.Add(new FourToadKernel(
            {Soccer3::mBitRowDA, Soccer3::mBitRowDB,
             {Soccer3::mToadCipherRotationADLeftA, Soccer3::mToadCipherRotationADLeftB, Soccer3::mToadCipherRotationADLeftC, Soccer3::mToadCipherRotationADLeftD}},
            {Soccer3::mBitRowDC, Soccer3::mBitRowDD,
             {Soccer3::mToadCipherRotationADLeftE, Soccer3::mToadCipherRotationADLeftF, Soccer3::mToadCipherRotationADLeftG, Soccer3::mToadCipherRotationADLeftH}},
            {Soccer3::mBitRowDE, Soccer3::mBitRowDF,
             {Soccer3::mToadCipherRotationADRightA, Soccer3::mToadCipherRotationADRightB, Soccer3::mToadCipherRotationADRightC, Soccer3::mToadCipherRotationADRightD}},
            {Soccer3::mBitRowDG, Soccer3::mBitRowDH,
             {Soccer3::mToadCipherRotationADRightE, Soccer3::mToadCipherRotationADRightF, Soccer3::mToadCipherRotationADRightG, Soccer3::mToadCipherRotationADRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftADLeft, Soccer3::mPlaneShiftADRight,
            Soccer3::mMutateMaterialH));
        mLayerAD.Add(new BitReverseKernel{});

        // Layer BA
        mLayerBA.Add(new PasswordXORKernel(Soccer3::mMutateMaterialI));
        mLayerBA.Add(new FourToadKernel(
            {Soccer3::mBitRowAA, Soccer3::mBitRowAB,
             {Soccer3::mToadCipherRotationBALeftA, Soccer3::mToadCipherRotationBALeftB, Soccer3::mToadCipherRotationBALeftC, Soccer3::mToadCipherRotationBALeftD}},
            {Soccer3::mBitRowAC, Soccer3::mBitRowAD,
             {Soccer3::mToadCipherRotationBALeftE, Soccer3::mToadCipherRotationBALeftF, Soccer3::mToadCipherRotationBALeftG, Soccer3::mToadCipherRotationBALeftH}},
            {Soccer3::mBitRowAE, Soccer3::mBitRowAF,
             {Soccer3::mToadCipherRotationBARightA, Soccer3::mToadCipherRotationBARightB, Soccer3::mToadCipherRotationBARightC, Soccer3::mToadCipherRotationBARightD}},
            {Soccer3::mBitRowAG, Soccer3::mBitRowAH,
             {Soccer3::mToadCipherRotationBARightE, Soccer3::mToadCipherRotationBARightF, Soccer3::mToadCipherRotationBARightG, Soccer3::mToadCipherRotationBARightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBALeft, Soccer3::mPlaneShiftBARight,
            Soccer3::mMutateMaterialJ));

        // Layer BB
        mLayerBB.Add(new PasswordXORKernel(Soccer3::mMutateMaterialK));
        mLayerBB.Add(new FourToadKernel(
            {Soccer3::mBitRowBA, Soccer3::mBitRowBB,
             {Soccer3::mToadCipherRotationBBLeftA, Soccer3::mToadCipherRotationBBLeftB, Soccer3::mToadCipherRotationBBLeftC, Soccer3::mToadCipherRotationBBLeftD}},
            {Soccer3::mBitRowBC, Soccer3::mBitRowBD,
             {Soccer3::mToadCipherRotationBBLeftE, Soccer3::mToadCipherRotationBBLeftF, Soccer3::mToadCipherRotationBBLeftG, Soccer3::mToadCipherRotationBBLeftH}},
            {Soccer3::mBitRowBE, Soccer3::mBitRowBF,
             {Soccer3::mToadCipherRotationBBRightA, Soccer3::mToadCipherRotationBBRightB, Soccer3::mToadCipherRotationBBRightC, Soccer3::mToadCipherRotationBBRightD}},
            {Soccer3::mBitRowBG, Soccer3::mBitRowBH,
             {Soccer3::mToadCipherRotationBBRightE, Soccer3::mToadCipherRotationBBRightF, Soccer3::mToadCipherRotationBBRightG, Soccer3::mToadCipherRotationBBRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBBLeft, Soccer3::mPlaneShiftBBRight,
            Soccer3::mMutateMaterialL));

        // Layer BC
        mLayerBC.Add(new PasswordXORKernel(Soccer3::mMutateMaterialM));
        mLayerBC.Add(new FourToadKernel(
            {Soccer3::mBitRowCA, Soccer3::mBitRowCB,
             {Soccer3::mToadCipherRotationBCLeftA, Soccer3::mToadCipherRotationBCLeftB, Soccer3::mToadCipherRotationBCLeftC, Soccer3::mToadCipherRotationBCLeftD}},
            {Soccer3::mBitRowCC, Soccer3::mBitRowCD,
             {Soccer3::mToadCipherRotationBCLeftE, Soccer3::mToadCipherRotationBCLeftF, Soccer3::mToadCipherRotationBCLeftG, Soccer3::mToadCipherRotationBCLeftH}},
            {Soccer3::mBitRowCE, Soccer3::mBitRowCF,
             {Soccer3::mToadCipherRotationBCRightA, Soccer3::mToadCipherRotationBCRightB, Soccer3::mToadCipherRotationBCRightC, Soccer3::mToadCipherRotationBCRightD}},
            {Soccer3::mBitRowCG, Soccer3::mBitRowCH,
             {Soccer3::mToadCipherRotationBCRightE, Soccer3::mToadCipherRotationBCRightF, Soccer3::mToadCipherRotationBCRightG, Soccer3::mToadCipherRotationBCRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBCLeft, Soccer3::mPlaneShiftBCRight,
            Soccer3::mMutateMaterialN));

        // Layer BD
        mLayerBD.Add(new PasswordXORKernel(Soccer3::mMutateMaterialO));
        mLayerBD.Add(new FourToadKernel(
            {Soccer3::mBitRowDA, Soccer3::mBitRowDB,
             {Soccer3::mToadCipherRotationBDLeftA, Soccer3::mToadCipherRotationBDLeftB, Soccer3::mToadCipherRotationBDLeftC, Soccer3::mToadCipherRotationBDLeftD}},
            {Soccer3::mBitRowDC, Soccer3::mBitRowDD,
             {Soccer3::mToadCipherRotationBDLeftE, Soccer3::mToadCipherRotationBDLeftF, Soccer3::mToadCipherRotationBDLeftG, Soccer3::mToadCipherRotationBDLeftH}},
            {Soccer3::mBitRowDE, Soccer3::mBitRowDF,
             {Soccer3::mToadCipherRotationBDRightA, Soccer3::mToadCipherRotationBDRightB, Soccer3::mToadCipherRotationBDRightC, Soccer3::mToadCipherRotationBDRightD}},
            {Soccer3::mBitRowDG, Soccer3::mBitRowDH,
             {Soccer3::mToadCipherRotationBDRightE, Soccer3::mToadCipherRotationBDRightF, Soccer3::mToadCipherRotationBDRightG, Soccer3::mToadCipherRotationBDRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBDLeft, Soccer3::mPlaneShiftBDRight,
            Soccer3::mMutateMaterialP));

        mMaterialCount = 16U;
    } else { // Normal, including unrecognized strength values.
        mStrength = EncryptionStrength::kNormal;
        // Layer AA
        mLayerAA.Add(new FourToadKernel(
            {Soccer3::mBitRowAA, Soccer3::mBitRowAB,
             {Soccer3::mToadCipherRotationAALeftA, Soccer3::mToadCipherRotationAALeftB, Soccer3::mToadCipherRotationAALeftC, Soccer3::mToadCipherRotationAALeftD}},
            {Soccer3::mBitRowAC, Soccer3::mBitRowAD,
             {Soccer3::mToadCipherRotationAALeftE, Soccer3::mToadCipherRotationAALeftF, Soccer3::mToadCipherRotationAALeftG, Soccer3::mToadCipherRotationAALeftH}},
            {Soccer3::mBitRowAE, Soccer3::mBitRowAF,
             {Soccer3::mToadCipherRotationAARightA, Soccer3::mToadCipherRotationAARightB, Soccer3::mToadCipherRotationAARightC, Soccer3::mToadCipherRotationAARightD}},
            {Soccer3::mBitRowAG, Soccer3::mBitRowAH,
             {Soccer3::mToadCipherRotationAARightE, Soccer3::mToadCipherRotationAARightF, Soccer3::mToadCipherRotationAARightG, Soccer3::mToadCipherRotationAARightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAA.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftAALeft, Soccer3::mPlaneShiftAARight,
            Soccer3::mMutateMaterialA));

        // Layer AB
        mLayerAB.Add(new FourToadKernel(
            {Soccer3::mBitRowBA, Soccer3::mBitRowBB,
             {Soccer3::mToadCipherRotationABLeftA, Soccer3::mToadCipherRotationABLeftB, Soccer3::mToadCipherRotationABLeftC, Soccer3::mToadCipherRotationABLeftD}},
            {Soccer3::mBitRowBC, Soccer3::mBitRowBD,
             {Soccer3::mToadCipherRotationABLeftE, Soccer3::mToadCipherRotationABLeftF, Soccer3::mToadCipherRotationABLeftG, Soccer3::mToadCipherRotationABLeftH}},
            {Soccer3::mBitRowBE, Soccer3::mBitRowBF,
             {Soccer3::mToadCipherRotationABRightA, Soccer3::mToadCipherRotationABRightB, Soccer3::mToadCipherRotationABRightC, Soccer3::mToadCipherRotationABRightD}},
            {Soccer3::mBitRowBG, Soccer3::mBitRowBH,
             {Soccer3::mToadCipherRotationABRightE, Soccer3::mToadCipherRotationABRightF, Soccer3::mToadCipherRotationABRightG, Soccer3::mToadCipherRotationABRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAB.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftABLeft, Soccer3::mPlaneShiftABRight,
            Soccer3::mMutateMaterialB));

        // Layer AC
        mLayerAC.Add(new FourToadKernel(
            {Soccer3::mBitRowCA, Soccer3::mBitRowCB,
             {Soccer3::mToadCipherRotationACLeftA, Soccer3::mToadCipherRotationACLeftB, Soccer3::mToadCipherRotationACLeftC, Soccer3::mToadCipherRotationACLeftD}},
            {Soccer3::mBitRowCC, Soccer3::mBitRowCD,
             {Soccer3::mToadCipherRotationACLeftE, Soccer3::mToadCipherRotationACLeftF, Soccer3::mToadCipherRotationACLeftG, Soccer3::mToadCipherRotationACLeftH}},
            {Soccer3::mBitRowCE, Soccer3::mBitRowCF,
             {Soccer3::mToadCipherRotationACRightA, Soccer3::mToadCipherRotationACRightB, Soccer3::mToadCipherRotationACRightC, Soccer3::mToadCipherRotationACRightD}},
            {Soccer3::mBitRowCG, Soccer3::mBitRowCH,
             {Soccer3::mToadCipherRotationACRightE, Soccer3::mToadCipherRotationACRightF, Soccer3::mToadCipherRotationACRightG, Soccer3::mToadCipherRotationACRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAC.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftACLeft, Soccer3::mPlaneShiftACRight,
            Soccer3::mMutateMaterialC));

        // Layer AD
        mLayerAD.Add(new FourToadKernel(
            {Soccer3::mBitRowDA, Soccer3::mBitRowDB,
             {Soccer3::mToadCipherRotationADLeftA, Soccer3::mToadCipherRotationADLeftB, Soccer3::mToadCipherRotationADLeftC, Soccer3::mToadCipherRotationADLeftD}},
            {Soccer3::mBitRowDC, Soccer3::mBitRowDD,
             {Soccer3::mToadCipherRotationADLeftE, Soccer3::mToadCipherRotationADLeftF, Soccer3::mToadCipherRotationADLeftG, Soccer3::mToadCipherRotationADLeftH}},
            {Soccer3::mBitRowDE, Soccer3::mBitRowDF,
             {Soccer3::mToadCipherRotationADRightA, Soccer3::mToadCipherRotationADRightB, Soccer3::mToadCipherRotationADRightC, Soccer3::mToadCipherRotationADRightD}},
            {Soccer3::mBitRowDG, Soccer3::mBitRowDH,
             {Soccer3::mToadCipherRotationADRightE, Soccer3::mToadCipherRotationADRightF, Soccer3::mToadCipherRotationADRightG, Soccer3::mToadCipherRotationADRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerAD.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftADLeft, Soccer3::mPlaneShiftADRight,
            Soccer3::mMutateMaterialD));
        mLayerAD.Add(new BitReverseKernel{});

        // Layer BA
        mLayerBA.Add(new FourToadKernel(
            {Soccer3::mBitRowAA, Soccer3::mBitRowAB,
             {Soccer3::mToadCipherRotationBALeftA, Soccer3::mToadCipherRotationBALeftB, Soccer3::mToadCipherRotationBALeftC, Soccer3::mToadCipherRotationBALeftD}},
            {Soccer3::mBitRowAC, Soccer3::mBitRowAD,
             {Soccer3::mToadCipherRotationBALeftE, Soccer3::mToadCipherRotationBALeftF, Soccer3::mToadCipherRotationBALeftG, Soccer3::mToadCipherRotationBALeftH}},
            {Soccer3::mBitRowAE, Soccer3::mBitRowAF,
             {Soccer3::mToadCipherRotationBARightA, Soccer3::mToadCipherRotationBARightB, Soccer3::mToadCipherRotationBARightC, Soccer3::mToadCipherRotationBARightD}},
            {Soccer3::mBitRowAG, Soccer3::mBitRowAH,
             {Soccer3::mToadCipherRotationBARightE, Soccer3::mToadCipherRotationBARightF, Soccer3::mToadCipherRotationBARightG, Soccer3::mToadCipherRotationBARightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBA.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBALeft, Soccer3::mPlaneShiftBARight,
            Soccer3::mMutateMaterialE));

        // Layer BB
        mLayerBB.Add(new FourToadKernel(
            {Soccer3::mBitRowBA, Soccer3::mBitRowBB,
             {Soccer3::mToadCipherRotationBBLeftA, Soccer3::mToadCipherRotationBBLeftB, Soccer3::mToadCipherRotationBBLeftC, Soccer3::mToadCipherRotationBBLeftD}},
            {Soccer3::mBitRowBC, Soccer3::mBitRowBD,
             {Soccer3::mToadCipherRotationBBLeftE, Soccer3::mToadCipherRotationBBLeftF, Soccer3::mToadCipherRotationBBLeftG, Soccer3::mToadCipherRotationBBLeftH}},
            {Soccer3::mBitRowBE, Soccer3::mBitRowBF,
             {Soccer3::mToadCipherRotationBBRightA, Soccer3::mToadCipherRotationBBRightB, Soccer3::mToadCipherRotationBBRightC, Soccer3::mToadCipherRotationBBRightD}},
            {Soccer3::mBitRowBG, Soccer3::mBitRowBH,
             {Soccer3::mToadCipherRotationBBRightE, Soccer3::mToadCipherRotationBBRightF, Soccer3::mToadCipherRotationBBRightG, Soccer3::mToadCipherRotationBBRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBB.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBBLeft, Soccer3::mPlaneShiftBBRight,
            Soccer3::mMutateMaterialF));

        // Layer BC
        mLayerBC.Add(new FourToadKernel(
            {Soccer3::mBitRowCA, Soccer3::mBitRowCB,
             {Soccer3::mToadCipherRotationBCLeftA, Soccer3::mToadCipherRotationBCLeftB, Soccer3::mToadCipherRotationBCLeftC, Soccer3::mToadCipherRotationBCLeftD}},
            {Soccer3::mBitRowCC, Soccer3::mBitRowCD,
             {Soccer3::mToadCipherRotationBCLeftE, Soccer3::mToadCipherRotationBCLeftF, Soccer3::mToadCipherRotationBCLeftG, Soccer3::mToadCipherRotationBCLeftH}},
            {Soccer3::mBitRowCE, Soccer3::mBitRowCF,
             {Soccer3::mToadCipherRotationBCRightA, Soccer3::mToadCipherRotationBCRightB, Soccer3::mToadCipherRotationBCRightC, Soccer3::mToadCipherRotationBCRightD}},
            {Soccer3::mBitRowCG, Soccer3::mBitRowCH,
             {Soccer3::mToadCipherRotationBCRightE, Soccer3::mToadCipherRotationBCRightF, Soccer3::mToadCipherRotationBCRightG, Soccer3::mToadCipherRotationBCRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBC.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBCLeft, Soccer3::mPlaneShiftBCRight,
            Soccer3::mMutateMaterialG));

        // Layer BD
        mLayerBD.Add(new FourToadKernel(
            {Soccer3::mBitRowDA, Soccer3::mBitRowDB,
             {Soccer3::mToadCipherRotationBDLeftA, Soccer3::mToadCipherRotationBDLeftB, Soccer3::mToadCipherRotationBDLeftC, Soccer3::mToadCipherRotationBDLeftD}},
            {Soccer3::mBitRowDC, Soccer3::mBitRowDD,
             {Soccer3::mToadCipherRotationBDLeftE, Soccer3::mToadCipherRotationBDLeftF, Soccer3::mToadCipherRotationBDLeftG, Soccer3::mToadCipherRotationBDLeftH}},
            {Soccer3::mBitRowDE, Soccer3::mBitRowDF,
             {Soccer3::mToadCipherRotationBDRightA, Soccer3::mToadCipherRotationBDRightB, Soccer3::mToadCipherRotationBDRightC, Soccer3::mToadCipherRotationBDRightD}},
            {Soccer3::mBitRowDG, Soccer3::mBitRowDH,
             {Soccer3::mToadCipherRotationBDRightE, Soccer3::mToadCipherRotationBDRightF, Soccer3::mToadCipherRotationBDRightG, Soccer3::mToadCipherRotationBDRightH}},
            {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
        mLayerBD.Add(new FourRavenKernel(
            Soccer3::mPlaneShiftBDLeft, Soccer3::mPlaneShiftBDRight,
            Soccer3::mMutateMaterialH));

        mMaterialCount = 8U;
    }
    mBuilt = true;
    return true;
}

bool Cryptex::SealData(const std::uint8_t *pSource, std::uint8_t *pWorkerA,
                       std::uint8_t *pWorkerB, std::uint8_t *pDestination,
                       std::size_t pLength, KernelErrorCode *pErrorCode) const {
    return Apply(false, pSource, pWorkerA, pWorkerB, pDestination, pLength, pErrorCode);
}

bool Cryptex::UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorkerA,
                         std::uint8_t *pWorkerB, std::uint8_t *pDestination,
                         std::size_t pLength, KernelErrorCode *pErrorCode) const {
    return Apply(true, pSource, pWorkerA, pWorkerB, pDestination, pLength, pErrorCode);
}

bool Cryptex::Apply(bool pUnseal, const std::uint8_t *pSource, std::uint8_t *pWorkerA,
                    std::uint8_t *pWorkerB, std::uint8_t *pDestination,
                    std::size_t pLength, KernelErrorCode *pErrorCode) const {
    const CryptexLayer *aLayers[kLayerCount] = {
        &mLayerAA, &mLayerAB, &mLayerAC, &mLayerAD,
        &mLayerBA, &mLayerBB, &mLayerBC, &mLayerBD
    };
    if (pLength == 0U) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
        return true;
    }

    const std::uint8_t *aBuffers[] = {pSource, pWorkerA, pWorkerB, pDestination};
    for (const auto *aBuffer : aBuffers) {
        if (aBuffer == nullptr) {
            SetKernelErrorCode(pErrorCode, KernelErrorCode::kNullBuffer);
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
                SetKernelErrorCode(pErrorCode, KernelErrorCode::kAliasedBuffer);
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
    SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
    return true;
}
