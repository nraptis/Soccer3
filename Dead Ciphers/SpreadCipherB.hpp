#ifndef SOCCER_SPREAD_CIPHER_B_HPP_
#define SOCCER_SPREAD_CIPHER_B_HPP_

#include "SpreadCipherBase.hpp"

// Companion to MixCipherB: preserve bit 1, invert the others when bit 1 is 1.
class SpreadCipherB final : public SpreadCipherBase<1U, CipherType::kSpreadCipherB> {
public:
    using SpreadCipherBase<1U, CipherType::kSpreadCipherB>::SpreadCipherBase;
};

#endif  // SOCCER_SPREAD_CIPHER_B_HPP_
