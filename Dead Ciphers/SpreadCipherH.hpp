#ifndef SOCCER_SPREAD_CIPHER_H_HPP_
#define SOCCER_SPREAD_CIPHER_H_HPP_

#include "SpreadCipherBase.hpp"

// Companion to MixCipherH: preserve bit 7, invert the others when bit 7 is 1.
class SpreadCipherH final : public SpreadCipherBase<7U, CipherType::kSpreadCipherH> {
public:
    using SpreadCipherBase<7U, CipherType::kSpreadCipherH>::SpreadCipherBase;
};

#endif  // SOCCER_SPREAD_CIPHER_H_HPP_
