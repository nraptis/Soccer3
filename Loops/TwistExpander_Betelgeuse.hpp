#pragma once

#include "TwistExpander.hpp"
#include "TwistExpander_Betelgeuse_Arx.hpp"

class TwistExpander_Betelgeuse : public TwistExpander {
public:
    TwistExpander_Betelgeuse();
    ~TwistExpander_Betelgeuse() override = default;

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

private:
    static const TwistDomainSaltSet kSeedSalts;
    static const TwistDomainConstants kSeedConstants;
};
