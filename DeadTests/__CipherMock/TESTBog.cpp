#include "TESTBog.hpp"

namespace {
bool Apply(const TESTBog &pPlan, bool pInverse, const std::uint8_t *pSource,
           std::uint8_t *pDestination, std::size_t pLength) {
    if (pLength == 0U) return true;
    const auto aShift = static_cast<unsigned>(pPlan.mHotPair);
    const auto aMask = static_cast<std::uint8_t>(3U << aShift);
    const auto &aOrder = TESTBog::kOrders[static_cast<unsigned>(pPlan.mPackOrder)];
    const auto aWindowCount = pLength/256U;
    auto aWindowA = pPlan.mWindowA%aWindowCount;
    auto aWindowB = pPlan.mWindowB%aWindowCount;
    auto aWindowC = pPlan.mWindowC%aWindowCount;
    for (std::size_t aPosition = 0U; aPosition < pLength; aPosition += 256U) {
        for (std::size_t i = 0U; i < 256U; ++i) {
            const std::array<unsigned,3> aSamples = {
                (pSource[256U*aWindowA+i] >> aShift) & 3U,
                (pSource[256U*aWindowB+i] >> aShift) & 3U,
                (pSource[256U*aWindowC+i] >> aShift) & 3U};
            const unsigned aKey = (aSamples[aOrder[0]] << 4U) |
                                      (aSamples[aOrder[1]] << 2U) | aSamples[aOrder[2]];
            const std::uint8_t aCurrent = pSource[aPosition+i];
            const std::uint8_t aOld = TESTBog::PackWritable(aCurrent,aMask);
            const auto aNew = static_cast<std::uint8_t>((pInverse ? aOld+64U-aKey : aOld+aKey) & 63U);
            // Unpack leaves zeros in the hot positions; restore them here.
            pDestination[aPosition+i] = static_cast<std::uint8_t>(
                (aCurrent & aMask) | TESTBog::UnpackWritable(aNew,aMask));
        }
        if (++aWindowA == aWindowCount) aWindowA = 0U;
        if (++aWindowB == aWindowCount) aWindowB = 0U;
        if (++aWindowC == aWindowCount) aWindowC = 0U;
    }
    return true;
}
} // namespace

bool TESTBog::SealData(const std::uint8_t *src, std::uint8_t *worker,
                       std::uint8_t *dst, std::size_t len) const {
    (void)worker;
    return Apply(*this,false,src,dst,len);
}
bool TESTBog::UnsealData(const std::uint8_t *src, std::uint8_t *worker,
                         std::uint8_t *dst, std::size_t len) const {
    (void)worker;
    return Apply(*this,true,src,dst,len);
}
