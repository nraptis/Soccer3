#include "EncryptionVaultPlan.hpp"
#include "FlameToadCipher.hpp"
#include "PasswordXORCipher.hpp"
#include "RotateMaskCipher.hpp"
#include "BitReverseCipher.hpp"
#include "Jelly.hpp"

bool EncryptionVaultPlanTool::MakePlan(EncryptionStrength pStrength, const BitPlane &pBitPlane,
                                       const WindowRotationPack &pRotations,
                                       EncryptionVaultPlan &pResult) {
    pResult = {};
    if ((pStrength != EncryptionStrength::kWeak && pStrength != EncryptionStrength::kNormal &&
         pStrength != EncryptionStrength::kStrong) || !pBitPlane.IsValid() ||
        !WindowRotationFarm::IsValid(pRotations)) return false;

    const WindowRotationPackChunk *aChunks[] = {
        &pRotations.mPlaneA.mChunkA, &pRotations.mPlaneA.mChunkB,
        &pRotations.mPlaneA.mChunkC, &pRotations.mPlaneA.mChunkD,
        &pRotations.mPlaneB.mChunkA, &pRotations.mPlaneB.mChunkB,
        &pRotations.mPlaneB.mChunkC, &pRotations.mPlaneB.mChunkD
    };

    // Explicit mutation schedule in execution order, l0 through l7.
    constexpr bool kWeakTrailingXOR[] = {false, false, true, true, false, false, true, true};
    constexpr bool kNormalTrailingXOR[] = {true, true, true, true, true, true, true, true};
    constexpr bool kStrongLeadingXOR[] = {true, true, true, true, true, true, true, true};
    pResult.mStrength = pStrength;
    for (std::size_t aIndex = 0U; aIndex < pResult.mLayers.size(); ++aIndex) {
        auto &aLayer = pResult.mLayers[aIndex];
        aLayer.mRow = pBitPlane.GetRow(aIndex % 4U);
        for (const auto &aPair : aLayer.mRow.mPairs) {
            aLayer.mMasks[0U] |= static_cast<std::uint8_t>(1U << aPair.mBitA);
            aLayer.mMasks[1U] |= static_cast<std::uint8_t>(1U << aPair.mBitB);
        }
        const auto &aChunk = *aChunks[aIndex];
        aLayer.mRotations = {aChunk.mFreeA, aChunk.mFreeB};
        aLayer.mSamplingRotations = {{
            {aChunk.mWindowA, aChunk.mWindowB, aChunk.mWindowC, aChunk.mWindowD},
            {aChunk.mWindowE, aChunk.mWindowF, aChunk.mWindowG, aChunk.mWindowH},
            {aChunk.mWindowI, aChunk.mWindowJ, aChunk.mWindowK, aChunk.mWindowL},
            {aChunk.mWindowM, aChunk.mWindowN, aChunk.mWindowO, aChunk.mWindowP}
        }};
        if (pStrength == EncryptionStrength::kStrong && kStrongLeadingXOR[aIndex])
            aLayer.mMaterialBeforeRotations = static_cast<std::uint8_t>(pResult.mMaterialCount++);
        if (pStrength == EncryptionStrength::kWeak ? kWeakTrailingXOR[aIndex] : kNormalTrailingXOR[aIndex])
            aLayer.mMaterialAfterRotations = static_cast<std::uint8_t>(pResult.mMaterialCount++);
    }
    return true;
}

