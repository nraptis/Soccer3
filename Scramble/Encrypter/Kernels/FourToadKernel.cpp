#include "FourToadKernel.hpp"

#include <algorithm>
#include <atomic>
#include <mutex>
#include <system_error>
#include <thread>

// Select the backend here without depending on Soccer3.hpp or shared helpers.
// Keep the project's existing IGNORE_SIMD switch for scalar builds.
#if (!defined(IGNORE_SIMD) || !IGNORE_SIMD) && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#define SOCCER_FOUR_TOAD_USE_NEON 1
#include <arm_neon.h>
#else
#define SOCCER_FOUR_TOAD_USE_NEON 0
#endif

#if !SOCCER_FOUR_TOAD_USE_NEON && (!defined(IGNORE_SIMD) || !IGNORE_SIMD) && \
    (defined(__SSE2__) || defined(_M_X64) || (defined(_M_IX86_FP) && _M_IX86_FP >= 2))
#define SOCCER_FOUR_TOAD_USE_SSE2 1
#include <emmintrin.h>
#else
#define SOCCER_FOUR_TOAD_USE_SSE2 0
#endif

namespace {
constexpr std::size_t kWindowBytes = 64U;
constexpr std::size_t kKeysPerWindow = 16U;
constexpr std::size_t kWorkerCount = 4U;
// Small inputs can finish on the caller before waking the helper threads pays off.
constexpr std::size_t kParallelBytes = 64U * 1024U;
#if SOCCER_FOUR_TOAD_USE_NEON
constexpr std::size_t kMainlineWindows = FourToadKernel::kBlockBytes / kWindowBytes;
#endif

// Each four-byte group contributes two selected row bits per byte:
//   [ B3 A3 B2 A2 B1 A1 B0 A0 ]
// Pack a whole 64-byte window into sixteen such bytes. The row-dependent
// shifts are prepared once per stage/quarter, outside this helper's calls.
#if SOCCER_FOUR_TOAD_USE_NEON
inline uint8x16_t PackRowsNEON(const std::uint8_t *pSource,
                             int8x16_t pShiftA, int8x16_t pShiftB) {
    const uint8x16_t aWeightsA = {1,4,16,64,1,4,16,64,1,4,16,64,1,4,16,64};
    const auto aWeightsB = vshlq_n_u8(aWeightsA, 1);
    const auto aPackGroup = [&](std::size_t pOffset) {
        const auto aValue = vld1q_u8(pSource + pOffset);
        return vorrq_u8(vandq_u8(vshlq_u8(aValue, pShiftA), aWeightsA),
                        vandq_u8(vshlq_u8(aValue, pShiftB), aWeightsB));
    };
    return vpaddq_u8(vpaddq_u8(aPackGroup(0U), aPackGroup(16U)),
                     vpaddq_u8(aPackGroup(32U), aPackGroup(48U)));
}

// Transform already holds bytes 0,4,8,... in val[0], bytes 1,5,9,... in
// val[1], etc. Pack the NEXT stage's row bits directly from those registers,
// avoiding another read/deinterleave of the just-written 64 output bytes.
inline uint8x16_t PackRowsFromLanes(const uint8x16x4_t &pValues,
                                  int8x16_t pShiftA, int8x16_t pShiftB) {
    const auto aPair = [&](uint8x16_t pValue) {
        const auto a = vshlq_u8(pValue, pShiftA);
        const auto b = vshlq_u8(pValue, pShiftB);
        return vandq_u8(vsliq_n_u8(a, b, 1), vdupq_n_u8(3U));
    };
    return vorrq_u8(vorrq_u8(aPair(pValues.val[0]), vshlq_n_u8(aPair(pValues.val[1]), 2)),
                     vorrq_u8(vshlq_n_u8(aPair(pValues.val[2]), 4),
                               vshlq_n_u8(aPair(pValues.val[3]), 6)));
}
#elif SOCCER_FOUR_TOAD_USE_SSE2
inline __m128i PackRowsSSE2(const std::uint8_t *pSource,
                          __m128i pShiftA, __m128i pShiftB) {
    const auto aOnes = _mm_set1_epi8(1);
    const auto aPackGroup = [&](std::size_t pOffset) {
        const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + pOffset));
        auto aBits = _mm_or_si128(_mm_and_si128(_mm_srl_epi16(aValue, pShiftA), aOnes),
            _mm_slli_epi16(_mm_and_si128(_mm_srl_epi16(aValue, pShiftB), aOnes), 1));
        aBits = _mm_or_si128(aBits, _mm_srli_epi32(aBits, 6));
        aBits = _mm_or_si128(aBits, _mm_srli_epi32(aBits, 12));
        return _mm_and_si128(aBits, _mm_set1_epi32(255));
    };
    return _mm_packus_epi16(_mm_packs_epi32(aPackGroup(0U), aPackGroup(16U)),
                            _mm_packs_epi32(aPackGroup(32U), aPackGroup(48U)));
}
#endif

