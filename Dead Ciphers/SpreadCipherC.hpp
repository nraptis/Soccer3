#ifndef SOCCER_SPREAD_CIPHER_C_HPP_
#define SOCCER_SPREAD_CIPHER_C_HPP_

#include "SpreadCipherBase.hpp"

// Companion to MixCipherC: preserve bit 2, invert the others when bit 2 is 1.
class SpreadCipherC final : public SpreadCipherBase<2U, CipherType::kSpreadCipherC> {
public:
    using SpreadCipherBase<2U, CipherType::kSpreadCipherC>::SpreadCipherBase;
};

#endif  // SOCCER_SPREAD_CIPHER_C_HPP_
