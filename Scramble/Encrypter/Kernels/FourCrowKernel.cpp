#include "FourCrowKernel.hpp"

#include <algorithm>
#include <array>
#include <atomic>
#include <bit>
#include <mutex>
#include <system_error>
#include <thread>

#if (!defined(IGNORE_SIMD) || !IGNORE_SIMD) && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#define SOCCER_FOUR_CROW_USE_NEON 1
#include <arm_neon.h>
#else
#define SOCCER_FOUR_CROW_USE_NEON 0
#endif

#if !SOCCER_FOUR_CROW_USE_NEON && (!defined(IGNORE_SIMD) || !IGNORE_SIMD) && \
    (defined(__SSE2__) || defined(_M_X64) || (defined(_M_IX86_FP) && _M_IX86_FP >= 2))
#define SOCCER_FOUR_CROW_USE_SSE2 1
#include <immintrin.h>
#else
#define SOCCER_FOUR_CROW_USE_SSE2 0
#endif

namespace {
// One sleeping helper team per cipher implementation, reused by both
// directions. Only the caller's stack job borrows data; Run waits for every
// helper before returning. Small compatibility calls stay on the caller.
struct ParallelJob {
    const void *mContext;
    void (*mRunQuarter)(const void *, std::size_t);
};

class Workers {
public:
    Workers() {
        try {
            for (std::size_t i = 0U; i < mThreads.size(); ++i)
                mThreads[i] = std::thread(&Workers::Work, this, i + 1U);
            mAvailable = true;
        } catch (const std::system_error &) {
            Stop();
        }
    }
    ~Workers() { Stop(); }

    void Run(const ParallelJob &pJob) {
        if (!mAvailable) {
            for (std::size_t i = 0U; i < 4U; ++i) pJob.mRunQuarter(pJob.mContext, i);
            return;
        }
        const std::lock_guard aLock(mSubmission);
        mRemaining.store(3U, std::memory_order_relaxed);
        mJob = &pJob;
        mGeneration.fetch_add(1U, std::memory_order_release);
        mGeneration.notify_all();
        pJob.mRunQuarter(pJob.mContext, 0U);
        auto aRemaining = mRemaining.load(std::memory_order_acquire);
        while (aRemaining != 0U) {
            mRemaining.wait(aRemaining, std::memory_order_acquire);
            aRemaining = mRemaining.load(std::memory_order_acquire);
        }
        mJob = nullptr;
    }

private:
    void Work(std::size_t pQuarter) {
        unsigned aGeneration = 0U;
        for (;;) {
            mGeneration.wait(aGeneration, std::memory_order_acquire);
            aGeneration = mGeneration.load(std::memory_order_acquire);
            const auto *aJob = mJob;
            if (!aJob) return;
            aJob->mRunQuarter(aJob->mContext, pQuarter);
            if (mRemaining.fetch_sub(1U, std::memory_order_acq_rel) == 1U)
                mRemaining.notify_one();
        }
    }
    void Stop() {
        mJob = nullptr;
        mGeneration.fetch_add(1U, std::memory_order_release);
        mGeneration.notify_all();
        for (auto &aThread : mThreads)
            if (aThread.joinable()) aThread.join();
    }