struct StagePlan {
    FourToadKernel::Stage mStage;
    std::uint8_t mProtected;
    std::uint8_t mLowestWritable;

    explicit StagePlan(const FourToadKernel::Stage &pStage, std::size_t pWindowCount)
        : mStage(pStage) {
        for (auto &aRotation : mStage.mWindowRotations) aRotation %= pWindowCount;
        mProtected = static_cast<std::uint8_t>((1U << pStage.mRowA) | (1U << pStage.mRowB));
        const auto aWritable = static_cast<std::uint8_t>(~mProtected);
        mLowestWritable = static_cast<std::uint8_t>(aWritable & (0U - aWritable));
    }

    void PackKeys(const std::uint8_t *pInput, std::uint8_t *pKeys,
                  std::size_t pBegin, std::size_t pEnd) const {
#if SOCCER_FOUR_TOAD_USE_NEON
        const int8x16_t aPositions = {0,2,4,6,0,2,4,6,0,2,4,6,0,2,4,6};
        const auto aShiftA = vsubq_s8(aPositions, vdupq_n_s8(mStage.mRowA));
        const auto aShiftB = vsubq_s8(vaddq_s8(aPositions, vdupq_n_s8(1)), vdupq_n_s8(mStage.mRowB));
        const auto aMask = vdupq_n_u8(mProtected);
        const auto aLowest = vdupq_n_u8(mLowestWritable);
#elif SOCCER_FOUR_TOAD_USE_SSE2
        const auto aShiftA = _mm_cvtsi32_si128(static_cast<int>(mStage.mRowA));
        const auto aShiftB = _mm_cvtsi32_si128(static_cast<int>(mStage.mRowB));
        const auto aMask = _mm_set1_epi8(static_cast<char>(mProtected));
        const auto aLowest = _mm_set1_epi8(static_cast<char>(mLowestWritable));
#endif
        for (std::size_t aWindow = pBegin; aWindow < pEnd; ++aWindow) {
            const auto *aSource = pInput + kWindowBytes * aWindow;
            auto *aDestination = pKeys + kKeysPerWindow * aWindow;
            // All four offset reads need the same gate. Compute it once, before storing.
#if SOCCER_FOUR_TOAD_USE_NEON
            const auto aPacked = PackRowsNEON(aSource, aShiftA, aShiftB);
            const auto aGate = vceqq_u8(vandq_u8(aPacked, aMask), aMask);
            vst1q_u8(aDestination, vbicq_u8(veorq_u8(aPacked, vandq_u8(aGate, aLowest)), aMask));
#elif SOCCER_FOUR_TOAD_USE_SSE2
            const auto aPacked = PackRowsSSE2(aSource, aShiftA, aShiftB);
            const auto aGate = _mm_cmpeq_epi8(_mm_and_si128(aPacked, aMask), aMask);
            const auto aKey = _mm_andnot_si128(aMask, _mm_xor_si128(aPacked, _mm_and_si128(aGate, aLowest)));
            _mm_storeu_si128(reinterpret_cast<__m128i *>(aDestination), aKey);
#else
            for (std::size_t aGroup = 0; aGroup < kKeysPerWindow; ++aGroup) {
                unsigned aPacked = 0;
                for (unsigned aByte = 0; aByte < 4; ++aByte) {
                    const auto aValue = aSource[4 * aGroup + aByte];
                    aPacked |= ((aValue >> mStage.mRowA) & 1U) << (2 * aByte);
                    aPacked |= ((aValue >> mStage.mRowB) & 1U) << (2 * aByte + 1);
                }
                if ((aPacked & mProtected) == mProtected) aPacked ^= mLowestWritable;
                aDestination[aGroup] = static_cast<std::uint8_t>(aPacked & ~mProtected);
            }
#endif
        }
    }

