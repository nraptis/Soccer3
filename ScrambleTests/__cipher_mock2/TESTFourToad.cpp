#include "TESTFourToad.hpp"

#include <algorithm>
#include <vector>

namespace {
// Remove the protected positions, keeping the other six bits in order.
// Returns a BYTE containing a SIX-BIT word (0..63), with its high bits zero.
// Example: protected rows 0 and 3, mask 0b00001001:
//   input byte:  0b10110110
//   result:      0b00101111
std::uint8_t GatherWritableBits(std::uint8_t pByte, std::uint8_t pProtectedMask) {
    std::uint8_t aSixBitWord = 0U;
    unsigned aWordBit = 0U;
    for (unsigned aByteBit = 0U; aByteBit < 8U; ++aByteBit) {
        if ((pProtectedMask & (1U << aByteBit)) == 0U) {
            const unsigned aBit = (pByte >> aByteBit) & 1U;
            aSixBitWord |= static_cast<std::uint8_t>(aBit << aWordBit);
            ++aWordBit;
        }
    }
    return aSixBitWord;
}

// Restore the six writable positions, leaving ZERO in both protected positions.
// This returns a BYTE (0..255); the caller restores its original protected bits.
// Using the same mask as above:
//   six-bit word: 0b00101111
//   result:       0b10110110
std::uint8_t ScatterWritableBits(std::uint8_t pSixBitWord, std::uint8_t pProtectedMask) {
    std::uint8_t aByte = 0U;
    unsigned aWordBit = 0U;
    for (unsigned aByteBit = 0U; aByteBit < 8U; ++aByteBit) {
        if ((pProtectedMask & (1U << aByteBit)) == 0U) {
            const unsigned aBit = (pSixBitWord >> aWordBit) & 1U;
            aByte |= static_cast<std::uint8_t>(aBit << aByteBit);
            ++aWordBit;
        }
    }
    return aByte;
}

// Sample two rows from each of FOUR consecutive bytes in ONE selected window.
// Let Ai = bit at row A in byte i; Bi = bit at row B in byte i.
// The returned eight-bit word is, from high bit to low bit:
//
//                  [ B3 A3 B2 A2 B1 A1 B0 A0 ]
//
// Example: rows A=0, B=3, four bytes {0x01, 0x08, 0x09, 0x00}:
//   pairs (B,A) in byte order: 01, 10, 11, 00
//   returned byte:            0b00111001 (0x39)
std::uint8_t PackSampledRows(const std::uint8_t *pFourBytes,
                            const TESTFourToad::Stage &pStage) {
    std::uint8_t aPackedByte = 0U;
    for (unsigned aByte = 0U; aByte < TESTFourToad::kBytesPerGroup; ++aByte) {
        const unsigned aBitA = (pFourBytes[aByte] >> pStage.mRowA) & 1U;
        const unsigned aBitB = (pFourBytes[aByte] >> pStage.mRowB) & 1U;
        aPackedByte |= static_cast<std::uint8_t>(aBitA << (2U * aByte));
        aPackedByte |= static_cast<std::uint8_t>(aBitB << (2U * aByte + 1U));
    }
    return aPackedByte;
}

// Turn the eight sampled bits into a SIX-BIT addition key (0..63).
std::uint8_t MakeSixBitKey(std::uint8_t pPackedByte, std::uint8_t pProtectedMask) {
    // This gate examines positions row A and row B IN THE PACKED WORD.
    // These positions can contain bits sampled from different source bytes.
    // If both are 1, flip the lowest writable position in the packed word.
    const bool aBothGateBitsAreOne = (pPackedByte & pProtectedMask) == pProtectedMask;
    if (aBothGateBitsAreOne) {
        for (unsigned aBit = 0U; aBit < 8U; ++aBit) {
            if ((pProtectedMask & (1U << aBit)) == 0U) {
                pPackedByte ^= static_cast<std::uint8_t>(1U << aBit);
                break;
            }
        }
    }

    // Discard the two gate positions; compact the remaining six positions.
    // Continuing the example with rows 0 and 3:
    //   packed:       0b00111001  (both gate bits are 1)
    //   after flip:   0b00111011  (lowest writable position is bit 1)
    //   six-bit key:  0b00001101  (13)
    return GatherWritableBits(pPackedByte, pProtectedMask);
}

void ApplyStage(const TESTFourToad::Stage &pStage, bool pInverse,
                const std::uint8_t *pInput, std::uint8_t *pOutput,
                std::size_t pLength) {
    const auto aProtectedMask = static_cast<std::uint8_t>(
        (1U << pStage.mRowA) | (1U << pStage.mRowB));
    const std::size_t aWindowCount = pLength / TESTFourToad::kWindowBytes;

    for (std::size_t aWindow = 0U; aWindow < aWindowCount; ++aWindow) {
        for (std::size_t aGroup = 0U; aGroup < TESTFourToad::kGroupsPerWindow; ++aGroup) {
            for (std::size_t aByte = 0U; aByte < TESTFourToad::kBytesPerGroup; ++aByte) {
                // Each byte chooses ONE of the four window offsets. For example,
                // window 2 with offsets {1,3,5,7} in an eight-window block reads
                // windows {3,5,7,1} for bytes {0,1,2,3} of EVERY group.
                const std::size_t aRotation = pStage.mWindowRotations[aByte] % aWindowCount;
                const std::size_t aSampleWindow = (aWindow + aRotation) % aWindowCount;
                const std::size_t aSampleGroupStart =
                    aSampleWindow * TESTFourToad::kWindowBytes +
                    aGroup * TESTFourToad::kBytesPerGroup;
                const std::uint8_t aPackedByte = PackSampledRows(pInput + aSampleGroupStart, pStage);
                const std::uint8_t aKey = MakeSixBitKey(aPackedByte, aProtectedMask);

                const std::size_t aIndex = aWindow * TESTFourToad::kWindowBytes +
                                          aGroup * TESTFourToad::kBytesPerGroup + aByte;
                const std::uint8_t aCurrentByte = pInput[aIndex];
                const std::uint8_t aOldWord = GatherWritableBits(aCurrentByte, aProtectedMask);

                // Work explicitly in six-bit space. Adding 64 before subtraction
                // keeps the intermediate nonnegative; & 63 performs modulo 64.
                const unsigned aChangedWord = pInverse ? aOldWord + 64U - aKey : aOldWord + aKey;
                const auto aNewWord = static_cast<std::uint8_t>(aChangedWord & 63U);
                const std::uint8_t aWritableBits = ScatterWritableBits(aNewWord, aProtectedMask);
                const std::uint8_t aPreservedBits = aCurrentByte & aProtectedMask;
                pOutput[aIndex] = aPreservedBits | aWritableBits;

                // With rows 0 and 3, current=0b10110110, key=13:
                //   gather current = 47; (47 + 13) mod 64 = 60
                //   scatter 60 = 0b11110000; protected bits here are 0
                //   output = 0b11110000. Subtracting 13 restores 0b10110110.
                // Production FourToadKernel obtains the same result by adding in the
                // original byte positions, using 1s to bridge carries through
                // protected positions (0s for borrows), then restoring them.
            }
        }
    }

    // The two protected rows remain unchanged across the ENTIRE stage. The key
    // only depends on those rows, so unsealing regenerates exactly the same key
    // from the stage's output. It does not need the original stage input.
}
} // namespace

