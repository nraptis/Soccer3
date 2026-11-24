#include "TESTQuarkLow.hpp"

TESTQuarkLow::TESTQuarkLow(std::size_t pWindowA, std::size_t pWindowB)
    : mWindowA(pWindowA), mWindowB(pWindowB) {}

bool TESTQuarkLow::SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                            std::uint8_t *pDestination, std::size_t pLength) const {
    (void)pWorker;
    return Apply(false, pSource, pDestination, pLength);
}

bool TESTQuarkLow::UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                              std::uint8_t *pDestination, std::size_t pLength) const {
    (void)pWorker;
    return Apply(true, pSource, pDestination, pLength);
}

bool TESTQuarkLow::Apply(bool pInverse, const std::uint8_t *pSource,
                        std::uint8_t *pDestination, std::size_t pLength) const {
    if (pLength == 0U) return true;
    if (pLength % kWindowBytes != 0U || !pSource || !pDestination) return false;

    // Exact in-place is safe: every sampled low nibble remains unchanged.
    const auto aSource = reinterpret_cast<std::uintptr_t>(pSource);
    const auto aDestination = reinterpret_cast<std::uintptr_t>(pDestination);
    const auto aDistance = aSource < aDestination ? aDestination - aSource : aSource - aDestination;
    if (pSource != pDestination && aDistance < pLength) return false;

    const auto aWindowCount = pLength / kWindowBytes;
    auto aWindowA = mWindowA % aWindowCount;
    auto aWindowB = mWindowB % aWindowCount;
    for (std::size_t aPosition = 0U; aPosition < pLength; aPosition += kWindowBytes) {
        for (std::size_t aByte = 0U; aByte < kWindowBytes; ++aByte) {
            const auto aCurrent = pSource[aPosition + aByte];
            const unsigned aKey = (pSource[aWindowA * kWindowBytes + aByte] ^
                                   pSource[aWindowB * kWindowBytes + aByte]) & 0x0FU;
            const unsigned aHigh = aCurrent >> 4U;
            const unsigned aChanged = pInverse ? aHigh - aKey : aHigh + aKey;
            pDestination[aPosition + aByte] = static_cast<std::uint8_t>(
                (aCurrent & 0x0FU) | ((aChanged & 0x0FU) << 4U));
        }
        if (++aWindowA == aWindowCount) aWindowA = 0U;
        if (++aWindowB == aWindowCount) aWindowB = 0U;
    }
    return true;
}
