#ifndef TESTQuirkHigh_hpp
#define TESTQuirkHigh_hpp

#include <cstddef>
#include <cstdint>

// Reversible High mixer reference, separate from the two-window Quark tests.
// Each 256-BYTE window contains sixteen 16-BYTE chunks. Reverse changes only
// the order of these chunks; byte order inside a chunk remains unchanged.
//
// At each destination byte, sample the HIGH nibble from each selected window:
//   A = sampleA >> 4; B = sampleB >> 4; C = sampleC >> 4;
//   key = A ^ (B & C);
// XOR mode: output = current ^ key; unseal performs the same operation.
// ADD mode: add key to the old LOW nibble mod 16; unseal subtracts key mod 16.
// All high nibbles are preserved, so both directions regenerate the same key
// using the SAME reversal flags. Undo a sequence of stages in reverse order.
class TESTQuirkHigh {
public:
    enum class Update : std::uint8_t { kXor, kAdd };
    static constexpr Update kDefaultUpdate = Update::kAdd;
    static constexpr std::size_t kWindowBytes = 256U;
    static constexpr std::size_t kChunkBytes = 16U;
    static constexpr std::size_t kChunksPerWindow = kWindowBytes / kChunkBytes;

    // Relative offsets in 256-byte windows, wrapping around the input block.
    TESTQuirkHigh(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC,
                  bool pReverseA = false, bool pReverseB = false, bool pReverseC = false,
                  Update pUpdate = kDefaultUpdate);

    std::size_t mWindowA;
    std::size_t mWindowB;
    std::size_t mWindowC;
    bool mReverseA;
    bool mReverseB;
    bool mReverseC;
    Update mUpdate;

    // No allocation. Output need not be initialized. Exact in-place operation
    // works on one thread; other overlaps are rejected. pWorker is unused.
    // Zero length succeeds; nonzero lengths must be multiples of 256 bytes.
    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength) const;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength) const;
};

template<bool ReverseA, bool ReverseB, bool ReverseC>
class TESTQuirkHighVariant : public TESTQuirkHigh {
public:
    TESTQuirkHighVariant(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC,
                         Update pUpdate = kDefaultUpdate)
        : TESTQuirkHigh(pWindowA, pWindowB, pWindowC, ReverseA, ReverseB, ReverseC, pUpdate) {}
};

// A is the most significant reversal flag; C is the least significant.
using TestQuirkHighA = TESTQuirkHighVariant<false, false, false>;
using TestQuirkHighB = TESTQuirkHighVariant<false, false, true>;
using TestQuirkHighC = TESTQuirkHighVariant<false, true, false>;
using TestQuirkHighD = TESTQuirkHighVariant<false, true, true>;
using TestQuirkHighE = TESTQuirkHighVariant<true, false, false>;
using TestQuirkHighF = TESTQuirkHighVariant<true, false, true>;
using TestQuirkHighG = TESTQuirkHighVariant<true, true, false>;
using TestQuirkHighH = TESTQuirkHighVariant<true, true, true>;


//using TestQuirkHighA = TESTQuirkHighVariant<false, false, false>;
//using TestQuirkHighD = TESTQuirkHighVariant<false, true, true>;
//using TestQuirkHighF = TESTQuirkHighVariant<true, false, true>;
//using TestQuirkHighG = TESTQuirkHighVariant<true, true, false>;

namespace TESTQuirkHighDetail {
inline bool ValidBuffers(const std::uint8_t *pSource, const std::uint8_t *pDestination,
                         std::size_t pLength) {
    if (pLength == 0U) return true;
    if (pLength % TESTQuirkHigh::kWindowBytes != 0U || !pSource || !pDestination) return false;
    if (pSource == pDestination) return true;
    const auto aSource = reinterpret_cast<std::uintptr_t>(pSource);
    const auto aDestination = reinterpret_cast<std::uintptr_t>(pDestination);
    const auto aDistance = aSource < aDestination ? aDestination - aSource : aSource - aDestination;
    return aDistance >= pLength;
}
} // namespace TESTQuirkHighDetail

#endif /* TESTQuirkHigh_hpp */
