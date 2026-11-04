#ifndef SOCCER_SKULL_CIPHER_A_HPP_
#define SOCCER_SKULL_CIPHER_A_HPP_

#include "SkullCipherBase.hpp"

// a0 b0, a1 b1, a2 b2, a3 b3, b4 a4, b5 a5, b6 a6, b7 a7.
class SkullCipherA final : public SkullCipherBase<0U, CipherType::kSkullCipherA> {
public:
    using SkullCipherBase<0U, CipherType::kSkullCipherA>::SkullCipherBase;
};

#endif  // SOCCER_SKULL_CIPHER_A_HPP_
