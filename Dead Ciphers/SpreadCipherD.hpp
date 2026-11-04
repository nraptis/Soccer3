#ifndef SOCCER_SPREAD_CIPHER_D_HPP_
#define SOCCER_SPREAD_CIPHER_D_HPP_

#include "SpreadCipherBase.hpp"

// Companion to MixCipherD: preserve bit 3, invert the others when bit 3 is 1.
class SpreadCipherD final : public SpreadCipherBase<3U, CipherType::kSpreadCipherD> {
public:
    using SpreadCipherBase<3U, CipherType::kSpreadCipherD>::SpreadCipherBase;
};

#endif  // SOCCER_SPREAD_CIPHER_D_HPP_
