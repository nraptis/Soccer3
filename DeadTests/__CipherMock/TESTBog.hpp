#ifndef TESTBog_hpp
#define TESTBog_hpp

#include <array>
#include <cstddef>
#include <cstdint>

// Readable reference: preserve a two-bit hot pair, sample that same pair
// from three 256-byte windows, pack the samples into six bits, and ADD to
// the six non-hot destination bits modulo 64. Unseal subtracts the same key.
// There is no nonlinear AND gate; masks below only extract/restore fields.
class TESTBog {
public:
    enum class HotPair : std::uint8_t { kA = 6U, kB = 4U, kC = 2U, kD = 0U };
    enum class PackOrder : std::uint8_t { kABC, kACB, kBAC, kBCA, kCAB, kCBA };
    static constexpr std::size_t kWindowBytes = 256U;
    inline static constexpr std::array<std::array<unsigned,3>,6> kOrders = {{
        {0U,1U,2U}, {0U,2U,1U}, {1U,0U,2U},
        {1U,2U,0U}, {2U,0U,1U}, {2U,1U,0U}}};

    TESTBog(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC,
            HotPair pHotPair, PackOrder pPackOrder)
        : mWindowA(pWindowA), mWindowB(pWindowB), mWindowC(pWindowC),
          mHotPair(pHotPair), mPackOrder(pPackOrder) {}

    // Relative offsets measured in whole 256-byte windows, with wrapping.
    std::size_t mWindowA;
    std::size_t mWindowB;
    std::size_t mWindowC;
    HotPair mHotPair;
    PackOrder mPackOrder;

    // Unchecked reference calls: settings must be valid and nonzero lengths
    // must be multiples of 256. Buffers must cover that length and be either
    // separate or exactly the same buffer. Zero length does nothing.
    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength) const;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength) const;

    // Remove the two hot positions, keeping the other six bits in order.
    // Return an 8-bit byte holding a SIX-BIT word: 0b00xxxxxx (0..63).
    //
    // Example with the middle pair hot:
    //   pByte:       0b10110110  [a b H H c d e f]
    //   pHotMask:    0b00110000
    //   return:      0b00100110  [0 0 a b c d e f]
    //
    static std::uint8_t PackWritable(std::uint8_t pByte, std::uint8_t pHotMask) {
        std::uint32_t aPackedWord = 0U;
        std::size_t aPackedBit = 0U;
        for (std::size_t aByteBit = 0U; aByteBit < 8U; ++aByteBit) {
            if ((pHotMask & (1U << aByteBit)) == 0U) {
                aPackedWord |= ((pByte >> aByteBit) & 1U) << aPackedBit;
                ++aPackedBit;
            }
        }
        return static_cast<std::uint8_t>(aPackedWord);
    }

    // Put a six-bit word back into the six writable positions of a byte.
    // Return an 8-bit byte with ZERO in both hot positions. This helper
    // does not restore the original hot bits; the caller merges those in.
    //
    //   pPackedWord: 0b00100110  [0 0 a b c d e f]
    //   pHotMask:    0b00110000
    //   return:      0b10000110  [a b 0 0 c d e f]
    //
    static std::uint8_t UnpackWritable(std::uint8_t pPackedWord, std::uint8_t pHotMask) {
        std::uint32_t aByte = 0U;
        std::size_t aPackedBit = 0U;
        for (std::size_t aByteBit = 0U; aByteBit < 8U; ++aByteBit) {
            if ((pHotMask & (1U << aByteBit)) == 0U) {
                aByte |= ((pPackedWord >> aPackedBit) & 1U) << aByteBit;
                ++aPackedBit;
            }
        }
        return static_cast<std::uint8_t>(aByte);
    }
};

template<TESTBog::HotPair Pair, TESTBog::PackOrder Order>
class TESTBogVariant : public TESTBog {
public:
    TESTBogVariant(std::size_t a, std::size_t b, std::size_t c)
        : TESTBog(a,b,c,Pair,Order) {}
};

// First suffix: hot pair A..D. Second suffix: packing order A..F.
using TestBogAA = TESTBogVariant<TESTBog::HotPair::kA, TESTBog::PackOrder::kABC>;
using TestBogAB = TESTBogVariant<TESTBog::HotPair::kA, TESTBog::PackOrder::kACB>;
using TestBogAC = TESTBogVariant<TESTBog::HotPair::kA, TESTBog::PackOrder::kBAC>;
using TestBogAD = TESTBogVariant<TESTBog::HotPair::kA, TESTBog::PackOrder::kBCA>;
using TestBogAE = TESTBogVariant<TESTBog::HotPair::kA, TESTBog::PackOrder::kCAB>;
using TestBogAF = TESTBogVariant<TESTBog::HotPair::kA, TESTBog::PackOrder::kCBA>;
using TestBogBA = TESTBogVariant<TESTBog::HotPair::kB, TESTBog::PackOrder::kABC>;
using TestBogBB = TESTBogVariant<TESTBog::HotPair::kB, TESTBog::PackOrder::kACB>;
using TestBogBC = TESTBogVariant<TESTBog::HotPair::kB, TESTBog::PackOrder::kBAC>;
using TestBogBD = TESTBogVariant<TESTBog::HotPair::kB, TESTBog::PackOrder::kBCA>;
using TestBogBE = TESTBogVariant<TESTBog::HotPair::kB, TESTBog::PackOrder::kCAB>;
using TestBogBF = TESTBogVariant<TESTBog::HotPair::kB, TESTBog::PackOrder::kCBA>;
using TestBogCA = TESTBogVariant<TESTBog::HotPair::kC, TESTBog::PackOrder::kABC>;
using TestBogCB = TESTBogVariant<TESTBog::HotPair::kC, TESTBog::PackOrder::kACB>;
using TestBogCC = TESTBogVariant<TESTBog::HotPair::kC, TESTBog::PackOrder::kBAC>;
using TestBogCD = TESTBogVariant<TESTBog::HotPair::kC, TESTBog::PackOrder::kBCA>;
using TestBogCE = TESTBogVariant<TESTBog::HotPair::kC, TESTBog::PackOrder::kCAB>;
using TestBogCF = TESTBogVariant<TESTBog::HotPair::kC, TESTBog::PackOrder::kCBA>;
using TestBogDA = TESTBogVariant<TESTBog::HotPair::kD, TESTBog::PackOrder::kABC>;
using TestBogDB = TESTBogVariant<TESTBog::HotPair::kD, TESTBog::PackOrder::kACB>;
using TestBogDC = TESTBogVariant<TESTBog::HotPair::kD, TESTBog::PackOrder::kBAC>;
using TestBogDD = TESTBogVariant<TESTBog::HotPair::kD, TESTBog::PackOrder::kBCA>;
using TestBogDE = TESTBogVariant<TESTBog::HotPair::kD, TESTBog::PackOrder::kCAB>;
using TestBogDF = TESTBogVariant<TESTBog::HotPair::kD, TESTBog::PackOrder::kCBA>;

#endif
