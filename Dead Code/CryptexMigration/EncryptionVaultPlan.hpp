#ifndef SOCCER_ENCRYPTION_VAULT_PLAN_HPP_
#define SOCCER_ENCRYPTION_VAULT_PLAN_HPP_

#include "BitPlane.hpp"
#include "EncryptionVault.hpp"
#include "WindowRotationFarm.hpp"
#include <array>
#include <span>

struct EncryptionVaultLayerPlan {
    static constexpr std::uint8_t kNoMaterial = 255U;
    BitPlaneRow                 mRow{};
    std::array<std::uint8_t, 2U> mMasks{};
    std::array<std::int32_t, 2U> mRotations{};
    std::array<std::array<std::uint16_t, 4U>, 4U> mSamplingRotations{};
    std::uint8_t                mMaterialBeforeRotations = kNoMaterial;
    std::uint8_t                mMaterialAfterRotations = kNoMaterial;
    bool operator==(const EncryptionVaultLayerPlan &) const = default;
};

struct EncryptionVaultPlan {
    EncryptionStrength mStrength = EncryptionStrength::kTest;
    std::array<EncryptionVaultLayerPlan, EncryptionVault::kLayerCount> mLayers{};
    std::size_t mMaterialCount = 0U;
    bool operator==(const EncryptionVaultPlan &) const = default;
};

class EncryptionVaultPlanTool {
public:
    static constexpr std::size_t kRotationCount = WindowRotationFarm::kFreeRotationCount;
    static constexpr std::size_t kSamplingRotationCount = WindowRotationFarm::kSamplingRotationCount;

    // Same four-layer grid in both rounds, without relabeling its rows after
    // the boundary bit reversal. Each layer consumes one data-only chunk.
    static bool MakePlan(EncryptionStrength pStrength, const BitPlane &pBitPlane,
                         const WindowRotationPack &pRotations,
                         EncryptionVaultPlan &pResult);

    // Each material entry supplies a complete 1 MiB PasswordXOR lane.
    // Validates the entire plan/budget before replacing the vault's ciphers.
    static bool Build(EncryptionVault &pVault, const EncryptionVaultPlan &pPlan,
                      const std::uint8_t *const *pMaterials, std::size_t pMaterialCount,
                      std::span<std::uint8_t> pPackedRows = {});
};

#endif  // SOCCER_ENCRYPTION_VAULT_PLAN_HPP_
