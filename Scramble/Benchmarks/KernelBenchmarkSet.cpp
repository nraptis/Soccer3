#include "KernelBenchmarkSet.hpp"
#include "PasswordXORKernel.hpp"
#include "BitReverseKernel.hpp"
#include "FourToadKernel.hpp"
#include "FourCrowKernel.hpp"
#include "FourRavenKernel.hpp"

#include <cstring>
#include <random>
#include <utility>

KernelBenchmarkSet::KernelBenchmarkSet()
    : mMaterial(Kernel::kBlockBytes), mPackedRows(Kernel::kBlockBytes/4U) {
    // Representative material for standalone timings; no KDF or seed work
    // is part of the executor. The same immutable lane serves all borrowers.
    std::mt19937_64 random(0xB06A017C1F3E2045ULL);
    std::size_t i = 0U;
    for (; mMaterial.size()-i >= sizeof(std::uint64_t); i += sizeof(std::uint64_t)) {
        const auto word = random();
        std::memcpy(mMaterial.data()+i,&word,sizeof(word));
    }
    for (; i < mMaterial.size(); ++i) mMaterial[i] = static_cast<std::uint8_t>(random());

    mOwnedKernels.reserve(5U);
    mKernels.reserve(5U);
    // The same five kernels used by Cryptex::Build. Setup stays outside timing.
    const char *group = "Mainline";
#define ADD(Type, ...) do { \
    auto kernel = std::make_unique<Type>(__VA_ARGS__); \
    mKernels.push_back({group, #Type, kernel.get()}); \
    mOwnedKernels.push_back(std::move(kernel)); \
} while (false)
    ADD(FourToadKernel,
        FourToadKernel::Stage{0U,3U,{2053U,6151U,10007U,14009U}},
        FourToadKernel::Stage{1U,6U,{123U,4917U,13083U,11019U}},
        FourToadKernel::Stage{5U,7U,{1555U,8010U,5801U,14221U}},
        FourToadKernel::Stage{2U,4U,{339U,7260U,9743U,15877U}},mPackedRows);
    ADD(FourCrowKernel,FourCrowKernel::Shift{0x05U,131071U},FourCrowKernel::Shift{0x50U,524321U});
    ADD(FourRavenKernel,FourRavenKernel::Shift{0x05U,131071U},FourRavenKernel::Shift{0x50U,524321U},mMaterial.data());
    ADD(PasswordXORKernel,mMaterial.data());
    ADD(BitReverseKernel);
#undef ADD
}
