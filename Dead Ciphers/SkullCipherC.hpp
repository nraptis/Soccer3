#ifndef SOCCER_SKULL_CIPHER_C_HPP_
#define SOCCER_SKULL_CIPHER_C_HPP_

#include "SkullCipherBase.hpp"

// b0 a0, b1 a1, b2 a2, b3 a3, a4 b4, a5 b5, a6 b6, a7 b7.
class SkullCipherC final : public SkullCipherBase<2U, CipherType::kSkullCipherC> {
public:
    using SkullCipherBase<2U, CipherType::kSkullCipherC>::SkullCipherBase;
};

#endif  // SOCCER_SKULL_CIPHER_C_HPP_
