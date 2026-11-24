#ifndef TESTQuirkLow_hpp
#define TESTQuirkLow_hpp

#include "TESTQuirkHigh.hpp"

// Low preserves the LOW nibble, samples those same bits in three windows,
// and adds A ^ (B & C) to the old HIGH nibble modulo 16. Unseal subtracts.
// Windows and chunk-order reversal have exactly the same meaning as High.
class TESTQuirkLow {
public:
    using Update = TESTQuirkHigh::Update;
    static constexpr Update kDefaultUpdate = TESTQuirkHigh::kDefaultUpdate;
    static constexpr std::size_t kWindowBytes = 256U;
    static constexpr std::size_t kChunkBytes = 16U;

    TESTQuirkLow(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC,
                 bool pReverseA = false, bool pReverseB = false, bool pReverseC = false,
                 Update pUpdate = kDefaultUpdate);

    std::size_t mWindowA;
    std::size_t mWindowB;
    std::size_t mWindowC;
    bool mReverseA;
    bool mReverseB;
    bool mReverseC;
    Update mUpdate;

    // No allocation or worker. Exact in-place operation is safe on one thread;
    // other overlaps are rejected. Nonzero lengths must be multiples of 256.
    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength) const;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength) const;
};

template<bool ReverseA, bool ReverseB, bool ReverseC>
class TESTQuirkLowVariant : public TESTQuirkLow {
public:
    TESTQuirkLowVariant(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC,
                        Update pUpdate = kDefaultUpdate)
        : TESTQuirkLow(pWindowA, pWindowB, pWindowC, ReverseA, ReverseB, ReverseC, pUpdate) {}
};

using TestQuirkLowA = TESTQuirkLowVariant<false, false, false>;
using TestQuirkLowB = TESTQuirkLowVariant<false, false, true>;
using TestQuirkLowC = TESTQuirkLowVariant<false, true, false>;
using TestQuirkLowD = TESTQuirkLowVariant<false, true, true>;
using TestQuirkLowE = TESTQuirkLowVariant<true, false, false>;
using TestQuirkLowF = TESTQuirkLowVariant<true, false, true>;
using TestQuirkLowG = TESTQuirkLowVariant<true, true, false>;
using TestQuirkLowH = TESTQuirkLowVariant<true, true, true>;

#endif
