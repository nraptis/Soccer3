#ifndef SOCCER_SPREAD_CIPHER_E_HPP_
#define SOCCER_SPREAD_CIPHER_E_HPP_

#include "SpreadCipherBase.hpp"

// Companion to MixCipherE: preserve bit 4, invert the others when bit 4 is 1.
class SpreadCipherE final : public SpreadCipherBase<4U, CipherType::kSpreadCipherE> {
public:
    using SpreadCipherBase<4U, CipherType::kSpreadCipherE>::SpreadCipherBase;
};

#endif  // SOCCER_SPREAD_CIPHER_E_HPP_