    template<bool Inverse, bool PackNext = false>
    void Transform(const std::uint8_t *pInput, std::uint8_t *pOutput, const std::uint8_t *pKeys,
                   std::size_t pWindowCount, std::size_t pBegin, std::size_t pEnd,
                   const StagePlan *pNextStage = nullptr, std::uint8_t *pNextKeys = nullptr) const {
#if SOCCER_FOUR_TOAD_USE_NEON
        // The false specialization eliminates all next-stage setup and writes.
        const auto aNextShiftA = vdupq_n_s8(PackNext ? -static_cast<int>(pNextStage->mStage.mRowA) : 0);
        const auto aNextShiftB = vdupq_n_s8(PackNext ? -static_cast<int>(pNextStage->mStage.mRowB) : 0);
        const auto aNextMask = vdupq_n_u8(PackNext ? pNextStage->mProtected : 0U);
        const auto aNextLowest = vdupq_n_u8(PackNext ? pNextStage->mLowestWritable : 0U);
#else
        (void)pNextStage;
        (void)pNextKeys;
#endif
        auto aSamples = mStage.mWindowRotations;
        for (auto &aSample : aSamples) aSample = (aSample + pBegin) % pWindowCount;
        // Each offset wraps only once. Keep modulo out of the inner loop.
        while (pBegin < pEnd) {
            auto aCount = pEnd - pBegin;
            for (auto aSample : aSamples) aCount = std::min(aCount, pWindowCount - aSample);
            for (std::size_t aIndex = 0; aIndex < aCount; ++aIndex) {
                const auto *aSource = pInput + kWindowBytes * (pBegin + aIndex);
                auto *aDestination = pOutput + kWindowBytes * (pBegin + aIndex);
#if SOCCER_FOUR_TOAD_USE_NEON
                const auto aMask = vdupq_n_u8(mProtected);
                auto aValues = vld4q_u8(aSource);
                // Dynamic val[lane] indexing spills all four vectors at -Os.
                // Keep the four lanes in registers even in size-optimized builds.
#if defined(__clang__)
#pragma clang loop unroll(full)
#endif
                for (std::size_t aLane = 0; aLane < 4; ++aLane) {
                    const auto aKey = vld1q_u8(pKeys + kKeysPerWindow * (aSamples[aLane] + aIndex));
                    const auto aValue = aValues.val[aLane];
                    const auto aChanged = Inverse ? vsubq_u8(vbicq_u8(aValue, aMask), aKey)
                                                  : vaddq_u8(vorrq_u8(aValue, aMask), aKey);
                    aValues.val[aLane] = vbslq_u8(aMask, aValue, aChanged);
                }
                vst4q_u8(aDestination, aValues);
                if constexpr (PackNext) {
                    const auto aPacked = PackRowsFromLanes(aValues, aNextShiftA, aNextShiftB);
                    const auto aGate = vceqq_u8(vandq_u8(aPacked, aNextMask), aNextMask);
                    const auto aKey = vbicq_u8(veorq_u8(aPacked, vandq_u8(aGate, aNextLowest)), aNextMask);
                    vst1q_u8(pNextKeys + kKeysPerWindow * (pBegin + aIndex), aKey);
                }
#elif SOCCER_FOUR_TOAD_USE_SSE2
                const auto aMask = _mm_set1_epi8(static_cast<char>(mProtected));
                __m128i aKeys[4];
                for (std::size_t aLane = 0; aLane < 4; ++aLane) {
                    const auto *aKey = pKeys + kKeysPerWindow * (aSamples[aLane] + aIndex);
                    aKeys[aLane] = _mm_loadu_si128(reinterpret_cast<const __m128i *>(aKey));
                }
                const auto aLowAB = _mm_unpacklo_epi8(aKeys[0], aKeys[1]);
                const auto aLowCD = _mm_unpacklo_epi8(aKeys[2], aKeys[3]);
                const auto aHighAB = _mm_unpackhi_epi8(aKeys[0], aKeys[1]);
                const auto aHighCD = _mm_unpackhi_epi8(aKeys[2], aKeys[3]);
                const __m128i aInterleaved[] = {_mm_unpacklo_epi16(aLowAB, aLowCD), _mm_unpackhi_epi16(aLowAB, aLowCD),
                                                _mm_unpacklo_epi16(aHighAB, aHighCD), _mm_unpackhi_epi16(aHighAB, aHighCD)};
                for (std::size_t aLane = 0; aLane < 4; ++aLane) {
                    const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(aSource + 16 * aLane));
                    const auto aChanged = Inverse ? _mm_sub_epi8(_mm_andnot_si128(aMask, aValue), aInterleaved[aLane])
                                                  : _mm_add_epi8(_mm_or_si128(aMask, aValue), aInterleaved[aLane]);
                    const auto aResult = _mm_or_si128(_mm_and_si128(aMask, aValue), _mm_andnot_si128(aMask, aChanged));
                    _mm_storeu_si128(reinterpret_cast<__m128i *>(aDestination + 16 * aLane), aResult);
                }
#else
                for (std::size_t aGroup = 0; aGroup < kKeysPerWindow; ++aGroup) {
                    for (std::size_t aLane = 0; aLane < 4; ++aLane) {
                        const auto aKey = pKeys[kKeysPerWindow * (aSamples[aLane] + aIndex) + aGroup];
                        const auto aValue = aSource[4 * aGroup + aLane];
                        const auto aChanged = Inverse ? (aValue & ~mProtected) - aKey : (aValue | mProtected) + aKey;
                        aDestination[4 * aGroup + aLane] = static_cast<std::uint8_t>((aValue & mProtected) | (aChanged & ~mProtected));
                    }
                }
#endif
            }
            pBegin += aCount;
            for (auto &aSample : aSamples) {
                aSample += aCount;
                if (aSample == pWindowCount) aSample = 0;
            }
        }
    }
};

