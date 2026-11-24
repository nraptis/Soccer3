#ifndef TESTQuarkLow_hpp
#define TESTQuarkLow_hpp

#include <cstddef>
#include <cstdint>

class TESTQuarkLow {
public:
    static constexpr std::size_t kWindowBytes = 32U; // 256 bits

    // Relative window offsets, in 32-byte units, wrapping around the block.
    TESTQuarkLow(std::size_t pWindowA, std::size_t pWindowB);

    std::size_t mWindowA;
    std::size_t mWindowB;

    // Sample LOW nibbles; add their XOR into the current HIGH nibble mod 16.
    //   key = (sampleA ^ sampleB) & 0x0F
    //   out = (current & 0x0F) | ((((current >> 4) + key) & 0x0F) << 4)
    // Unseal subtracts the same key. Low nibbles stay unchanged globally.
    // "current" comes from pSource; pDestination need not be initialized.
    // Exact in-place operation is supported; other overlaps are rejected.
    // Nonzero lengths must be multiples of 32. pWorker is unused.
    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength) const;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength) const;

private:
    bool Apply(bool pInverse, const std::uint8_t *pSource,
               std::uint8_t *pDestination, std::size_t pLength) const;
};

#endif /* TESTQuarkLow_hpp */
