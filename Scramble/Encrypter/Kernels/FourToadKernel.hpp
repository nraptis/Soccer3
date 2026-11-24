#ifndef SOCCER_FOUR_TOAD_KERNEL_HPP_
#define SOCCER_FOUR_TOAD_KERNEL_HPP_

#include "Kernel.hpp"
#include <array>
#include <cstddef>
#include <cstdint>
#include <span>

// Self-contained implementation in FourToadKernel.cpp: packing, SIMD selection,
// and the reusable worker team. Kernel.hpp is the only project dependency.
// The four row pairs and window offsets, in encryption order.
class FourToadKernel final : public Kernel {
public:
    struct Stage {
        std::size_t mRowA;
        std::size_t mRowB;
        std::array<std::size_t, 4> mWindowRotations;
    };
    
    

    // The caller provides length/4 bytes of non-overlapping scratch, reusable
    // between sequential calls. The intermediate stages update the destination.
    // At 1 MiB, the worker team also owns a second packed-key buffer so it can
    // prepare the following stage's keys while writing the current stage.
    FourToadKernel(Stage pFirst, Stage pSecond, Stage pThird, Stage pFourth,
             std::span<std::uint8_t> pPackedKeys);

    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  KernelErrorCode *pErrorCode) const override;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength,
                    KernelErrorCode *pErrorCode) const override;
    void Zero() override;

private:
    bool Apply(bool pInverse, const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, KernelErrorCode *pErrorCode) const;

    std::array<Stage, 4> mStages;
    std::span<std::uint8_t> mPackedKeys;
};

#endif
