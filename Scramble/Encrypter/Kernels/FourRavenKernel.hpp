#pragma once

#include "Kernel.hpp"
#include <cstddef>
#include <cstdint>

// Four shifted planes, followed by one full-byte material XOR.
class FourRavenKernel final : public Kernel {
public:
    struct Shift {
        std::uint8_t mMask;
        std::size_t mRotation;
    };

    // Disjoint two-bit masks. Material contains at least pLength immutable
    // bytes and must outlive the cipher; it is read directly on every call.
    FourRavenKernel(Shift pShiftA, Shift pShiftB, const std::uint8_t *pMaterial);

    template<class ShiftA, class ShiftB>
    FourRavenKernel(const ShiftA &pShiftA, const ShiftB &pShiftB, const std::uint8_t *pMaterial)
        : FourRavenKernel(Shift{pShiftA.mMask, pShiftA.mRotation},
                    Shift{pShiftB.mMask, pShiftB.mRotation}, pMaterial) {}

    // Uses four workers at 1 MiB; retains other multiples of 32 bytes.
    // Source/destination and material/destination must not overlap. Worker is unused.
    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  KernelErrorCode *pErrorCode) const override;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength,
                    KernelErrorCode *pErrorCode) const override;
    void Zero() override;

private:
    template<bool Inverse>
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, KernelErrorCode *pErrorCode) const;

    template<bool Inverse, std::size_t FixedLength>
    void Transform(const std::uint8_t *pSource, std::uint8_t *pDestination,
                   std::size_t pLength, std::size_t pBegin, std::size_t pEnd) const;

    Shift mShifts[2];
    const std::uint8_t *mMaterial;
    std::uint8_t mStationaryMask;
    bool mValidMasks;
};
