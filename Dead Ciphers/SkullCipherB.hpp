#ifndef SOCCER_SKULL_CIPHER_B_HPP_
#define SOCCER_SKULL_CIPHER_B_HPP_

#include "SkullCipherBase.hpp"

// a4 b4, a5 b5, a6 b6, a7 b7, b0 a0, b1 a1, b2 a2, b3 a3.
class SkullCipherB final : public SkullCipherBase<1U, CipherType::kSkullCipherB> {
public:
    using SkullCipherBase<1U, CipherType::kSkullCipherB>::SkullCipherBase;
};

#endif  // SOCCER_SKULL_CIPHER_B_HPP_
