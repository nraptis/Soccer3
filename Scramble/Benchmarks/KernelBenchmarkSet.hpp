#ifndef SOCCER_KERNEL_BENCHMARK_SET_HPP_
#define SOCCER_KERNEL_BENCHMARK_SET_HPP_

#include "QBTests.hpp"
#include <cstdint>
#include <memory>
#include <vector>

// Preparation only: owns every active kernel plus the material and cache
// storage they borrow. Construct this before calling the generic executor.
// The shared packed cache is reused sequentially; source-dependent packing
// still happens inside the kernel calls and remains part of their timing.
class KernelBenchmarkSet {
public:
    KernelBenchmarkSet();
    KernelBenchmarkSet(const KernelBenchmarkSet &) = delete;
    KernelBenchmarkSet &operator=(const KernelBenchmarkSet &) = delete;

    std::span<const QBTests::Entry> GetKernels() const { return mKernels; }

private:
    // Destroy the kernel instances before their borrowed buffers.
    std::vector<std::uint8_t> mMaterial;
    std::vector<std::uint8_t> mPackedRows;
    std::vector<std::unique_ptr<Kernel>> mOwnedKernels;
    std::vector<QBTests::Entry> mKernels;
};

#endif // SOCCER_KERNEL_BENCHMARK_SET_HPP_