TESTFourToad::TESTFourToad(Stage pFirst, Stage pSecond, Stage pThird, Stage pFourth)
    : mStages{pFirst, pSecond, pThird, pFourth} {}

bool TESTFourToad::SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                           std::uint8_t *pDestination, std::size_t pLength) const {
    (void)pWorker;
    return Apply(false, pSource, pDestination, pLength);
}

bool TESTFourToad::UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                             std::uint8_t *pDestination, std::size_t pLength) const {
    (void)pWorker;
    return Apply(true, pSource, pDestination, pLength);
}

bool TESTFourToad::Apply(bool pInverse, const std::uint8_t *pSource,
                        std::uint8_t *pDestination, std::size_t pLength) const {
    if (pLength == 0U) return true;

    // Deliberately use a complete snapshot instead of a packed-key cache or
    // threads: every sample clearly comes from the current stage's input.
    std::vector<std::uint8_t> aStageInput(pSource, pSource + pLength);
    for (std::size_t aStep = 0U; aStep < mStages.size(); ++aStep) {
        const std::size_t aStageIndex = pInverse ? mStages.size() - 1U - aStep : aStep;
        ApplyStage(mStages[aStageIndex], pInverse, aStageInput.data(), pDestination, pLength);
        if (aStep + 1U < mStages.size())
            std::copy_n(pDestination, pLength, aStageInput.data());
    }
    return true;
}
