#ifndef SOCCER_SPREAD_CIPHER_A_HPP_
#define SOCCER_SPREAD_CIPHER_A_HPP_

#include "SpreadCipherBase.hpp"

// Companion to MixCipherA: preserve bit 0, invert the others when bit 0 is 1.
class SpreadCipherA final : public SpreadCipherBase<0U, CipherType::kSpreadCipherA> {
public:
    using SpreadCipherBase<0U, CipherType::kSpreadCipherA>::SpreadCipherBase;
};

#endif  // SOCCER_SPREAD_CIPHER_A_HPP_
