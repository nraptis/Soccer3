#ifndef SOCCER_DANCE_CIPHER_B_HPP_
#define SOCCER_DANCE_CIPHER_B_HPP_

#include "DanceCipherBase.hpp"

// Add the sampled second halves; XOR the sum into the current first half.
class DanceCipherB final : public DanceCipherBase<1U, CipherType::kDanceCipherB> {
public:
    using DanceCipherBase<1U, CipherType::kDanceCipherB>::DanceCipherBase;
};

#endif  // SOCCER_DANCE_CIPHER_B_HPP_
