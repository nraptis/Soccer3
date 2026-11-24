#pragma once

#include "Kernel.hpp"

#include <cstddef>
#include <cstdint>

// Two independent two-bit shifts. The other four planes keep their positions.
class FourCrowKernel final : public Kernel {
public:
    struct Shift {
        std::uint8_t mMask;
        std::size_t mRotation;
    };

    // Disjoint two-bit masks; rotations are measured in bytes.
    FourCrowKernel(Shift pShiftA, Shift pShiftB);

    // Accept caller-owned shift settings without depending on a shared
    // type or implementation. Direct callers can use Shift.
    template<class ShiftA, class ShiftB>
    FourCrowKernel(const ShiftA &pShiftA, const ShiftB &pShiftB)
        : FourCrowKernel(Shift{pShiftA.mMask, pShiftA.mRotation},
                   Shift{pShiftB.mMask, pShiftB.mRotation}) {}

    // The 1 MiB path uses four workers and specializes block-size arithmetic. Other multiples of 16
    // retain their existing behavior. Buffers must not overlap; worker is unused.
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
    std::uint8_t mStationaryMask;
    bool mValidMasks;
};
