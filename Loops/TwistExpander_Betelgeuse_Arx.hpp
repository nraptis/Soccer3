#pragma once

#include "TwistExpander.hpp"

class TwistExpander_Betelgeuse_Arx {
public:
    static void KDF_A_A_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_B_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_C_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_A_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_B_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_C_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_A_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_B_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_C_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void SEED_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_F(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_G(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_H(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_I(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_J(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_K(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_L(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_M(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_N(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_O(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_P(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void SEED_Q(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
};