// Reused for packing, transforming, and returning the completed job.
// Each arriving quarter publishes its writes to the next arrival. The last
// publishes all four quarters to the peers waiting for the phase to advance.
class QuarterBarrier {
public:
    void Wait() {
        const auto aPhase = mPhase.load(std::memory_order_relaxed);
        if (mRemaining.fetch_sub(1, std::memory_order_acq_rel) == 1) {
            mRemaining.store(kWorkerCount, std::memory_order_relaxed);
            mPhase.fetch_add(1, std::memory_order_release);
            mPhase.notify_all();
        } else {
            mPhase.wait(aPhase, std::memory_order_acquire);
        }
    }

private:
    std::atomic<unsigned> mRemaining{kWorkerCount};
    std::atomic<unsigned> mPhase{0};
};

struct FourToadKernelJob {
    const std::array<StagePlan, 4> &mStages;
    const std::uint8_t *mSource;
    std::uint8_t *mDestination;
    std::uint8_t *mPackedKeys;
    std::size_t mWindowCount;
    bool mInverse;
    std::uint8_t *mNextPackedKeys = nullptr;

#if SOCCER_FOUR_TOAD_USE_NEON
    template<bool Inverse>
    void RunPipelined(std::size_t pQuarter, QuarterBarrier *pBarrier) const {
        constexpr auto kQuarterWindows = kMainlineWindows / kWorkerCount;
        const auto aBegin = kQuarterWindows * pQuarter;
        const auto aEnd = aBegin + kQuarterWindows;
        auto *aKeys = mPackedKeys;
        auto *aNextKeys = mNextPackedKeys;
        const auto *aInput = mSource;
        mStages[Inverse ? 3U : 0U].PackKeys(aInput, aKeys, aBegin, aEnd);
        pBarrier->Wait();
        for (std::size_t aStep = 0U; aStep < mStages.size(); ++aStep) {
            const auto aStageIndex = Inverse ? 3U - aStep : aStep;
            const auto &aStage = mStages[aStageIndex];
            if (aStep + 1U < mStages.size()) {
                const auto &aNextStage = mStages[Inverse ? aStageIndex - 1U : aStageIndex + 1U];
                aStage.Transform<Inverse, true>(aInput, mDestination, aKeys, kMainlineWindows,
                                               aBegin, aEnd, &aNextStage, aNextKeys);
                // Publish all next-stage keys AND finish all current-key reads.
                // Two distinct buffers prevent overwrite of keys still in use.
                pBarrier->Wait();
                std::swap(aKeys, aNextKeys);
            } else {
                aStage.Transform<Inverse>(aInput, mDestination, aKeys, kMainlineWindows, aBegin, aEnd);
            }
            aInput = mDestination;
        }
    }
#endif