bool EncryptionVaultPlanTool::Build(EncryptionVault &pVault, const EncryptionVaultPlan &pPlan,
                                    const std::uint8_t *const *pMaterials, std::size_t pMaterialCount,
                                    std::span<std::uint8_t> pPackedRows) {
    BitPlane aBitPlane{};
    WindowRotationPack aRotations{};
    WindowRotationPackChunk *aChunks[] = {
        &aRotations.mPlaneA.mChunkA, &aRotations.mPlaneA.mChunkB,
        &aRotations.mPlaneA.mChunkC, &aRotations.mPlaneA.mChunkD,
        &aRotations.mPlaneB.mChunkA, &aRotations.mPlaneB.mChunkB,
        &aRotations.mPlaneB.mChunkC, &aRotations.mPlaneB.mChunkD
    };
    for (std::size_t aIndex = 0U; aIndex < pPlan.mLayers.size(); ++aIndex) {
        if (aIndex < 4U) aBitPlane.SetRow(aIndex, pPlan.mLayers[aIndex].mRow);
        const auto &aLayer = pPlan.mLayers[aIndex];
        const auto &aSamples = aLayer.mSamplingRotations;
        *aChunks[aIndex] = {
            aLayer.mRotations[0U], aLayer.mRotations[1U],
            aSamples[0U][0U], aSamples[0U][1U], aSamples[0U][2U], aSamples[0U][3U],
            aSamples[1U][0U], aSamples[1U][1U], aSamples[1U][2U], aSamples[1U][3U],
            aSamples[2U][0U], aSamples[2U][1U], aSamples[2U][2U], aSamples[2U][3U],
            aSamples[3U][0U], aSamples[3U][1U], aSamples[3U][2U], aSamples[3U][3U]
        };
    }
    EncryptionVaultPlan aExpected;
    if (!MakePlan(pPlan.mStrength, aBitPlane, aRotations, aExpected) ||
        pPlan != aExpected || pMaterials == nullptr || pMaterialCount < pPlan.mMaterialCount) return false;
    for (std::size_t aIndex = 0U; aIndex < pPlan.mMaterialCount; ++aIndex)
        if (pMaterials[aIndex] == nullptr) return false;
    if (!pPackedRows.empty()) {
        if (!pPackedRows.data() || pPackedRows.size() < SOCCER_BLOCK_SIZE/4U) return false;
        const auto aCache = reinterpret_cast<std::uintptr_t>(pPackedRows.data());
        for (std::size_t aIndex = 0U; aIndex < pPlan.mMaterialCount; ++aIndex) {
            const auto aMaterial = reinterpret_cast<std::uintptr_t>(pMaterials[aIndex]);
            if (aCache <= aMaterial ? aMaterial-aCache < SOCCER_BLOCK_SIZE/4U : aCache-aMaterial < SOCCER_BLOCK_SIZE) return false;
        }
    }

    pVault.Free();
    using AddCipher = void (EncryptionLayerRound::*)(Cipher *);
    constexpr AddCipher kAddCipher[] = {
        &EncryptionLayerRound::AddCipherLayerA, &EncryptionLayerRound::AddCipherLayerB,
        &EncryptionLayerRound::AddCipherLayerC, &EncryptionLayerRound::AddCipherLayerD
    };
    for (std::size_t aIndex = 0U; aIndex < pPlan.mLayers.size(); ++aIndex) {
        const auto &aLayer = pPlan.mLayers[aIndex];
        auto &aRound = aIndex < 4U ? pVault.mRoundA : pVault.mRoundB;
        const auto aAdd = [&](Cipher *pCipher) { (aRound.*kAddCipher[aIndex % 4U])(pCipher); };

        // The same explicitly ordered cipher stack on every full-size layer.
        const auto aAddFlame = [&](std::size_t pIndex) {
            const auto &aRows = aLayer.mRow.mPairs[pIndex];
            const auto &aRotations = aLayer.mSamplingRotations[pIndex];
            aAdd(new FlameToadCipher(aRows.mBitA, aRows.mBitB, aRotations[0U], aRotations[1U],
                                    aRotations[2U], aRotations[3U], pPackedRows));
        };
        aAddFlame(0U);
        aAddFlame(1U);
        aAddFlame(2U);
        aAddFlame(3U);
        if (aLayer.mMaterialBeforeRotations != EncryptionVaultLayerPlan::kNoMaterial)
            aAdd(new PasswordXORCipher(pMaterials[aLayer.mMaterialBeforeRotations]));
        aAdd(new RotateMaskCipher(aLayer.mMasks[0U], static_cast<std::size_t>(aLayer.mRotations[0U])));
        aAdd(new RotateMaskCipher(aLayer.mMasks[1U], static_cast<std::size_t>(aLayer.mRotations[1U])));
        if (aLayer.mMaterialAfterRotations != EncryptionVaultLayerPlan::kNoMaterial)
            aAdd(new PasswordXORCipher(pMaterials[aLayer.mMaterialAfterRotations]));
    }
    // After all operations (including trailing XOR) in the first four layers.
    // Appending to A.D preserves four layers per round and reverses naturally.
    pVault.mRoundA.AddCipherLayerD(new BitReverseCipher{});
    return true;
}
