#ifndef SOCCER_SPREAD_CIPHER_F_HPP_
#define SOCCER_SPREAD_CIPHER_F_HPP_

#include "SpreadCipherBase.hpp"

// Companion to MixCipherF: preserve bit 5, invert the others when bit 5 is 1.
class SpreadCipherF final : public SpreadCipherBase<5U, CipherType::kSpreadCipherF> {
public:
    using SpreadCipherBase<5U, CipherType::kSpreadCipherF>::SpreadCipherBase;
};

#endif  // SOCCER_SPREAD_CIPHER_F_HPP_