    template<bool Parallel, bool Inverse>
    void RunStages(std::size_t pQuarter, QuarterBarrier *pBarrier) const {
        const std::size_t aBegin = Parallel ? mWindowCount * pQuarter / kWorkerCount : 0;
        const std::size_t aEnd = Parallel ? mWindowCount * (pQuarter + 1) / kWorkerCount : mWindowCount;
        const auto *aInput = mSource;
        for (std::size_t aStep = 0; aStep < mStages.size(); ++aStep) {
            const auto &aStage = mStages[Inverse ? mStages.size() - 1 - aStep : aStep];
            aStage.PackKeys(aInput, mPackedKeys, aBegin, aEnd);
            if constexpr (Parallel) pBarrier->Wait();
            aStage.Transform<Inverse>(aInput, mDestination, mPackedKeys, mWindowCount, aBegin, aEnd);
            // Peers can still be reading our keys. Finish before reusing the cache.
            if constexpr (Parallel) {
                if (aStep + 1 < mStages.size()) pBarrier->Wait();
            }
            aInput = mDestination;
        }
    }

    template<bool Parallel>
    void Run(std::size_t pQuarter, QuarterBarrier *pBarrier) const {
#if SOCCER_FOUR_TOAD_USE_NEON
        if constexpr (Parallel) {
            if (mNextPackedKeys) {
                if (mInverse) RunPipelined<true>(pQuarter, pBarrier);
                else RunPipelined<false>(pQuarter, pBarrier);
                return;
            }
        }
#endif
        if (mInverse) RunStages<Parallel, true>(pQuarter, pBarrier);
        else RunStages<Parallel, false>(pQuarter, pBarrier);
    }
};

// One team serves all eight layers. Helpers sleep between jobs, and the caller
// does one quarter itself. Only the published job refers to cipher buffers.
class FourToadKernelWorkers {
public:
    FourToadKernelWorkers() {
        try {
            for (std::size_t aIndex = 0; aIndex < mThreads.size(); ++aIndex) {
                mThreads[aIndex] = std::thread(&FourToadKernelWorkers::WorkerLoop, this, aIndex + 1);
            }
            mAvailable = true;
        } catch (const std::system_error &) {
            Stop(); // A partially created team must never enter the four-party barrier.
        }
    }

    ~FourToadKernelWorkers() { Stop(); }

    void Run(const FourToadKernelJob &pJob) {
        if (!mAvailable) {
            pJob.Run<false>(0, nullptr);
            return;
        }
        const std::lock_guard aLock(mSubmission);
        auto aJob = pJob;
#if SOCCER_FOUR_TOAD_USE_NEON
        if (aJob.mWindowCount == kMainlineWindows) aJob.mNextPackedKeys = mPipelineKeys.data();
#endif
        mJob = &aJob;
        WakeWorkers();
        aJob.Run<true>(0, &mBarrier);
        mBarrier.Wait(); // All helpers have finished using pJob.
        mJob = nullptr;
    }

private:
    void WorkerLoop(std::size_t pQuarter) {
        unsigned aGeneration = 0;
        for (;;) {
            mGeneration.wait(aGeneration);
            aGeneration = mGeneration.load();
            const auto *aJob = mJob;
            if (!aJob) return;
            aJob->Run<true>(pQuarter, &mBarrier);
            mBarrier.Wait();
        }
    }

