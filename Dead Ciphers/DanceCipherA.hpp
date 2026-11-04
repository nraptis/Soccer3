#ifndef SOCCER_DANCE_CIPHER_A_HPP_
#define SOCCER_DANCE_CIPHER_A_HPP_

#include "DanceCipherBase.hpp"

// Add the sampled first halves; XOR the sum into the current second half.
class DanceCipherA final : public DanceCipherBase<0U, CipherType::kDanceCipherA> {
public:
    using DanceCipherBase<0U, CipherType::kDanceCipherA>::DanceCipherBase;
};

#endif  // SOCCER_DANCE_CIPHER_A_HPP_
