#pragma once

#include "CorvidShift.hpp"

// Four independent two-bit shifts cover all planes, then one material XOR.
class EightRaven final : public CorvidCipher<4, true> {
public:
    EightRaven(CorvidShift pShiftA, CorvidShift pShiftB, CorvidShift pShiftC,
               CorvidShift pShiftD, const std::uint8_t *pMaterial)
        : CorvidCipher(CipherType::kEightRaven, {pShiftA, pShiftB, pShiftC, pShiftD},
                       pMaterial) {}
};