    std::array<std::thread, 3> mThreads;
    std::mutex mSubmission;
    std::atomic<unsigned> mGeneration{0U};
    std::atomic<unsigned> mRemaining{0U};
    const ParallelJob *mJob = nullptr;
    bool mAvailable = false;
};

Workers &GetWorkers() {
    static Workers aWorkers;
    return aWorkers;
}

bool BuffersOverlap(const std::uint8_t *pFirst, const std::uint8_t *pSecond,
                    std::size_t pLength) {
    const auto aFirst = reinterpret_cast<std::uintptr_t>(pFirst);
    const auto aSecond = reinterpret_cast<std::uintptr_t>(pSecond);
    return aFirst <= aSecond ? aSecond - aFirst < pLength : aFirst - aSecond < pLength;
}

// Spans stop at circular-buffer boundaries. Four independent vectors per
// iteration expose load/ALU parallelism without reading beyond a span.
void BlendSpan(const std::uint8_t *pSource, const std::uint8_t *pSourceA,
               const std::uint8_t *pSourceB, std::uint8_t *__restrict pDestination,
               std::size_t pLength, std::uint8_t pMaskA, std::uint8_t pMaskB,
               std::uint8_t pStationaryMask) {
    std::size_t aIndex = 0U;
#if SOCCER_FOUR_CROW_USE_NEON
    {
        const auto aMaskA = vdupq_n_u8(pMaskA);
        const auto aMaskB = vdupq_n_u8(pMaskB);
        const auto aBlend = [&](std::size_t i) {
            auto aCurrent = vld1q_u8(pSource + i);
            auto a = vld1q_u8(pSourceA + i);
            auto b = vld1q_u8(pSourceB + i);
            auto aResult = vbslq_u8(aMaskA, a, aCurrent);
            aResult = vbslq_u8(aMaskB, b, aResult);
            vst1q_u8(pDestination + i, aResult);
        };
        // The masks are disjoint: two selects preserve the stationary bits.
        // This replaces three ANDs and two ORs with two BIT/BIF instructions.
        for (; aIndex + 64U <= pLength; aIndex += 64U) {
            aBlend(aIndex); aBlend(aIndex + 16U);
            aBlend(aIndex + 32U); aBlend(aIndex + 48U);
        }
        for (; aIndex + 16U <= pLength; aIndex += 16U) aBlend(aIndex);
    }
#elif SOCCER_FOUR_CROW_USE_SSE2
#if defined(__AVX2__)
    {
        const auto aMaskA = _mm256_set1_epi8(static_cast<char>(pMaskA));
        const auto aMaskB = _mm256_set1_epi8(static_cast<char>(pMaskB));
        const auto aStationary = _mm256_set1_epi8(static_cast<char>(pStationaryMask));
        const auto aBlend = [&](std::size_t i) {
            auto aCurrent = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pSource + i));
            auto a = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pSourceA + i));
            auto b = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pSourceB + i));
            auto aResult = _mm256_or_si256(_mm256_and_si256(aCurrent, aStationary),
                _mm256_or_si256(_mm256_and_si256(a, aMaskA), _mm256_and_si256(b, aMaskB)));
            _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + i), aResult);
        };
        for (; aIndex + 64U <= pLength; aIndex += 64U) {
            aBlend(aIndex); aBlend(aIndex + 32U);
        }
        for (; aIndex + 32U <= pLength; aIndex += 32U) aBlend(aIndex);
    }
#endif
    {
        const auto aMaskA = _mm_set1_epi8(static_cast<char>(pMaskA));
        const auto aMaskB = _mm_set1_epi8(static_cast<char>(pMaskB));
        const auto aStationary = _mm_set1_epi8(static_cast<char>(pStationaryMask));
        const auto aBlend = [&](std::size_t i) {
            auto aCurrent = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + i));
            auto a = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSourceA + i));
            auto b = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSourceB + i));
            auto aResult = _mm_or_si128(_mm_and_si128(aCurrent, aStationary),
                _mm_or_si128(_mm_and_si128(a, aMaskA), _mm_and_si128(b, aMaskB)));
            _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + i), aResult);
        };
#if !defined(__AVX2__)
        for (; aIndex + 64U <= pLength; aIndex += 64U) {
            aBlend(aIndex); aBlend(aIndex + 16U);
            aBlend(aIndex + 32U); aBlend(aIndex + 48U);
        }
#endif
        for (; aIndex + 16U <= pLength; aIndex += 16U) aBlend(aIndex);
    }
#endif
    for (; aIndex < pLength; ++aIndex) {
        auto aCurrent = pSource[aIndex];
        auto a = pSourceA[aIndex];
        auto b = pSourceB[aIndex];
        auto aResult = static_cast<std::uint8_t>((aCurrent & pStationaryMask) |
                                                 (a & pMaskA) | (b & pMaskB));
        pDestination[aIndex] = aResult;
    }
}
} // namespace

