#pragma once

#include "TwistExpander.hpp"

class TwistExpander_Rigel_Arx {
public:
    static void KDF_A_A_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_B_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_C_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_A_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_B_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_C_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_A_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_B_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_C_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_A_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_B_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_C_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_A_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_B_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_C_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_A_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_B_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_C_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_A_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_B_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_C_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_A_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_B_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_C_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_A_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_B_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_C_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_A_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_B_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_C_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_A_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_B_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_C_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_A_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_B_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_C_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_A_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_B_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_A_C_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_A_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_B_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_B_C_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_A_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_B_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
    static void KDF_C_C_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     TwistDomainConstants *pConstants,
                     TwistDomainSaltSet *pDomainSaltSet,
                     MUTABLE_PARAMS);
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
    static void KEY_A_A_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_B_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_C_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_D_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_E_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_F_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_G_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_H_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_A_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_B_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_C_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_D_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_E_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_F_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_G_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_H_A(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_A_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_B_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_C_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_D_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_E_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_F_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_G_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_H_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_A_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_B_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_C_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_D_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_E_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_F_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_G_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_H_B(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_A_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_B_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_C_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_D_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_E_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_F_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_G_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_H_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_A_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_B_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_C_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_D_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_E_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_F_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_G_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_H_C(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_A_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_B_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_C_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_D_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_E_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_F_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_G_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_H_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_A_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_B_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_C_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_D_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_E_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_F_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_G_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_H_D(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_A_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_B_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_C_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_D_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_E_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_F_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_G_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_A_H_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_A_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_B_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_C_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_D_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_E_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_F_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_G_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void KEY_B_H_E(TwistWorkSpace *pWorkSpace,
                     std::uint64_t pNonce,
                     MUTABLE_PARAMS);
    static void TWIST_A(TwistWorkSpace *pWorkSpace,
                     std::uint8_t *pSource,
                     std::uint8_t *pCrossLaneA,
                     std::uint8_t *pCrossLaneB,
                     std::uint8_t *pCrossLaneC,
                     std::uint8_t *pCrossLaneD,
                     MUTABLE_PARAMS);
    static void TWIST_B(TwistWorkSpace *pWorkSpace,
                     std::uint8_t *pSource,
                     std::uint8_t *pCrossLaneA,
                     std::uint8_t *pCrossLaneB,
                     std::uint8_t *pCrossLaneC,
                     std::uint8_t *pCrossLaneD,
                     MUTABLE_PARAMS);
    static void TWIST_C(TwistWorkSpace *pWorkSpace,
                     std::uint8_t *pSource,
                     std::uint8_t *pCrossLaneA,
                     std::uint8_t *pCrossLaneB,
                     std::uint8_t *pCrossLaneC,
                     std::uint8_t *pCrossLaneD,
                     MUTABLE_PARAMS);
    static void GROW_A_A(TwistWorkSpace *pWorkSpace,
                     std::uint8_t *pCrossLaneA,
                     std::uint8_t *pCrossLaneB,
                     MUTABLE_PARAMS);
    static void GROW_A_B(TwistWorkSpace *pWorkSpace,
                     MUTABLE_PARAMS);
    static void GROW_A_C(TwistWorkSpace *pWorkSpace,
                     MUTABLE_PARAMS);
    static void GROW_A_D(TwistWorkSpace *pWorkSpace,
                     MUTABLE_PARAMS);
    static void GROW_A_E(TwistWorkSpace *pWorkSpace,
                     MUTABLE_PARAMS);
    static void GROW_B_A(TwistWorkSpace *pWorkSpace,
                     std::uint8_t *pCrossLaneA,
                     std::uint8_t *pCrossLaneB,
                     MUTABLE_PARAMS);
    static void GROW_B_B(TwistWorkSpace *pWorkSpace,
                     MUTABLE_PARAMS);
    static void GROW_B_C(TwistWorkSpace *pWorkSpace,
                     MUTABLE_PARAMS);
    static void GROW_B_D(TwistWorkSpace *pWorkSpace,
                     MUTABLE_PARAMS);
    static void GROW_B_E(TwistWorkSpace *pWorkSpace,
                     MUTABLE_PARAMS);
};

//
// Key-lane assignments
//

// KEY_A_A
#define RIGEL_KEY_A_A_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_A_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_A_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_A_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_A_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_A_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_A_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_A_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_A_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_A_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_A_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_A_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_A_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_A_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_A_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_A_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_A_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_A_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_A_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_A_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_A_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_A_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_A_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_A_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_A_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_A_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_A_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_A_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_A_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_A_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_A_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_A_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_A_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_A_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_A_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_A_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_A_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_A_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_A_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_A_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_A_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_A_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_A_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_A_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_A_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_A_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_A_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_A_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_A_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_A_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_A_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_A_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_A_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_A_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_A_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_A_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_A_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_A_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_A_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_A_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_A_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_A_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_A_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_A_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_A_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_A_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_A_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_A_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_A_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_A_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_A_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_A_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_A_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_A_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_A_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_A_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_A_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_A_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_A_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_A_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_A_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_A_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_A_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_A_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_A_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_A_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_A_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_A_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_A_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_A_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_A_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_A_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_A_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_A_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_A_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_A_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_A_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_A_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_A_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_A_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_A_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_A_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_A_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_A_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_A_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_A_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_A_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_A_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_A_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_A_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_A_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_A_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_A_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_A_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_A_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_A_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_A_ArcaneLanes \
    RIGEL_KEY_A_A_ArcaneLaneA, \
    RIGEL_KEY_A_A_ArcaneLaneB, \
    RIGEL_KEY_A_A_ArcaneLaneC, \
    RIGEL_KEY_A_A_ArcaneLaneD
#define RIGEL_KEY_A_A_PlasmaLanes \
    RIGEL_KEY_A_A_PlasmaLaneA, \
    RIGEL_KEY_A_A_PlasmaLaneB, \
    RIGEL_KEY_A_A_PlasmaLaneC, \
    RIGEL_KEY_A_A_PlasmaLaneD
#define RIGEL_KEY_A_A_RainbowLanes \
    RIGEL_KEY_A_A_RainbowLaneA, \
    RIGEL_KEY_A_A_RainbowLaneB, \
    RIGEL_KEY_A_A_RainbowLaneC, \
    RIGEL_KEY_A_A_RainbowLaneD
#define RIGEL_KEY_A_A_WaterLanes \
    RIGEL_KEY_A_A_WaterLaneA, \
    RIGEL_KEY_A_A_WaterLaneB, \
    RIGEL_KEY_A_A_WaterLaneC, \
    RIGEL_KEY_A_A_WaterLaneD
#define RIGEL_KEY_A_A_VaporLanes \
    RIGEL_KEY_A_A_VaporLaneA, \
    RIGEL_KEY_A_A_VaporLaneB, \
    RIGEL_KEY_A_A_VaporLaneC, \
    RIGEL_KEY_A_A_VaporLaneD
#define RIGEL_KEY_A_A_FrostLanes \
    RIGEL_KEY_A_A_FrostLaneA, \
    RIGEL_KEY_A_A_FrostLaneB, \
    RIGEL_KEY_A_A_FrostLaneC, \
    RIGEL_KEY_A_A_FrostLaneD
#define RIGEL_KEY_A_A_IceLanes \
    RIGEL_KEY_A_A_IceLaneA, \
    RIGEL_KEY_A_A_IceLaneB, \
    RIGEL_KEY_A_A_IceLaneC, \
    RIGEL_KEY_A_A_IceLaneD
#define RIGEL_KEY_A_A \
    { \
        { RIGEL_KEY_A_A_ArcaneLanes }, \
        { RIGEL_KEY_A_A_PlasmaLanes }, \
        { RIGEL_KEY_A_A_RainbowLanes }, \
        { RIGEL_KEY_A_A_WaterLanes }, \
        { RIGEL_KEY_A_A_VaporLanes }, \
        { RIGEL_KEY_A_A_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnAConstants) \
    }

// KEY_A_B
#define RIGEL_KEY_A_B_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_B_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_B_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_B_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_B_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_B_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_B_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_B_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_B_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_B_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_B_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_B_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_B_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_B_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_B_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_B_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_B_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_B_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_B_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_B_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_B_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_B_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_B_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_B_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_B_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_B_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_B_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_B_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_B_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_B_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_B_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_B_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_B_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_B_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_B_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_B_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_B_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_B_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_B_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_B_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_B_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_B_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_B_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_B_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_B_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_B_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_B_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_B_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_B_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_B_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_B_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_B_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_B_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_B_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_B_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_B_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_B_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_B_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_B_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_B_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_B_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_B_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_B_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_B_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_B_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_B_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_B_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_B_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_B_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_B_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_B_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_B_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_B_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_B_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_B_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_B_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_B_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_B_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_B_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_B_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_B_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_B_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_B_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_B_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_B_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_B_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_B_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_B_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_B_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_B_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_B_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_B_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_B_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_B_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_B_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_B_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_B_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_B_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_B_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_B_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_B_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_B_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_B_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_B_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_B_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_B_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_B_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_B_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_B_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_B_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_B_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_B_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_B_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_B_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_B_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_B_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_B_ArcaneLanes \
    RIGEL_KEY_A_B_ArcaneLaneA, \
    RIGEL_KEY_A_B_ArcaneLaneB, \
    RIGEL_KEY_A_B_ArcaneLaneC, \
    RIGEL_KEY_A_B_ArcaneLaneD
#define RIGEL_KEY_A_B_PlasmaLanes \
    RIGEL_KEY_A_B_PlasmaLaneA, \
    RIGEL_KEY_A_B_PlasmaLaneB, \
    RIGEL_KEY_A_B_PlasmaLaneC, \
    RIGEL_KEY_A_B_PlasmaLaneD
#define RIGEL_KEY_A_B_RainbowLanes \
    RIGEL_KEY_A_B_RainbowLaneA, \
    RIGEL_KEY_A_B_RainbowLaneB, \
    RIGEL_KEY_A_B_RainbowLaneC, \
    RIGEL_KEY_A_B_RainbowLaneD
#define RIGEL_KEY_A_B_WaterLanes \
    RIGEL_KEY_A_B_WaterLaneA, \
    RIGEL_KEY_A_B_WaterLaneB, \
    RIGEL_KEY_A_B_WaterLaneC, \
    RIGEL_KEY_A_B_WaterLaneD
#define RIGEL_KEY_A_B_VaporLanes \
    RIGEL_KEY_A_B_VaporLaneA, \
    RIGEL_KEY_A_B_VaporLaneB, \
    RIGEL_KEY_A_B_VaporLaneC, \
    RIGEL_KEY_A_B_VaporLaneD
#define RIGEL_KEY_A_B_FrostLanes \
    RIGEL_KEY_A_B_FrostLaneA, \
    RIGEL_KEY_A_B_FrostLaneB, \
    RIGEL_KEY_A_B_FrostLaneC, \
    RIGEL_KEY_A_B_FrostLaneD
#define RIGEL_KEY_A_B_IceLanes \
    RIGEL_KEY_A_B_IceLaneA, \
    RIGEL_KEY_A_B_IceLaneB, \
    RIGEL_KEY_A_B_IceLaneC, \
    RIGEL_KEY_A_B_IceLaneD
#define RIGEL_KEY_A_B \
    { \
        { RIGEL_KEY_A_B_ArcaneLanes }, \
        { RIGEL_KEY_A_B_PlasmaLanes }, \
        { RIGEL_KEY_A_B_RainbowLanes }, \
        { RIGEL_KEY_A_B_WaterLanes }, \
        { RIGEL_KEY_A_B_VaporLanes }, \
        { RIGEL_KEY_A_B_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnAConstants) \
    }

// KEY_A_C
#define RIGEL_KEY_A_C_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_C_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_C_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_C_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_C_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_C_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_C_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_C_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_C_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_C_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_C_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_C_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_C_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_C_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_C_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_C_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_C_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_C_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_C_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_C_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_C_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_C_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_C_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_C_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_C_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_C_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_C_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_C_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_C_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_C_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_C_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_C_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_C_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_C_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_C_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_C_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_C_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_C_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_C_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_C_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_C_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_C_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_C_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_C_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_C_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_C_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_C_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_C_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_C_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_C_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_C_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_C_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_C_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_C_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_C_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_C_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_C_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_C_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_C_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_C_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_C_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_C_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_C_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_C_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_C_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_C_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_C_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_C_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_C_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_C_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_C_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_C_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_C_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_C_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_C_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_C_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_C_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_C_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_C_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_C_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_C_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_C_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_C_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_C_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_C_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_C_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_C_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_C_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_C_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_C_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_C_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_C_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_C_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_C_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_C_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_C_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_C_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_C_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_C_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_C_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_C_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_C_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_C_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_C_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_C_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_C_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_C_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_C_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_C_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_C_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_C_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_C_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_C_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_C_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_C_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_C_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_C_ArcaneLanes \
    RIGEL_KEY_A_C_ArcaneLaneA, \
    RIGEL_KEY_A_C_ArcaneLaneB, \
    RIGEL_KEY_A_C_ArcaneLaneC, \
    RIGEL_KEY_A_C_ArcaneLaneD
#define RIGEL_KEY_A_C_PlasmaLanes \
    RIGEL_KEY_A_C_PlasmaLaneA, \
    RIGEL_KEY_A_C_PlasmaLaneB, \
    RIGEL_KEY_A_C_PlasmaLaneC, \
    RIGEL_KEY_A_C_PlasmaLaneD
#define RIGEL_KEY_A_C_RainbowLanes \
    RIGEL_KEY_A_C_RainbowLaneA, \
    RIGEL_KEY_A_C_RainbowLaneB, \
    RIGEL_KEY_A_C_RainbowLaneC, \
    RIGEL_KEY_A_C_RainbowLaneD
#define RIGEL_KEY_A_C_WaterLanes \
    RIGEL_KEY_A_C_WaterLaneA, \
    RIGEL_KEY_A_C_WaterLaneB, \
    RIGEL_KEY_A_C_WaterLaneC, \
    RIGEL_KEY_A_C_WaterLaneD
#define RIGEL_KEY_A_C_VaporLanes \
    RIGEL_KEY_A_C_VaporLaneA, \
    RIGEL_KEY_A_C_VaporLaneB, \
    RIGEL_KEY_A_C_VaporLaneC, \
    RIGEL_KEY_A_C_VaporLaneD
#define RIGEL_KEY_A_C_FrostLanes \
    RIGEL_KEY_A_C_FrostLaneA, \
    RIGEL_KEY_A_C_FrostLaneB, \
    RIGEL_KEY_A_C_FrostLaneC, \
    RIGEL_KEY_A_C_FrostLaneD
#define RIGEL_KEY_A_C_IceLanes \
    RIGEL_KEY_A_C_IceLaneA, \
    RIGEL_KEY_A_C_IceLaneB, \
    RIGEL_KEY_A_C_IceLaneC, \
    RIGEL_KEY_A_C_IceLaneD
#define RIGEL_KEY_A_C \
    { \
        { RIGEL_KEY_A_C_ArcaneLanes }, \
        { RIGEL_KEY_A_C_PlasmaLanes }, \
        { RIGEL_KEY_A_C_RainbowLanes }, \
        { RIGEL_KEY_A_C_WaterLanes }, \
        { RIGEL_KEY_A_C_VaporLanes }, \
        { RIGEL_KEY_A_C_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnAConstants) \
    }

// KEY_A_D
#define RIGEL_KEY_A_D_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_D_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_D_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_D_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_D_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_D_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_D_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_D_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_D_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_D_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_D_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_D_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_D_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_D_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_D_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_D_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_D_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_D_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_D_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_D_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_D_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_D_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_D_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_D_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_D_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_D_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_D_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_D_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_D_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_D_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_D_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_D_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_D_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_D_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_D_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_D_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_D_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_D_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_D_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_D_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_D_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_D_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_D_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_D_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_D_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_D_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_D_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_D_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_D_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_D_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_D_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_D_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_D_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_D_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_D_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_D_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_D_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_D_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_D_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_D_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_D_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_D_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_D_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_D_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_D_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_D_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_D_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_D_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_D_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_D_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_D_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_D_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_D_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_D_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_D_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_D_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_D_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_D_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_D_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_D_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_D_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_D_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_D_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_D_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_D_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_D_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_D_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_D_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_D_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_D_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_D_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_D_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_D_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_D_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_D_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_D_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_D_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_D_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_D_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_D_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_D_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_D_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_D_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_D_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_D_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_D_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_D_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_D_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_D_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_D_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_D_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_D_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_D_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_D_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_D_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_D_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_D_ArcaneLanes \
    RIGEL_KEY_A_D_ArcaneLaneA, \
    RIGEL_KEY_A_D_ArcaneLaneB, \
    RIGEL_KEY_A_D_ArcaneLaneC, \
    RIGEL_KEY_A_D_ArcaneLaneD
#define RIGEL_KEY_A_D_PlasmaLanes \
    RIGEL_KEY_A_D_PlasmaLaneA, \
    RIGEL_KEY_A_D_PlasmaLaneB, \
    RIGEL_KEY_A_D_PlasmaLaneC, \
    RIGEL_KEY_A_D_PlasmaLaneD
#define RIGEL_KEY_A_D_RainbowLanes \
    RIGEL_KEY_A_D_RainbowLaneA, \
    RIGEL_KEY_A_D_RainbowLaneB, \
    RIGEL_KEY_A_D_RainbowLaneC, \
    RIGEL_KEY_A_D_RainbowLaneD
#define RIGEL_KEY_A_D_WaterLanes \
    RIGEL_KEY_A_D_WaterLaneA, \
    RIGEL_KEY_A_D_WaterLaneB, \
    RIGEL_KEY_A_D_WaterLaneC, \
    RIGEL_KEY_A_D_WaterLaneD
#define RIGEL_KEY_A_D_VaporLanes \
    RIGEL_KEY_A_D_VaporLaneA, \
    RIGEL_KEY_A_D_VaporLaneB, \
    RIGEL_KEY_A_D_VaporLaneC, \
    RIGEL_KEY_A_D_VaporLaneD
#define RIGEL_KEY_A_D_FrostLanes \
    RIGEL_KEY_A_D_FrostLaneA, \
    RIGEL_KEY_A_D_FrostLaneB, \
    RIGEL_KEY_A_D_FrostLaneC, \
    RIGEL_KEY_A_D_FrostLaneD
#define RIGEL_KEY_A_D_IceLanes \
    RIGEL_KEY_A_D_IceLaneA, \
    RIGEL_KEY_A_D_IceLaneB, \
    RIGEL_KEY_A_D_IceLaneC, \
    RIGEL_KEY_A_D_IceLaneD
#define RIGEL_KEY_A_D \
    { \
        { RIGEL_KEY_A_D_ArcaneLanes }, \
        { RIGEL_KEY_A_D_PlasmaLanes }, \
        { RIGEL_KEY_A_D_RainbowLanes }, \
        { RIGEL_KEY_A_D_WaterLanes }, \
        { RIGEL_KEY_A_D_VaporLanes }, \
        { RIGEL_KEY_A_D_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnAConstants) \
    }

// KEY_A_E
#define RIGEL_KEY_A_E_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_E_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_E_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_E_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_E_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_E_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_E_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_E_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_E_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_E_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_E_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_E_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_E_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_E_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_E_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_E_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_E_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_E_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_E_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_E_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_E_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_E_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_E_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_E_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_E_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_E_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_E_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_E_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_E_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_E_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_E_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_E_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_E_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_E_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_E_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_E_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_E_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_E_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_E_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_E_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_E_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_E_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_E_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_E_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_E_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_E_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_E_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_E_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_E_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_E_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_E_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_E_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_E_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_E_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_E_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_E_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_E_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_E_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_E_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_E_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_E_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_E_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_E_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_E_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_E_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_E_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_E_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_E_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_E_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_E_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_E_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_E_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_E_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_E_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_E_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_E_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_E_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_E_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_E_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_E_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_E_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_E_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_E_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_E_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_E_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_E_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_E_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_E_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_E_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_E_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_E_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_E_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_E_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_E_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_E_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_E_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_E_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_E_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_E_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_E_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_E_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_E_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_E_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_E_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_E_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_E_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_E_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_E_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_E_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_E_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_E_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_E_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_E_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_E_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_E_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_E_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_E_ArcaneLanes \
    RIGEL_KEY_A_E_ArcaneLaneA, \
    RIGEL_KEY_A_E_ArcaneLaneB, \
    RIGEL_KEY_A_E_ArcaneLaneC, \
    RIGEL_KEY_A_E_ArcaneLaneD
#define RIGEL_KEY_A_E_PlasmaLanes \
    RIGEL_KEY_A_E_PlasmaLaneA, \
    RIGEL_KEY_A_E_PlasmaLaneB, \
    RIGEL_KEY_A_E_PlasmaLaneC, \
    RIGEL_KEY_A_E_PlasmaLaneD
#define RIGEL_KEY_A_E_RainbowLanes \
    RIGEL_KEY_A_E_RainbowLaneA, \
    RIGEL_KEY_A_E_RainbowLaneB, \
    RIGEL_KEY_A_E_RainbowLaneC, \
    RIGEL_KEY_A_E_RainbowLaneD
#define RIGEL_KEY_A_E_WaterLanes \
    RIGEL_KEY_A_E_WaterLaneA, \
    RIGEL_KEY_A_E_WaterLaneB, \
    RIGEL_KEY_A_E_WaterLaneC, \
    RIGEL_KEY_A_E_WaterLaneD
#define RIGEL_KEY_A_E_VaporLanes \
    RIGEL_KEY_A_E_VaporLaneA, \
    RIGEL_KEY_A_E_VaporLaneB, \
    RIGEL_KEY_A_E_VaporLaneC, \
    RIGEL_KEY_A_E_VaporLaneD
#define RIGEL_KEY_A_E_FrostLanes \
    RIGEL_KEY_A_E_FrostLaneA, \
    RIGEL_KEY_A_E_FrostLaneB, \
    RIGEL_KEY_A_E_FrostLaneC, \
    RIGEL_KEY_A_E_FrostLaneD
#define RIGEL_KEY_A_E_IceLanes \
    RIGEL_KEY_A_E_IceLaneA, \
    RIGEL_KEY_A_E_IceLaneB, \
    RIGEL_KEY_A_E_IceLaneC, \
    RIGEL_KEY_A_E_IceLaneD
#define RIGEL_KEY_A_E \
    { \
        { RIGEL_KEY_A_E_ArcaneLanes }, \
        { RIGEL_KEY_A_E_PlasmaLanes }, \
        { RIGEL_KEY_A_E_RainbowLanes }, \
        { RIGEL_KEY_A_E_WaterLanes }, \
        { RIGEL_KEY_A_E_VaporLanes }, \
        { RIGEL_KEY_A_E_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnAConstants) \
    }

// KEY_A_F
#define RIGEL_KEY_A_F_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_F_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_F_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_F_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_F_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_F_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_F_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_F_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_F_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_F_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_F_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_F_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_F_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_F_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_F_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_F_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_F_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_F_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_F_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_F_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_F_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_F_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_F_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_F_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_F_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_F_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_F_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_F_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_F_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_F_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_F_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_F_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_F_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_F_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_F_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_F_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_F_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_F_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_F_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_F_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_F_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_F_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_F_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_F_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_F_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 4U))
#define RIGEL_KEY_A_F_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_F_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_F_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_F_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_F_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_F_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_F_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_F_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_F_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_F_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_F_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_F_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_F_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_F_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_F_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_F_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_F_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_F_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_F_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_F_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_F_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_F_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_F_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_F_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_F_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_F_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 1U))
#define RIGEL_KEY_A_F_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_F_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_F_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_F_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_F_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_F_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_F_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_F_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_F_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_F_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_F_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_F_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_F_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_F_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_F_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_F_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_F_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_F_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_F_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_F_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_F_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_F_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_F_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_F_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_F_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_F_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_F_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_F_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_F_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_F_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_F_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_F_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_F_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_F_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_F_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_F_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_F_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_F_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_F_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_F_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_F_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_F_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_F_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 15U))
#define RIGEL_KEY_A_F_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_F_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_F_ArcaneLanes \
    RIGEL_KEY_A_F_ArcaneLaneA, \
    RIGEL_KEY_A_F_ArcaneLaneB, \
    RIGEL_KEY_A_F_ArcaneLaneC, \
    RIGEL_KEY_A_F_ArcaneLaneD
#define RIGEL_KEY_A_F_PlasmaLanes \
    RIGEL_KEY_A_F_PlasmaLaneA, \
    RIGEL_KEY_A_F_PlasmaLaneB, \
    RIGEL_KEY_A_F_PlasmaLaneC, \
    RIGEL_KEY_A_F_PlasmaLaneD
#define RIGEL_KEY_A_F_RainbowLanes \
    RIGEL_KEY_A_F_RainbowLaneA, \
    RIGEL_KEY_A_F_RainbowLaneB, \
    RIGEL_KEY_A_F_RainbowLaneC, \
    RIGEL_KEY_A_F_RainbowLaneD
#define RIGEL_KEY_A_F_WaterLanes \
    RIGEL_KEY_A_F_WaterLaneA, \
    RIGEL_KEY_A_F_WaterLaneB, \
    RIGEL_KEY_A_F_WaterLaneC, \
    RIGEL_KEY_A_F_WaterLaneD
#define RIGEL_KEY_A_F_VaporLanes \
    RIGEL_KEY_A_F_VaporLaneA, \
    RIGEL_KEY_A_F_VaporLaneB, \
    RIGEL_KEY_A_F_VaporLaneC, \
    RIGEL_KEY_A_F_VaporLaneD
#define RIGEL_KEY_A_F_FrostLanes \
    RIGEL_KEY_A_F_FrostLaneA, \
    RIGEL_KEY_A_F_FrostLaneB, \
    RIGEL_KEY_A_F_FrostLaneC, \
    RIGEL_KEY_A_F_FrostLaneD
#define RIGEL_KEY_A_F_IceLanes \
    RIGEL_KEY_A_F_IceLaneA, \
    RIGEL_KEY_A_F_IceLaneB, \
    RIGEL_KEY_A_F_IceLaneC, \
    RIGEL_KEY_A_F_IceLaneD
#define RIGEL_KEY_A_F \
    { \
        { RIGEL_KEY_A_F_ArcaneLanes }, \
        { RIGEL_KEY_A_F_PlasmaLanes }, \
        { RIGEL_KEY_A_F_RainbowLanes }, \
        { RIGEL_KEY_A_F_WaterLanes }, \
        { RIGEL_KEY_A_F_VaporLanes }, \
        { RIGEL_KEY_A_F_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnAConstants) \
    }

// KEY_A_G
#define RIGEL_KEY_A_G_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_G_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_G_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_G_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_G_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_G_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_G_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_G_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_G_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_G_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_G_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_G_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_G_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_G_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_G_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_G_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_G_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_G_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_G_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_G_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_G_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_G_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_G_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_G_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_G_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_G_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_G_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_G_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_G_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_G_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_G_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_G_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_G_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_G_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_G_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_G_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_G_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_G_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_G_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_G_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_G_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_G_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_G_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_G_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_G_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_G_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_G_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_G_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_G_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_G_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_G_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_G_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_G_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_G_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_G_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_G_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_G_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_G_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 12U))
#define RIGEL_KEY_A_G_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 13U))
#define RIGEL_KEY_A_G_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_G_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 11U))
#define RIGEL_KEY_A_G_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_G_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_G_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_G_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_G_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_G_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_G_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_G_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_G_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_G_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_G_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_G_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_G_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 4U))
#define RIGEL_KEY_A_G_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_G_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_G_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_G_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_G_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 5U))
#define RIGEL_KEY_A_G_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_G_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_G_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_G_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_G_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_G_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_G_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_G_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_G_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_G_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_G_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_G_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_G_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_G_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_G_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_G_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_G_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_G_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 5U))
#define RIGEL_KEY_A_G_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_G_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_G_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_G_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_G_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_G_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_G_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_G_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 14U))
#define RIGEL_KEY_A_G_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_G_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_G_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_G_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 7U))
#define RIGEL_KEY_A_G_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_G_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_G_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 4U))
#define RIGEL_KEY_A_G_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 0U))
#define RIGEL_KEY_A_G_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_G_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_G_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_G_ArcaneLanes \
    RIGEL_KEY_A_G_ArcaneLaneA, \
    RIGEL_KEY_A_G_ArcaneLaneB, \
    RIGEL_KEY_A_G_ArcaneLaneC, \
    RIGEL_KEY_A_G_ArcaneLaneD
#define RIGEL_KEY_A_G_PlasmaLanes \
    RIGEL_KEY_A_G_PlasmaLaneA, \
    RIGEL_KEY_A_G_PlasmaLaneB, \
    RIGEL_KEY_A_G_PlasmaLaneC, \
    RIGEL_KEY_A_G_PlasmaLaneD
#define RIGEL_KEY_A_G_RainbowLanes \
    RIGEL_KEY_A_G_RainbowLaneA, \
    RIGEL_KEY_A_G_RainbowLaneB, \
    RIGEL_KEY_A_G_RainbowLaneC, \
    RIGEL_KEY_A_G_RainbowLaneD
#define RIGEL_KEY_A_G_WaterLanes \
    RIGEL_KEY_A_G_WaterLaneA, \
    RIGEL_KEY_A_G_WaterLaneB, \
    RIGEL_KEY_A_G_WaterLaneC, \
    RIGEL_KEY_A_G_WaterLaneD
#define RIGEL_KEY_A_G_VaporLanes \
    RIGEL_KEY_A_G_VaporLaneA, \
    RIGEL_KEY_A_G_VaporLaneB, \
    RIGEL_KEY_A_G_VaporLaneC, \
    RIGEL_KEY_A_G_VaporLaneD
#define RIGEL_KEY_A_G_FrostLanes \
    RIGEL_KEY_A_G_FrostLaneA, \
    RIGEL_KEY_A_G_FrostLaneB, \
    RIGEL_KEY_A_G_FrostLaneC, \
    RIGEL_KEY_A_G_FrostLaneD
#define RIGEL_KEY_A_G_IceLanes \
    RIGEL_KEY_A_G_IceLaneA, \
    RIGEL_KEY_A_G_IceLaneB, \
    RIGEL_KEY_A_G_IceLaneC, \
    RIGEL_KEY_A_G_IceLaneD
#define RIGEL_KEY_A_G \
    { \
        { RIGEL_KEY_A_G_ArcaneLanes }, \
        { RIGEL_KEY_A_G_PlasmaLanes }, \
        { RIGEL_KEY_A_G_RainbowLanes }, \
        { RIGEL_KEY_A_G_WaterLanes }, \
        { RIGEL_KEY_A_G_VaporLanes }, \
        { RIGEL_KEY_A_G_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnAConstants) \
    }

// KEY_A_H
#define RIGEL_KEY_A_H_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_H_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_H_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_H_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 6U))
#define RIGEL_KEY_A_H_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_H_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_H_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_H_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_H_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_H_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_H_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_H_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_H_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_H_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_H_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_H_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_H_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_H_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_H_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_H_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 3U))
#define RIGEL_KEY_A_H_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_H_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_H_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_H_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_H_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_H_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_H_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_H_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 7U))
#define RIGEL_KEY_A_H_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 6U))
#define RIGEL_KEY_A_H_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 3U))
#define RIGEL_KEY_A_H_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_H_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_H_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_H_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_H_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_H_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_H_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_H_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_H_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_H_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_H_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_H_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_H_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_H_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_H_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 12U))
#define RIGEL_KEY_A_H_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_H_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 6U))
#define RIGEL_KEY_A_H_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_H_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_H_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 10U))
#define RIGEL_KEY_A_H_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_H_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 2U))
#define RIGEL_KEY_A_H_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_H_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 5U))
#define RIGEL_KEY_A_H_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_H_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_H_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_H_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_H_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 7U))
#define RIGEL_KEY_A_H_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_H_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_H_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 0U))
#define RIGEL_KEY_A_H_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_H_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 15U))
#define RIGEL_KEY_A_H_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_H_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_H_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 11U))
#define RIGEL_KEY_A_H_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_H_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_H_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_H_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_H_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_H_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_H_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 13U))
#define RIGEL_KEY_A_H_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 15U))
#define RIGEL_KEY_A_H_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 11U))
#define RIGEL_KEY_A_H_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 3U))
#define RIGEL_KEY_A_H_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_H_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 0U))
#define RIGEL_KEY_A_H_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 13U))
#define RIGEL_KEY_A_H_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_H_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 2U))
#define RIGEL_KEY_A_H_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 9U))
#define RIGEL_KEY_A_H_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 12U))
#define RIGEL_KEY_A_H_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 13U))
#define RIGEL_KEY_A_H_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 6U))
#define RIGEL_KEY_A_H_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 14U))
#define RIGEL_KEY_A_H_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 8U))
#define RIGEL_KEY_A_H_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 15U))
#define RIGEL_KEY_A_H_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_H_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 8U))
#define RIGEL_KEY_A_H_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 5U))
#define RIGEL_KEY_A_H_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_H_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 14U))
#define RIGEL_KEY_A_H_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 10U))
#define RIGEL_KEY_A_H_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 9U))
#define RIGEL_KEY_A_H_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 1U))
#define RIGEL_KEY_A_H_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 11U))
#define RIGEL_KEY_A_H_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 4U))
#define RIGEL_KEY_A_H_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 10U))
#define RIGEL_KEY_A_H_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 10U))
#define RIGEL_KEY_A_H_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 8U))
#define RIGEL_KEY_A_H_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_H_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_H_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 2U))
#define RIGEL_KEY_A_H_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 9U))
#define RIGEL_KEY_A_H_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 3U))
#define RIGEL_KEY_A_H_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 1U))
#define RIGEL_KEY_A_H_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 8U))
#define RIGEL_KEY_A_H_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 7U))
#define RIGEL_KEY_A_H_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 12U))
#define RIGEL_KEY_A_H_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 0U))
#define RIGEL_KEY_A_H_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 9U))
#define RIGEL_KEY_A_H_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 1U))
#define RIGEL_KEY_A_H_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 2U))
#define RIGEL_KEY_A_H_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 14U))
#define RIGEL_KEY_A_H_ArcaneLanes \
    RIGEL_KEY_A_H_ArcaneLaneA, \
    RIGEL_KEY_A_H_ArcaneLaneB, \
    RIGEL_KEY_A_H_ArcaneLaneC, \
    RIGEL_KEY_A_H_ArcaneLaneD
#define RIGEL_KEY_A_H_PlasmaLanes \
    RIGEL_KEY_A_H_PlasmaLaneA, \
    RIGEL_KEY_A_H_PlasmaLaneB, \
    RIGEL_KEY_A_H_PlasmaLaneC, \
    RIGEL_KEY_A_H_PlasmaLaneD
#define RIGEL_KEY_A_H_RainbowLanes \
    RIGEL_KEY_A_H_RainbowLaneA, \
    RIGEL_KEY_A_H_RainbowLaneB, \
    RIGEL_KEY_A_H_RainbowLaneC, \
    RIGEL_KEY_A_H_RainbowLaneD
#define RIGEL_KEY_A_H_WaterLanes \
    RIGEL_KEY_A_H_WaterLaneA, \
    RIGEL_KEY_A_H_WaterLaneB, \
    RIGEL_KEY_A_H_WaterLaneC, \
    RIGEL_KEY_A_H_WaterLaneD
#define RIGEL_KEY_A_H_VaporLanes \
    RIGEL_KEY_A_H_VaporLaneA, \
    RIGEL_KEY_A_H_VaporLaneB, \
    RIGEL_KEY_A_H_VaporLaneC, \
    RIGEL_KEY_A_H_VaporLaneD
#define RIGEL_KEY_A_H_FrostLanes \
    RIGEL_KEY_A_H_FrostLaneA, \
    RIGEL_KEY_A_H_FrostLaneB, \
    RIGEL_KEY_A_H_FrostLaneC, \
    RIGEL_KEY_A_H_FrostLaneD
#define RIGEL_KEY_A_H_IceLanes \
    RIGEL_KEY_A_H_IceLaneA, \
    RIGEL_KEY_A_H_IceLaneB, \
    RIGEL_KEY_A_H_IceLaneC, \
    RIGEL_KEY_A_H_IceLaneD
#define RIGEL_KEY_A_H \
    { \
        { RIGEL_KEY_A_H_ArcaneLanes }, \
        { RIGEL_KEY_A_H_PlasmaLanes }, \
        { RIGEL_KEY_A_H_RainbowLanes }, \
        { RIGEL_KEY_A_H_WaterLanes }, \
        { RIGEL_KEY_A_H_VaporLanes }, \
        { RIGEL_KEY_A_H_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnAConstants) \
    }

// KEY_B_A
#define RIGEL_KEY_B_A_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_A_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_A_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_A_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_A_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_A_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_A_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_A_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_A_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_A_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_A_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_A_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_A_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_A_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_A_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_A_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_A_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_A_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_A_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_A_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_A_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_A_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_A_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_A_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_A_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_A_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_A_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_A_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_A_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_A_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_A_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_A_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_A_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_A_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_A_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_A_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_A_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_A_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_A_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_A_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_A_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_A_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_A_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_A_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_A_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_A_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_A_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_A_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_A_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_A_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_A_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_A_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_A_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_A_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_A_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_A_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_A_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_A_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_A_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_A_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_A_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_A_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_A_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_A_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_A_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_A_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_A_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_A_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_A_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_A_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_A_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_A_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_A_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_A_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_A_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_A_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_A_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_A_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_A_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_A_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_A_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_A_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_A_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_A_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_A_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_A_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_A_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_A_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_A_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_A_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_A_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_A_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_A_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_A_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_A_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_A_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_A_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_A_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_A_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_A_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_A_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_A_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_A_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_A_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_A_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_A_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_A_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_A_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_A_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_A_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_A_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_A_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_A_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_A_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_A_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_A_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_A_ArcaneLanes \
    RIGEL_KEY_B_A_ArcaneLaneA, \
    RIGEL_KEY_B_A_ArcaneLaneB, \
    RIGEL_KEY_B_A_ArcaneLaneC, \
    RIGEL_KEY_B_A_ArcaneLaneD
#define RIGEL_KEY_B_A_PlasmaLanes \
    RIGEL_KEY_B_A_PlasmaLaneA, \
    RIGEL_KEY_B_A_PlasmaLaneB, \
    RIGEL_KEY_B_A_PlasmaLaneC, \
    RIGEL_KEY_B_A_PlasmaLaneD
#define RIGEL_KEY_B_A_RainbowLanes \
    RIGEL_KEY_B_A_RainbowLaneA, \
    RIGEL_KEY_B_A_RainbowLaneB, \
    RIGEL_KEY_B_A_RainbowLaneC, \
    RIGEL_KEY_B_A_RainbowLaneD
#define RIGEL_KEY_B_A_WaterLanes \
    RIGEL_KEY_B_A_WaterLaneA, \
    RIGEL_KEY_B_A_WaterLaneB, \
    RIGEL_KEY_B_A_WaterLaneC, \
    RIGEL_KEY_B_A_WaterLaneD
#define RIGEL_KEY_B_A_VaporLanes \
    RIGEL_KEY_B_A_VaporLaneA, \
    RIGEL_KEY_B_A_VaporLaneB, \
    RIGEL_KEY_B_A_VaporLaneC, \
    RIGEL_KEY_B_A_VaporLaneD
#define RIGEL_KEY_B_A_FrostLanes \
    RIGEL_KEY_B_A_FrostLaneA, \
    RIGEL_KEY_B_A_FrostLaneB, \
    RIGEL_KEY_B_A_FrostLaneC, \
    RIGEL_KEY_B_A_FrostLaneD
#define RIGEL_KEY_B_A_IceLanes \
    RIGEL_KEY_B_A_IceLaneA, \
    RIGEL_KEY_B_A_IceLaneB, \
    RIGEL_KEY_B_A_IceLaneC, \
    RIGEL_KEY_B_A_IceLaneD
#define RIGEL_KEY_B_A \
    { \
        { RIGEL_KEY_B_A_ArcaneLanes }, \
        { RIGEL_KEY_B_A_PlasmaLanes }, \
        { RIGEL_KEY_B_A_RainbowLanes }, \
        { RIGEL_KEY_B_A_WaterLanes }, \
        { RIGEL_KEY_B_A_VaporLanes }, \
        { RIGEL_KEY_B_A_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnBConstants) \
    }

// KEY_B_B
#define RIGEL_KEY_B_B_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_B_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_B_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_B_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_B_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_B_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_B_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_B_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_B_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_B_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_B_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_B_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_B_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_B_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_B_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_B_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_B_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_B_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_B_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_B_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_B_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_B_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_B_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_B_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_B_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_B_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_B_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_B_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_B_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_B_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_B_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_B_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_B_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_B_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_B_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_B_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_B_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_B_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_B_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_B_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_B_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_B_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_B_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_B_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_B_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_B_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_B_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_B_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_B_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_B_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_B_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_B_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_B_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_B_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_B_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_B_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_B_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_B_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_B_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_B_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_B_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_B_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_B_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_B_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_B_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_B_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_B_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_B_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_B_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_B_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_B_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_B_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_B_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_B_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_B_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_B_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_B_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_B_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_B_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_B_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_B_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_B_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_B_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_B_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_B_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_B_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_B_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_B_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_B_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_B_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_B_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_B_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_B_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_B_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_B_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_B_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_B_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_B_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_B_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_B_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_B_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_B_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_B_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_B_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_B_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_B_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_B_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_B_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_B_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_B_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_B_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_B_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_B_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_B_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_B_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_B_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_B_ArcaneLanes \
    RIGEL_KEY_B_B_ArcaneLaneA, \
    RIGEL_KEY_B_B_ArcaneLaneB, \
    RIGEL_KEY_B_B_ArcaneLaneC, \
    RIGEL_KEY_B_B_ArcaneLaneD
#define RIGEL_KEY_B_B_PlasmaLanes \
    RIGEL_KEY_B_B_PlasmaLaneA, \
    RIGEL_KEY_B_B_PlasmaLaneB, \
    RIGEL_KEY_B_B_PlasmaLaneC, \
    RIGEL_KEY_B_B_PlasmaLaneD
#define RIGEL_KEY_B_B_RainbowLanes \
    RIGEL_KEY_B_B_RainbowLaneA, \
    RIGEL_KEY_B_B_RainbowLaneB, \
    RIGEL_KEY_B_B_RainbowLaneC, \
    RIGEL_KEY_B_B_RainbowLaneD
#define RIGEL_KEY_B_B_WaterLanes \
    RIGEL_KEY_B_B_WaterLaneA, \
    RIGEL_KEY_B_B_WaterLaneB, \
    RIGEL_KEY_B_B_WaterLaneC, \
    RIGEL_KEY_B_B_WaterLaneD
#define RIGEL_KEY_B_B_VaporLanes \
    RIGEL_KEY_B_B_VaporLaneA, \
    RIGEL_KEY_B_B_VaporLaneB, \
    RIGEL_KEY_B_B_VaporLaneC, \
    RIGEL_KEY_B_B_VaporLaneD
#define RIGEL_KEY_B_B_FrostLanes \
    RIGEL_KEY_B_B_FrostLaneA, \
    RIGEL_KEY_B_B_FrostLaneB, \
    RIGEL_KEY_B_B_FrostLaneC, \
    RIGEL_KEY_B_B_FrostLaneD
#define RIGEL_KEY_B_B_IceLanes \
    RIGEL_KEY_B_B_IceLaneA, \
    RIGEL_KEY_B_B_IceLaneB, \
    RIGEL_KEY_B_B_IceLaneC, \
    RIGEL_KEY_B_B_IceLaneD
#define RIGEL_KEY_B_B \
    { \
        { RIGEL_KEY_B_B_ArcaneLanes }, \
        { RIGEL_KEY_B_B_PlasmaLanes }, \
        { RIGEL_KEY_B_B_RainbowLanes }, \
        { RIGEL_KEY_B_B_WaterLanes }, \
        { RIGEL_KEY_B_B_VaporLanes }, \
        { RIGEL_KEY_B_B_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnBConstants) \
    }

// KEY_B_C
#define RIGEL_KEY_B_C_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_C_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_C_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_C_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_C_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_C_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_C_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_C_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_C_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_C_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_C_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_C_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_C_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_C_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_C_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_C_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_C_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_C_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_C_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_C_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_C_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_C_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_C_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_C_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_C_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_C_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_C_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_C_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_C_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_C_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_C_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_C_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_C_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_C_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_C_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_C_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_C_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_C_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_C_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_C_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_C_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_C_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_C_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_C_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_C_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_C_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_C_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_C_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_C_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_C_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_C_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_C_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_C_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_C_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_C_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_C_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_C_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_C_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_C_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_C_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_C_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_C_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_C_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_C_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_C_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_C_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_C_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_C_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_C_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_C_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_C_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_C_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_C_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_C_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_C_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_C_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_C_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_C_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_C_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_C_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_C_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_C_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_C_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_C_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_C_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_C_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_C_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_C_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_C_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_C_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_C_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_C_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_C_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_C_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_C_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_C_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_C_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_C_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_C_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_C_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_C_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_C_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_C_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_C_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_C_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_C_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_C_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_C_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_C_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_C_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_C_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_C_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_C_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_C_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_C_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_C_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_C_ArcaneLanes \
    RIGEL_KEY_B_C_ArcaneLaneA, \
    RIGEL_KEY_B_C_ArcaneLaneB, \
    RIGEL_KEY_B_C_ArcaneLaneC, \
    RIGEL_KEY_B_C_ArcaneLaneD
#define RIGEL_KEY_B_C_PlasmaLanes \
    RIGEL_KEY_B_C_PlasmaLaneA, \
    RIGEL_KEY_B_C_PlasmaLaneB, \
    RIGEL_KEY_B_C_PlasmaLaneC, \
    RIGEL_KEY_B_C_PlasmaLaneD
#define RIGEL_KEY_B_C_RainbowLanes \
    RIGEL_KEY_B_C_RainbowLaneA, \
    RIGEL_KEY_B_C_RainbowLaneB, \
    RIGEL_KEY_B_C_RainbowLaneC, \
    RIGEL_KEY_B_C_RainbowLaneD
#define RIGEL_KEY_B_C_WaterLanes \
    RIGEL_KEY_B_C_WaterLaneA, \
    RIGEL_KEY_B_C_WaterLaneB, \
    RIGEL_KEY_B_C_WaterLaneC, \
    RIGEL_KEY_B_C_WaterLaneD
#define RIGEL_KEY_B_C_VaporLanes \
    RIGEL_KEY_B_C_VaporLaneA, \
    RIGEL_KEY_B_C_VaporLaneB, \
    RIGEL_KEY_B_C_VaporLaneC, \
    RIGEL_KEY_B_C_VaporLaneD
#define RIGEL_KEY_B_C_FrostLanes \
    RIGEL_KEY_B_C_FrostLaneA, \
    RIGEL_KEY_B_C_FrostLaneB, \
    RIGEL_KEY_B_C_FrostLaneC, \
    RIGEL_KEY_B_C_FrostLaneD
#define RIGEL_KEY_B_C_IceLanes \
    RIGEL_KEY_B_C_IceLaneA, \
    RIGEL_KEY_B_C_IceLaneB, \
    RIGEL_KEY_B_C_IceLaneC, \
    RIGEL_KEY_B_C_IceLaneD
#define RIGEL_KEY_B_C \
    { \
        { RIGEL_KEY_B_C_ArcaneLanes }, \
        { RIGEL_KEY_B_C_PlasmaLanes }, \
        { RIGEL_KEY_B_C_RainbowLanes }, \
        { RIGEL_KEY_B_C_WaterLanes }, \
        { RIGEL_KEY_B_C_VaporLanes }, \
        { RIGEL_KEY_B_C_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnBConstants) \
    }

// KEY_B_D
#define RIGEL_KEY_B_D_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_D_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_D_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_D_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_D_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_D_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_D_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_D_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_D_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_D_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_D_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_D_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_D_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_D_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_D_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_D_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_D_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_D_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_D_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_D_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_D_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_D_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_D_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_D_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_D_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_D_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_D_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_D_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_D_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_D_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_D_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_D_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_D_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_D_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_D_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_D_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_D_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_D_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_D_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_D_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_D_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_D_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_D_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_D_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_D_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_D_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_D_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_D_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_D_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_D_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_D_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_D_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_D_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_D_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_D_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_D_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_D_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_D_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_D_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_D_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_D_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_D_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_D_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_D_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_D_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_D_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_D_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_D_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_D_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_D_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_D_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_D_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_D_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_D_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_D_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_D_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_D_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_D_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_D_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_D_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_D_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_D_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_D_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_D_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_D_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_D_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_D_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_D_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_D_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_D_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_D_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_D_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_D_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_D_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_D_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_D_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_D_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_D_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_D_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_D_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_D_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_D_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_D_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_D_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_D_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_D_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_D_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_D_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_D_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_D_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_D_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_D_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_D_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_D_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_D_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_D_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_D_ArcaneLanes \
    RIGEL_KEY_B_D_ArcaneLaneA, \
    RIGEL_KEY_B_D_ArcaneLaneB, \
    RIGEL_KEY_B_D_ArcaneLaneC, \
    RIGEL_KEY_B_D_ArcaneLaneD
#define RIGEL_KEY_B_D_PlasmaLanes \
    RIGEL_KEY_B_D_PlasmaLaneA, \
    RIGEL_KEY_B_D_PlasmaLaneB, \
    RIGEL_KEY_B_D_PlasmaLaneC, \
    RIGEL_KEY_B_D_PlasmaLaneD
#define RIGEL_KEY_B_D_RainbowLanes \
    RIGEL_KEY_B_D_RainbowLaneA, \
    RIGEL_KEY_B_D_RainbowLaneB, \
    RIGEL_KEY_B_D_RainbowLaneC, \
    RIGEL_KEY_B_D_RainbowLaneD
#define RIGEL_KEY_B_D_WaterLanes \
    RIGEL_KEY_B_D_WaterLaneA, \
    RIGEL_KEY_B_D_WaterLaneB, \
    RIGEL_KEY_B_D_WaterLaneC, \
    RIGEL_KEY_B_D_WaterLaneD
#define RIGEL_KEY_B_D_VaporLanes \
    RIGEL_KEY_B_D_VaporLaneA, \
    RIGEL_KEY_B_D_VaporLaneB, \
    RIGEL_KEY_B_D_VaporLaneC, \
    RIGEL_KEY_B_D_VaporLaneD
#define RIGEL_KEY_B_D_FrostLanes \
    RIGEL_KEY_B_D_FrostLaneA, \
    RIGEL_KEY_B_D_FrostLaneB, \
    RIGEL_KEY_B_D_FrostLaneC, \
    RIGEL_KEY_B_D_FrostLaneD
#define RIGEL_KEY_B_D_IceLanes \
    RIGEL_KEY_B_D_IceLaneA, \
    RIGEL_KEY_B_D_IceLaneB, \
    RIGEL_KEY_B_D_IceLaneC, \
    RIGEL_KEY_B_D_IceLaneD
#define RIGEL_KEY_B_D \
    { \
        { RIGEL_KEY_B_D_ArcaneLanes }, \
        { RIGEL_KEY_B_D_PlasmaLanes }, \
        { RIGEL_KEY_B_D_RainbowLanes }, \
        { RIGEL_KEY_B_D_WaterLanes }, \
        { RIGEL_KEY_B_D_VaporLanes }, \
        { RIGEL_KEY_B_D_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnBConstants) \
    }

// KEY_B_E
#define RIGEL_KEY_B_E_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_E_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_E_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_E_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_E_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_E_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_E_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_E_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_E_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_E_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_E_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_E_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_E_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_E_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_E_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_E_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_E_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_E_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_E_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_E_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_E_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_E_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_E_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_E_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_E_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_E_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_E_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_E_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_E_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_E_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_E_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_E_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_E_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_E_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_E_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_E_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_E_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_E_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_E_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_E_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_E_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_E_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_E_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_E_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_E_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_E_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_E_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_E_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_E_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_E_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_E_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_E_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_E_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_E_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_E_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_E_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_E_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_E_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_E_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_E_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_E_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_E_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_E_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_E_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_E_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_E_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_E_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_E_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_E_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_E_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_E_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_E_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_E_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_E_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_E_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_E_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_E_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_E_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_E_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_E_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_E_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_E_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_E_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_E_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_E_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_E_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_E_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_E_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_E_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_E_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_E_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_E_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_E_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_E_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_E_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_E_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_E_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_E_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_E_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_E_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_E_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_E_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_E_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_E_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_E_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_E_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_E_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_E_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_E_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_E_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_E_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_E_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_E_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_E_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_E_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_E_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_E_ArcaneLanes \
    RIGEL_KEY_B_E_ArcaneLaneA, \
    RIGEL_KEY_B_E_ArcaneLaneB, \
    RIGEL_KEY_B_E_ArcaneLaneC, \
    RIGEL_KEY_B_E_ArcaneLaneD
#define RIGEL_KEY_B_E_PlasmaLanes \
    RIGEL_KEY_B_E_PlasmaLaneA, \
    RIGEL_KEY_B_E_PlasmaLaneB, \
    RIGEL_KEY_B_E_PlasmaLaneC, \
    RIGEL_KEY_B_E_PlasmaLaneD
#define RIGEL_KEY_B_E_RainbowLanes \
    RIGEL_KEY_B_E_RainbowLaneA, \
    RIGEL_KEY_B_E_RainbowLaneB, \
    RIGEL_KEY_B_E_RainbowLaneC, \
    RIGEL_KEY_B_E_RainbowLaneD
#define RIGEL_KEY_B_E_WaterLanes \
    RIGEL_KEY_B_E_WaterLaneA, \
    RIGEL_KEY_B_E_WaterLaneB, \
    RIGEL_KEY_B_E_WaterLaneC, \
    RIGEL_KEY_B_E_WaterLaneD
#define RIGEL_KEY_B_E_VaporLanes \
    RIGEL_KEY_B_E_VaporLaneA, \
    RIGEL_KEY_B_E_VaporLaneB, \
    RIGEL_KEY_B_E_VaporLaneC, \
    RIGEL_KEY_B_E_VaporLaneD
#define RIGEL_KEY_B_E_FrostLanes \
    RIGEL_KEY_B_E_FrostLaneA, \
    RIGEL_KEY_B_E_FrostLaneB, \
    RIGEL_KEY_B_E_FrostLaneC, \
    RIGEL_KEY_B_E_FrostLaneD
#define RIGEL_KEY_B_E_IceLanes \
    RIGEL_KEY_B_E_IceLaneA, \
    RIGEL_KEY_B_E_IceLaneB, \
    RIGEL_KEY_B_E_IceLaneC, \
    RIGEL_KEY_B_E_IceLaneD
#define RIGEL_KEY_B_E \
    { \
        { RIGEL_KEY_B_E_ArcaneLanes }, \
        { RIGEL_KEY_B_E_PlasmaLanes }, \
        { RIGEL_KEY_B_E_RainbowLanes }, \
        { RIGEL_KEY_B_E_WaterLanes }, \
        { RIGEL_KEY_B_E_VaporLanes }, \
        { RIGEL_KEY_B_E_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnBConstants) \
    }

// KEY_B_F
#define RIGEL_KEY_B_F_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_F_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_F_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_F_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_F_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_F_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_F_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_F_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_F_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_F_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_F_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_F_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_F_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_F_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_F_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_F_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_F_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_F_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_F_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_F_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_F_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_F_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_F_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_F_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_F_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_F_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_F_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_F_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_F_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_F_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_F_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_F_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_F_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_F_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_F_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_F_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_F_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_F_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_F_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_F_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_F_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_F_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_F_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_F_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_F_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_F_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_F_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_F_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_F_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_F_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_F_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_F_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_F_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_F_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_F_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_F_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_F_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_F_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_F_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_F_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_F_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_F_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_F_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_F_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_F_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_F_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_F_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_F_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_F_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_F_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_F_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_F_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_F_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_F_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_F_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_F_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_F_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_F_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_F_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_F_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 0U))
#define RIGEL_KEY_B_F_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_F_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_F_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_F_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_F_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_F_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_F_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_F_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_F_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_F_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_F_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_F_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_F_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_F_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_F_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_F_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_F_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_F_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_F_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_F_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_F_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_F_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_F_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_F_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_F_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_F_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_F_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_F_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_F_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_F_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_F_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_F_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_F_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 13U))
#define RIGEL_KEY_B_F_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_F_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_F_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_F_ArcaneLanes \
    RIGEL_KEY_B_F_ArcaneLaneA, \
    RIGEL_KEY_B_F_ArcaneLaneB, \
    RIGEL_KEY_B_F_ArcaneLaneC, \
    RIGEL_KEY_B_F_ArcaneLaneD
#define RIGEL_KEY_B_F_PlasmaLanes \
    RIGEL_KEY_B_F_PlasmaLaneA, \
    RIGEL_KEY_B_F_PlasmaLaneB, \
    RIGEL_KEY_B_F_PlasmaLaneC, \
    RIGEL_KEY_B_F_PlasmaLaneD
#define RIGEL_KEY_B_F_RainbowLanes \
    RIGEL_KEY_B_F_RainbowLaneA, \
    RIGEL_KEY_B_F_RainbowLaneB, \
    RIGEL_KEY_B_F_RainbowLaneC, \
    RIGEL_KEY_B_F_RainbowLaneD
#define RIGEL_KEY_B_F_WaterLanes \
    RIGEL_KEY_B_F_WaterLaneA, \
    RIGEL_KEY_B_F_WaterLaneB, \
    RIGEL_KEY_B_F_WaterLaneC, \
    RIGEL_KEY_B_F_WaterLaneD
#define RIGEL_KEY_B_F_VaporLanes \
    RIGEL_KEY_B_F_VaporLaneA, \
    RIGEL_KEY_B_F_VaporLaneB, \
    RIGEL_KEY_B_F_VaporLaneC, \
    RIGEL_KEY_B_F_VaporLaneD
#define RIGEL_KEY_B_F_FrostLanes \
    RIGEL_KEY_B_F_FrostLaneA, \
    RIGEL_KEY_B_F_FrostLaneB, \
    RIGEL_KEY_B_F_FrostLaneC, \
    RIGEL_KEY_B_F_FrostLaneD
#define RIGEL_KEY_B_F_IceLanes \
    RIGEL_KEY_B_F_IceLaneA, \
    RIGEL_KEY_B_F_IceLaneB, \
    RIGEL_KEY_B_F_IceLaneC, \
    RIGEL_KEY_B_F_IceLaneD
#define RIGEL_KEY_B_F \
    { \
        { RIGEL_KEY_B_F_ArcaneLanes }, \
        { RIGEL_KEY_B_F_PlasmaLanes }, \
        { RIGEL_KEY_B_F_RainbowLanes }, \
        { RIGEL_KEY_B_F_WaterLanes }, \
        { RIGEL_KEY_B_F_VaporLanes }, \
        { RIGEL_KEY_B_F_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnBConstants) \
    }

// KEY_B_G
#define RIGEL_KEY_B_G_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_G_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_G_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_G_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_G_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_G_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_G_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_G_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_G_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_G_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_G_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_G_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_G_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_G_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_G_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_G_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_G_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_G_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_G_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_G_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_G_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_G_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_G_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_G_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_G_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_G_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 7U))
#define RIGEL_KEY_B_G_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_G_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_G_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_G_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_G_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_G_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_G_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_G_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_G_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_G_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_G_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_G_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_G_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_G_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_G_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_G_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_G_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_G_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_G_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_G_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_G_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_G_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_G_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_G_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_G_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_G_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_G_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_G_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 8U))
#define RIGEL_KEY_B_G_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_G_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_G_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_G_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_G_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 5U))
#define RIGEL_KEY_B_G_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_G_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_G_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_G_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_G_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_G_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_G_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_G_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_G_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_G_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_G_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_G_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_G_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_G_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_G_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 1U))
#define RIGEL_KEY_B_G_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_G_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_G_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_G_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_G_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_G_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_G_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_G_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_G_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_G_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_G_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_G_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_G_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_G_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_G_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_G_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_G_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_G_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 10U))
#define RIGEL_KEY_B_G_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_G_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_G_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_G_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_G_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_G_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_G_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 9U))
#define RIGEL_KEY_B_G_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_G_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_G_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 15U))
#define RIGEL_KEY_B_G_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_G_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_G_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_G_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_G_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_G_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_G_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_G_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_G_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_G_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_G_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_G_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_G_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_G_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 1U))
#define RIGEL_KEY_B_G_ArcaneLanes \
    RIGEL_KEY_B_G_ArcaneLaneA, \
    RIGEL_KEY_B_G_ArcaneLaneB, \
    RIGEL_KEY_B_G_ArcaneLaneC, \
    RIGEL_KEY_B_G_ArcaneLaneD
#define RIGEL_KEY_B_G_PlasmaLanes \
    RIGEL_KEY_B_G_PlasmaLaneA, \
    RIGEL_KEY_B_G_PlasmaLaneB, \
    RIGEL_KEY_B_G_PlasmaLaneC, \
    RIGEL_KEY_B_G_PlasmaLaneD
#define RIGEL_KEY_B_G_RainbowLanes \
    RIGEL_KEY_B_G_RainbowLaneA, \
    RIGEL_KEY_B_G_RainbowLaneB, \
    RIGEL_KEY_B_G_RainbowLaneC, \
    RIGEL_KEY_B_G_RainbowLaneD
#define RIGEL_KEY_B_G_WaterLanes \
    RIGEL_KEY_B_G_WaterLaneA, \
    RIGEL_KEY_B_G_WaterLaneB, \
    RIGEL_KEY_B_G_WaterLaneC, \
    RIGEL_KEY_B_G_WaterLaneD
#define RIGEL_KEY_B_G_VaporLanes \
    RIGEL_KEY_B_G_VaporLaneA, \
    RIGEL_KEY_B_G_VaporLaneB, \
    RIGEL_KEY_B_G_VaporLaneC, \
    RIGEL_KEY_B_G_VaporLaneD
#define RIGEL_KEY_B_G_FrostLanes \
    RIGEL_KEY_B_G_FrostLaneA, \
    RIGEL_KEY_B_G_FrostLaneB, \
    RIGEL_KEY_B_G_FrostLaneC, \
    RIGEL_KEY_B_G_FrostLaneD
#define RIGEL_KEY_B_G_IceLanes \
    RIGEL_KEY_B_G_IceLaneA, \
    RIGEL_KEY_B_G_IceLaneB, \
    RIGEL_KEY_B_G_IceLaneC, \
    RIGEL_KEY_B_G_IceLaneD
#define RIGEL_KEY_B_G \
    { \
        { RIGEL_KEY_B_G_ArcaneLanes }, \
        { RIGEL_KEY_B_G_PlasmaLanes }, \
        { RIGEL_KEY_B_G_RainbowLanes }, \
        { RIGEL_KEY_B_G_WaterLanes }, \
        { RIGEL_KEY_B_G_VaporLanes }, \
        { RIGEL_KEY_B_G_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnBConstants) \
    }

// KEY_B_H
#define RIGEL_KEY_B_H_EarthLaneA (pWorkSpace->mEarthLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_H_EarthLaneB (pWorkSpace->mEarthLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_H_EarthLaneC (pWorkSpace->mEarthLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_H_EarthLaneD (pWorkSpace->mEarthLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_H_FireLaneA (pWorkSpace->mFireLaneA + (W_KEY * 4U))
#define RIGEL_KEY_B_H_FireLaneB (pWorkSpace->mFireLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_H_FireLaneC (pWorkSpace->mFireLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_H_FireLaneD (pWorkSpace->mFireLaneD + (W_KEY * 6U))
#define RIGEL_KEY_B_H_WindLaneA (pWorkSpace->mWindLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_H_WindLaneB (pWorkSpace->mWindLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_H_WindLaneC (pWorkSpace->mWindLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_H_WindLaneD (pWorkSpace->mWindLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_H_WaterLaneA (pWorkSpace->mWaterLaneA + (W_KEY * 11U))
#define RIGEL_KEY_B_H_WaterLaneB (pWorkSpace->mWaterLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_H_WaterLaneC (pWorkSpace->mWaterLaneC + (W_KEY * 6U))
#define RIGEL_KEY_B_H_WaterLaneD (pWorkSpace->mWaterLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_H_RainbowLaneA (pWorkSpace->mRainbowLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_H_RainbowLaneB (pWorkSpace->mRainbowLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_H_RainbowLaneC (pWorkSpace->mRainbowLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_H_RainbowLaneD (pWorkSpace->mRainbowLaneD + (W_KEY * 12U))
#define RIGEL_KEY_B_H_LightningLaneA (pWorkSpace->mLightningLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_H_LightningLaneB (pWorkSpace->mLightningLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_H_LightningLaneC (pWorkSpace->mLightningLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_H_LightningLaneD (pWorkSpace->mLightningLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_H_IceLaneA (pWorkSpace->mIceLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_H_IceLaneB (pWorkSpace->mIceLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_H_IceLaneC (pWorkSpace->mIceLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_H_IceLaneD (pWorkSpace->mIceLaneD + (W_KEY * 4U))
#define RIGEL_KEY_B_H_PlasmaLaneA (pWorkSpace->mPlasmaLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_H_PlasmaLaneB (pWorkSpace->mPlasmaLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_H_PlasmaLaneC (pWorkSpace->mPlasmaLaneC + (W_KEY * 14U))
#define RIGEL_KEY_B_H_PlasmaLaneD (pWorkSpace->mPlasmaLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_H_ShadowLaneA (pWorkSpace->mShadowLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_H_ShadowLaneB (pWorkSpace->mShadowLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_H_ShadowLaneC (pWorkSpace->mShadowLaneC + (W_KEY * 11U))
#define RIGEL_KEY_B_H_ShadowLaneD (pWorkSpace->mShadowLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_H_CrystalLaneA (pWorkSpace->mCrystalLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_H_CrystalLaneB (pWorkSpace->mCrystalLaneB + (W_KEY * 3U))
#define RIGEL_KEY_B_H_CrystalLaneC (pWorkSpace->mCrystalLaneC + (W_KEY * 2U))
#define RIGEL_KEY_B_H_CrystalLaneD (pWorkSpace->mCrystalLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_H_AetherLaneA (pWorkSpace->mAetherLaneA + (W_KEY * 7U))
#define RIGEL_KEY_B_H_AetherLaneB (pWorkSpace->mAetherLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_H_AetherLaneC (pWorkSpace->mAetherLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_H_AetherLaneD (pWorkSpace->mAetherLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_H_CelestialLaneA (pWorkSpace->mCelestialLaneA + (W_KEY * 0U))
#define RIGEL_KEY_B_H_CelestialLaneB (pWorkSpace->mCelestialLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_H_CelestialLaneC (pWorkSpace->mCelestialLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_H_CelestialLaneD (pWorkSpace->mCelestialLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_H_VaporLaneA (pWorkSpace->mVaporLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_H_VaporLaneB (pWorkSpace->mVaporLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_H_VaporLaneC (pWorkSpace->mVaporLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_H_VaporLaneD (pWorkSpace->mVaporLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_H_KineticLaneA (pWorkSpace->mKineticLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_H_KineticLaneB (pWorkSpace->mKineticLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_H_KineticLaneC (pWorkSpace->mKineticLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_H_KineticLaneD (pWorkSpace->mKineticLaneD + (W_KEY * 3U))
#define RIGEL_KEY_B_H_SonicLaneA (pWorkSpace->mSonicLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_H_SonicLaneB (pWorkSpace->mSonicLaneB + (W_KEY * 4U))
#define RIGEL_KEY_B_H_SonicLaneC (pWorkSpace->mSonicLaneC + (W_KEY * 3U))
#define RIGEL_KEY_B_H_SonicLaneD (pWorkSpace->mSonicLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_H_PlanarLaneA (pWorkSpace->mPlanarLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_H_PlanarLaneB (pWorkSpace->mPlanarLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_H_PlanarLaneC (pWorkSpace->mPlanarLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_H_PlanarLaneD (pWorkSpace->mPlanarLaneD + (W_KEY * 14U))
#define RIGEL_KEY_B_H_FrostLaneA (pWorkSpace->mFrostLaneA + (W_KEY * 8U))
#define RIGEL_KEY_B_H_FrostLaneB (pWorkSpace->mFrostLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_H_FrostLaneC (pWorkSpace->mFrostLaneC + (W_KEY * 7U))
#define RIGEL_KEY_B_H_FrostLaneD (pWorkSpace->mFrostLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_H_ArcaneLaneA (pWorkSpace->mArcaneLaneA + (W_KEY * 15U))
#define RIGEL_KEY_B_H_ArcaneLaneB (pWorkSpace->mArcaneLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_H_ArcaneLaneC (pWorkSpace->mArcaneLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_H_ArcaneLaneD (pWorkSpace->mArcaneLaneD + (W_KEY * 2U))
#define RIGEL_KEY_B_H_LunarLaneA (pWorkSpace->mLunarLaneA + (W_KEY * 9U))
#define RIGEL_KEY_B_H_LunarLaneB (pWorkSpace->mLunarLaneB + (W_KEY * 10U))
#define RIGEL_KEY_B_H_LunarLaneC (pWorkSpace->mLunarLaneC + (W_KEY * 0U))
#define RIGEL_KEY_B_H_LunarLaneD (pWorkSpace->mLunarLaneD + (W_KEY * 13U))
#define RIGEL_KEY_B_H_RunicLaneA (pWorkSpace->mRunicLaneA + (W_KEY * 6U))
#define RIGEL_KEY_B_H_RunicLaneB (pWorkSpace->mRunicLaneB + (W_KEY * 2U))
#define RIGEL_KEY_B_H_RunicLaneC (pWorkSpace->mRunicLaneC + (W_KEY * 8U))
#define RIGEL_KEY_B_H_RunicLaneD (pWorkSpace->mRunicLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_H_GloomLaneA (pWorkSpace->mGloomLaneA + (W_KEY * 10U))
#define RIGEL_KEY_B_H_GloomLaneB (pWorkSpace->mGloomLaneB + (W_KEY * 0U))
#define RIGEL_KEY_B_H_GloomLaneC (pWorkSpace->mGloomLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_H_GloomLaneD (pWorkSpace->mGloomLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_H_SpiritLaneA (pWorkSpace->mSpiritLaneA + (W_KEY * 1U))
#define RIGEL_KEY_B_H_SpiritLaneB (pWorkSpace->mSpiritLaneB + (W_KEY * 11U))
#define RIGEL_KEY_B_H_SpiritLaneC (pWorkSpace->mSpiritLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_H_SpiritLaneD (pWorkSpace->mSpiritLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_H_AbjurationLaneA (pWorkSpace->mAbjurationLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_H_AbjurationLaneB (pWorkSpace->mAbjurationLaneB + (W_KEY * 6U))
#define RIGEL_KEY_B_H_AbjurationLaneC (pWorkSpace->mAbjurationLaneC + (W_KEY * 12U))
#define RIGEL_KEY_B_H_AbjurationLaneD (pWorkSpace->mAbjurationLaneD + (W_KEY * 7U))
#define RIGEL_KEY_B_H_DivinationLaneA (pWorkSpace->mDivinationLaneA + (W_KEY * 3U))
#define RIGEL_KEY_B_H_DivinationLaneB (pWorkSpace->mDivinationLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_H_DivinationLaneC (pWorkSpace->mDivinationLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_H_DivinationLaneD (pWorkSpace->mDivinationLaneD + (W_KEY * 15U))
#define RIGEL_KEY_B_H_EvocationLaneA (pWorkSpace->mEvocationLaneA + (W_KEY * 2U))
#define RIGEL_KEY_B_H_EvocationLaneB (pWorkSpace->mEvocationLaneB + (W_KEY * 5U))
#define RIGEL_KEY_B_H_EvocationLaneC (pWorkSpace->mEvocationLaneC + (W_KEY * 13U))
#define RIGEL_KEY_B_H_EvocationLaneD (pWorkSpace->mEvocationLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_H_AlchemyLaneA (pWorkSpace->mAlchemyLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_H_AlchemyLaneB (pWorkSpace->mAlchemyLaneB + (W_KEY * 13U))
#define RIGEL_KEY_B_H_AlchemyLaneC (pWorkSpace->mAlchemyLaneC + (W_KEY * 1U))
#define RIGEL_KEY_B_H_AlchemyLaneD (pWorkSpace->mAlchemyLaneD + (W_KEY * 8U))
#define RIGEL_KEY_B_H_AuguryLaneA (pWorkSpace->mAuguryLaneA + (W_KEY * 12U))
#define RIGEL_KEY_B_H_AuguryLaneB (pWorkSpace->mAuguryLaneB + (W_KEY * 14U))
#define RIGEL_KEY_B_H_AuguryLaneC (pWorkSpace->mAuguryLaneC + (W_KEY * 10U))
#define RIGEL_KEY_B_H_AuguryLaneD (pWorkSpace->mAuguryLaneD + (W_KEY * 11U))
#define RIGEL_KEY_B_H_PsychicLaneA (pWorkSpace->mPsychicLaneA + (W_KEY * 14U))
#define RIGEL_KEY_B_H_PsychicLaneB (pWorkSpace->mPsychicLaneB + (W_KEY * 9U))
#define RIGEL_KEY_B_H_PsychicLaneC (pWorkSpace->mPsychicLaneC + (W_KEY * 4U))
#define RIGEL_KEY_B_H_PsychicLaneD (pWorkSpace->mPsychicLaneD + (W_KEY * 5U))
#define RIGEL_KEY_B_H_VoodooLaneA (pWorkSpace->mVoodooLaneA + (W_KEY * 5U))
#define RIGEL_KEY_B_H_VoodooLaneB (pWorkSpace->mVoodooLaneB + (W_KEY * 12U))
#define RIGEL_KEY_B_H_VoodooLaneC (pWorkSpace->mVoodooLaneC + (W_KEY * 15U))
#define RIGEL_KEY_B_H_VoodooLaneD (pWorkSpace->mVoodooLaneD + (W_KEY * 9U))
#define RIGEL_KEY_B_H_ArcaneLanes \
    RIGEL_KEY_B_H_ArcaneLaneA, \
    RIGEL_KEY_B_H_ArcaneLaneB, \
    RIGEL_KEY_B_H_ArcaneLaneC, \
    RIGEL_KEY_B_H_ArcaneLaneD
#define RIGEL_KEY_B_H_PlasmaLanes \
    RIGEL_KEY_B_H_PlasmaLaneA, \
    RIGEL_KEY_B_H_PlasmaLaneB, \
    RIGEL_KEY_B_H_PlasmaLaneC, \
    RIGEL_KEY_B_H_PlasmaLaneD
#define RIGEL_KEY_B_H_RainbowLanes \
    RIGEL_KEY_B_H_RainbowLaneA, \
    RIGEL_KEY_B_H_RainbowLaneB, \
    RIGEL_KEY_B_H_RainbowLaneC, \
    RIGEL_KEY_B_H_RainbowLaneD
#define RIGEL_KEY_B_H_WaterLanes \
    RIGEL_KEY_B_H_WaterLaneA, \
    RIGEL_KEY_B_H_WaterLaneB, \
    RIGEL_KEY_B_H_WaterLaneC, \
    RIGEL_KEY_B_H_WaterLaneD
#define RIGEL_KEY_B_H_VaporLanes \
    RIGEL_KEY_B_H_VaporLaneA, \
    RIGEL_KEY_B_H_VaporLaneB, \
    RIGEL_KEY_B_H_VaporLaneC, \
    RIGEL_KEY_B_H_VaporLaneD
#define RIGEL_KEY_B_H_FrostLanes \
    RIGEL_KEY_B_H_FrostLaneA, \
    RIGEL_KEY_B_H_FrostLaneB, \
    RIGEL_KEY_B_H_FrostLaneC, \
    RIGEL_KEY_B_H_FrostLaneD
#define RIGEL_KEY_B_H_IceLanes \
    RIGEL_KEY_B_H_IceLaneA, \
    RIGEL_KEY_B_H_IceLaneB, \
    RIGEL_KEY_B_H_IceLaneC, \
    RIGEL_KEY_B_H_IceLaneD
#define RIGEL_KEY_B_H \
    { \
        { RIGEL_KEY_B_H_ArcaneLanes }, \
        { RIGEL_KEY_B_H_PlasmaLanes }, \
        { RIGEL_KEY_B_H_RainbowLanes }, \
        { RIGEL_KEY_B_H_WaterLanes }, \
        { RIGEL_KEY_B_H_VaporLanes }, \
        { RIGEL_KEY_B_H_FrostLanes }, \
        &(pWorkSpace->mDomainBundle.mKeySpawnBConstants) \
    }
