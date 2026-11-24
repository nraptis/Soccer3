#include "TESTQuirkHigh.hpp"

TESTQuirkHigh::TESTQuirkHigh(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC,
                             bool pReverseA, bool pReverseB, bool pReverseC, Update pUpdate)
    : mWindowA(pWindowA), mWindowB(pWindowB), mWindowC(pWindowC),
      mReverseA(pReverseA), mReverseB(pReverseB), mReverseC(pReverseC), mUpdate(pUpdate) {}

namespace {
template<TESTQuirkHigh::Update Update, bool Inverse>
void Apply(const TESTQuirkHigh &pPlan, const std::uint8_t *pSource,
           std::uint8_t *pDestination, std::size_t pLength) {
    constexpr auto kWindowBytes = TESTQuirkHigh::kWindowBytes;
    constexpr auto kChunkBytes = TESTQuirkHigh::kChunkBytes;
    constexpr auto kChunksPerWindow = TESTQuirkHigh::kChunksPerWindow;
    const auto aWindowCount = pLength / kWindowBytes;
    auto aWindowA = pPlan.mWindowA % aWindowCount;
    auto aWindowB = pPlan.mWindowB % aWindowCount;
    auto aWindowC = pPlan.mWindowC % aWindowCount;
    for (std::size_t aPosition = 0U; aPosition < pLength; aPosition += kWindowBytes) {
        for (std::size_t aChunk = 0U; aChunk < kChunksPerWindow; ++aChunk) {
            const auto aChunkA = pPlan.mReverseA ? kChunksPerWindow - 1U - aChunk : aChunk;
            const auto aChunkB = pPlan.mReverseB ? kChunksPerWindow - 1U - aChunk : aChunk;
            const auto aChunkC = pPlan.mReverseC ? kChunksPerWindow - 1U - aChunk : aChunk;
            for (std::size_t aByte = 0U; aByte < kChunkBytes; ++aByte) {
                const unsigned a = pSource[aWindowA * kWindowBytes + aChunkA * kChunkBytes + aByte] >> 4U;
                const unsigned b = pSource[aWindowB * kWindowBytes + aChunkB * kChunkBytes + aByte] >> 4U;
                const unsigned c = pSource[aWindowC * kWindowBytes + aChunkC * kChunkBytes + aByte] >> 4U;
                const auto aIndex = aPosition + aChunk * kChunkBytes + aByte;
                const unsigned aCurrent = pSource[aIndex];
                const unsigned aKey = a ^ (b & c);
                if constexpr (Update == TESTQuirkHigh::Update::kXor) {
                    pDestination[aIndex] = static_cast<std::uint8_t>(aCurrent ^ aKey);
                } else {
                    const unsigned aLow = aCurrent & 0x0FU;
                    const unsigned aChanged = Inverse ? aLow - aKey : aLow + aKey;
                    pDestination[aIndex] = static_cast<std::uint8_t>((aCurrent & 0xF0U) | (aChanged & 0x0FU));
                }
            }
        }
        if (++aWindowA == aWindowCount) aWindowA = 0U;
        if (++aWindowB == aWindowCount) aWindowB = 0U;
        if (++aWindowC == aWindowCount) aWindowC = 0U;
    }
}

bool ApplyChecked(const TESTQuirkHigh &pPlan, bool pInverse, const std::uint8_t *pSource,
                  std::uint8_t *pDestination, std::size_t pLength) {
    if (!TESTQuirkHighDetail::ValidBuffers(pSource, pDestination, pLength)) return false;
    if (pLength == 0U) return true;
    switch (pPlan.mUpdate) {
        case TESTQuirkHigh::Update::kXor:
            Apply<TESTQuirkHigh::Update::kXor, false>(pPlan, pSource, pDestination, pLength);
            break;
        case TESTQuirkHigh::Update::kAdd:
            if (pInverse) Apply<TESTQuirkHigh::Update::kAdd, true>(pPlan, pSource, pDestination, pLength);
            else Apply<TESTQuirkHigh::Update::kAdd, false>(pPlan, pSource, pDestination, pLength);
            break;
        default: return false;
    }
    return true;
}
} // namespace

bool TESTQuirkHigh::SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                             std::uint8_t *pDestination, std::size_t pLength) const {
    (void)pWorker;
    return ApplyChecked(*this, false, pSource, pDestination, pLength);
}

bool TESTQuirkHigh::UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                               std::uint8_t *pDestination, std::size_t pLength) const {
    (void)pWorker;
    return ApplyChecked(*this, true, pSource, pDestination, pLength);
}