FourCrowKernel::FourCrowKernel(Shift pShiftA, Shift pShiftB)
    : Kernel(KernelType::kFourCrowKernel), mShifts{pShiftA, pShiftB},
      mStationaryMask(static_cast<std::uint8_t>(~(pShiftA.mMask | pShiftB.mMask))),
      mValidMasks(std::popcount(pShiftA.mMask) == 2 && std::popcount(pShiftB.mMask) == 2 &&
                  (pShiftA.mMask & pShiftB.mMask) == 0U) {}

bool FourCrowKernel::SealData(const std::uint8_t *pSource, std::uint8_t *,
                     std::uint8_t *pDestination, std::size_t pLength,
                     KernelErrorCode *pErrorCode) const {
    return Apply<false>(pSource, pDestination, pLength, pErrorCode);
}

bool FourCrowKernel::UnsealData(const std::uint8_t *pSource, std::uint8_t *,
                       std::uint8_t *pDestination, std::size_t pLength,
                       KernelErrorCode *pErrorCode) const {
    return Apply<true>(pSource, pDestination, pLength, pErrorCode);
}

void FourCrowKernel::Zero() {
    for (auto &aShift : mShifts) aShift = {};

    mStationaryMask = 0U;
    mValidMasks = false;
}

template<bool Inverse>
bool FourCrowKernel::Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
                  std::size_t pLength, KernelErrorCode *pErrorCode) const {
    if (pLength == 0U) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
        return true;
    }
    if (pLength % 16U != 0U) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kInvalidLength);
        return false;
    }
    if (!mValidMasks) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kInvalidParameter);
        return false;
    }
    if (!pSource || !pDestination) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNullBuffer);
        return false;
    }
    if (BuffersOverlap(pSource, pDestination, pLength)) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kAliasedBuffer);
        return false;
    }
    if (pLength == kBlockBytes) {
        struct Context {
            const FourCrowKernel *mKernel;
            const std::uint8_t *mSource;
            std::uint8_t *mDestination;
        };
        const Context aContext{this, pSource, pDestination};
        const ParallelJob aJob{&aContext, [](const void *pContext, std::size_t pQuarter) {
            const auto &c = *static_cast<const Context *>(pContext);
            constexpr auto kQuarter = kBlockBytes / 4U;
            c.mKernel->template Transform<Inverse, kBlockBytes>(c.mSource, c.mDestination, kBlockBytes,
                                                      pQuarter * kQuarter, (pQuarter + 1U) * kQuarter);
        }};
        GetWorkers().Run(aJob);
    } else {
        Transform<Inverse, 0U>(pSource, pDestination, pLength, 0U, pLength);
    }
    SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
    return true;
}

template<bool Inverse, std::size_t FixedLength>
void FourCrowKernel::Transform(const std::uint8_t *pSource, std::uint8_t *pDestination,
                      std::size_t pLength, std::size_t pBegin, std::size_t pEnd) const {
    const std::size_t aLength = FixedLength != 0U ? FixedLength : pLength;
    const std::size_t aRotationA = mShifts[0].mRotation % aLength;
    const std::size_t aRotationB = mShifts[1].mRotation % aLength;
    std::size_t aPositionA = Inverse || aRotationA == 0U ? aRotationA : aLength - aRotationA;
    std::size_t aPositionB = Inverse || aRotationB == 0U ? aRotationB : aLength - aRotationB;
    aPositionA = (aPositionA + pBegin) % aLength;
    aPositionB = (aPositionB + pBegin) % aLength;
    std::size_t aOffset = pBegin;
    while (aOffset < pEnd) {
        const std::size_t aSpan = std::min({pEnd - aOffset, aLength - aPositionA, aLength - aPositionB});
        BlendSpan(pSource + aOffset, pSource + aPositionA, pSource + aPositionB,
                  pDestination + aOffset, aSpan, mShifts[0].mMask, mShifts[1].mMask,
                  mStationaryMask);
        aOffset += aSpan;
        aPositionA += aSpan;
        aPositionB += aSpan;
        if (aPositionA == aLength) aPositionA = 0U;
        if (aPositionB == aLength) aPositionB = 0U;
    }
}
