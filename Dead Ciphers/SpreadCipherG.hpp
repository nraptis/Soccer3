#ifndef SOCCER_SPREAD_CIPHER_G_HPP_
#define SOCCER_SPREAD_CIPHER_G_HPP_

#include "SpreadCipherBase.hpp"

// Companion to MixCipherG: preserve bit 6, invert the others when bit 6 is 1.
class SpreadCipherG final : public SpreadCipherBase<6U, CipherType::kSpreadCipherG> {
public:
    using SpreadCipherBase<6U, CipherType::kSpreadCipherG>::SpreadCipherBase;
};

#endif  // SOCCER_SPREAD_CIPHER_G_HPP_