    void WakeWorkers() {
        mGeneration.fetch_add(1);
        mGeneration.notify_all();
    }

    void Stop() {
        mJob = nullptr;
        WakeWorkers();
        for (auto &aThread : mThreads) {
            if (aThread.joinable()) aThread.join();
        }
    }

    std::array<std::thread, kWorkerCount - 1> mThreads;
#if SOCCER_FOUR_TOAD_USE_NEON
    alignas(64) std::array<std::uint8_t, FourToadKernel::kBlockBytes / 4U> mPipelineKeys;
#endif
    std::atomic<unsigned> mGeneration{0};
    QuarterBarrier mBarrier;
    std::mutex mSubmission;
    const FourToadKernelJob *mJob = nullptr;
    bool mAvailable = false;
};

bool Overlaps(const std::uint8_t *pFirst, std::size_t pFirstLength,
              const std::uint8_t *pSecond, std::size_t pSecondLength) {
    const auto aFirst = reinterpret_cast<std::uintptr_t>(pFirst);
    const auto aSecond = reinterpret_cast<std::uintptr_t>(pSecond);
    return aFirst <= aSecond ? aSecond - aFirst < pFirstLength : aFirst - aSecond < pSecondLength;
}
} // namespace

FourToadKernel::FourToadKernel(Stage pFirst, Stage pSecond, Stage pThird, Stage pFourth,
                   std::span<std::uint8_t> pPackedKeys)
    : Kernel(KernelType::kFourToadKernel), mStages{pFirst, pSecond, pThird, pFourth}, mPackedKeys(pPackedKeys) {}

bool FourToadKernel::SealData(const std::uint8_t *pSource, std::uint8_t *, std::uint8_t *pDestination,
                        std::size_t pLength, KernelErrorCode *pErrorCode) const {
    return Apply(false, pSource, pDestination, pLength, pErrorCode);
}

bool FourToadKernel::UnsealData(const std::uint8_t *pSource, std::uint8_t *, std::uint8_t *pDestination,
                          std::size_t pLength, KernelErrorCode *pErrorCode) const {
    return Apply(true, pSource, pDestination, pLength, pErrorCode);
}

bool FourToadKernel::Apply(bool pInverse, const std::uint8_t *pSource, std::uint8_t *pDestination,
                     std::size_t pLength, KernelErrorCode *pErrorCode) const {
    if (pLength == 0) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
        return true;
    }
    if (pLength % kWindowBytes != 0) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kInvalidLength);
        return false;
    }
    if (!pSource || !pDestination) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNullBuffer);
        return false;
    }
    const auto aKeyLength = pLength / 4;
    if (!mPackedKeys.data() || mPackedKeys.size() < aKeyLength) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kInvalidParameter);
        return false;
    }
    if (Overlaps(pSource, pLength, pDestination, pLength) ||
        Overlaps(mPackedKeys.data(), aKeyLength, pSource, pLength) ||
        Overlaps(mPackedKeys.data(), aKeyLength, pDestination, pLength)) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kAliasedBuffer);
        return false;
    }
    for (const auto &aStage : mStages) {
        if (aStage.mRowA >= 8 || aStage.mRowB >= 8 || aStage.mRowA == aStage.mRowB) {
            SetKernelErrorCode(pErrorCode, KernelErrorCode::kInvalidParameter);
            return false;
        }
    }
    const auto aWindows = pLength / kWindowBytes;
    const std::array aPlans = {StagePlan(mStages[0], aWindows), StagePlan(mStages[1], aWindows),
                               StagePlan(mStages[2], aWindows), StagePlan(mStages[3], aWindows)};
    const FourToadKernelJob aJob{aPlans, pSource, pDestination, mPackedKeys.data(), aWindows, pInverse};
    if (pLength < kParallelBytes) {
        aJob.Run<false>(0, nullptr);
    } else {
        static FourToadKernelWorkers aWorkers;
        aWorkers.Run(aJob);
    }
    SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
    return true;
}

void FourToadKernel::Zero() {
    mStages = {};
    mPackedKeys = {};
}
