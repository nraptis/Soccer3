#pragma once

#include "TwistExpander.hpp"
#include "TwistExpander_Mimosa_Arx.hpp"

class TwistExpander_Mimosa : public TwistExpander {
public:
    TwistExpander_Mimosa();
    ~TwistExpander_Mimosa() override = default;

    void KDF_A_A(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_B_A(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_C_A(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_A_B(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_B_B(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_C_B(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_A_C(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_B_C(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_C_C(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_A_D(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_B_D(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_C_D(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_A_E(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_B_E(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_C_E(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_A_F(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_B_F(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void KDF_C_F(TwistWorkSpace *pWorkSpace,
               std::uint64_t pNonce,
               TwistDomainConstants *pConstants,
               TwistDomainSaltSet *pDomainSaltSet,
               MUTABLE_PARAMS);
    void Seed(TwistWorkSpace *pWorkSpace,
              std::uint64_t pNonce,
              std::uint8_t *pPassword,
              std::size_t pPasswordByteLength,
              std::uint8_t *pDestination,
              MUTABLE_PARAMS) override;
    void TwistBlock(TwistWorkSpace *pWorkSpace,
                    std::uint8_t *pSource,
                    std::uint8_t *pCrossLaneA,
                    std::uint8_t *pCrossLaneB,
                    std::uint8_t *pCrossLaneC,
                    std::uint8_t *pCrossLaneD,
                    std::uint8_t *pDestination,
                    bool pStifleKey,
                    MUTABLE_PARAMS) override;
    void GrowKeyA(TwistWorkSpace *pWorkSpace,
                  std::uint8_t *pCrossLaneA,
                  std::uint8_t *pCrossLaneB,
                  MUTABLE_PARAMS) override;
    void GrowKeyB(TwistWorkSpace *pWorkSpace,
                  std::uint8_t *pCrossLaneA,
                  std::uint8_t *pCrossLaneB,
                  MUTABLE_PARAMS) override;

private:
    void TwistForkKeyHalfA(TwistWorkSpace *pWorkSpace);
    void TwistForkKeyHalfB(TwistWorkSpace *pWorkSpace);
    struct KeyDiffuseLanes {
        std::uint8_t *mA;
        std::uint8_t *mB;
        std::uint8_t *mC;
        std::uint8_t *mD;
    };
    struct KeyDiffuseBundle {
        KeyDiffuseLanes mEntropyA;
        KeyDiffuseLanes mInputA;
        KeyDiffuseLanes mOutputA;
        KeyDiffuseLanes mEntropyB;
        KeyDiffuseLanes mInputB;
        KeyDiffuseLanes mOutputB;
        TwistDomainConstants *mConstants;
    };
    void KeyDiffuseA(TwistWorkSpace *pWorkSpace,
                     const KeyDiffuseBundle &pBundle);
    void KeyDiffuseB(TwistWorkSpace *pWorkSpace,
                     const KeyDiffuseBundle &pBundle);
    static const TwistDomainSaltSet kKeyRotateASalts;
    static const TwistDomainConstants kKeyRotateAConstants;
    static const TwistDomainSaltSet kKeyRotateBSalts;
    static const TwistDomainConstants kKeyRotateBConstants;
    static const TwistDomainSaltSet kKeySpawnASalts;
    static const TwistDomainConstants kKeySpawnAConstants;
    static const TwistDomainSaltSet kKeySpawnBSalts;
    static const TwistDomainConstants kKeySpawnBConstants;
    static const TwistDomainSaltSet kSeedSalts;
    static const TwistDomainConstants kSeedConstants;
    static const TwistDomainSaltSet kTwistSalts;
    static const TwistDomainConstants kTwistConstants;
};
