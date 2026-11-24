#ifndef TESTFourToad_hpp
#define TESTFourToad_hpp

#include <array>
#include <cstddef>
#include <cstdint>

// Readable scalar reference for FourToadKernel. Each of four successive stages:
//   1. Preserves two bit positions (rows) in EVERY byte of the block.
//   2. Samples those rows from four bytes in a selected 64-byte window.
//   3. Packs the eight sampled bits, applies the AND gate, and keeps six bits.
//   4. Adds that six-bit key to the current byte's six writable bits mod 64.
//
// Unseal subtracts instead of adding and runs stages 4, 3, 2, 1.
// The row numbers refer to bit positions: row 0 is 0b00000001, row 7 is
// 0b10000000. These windows are 64 BYTES, unlike Bog/Quirk's 256-byte windows.
class TESTFourToad {
public:
    static constexpr std::size_t kWindowBytes = 64U;
    static constexpr std::size_t kBytesPerGroup = 4U;
    static constexpr std::size_t kGroupsPerWindow = kWindowBytes / kBytesPerGroup;

    // Same parameter layout and meaning as FourToadKernel::Stage.
    struct Stage {
        std::size_t mRowA;
        std::size_t mRowB;

        // Relative offsets in WHOLE 64-byte windows, wrapping around the block.
        // Within each four-byte destination group:
        //   byte 0 uses offset [0], byte 1 uses [1], etc.
        std::array<std::size_t, 4> mWindowRotations;
    };

    TESTFourToad(Stage pFirst, Stage pSecond, Stage pThird, Stage pFourth);

    // Stored in encryption order. Different stages can protect different rows.
    std::array<Stage, 4> mStages;

    // Unchecked reference calls, like TESTBog: rows must be distinct and in
    // 0..7; nonzero lengths must be multiples of 64; buffers cover pLength.
    // Zero length does nothing. Output need not be initialized.
    // A private copy of each stage's input keeps the reads easy to follow and
    // also permits exact in-place calls. pWorker is unused.
    // This reference allocates memory; it is intended for reading, not timing.
    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength) const;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength) const;

private:
    bool Apply(bool pInverse, const std::uint8_t *pSource,
               std::uint8_t *pDestination, std::size_t pLength) const;
};

#endif // TESTFourToad_hpp
