#include "TESTQuirkLow.hpp"

TESTQuirkLow::TESTQuirkLow(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC,
                           bool pReverseA, bool pReverseB, bool pReverseC, Update pUpdate)
    : mWindowA(pWindowA), mWindowB(pWindowB), mWindowC(pWindowC),
      mReverseA(pReverseA), mReverseB(pReverseB), mReverseC(pReverseC), mUpdate(pUpdate) {}

namespace {
template<TESTQuirkLow::Update Update, bool Inverse>
void Apply(const TESTQuirkLow &pPlan, const std::uint8_t *pSource,
           std::uint8_t *pDestination, std::size_t pLength) {
    const auto aCount = pLength / 256U;
    auto aWindowA = pPlan.mWindowA % aCount;
    auto aWindowB = pPlan.mWindowB % aCount;
    auto aWindowC = pPlan.mWindowC % aCount;
    for (std::size_t aPosition = 0U; aPosition < pLength; aPosition += 256U) {
        for (std::size_t aChunk = 0U; aChunk < 16U; ++aChunk) {
            const auto aChunkA = pPlan.mReverseA ? 15U - aChunk : aChunk;
            const auto aChunkB = pPlan.mReverseB ? 15U - aChunk : aChunk;
            const auto aChunkC = pPlan.mReverseC ? 15U - aChunk : aChunk;
            for (std::size_t aByte = 0U; aByte < 16U; ++aByte) {
                const unsigned a = pSource[256U * aWindowA + 16U * aChunkA + aByte] & 15U;
                const unsigned b = pSource[256U * aWindowB + 16U * aChunkB + aByte] & 15U;
                const unsigned c = pSource[256U * aWindowC + 16U * aChunkC + aByte] & 15U;
                const auto aIndex = aPosition + 16U * aChunk + aByte;
                const unsigned aCurrent = pSource[aIndex];
                const unsigned aKey = a ^ (b & c);
                if constexpr (Update == TESTQuirkLow::Update::kXor) {
                    pDestination[aIndex] = static_cast<std::uint8_t>(aCurrent ^ (aKey << 4U));
                } else {
                    const unsigned aHigh = aCurrent >> 4U;
                    const unsigned aChanged = Inverse ? aHigh - aKey : aHigh + aKey;
                    pDestination[aIndex] = static_cast<std::uint8_t>((aCurrent & 15U) | ((aChanged & 15U) << 4U));
                }
            }
        }
        if (++aWindowA == aCount) aWindowA = 0U;
        if (++aWindowB == aCount) aWindowB = 0U;
        if (++aWindowC == aCount) aWindowC = 0U;
    }
}

bool ApplyChecked(const TESTQuirkLow &pPlan, bool pInverse, const std::uint8_t *pSource,
                  std::uint8_t *pDestination, std::size_t pLength) {
    if (!TESTQuirkHighDetail::ValidBuffers(pSource, pDestination, pLength)) return false;
    if (pLength == 0U) return true;
    switch (pPlan.mUpdate) {
        case TESTQuirkLow::Update::kXor:
            Apply<TESTQuirkLow::Update::kXor, false>(pPlan, pSource, pDestination, pLength);
            break;
        case TESTQuirkLow::Update::kAdd:
            if (pInverse) Apply<TESTQuirkLow::Update::kAdd, true>(pPlan, pSource, pDestination, pLength);
            else Apply<TESTQuirkLow::Update::kAdd, false>(pPlan, pSource, pDestination, pLength);
            break;
        default: return false;
    }
    return true;
}
} // namespace

bool TESTQuirkLow::SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                           std::uint8_t *pDestination, std::size_t pLength) const {
    (void)pWorker;
    return ApplyChecked(*this, false, pSource, pDestination, pLength);
}

bool TESTQuirkLow::UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                             std::uint8_t *pDestination, std::size_t pLength) const {
    (void)pWorker;
    return ApplyChecked(*this, true, pSource, pDestination, pLength);
}
