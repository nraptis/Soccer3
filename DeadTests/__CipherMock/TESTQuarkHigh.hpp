//
//  TESTQuarkHigh.hpp
//  ScrambleTests
//
//  Created by Icarus Black on 11/22/26.
//

#ifndef TESTQuarkHigh_hpp
#define TESTQuarkHigh_hpp

#include <cstddef>
#include <cstdint>

class TESTQuarkHigh {
public:

    static constexpr std::size_t kWindowBytes = 32U; // 256 bits

    // Relative window offsets, in 32-byte units, wrapping around the block.
    TESTQuarkHigh(std::size_t pWindowA, std::size_t pWindowB);

    std::size_t                     mWindowA;
    std::size_t                     mWindowB;

    // Sample HIGH nibbles; add their XOR into the current LOW nibble mod 16.
    // At byte j of current window w:
    //   key = (source[(w+A)%count][j] ^ source[(w+B)%count][j]) >> 4
    //   out = (current & 0xF0) | (((current & 0x0F) + key) & 0x0F)
    // Unseal subtracts the same key. High nibbles stay unchanged globally.
    // "current" comes from pSource; pDestination need not be initialized.
    // Exact in-place operation is supported; other overlaps are rejected.
    // Nonzero lengths must be multiples of 32. pWorker is unused.
    bool                            SealData(const std::uint8_t *pSource,
                                             std::uint8_t *pWorker,
                                             std::uint8_t *pDestination,
                                             std::size_t pLength) const;

    bool                            UnsealData(const std::uint8_t *pSource,
                                               std::uint8_t *pWorker,
                                               std::uint8_t *pDestination,
                                               std::size_t pLength) const;

private:
    bool Apply(bool pInverse, const std::uint8_t *pSource,
               std::uint8_t *pDestination, std::size_t pLength) const;
};

#endif /* TESTQuarkHigh_hpp */
