#ifndef SOCCER_BOG_QUIRK_PLAN_HPP_
#define SOCCER_BOG_QUIRK_PLAN_HPP_

// Benchmark-only schedules and range kernels. The active cryptex is unchanged.
#include "../ScrambleTests/__CipherMock/TESTBogNEON.hpp"
#include "../ScrambleTests/__CipherMock/TESTQuirkHigh.hpp"
#include "../ScrambleTests/__CipherMock/TESTQuirkLow.hpp"
#include "CorvidShift.hpp"
#include <atomic>
#include <span>
#include <stdexcept>
#include <thread>
#include <vector>

#if defined(__aarch64__)
namespace BogQuirkPlan {
enum class Kind { kBog, kHigh, kLow, kMove, kReverse };
struct Stage;
using Kernel = void (*)(const Stage &,const std::uint8_t *,std::uint8_t *,std::size_t,std::size_t,std::size_t);
struct Stage {
    Kind kind = Kind::kBog;
    TESTBog bog{0U,0U,0U,TESTBog::HotPair::kA,TESTBog::PackOrder::kABC};
    unsigned variant = 0U;
    std::array<std::size_t,3> windows{};
    std::array<CorvidShift,2> shifts{};
    const std::uint8_t *material = nullptr;
    Kernel seal = nullptr;
    Kernel unseal = nullptr;
};

template<bool Inverse>
inline void Bog(const Stage &p, const std::uint8_t *src, std::uint8_t *dst,
                 std::size_t len, std::size_t begin, std::size_t end) {
    TESTBogNEON::GetKernel<Inverse>(p.bog)(p.bog,src,dst,len,begin,end);
}

// Same arithmetic and chunk addresses as production Quirk. Ranges retain
// access to the whole source block; calling a cipher on four sub-blocks would
// change its circular windows and would benchmark a different operation.
template<bool High, bool Inverse, unsigned Variant>
inline void Quirk(const Stage &p, const std::uint8_t *src, std::uint8_t *dst,
                   std::size_t len, std::size_t begin, std::size_t end) {
    const auto n = len/256U;
    auto wa = (p.windows[0]%n+begin/256U)%n;
    auto wb = (p.windows[1]%n+begin/256U)%n;
    auto wc = (p.windows[2]%n+begin/256U)%n;
    for (std::size_t pos = begin; pos < end; pos += 256U) {
        for (std::size_t i = 0U; i < 256U; i += 16U) {
            const auto a = vld1q_u8(src+256U*wa+((Variant&4U) ? 240U-i : i));
            const auto b = vld1q_u8(src+256U*wb+((Variant&2U) ? 240U-i : i));
            const auto c = vld1q_u8(src+256U*wc+((Variant&1U) ? 240U-i : i));
            const auto current = vld1q_u8(src+pos+i);
            const auto key = veorq_u8(a,vandq_u8(b,c));
            uint8x16_t result;
            if constexpr (!High) {
                const auto shifted = vshlq_n_u8(key,4);
                result = Inverse ? vsubq_u8(current,shifted) : vaddq_u8(current,shifted);
            } else if constexpr (!Inverse) {
                result = vsriq_n_u8(current,vaddq_u8(vshlq_n_u8(current,4),key),4);
            } else {
                result = vbslq_u8(vdupq_n_u8(0xF0U),current,vsubq_u8(current,vshrq_n_u8(key,4)));
            }
            vst1q_u8(dst+pos+i,result);
        }
        if (++wa == n) wa = 0U;
        if (++wb == n) wb = 0U;
        if (++wc == n) wc = 0U;
    }
}
template<bool High, bool Inverse>
inline constexpr std::array<Kernel,8> kQuirks = {
    Quirk<High,Inverse,0>,Quirk<High,Inverse,1>,Quirk<High,Inverse,2>,Quirk<High,Inverse,3>,
    Quirk<High,Inverse,4>,Quirk<High,Inverse,5>,Quirk<High,Inverse,6>,Quirk<High,Inverse,7>};

inline uint8x16_t LoadWrapped(const std::uint8_t *src, std::size_t pos, std::size_t len) {
    if (len-pos >= 16U) return vld1q_u8(src+pos);
    std::array<std::uint8_t,16> tail{};
    for (std::size_t i = 0U; i < 16U; ++i) tail[i] = src[(pos+i)%len];
    return vld1q_u8(tail.data());
}
template<bool Inverse, bool Mutate>
inline void Move(const Stage &p, const std::uint8_t *src, std::uint8_t *dst,
                  std::size_t len, std::size_t begin, std::size_t end) {
    const auto r0 = p.shifts[0].mRotation%len, r1 = p.shifts[1].mRotation%len;
    auto s0 = (begin+(Inverse ? r0 : (len-r0)%len))%len;
    auto s1 = (begin+(Inverse ? r1 : (len-r1)%len))%len;
    const auto m0 = vdupq_n_u8(p.shifts[0].mMask), m1 = vdupq_n_u8(p.shifts[1].mMask);
    const auto still = vdupq_n_u8(static_cast<std::uint8_t>(~(p.shifts[0].mMask|p.shifts[1].mMask)));
    for (std::size_t pos = begin; pos < end; pos += 16U) {
        auto base = vld1q_u8(src+pos);
        auto a = LoadWrapped(src,s0,len), b = LoadWrapped(src,s1,len);
        if constexpr (Inverse && Mutate) {
            base = veorq_u8(base,vld1q_u8(p.material+pos));
            a = veorq_u8(a,LoadWrapped(p.material,s0,len));
            b = veorq_u8(b,LoadWrapped(p.material,s1,len));
        }
        auto result = vorrq_u8(vandq_u8(base,still),vorrq_u8(vandq_u8(a,m0),vandq_u8(b,m1)));
        if constexpr (!Inverse && Mutate) result = veorq_u8(result,vld1q_u8(p.material+pos));
        vst1q_u8(dst+pos,result);
        s0 += 16U; if (s0 >= len) s0 -= len;
        s1 += 16U; if (s1 >= len) s1 -= len;
    }
}
inline void Reverse(const Stage &, const std::uint8_t *src, std::uint8_t *dst,
                     std::size_t, std::size_t begin, std::size_t end) {
    for (std::size_t pos = begin; pos < end; pos += 16U) vst1q_u8(dst+pos,vrbitq_u8(vld1q_u8(src+pos)));
}

inline std::array<CorvidShift,2> Shifts(unsigned layer) {
    constexpr std::array<std::array<std::uint8_t,2>,8> masks = {{
        {0x05U,0x50U},{0x0AU,0xA0U},{0x11U,0x44U},{0x22U,0x88U},
        {0x09U,0x90U},{0x06U,0x60U},{0x21U,0x84U},{0x12U,0x48U}}};
    return {{{masks[layer%8U][0],256U*(57U+317U*layer)+1U+2U*(layer%32U)},
             {masks[layer%8U][1],256U*(1987U+461U*layer)+3U+2U*(layer%32U)}}};
}
inline std::array<std::size_t,3> Windows(std::size_t stage) {
    return {127U+31U*stage,2671U+67U*stage,7903U+127U*stage};
}

struct Plan {
    unsigned layers;
    unsigned bogCount = 0U, quirkCount = 0U, materialCount = 0U;
    std::vector<Stage> stages;
    Plan(unsigned pLayers, const std::array<const std::uint8_t *,16> &pMaterials) : layers(pLayers) {
        if (layers != 4U && layers != 6U && layers != 8U)
            throw std::invalid_argument("The benchmark defines 4-, 6-, and 8-layer proposals");
        const auto addBog = [&](unsigned family, unsigned order) {
            Stage p;
            p.windows = Windows(stages.size());
            p.bog = TESTBog(p.windows[0],p.windows[1],p.windows[2],
                static_cast<TESTBog::HotPair>(6U-2U*family),static_cast<TESTBog::PackOrder>(order));
            p.seal = Bog<false>; p.unseal = Bog<true>;
            stages.push_back(p); ++bogCount;
        };
        const auto addQuirk = [&](bool high, unsigned v) {
            Stage p;
            p.kind = high ? Kind::kHigh : Kind::kLow;
            p.variant = v; p.windows = Windows(stages.size());
            p.seal = high ? kQuirks<true,false>[v] : kQuirks<false,false>[v];
            p.unseal = high ? kQuirks<true,true>[v] : kQuirks<false,true>[v];
            stages.push_back(p); ++quirkCount;
        };
        for (unsigned layer = 0U; layer < layers; ++layer) {
            const unsigned bogs = layers == 8U ? 3U : 4U;
            // Four-layer subset: three cyclic packings plus one reverse;
            // Quirk A/D/F/G reverses each input exactly twice over the plan.
            constexpr std::array<unsigned,4> kFourOrders = {0U,3U,4U,5U};
            constexpr std::array<unsigned,4> kFourDirections = {0U,3U,5U,6U};
            constexpr std::array<unsigned,6> kSixDirections = {0U,1U,2U,5U,6U,7U};
            const unsigned direction = layers == 4U ? kFourDirections[layer] :
                                       layers == 6U ? kSixDirections[layer] : layer;
            for (unsigned i = 0U; i < bogs; ++i) {
                const unsigned index = layer*bogs+i;
                addBog(index%4U,layers == 4U ? kFourOrders[layer] : index/4U);
                if (i == 0U) addQuirk(true,direction);
                if (i == 1U) addQuirk(false,direction);
            }
            Stage move;
            move.kind = Kind::kMove; move.shifts = Shifts(layer);
            // Keep four material lanes in every candidate, as in Weak.
            if ((layer+1U)*4U/layers > layer*4U/layers) {
                move.material = pMaterials[materialCount++];
                move.seal = Move<false,true>; move.unseal = Move<true,true>;
            } else {
                move.seal = Move<false,false>; move.unseal = Move<true,false>;
            }
            stages.push_back(move);
            if (layer+1U == layers/2U) {
                Stage reverse;
                reverse.kind = Kind::kReverse; reverse.seal = reverse.unseal = Reverse;
                stages.push_back(reverse);
            }
        }
    }
};

// One submission wakes three helpers for the whole pipeline. Every pass has
// a barrier; source and destination are always distinct. Reusing this pool
// models the production design needed to keep all variants in the budget.
class Barrier {
public:
    void Wait() {
        const auto phase = mPhase.load(std::memory_order_relaxed);
        if (mRemaining.fetch_sub(1U,std::memory_order_acq_rel) == 1U) {
            mRemaining.store(4U,std::memory_order_relaxed);
            mPhase.fetch_add(1U,std::memory_order_release); mPhase.notify_all();
        } else mPhase.wait(phase,std::memory_order_acquire);
    }
private:
    std::atomic<unsigned> mRemaining{4U},mPhase{0U};
};
struct Job {
    std::span<const Stage> stages;
    const std::uint8_t *source;
    std::uint8_t *scratch;
    std::uint8_t *destination;
    std::size_t length;
    bool inverse;
};
inline void Run(const Job &job, unsigned quarter, Barrier *barrier) {
    // Copy all job state before processing. After the final barrier, the
    // caller may destroy Job immediately; no worker reads it again.
    const auto *stages = job.stages.data();
    const auto count = job.stages.size();
    const auto len = job.length;
    const bool inverse = job.inverse;
    const auto *input = job.source;
    auto *scratch = job.scratch;
    auto *dest = job.destination;
    const auto begin = barrier ? (len/256U*quarter/4U)*256U : 0U;
    const auto end = barrier ? (len/256U*(quarter+1U)/4U)*256U : len;
    for (std::size_t i = 0U; i < count; ++i) {
        auto *output = ((count-i)%2U != 0U) ? dest : scratch;
        const auto &stage = stages[inverse ? count-1U-i : i];
        (inverse ? stage.unseal : stage.seal)(stage,input,output,len,begin,end);
        input = output;
        if (barrier) barrier->Wait();
    }
}
class FourWorkers {
public:
    FourWorkers() {
        try {
            for (unsigned i = 0U; i < 3U; ++i) mThreads[i] = std::thread([this,i] {
                unsigned seen = 0U;
                for (;;) {
                    auto epoch = mEpoch.load(std::memory_order_acquire);
                    while (epoch == seen) {
                        mEpoch.wait(seen,std::memory_order_acquire);
                        epoch = mEpoch.load(std::memory_order_acquire);
                    }
                    seen = epoch;
                    if (mStop.load(std::memory_order_relaxed)) return;
                    Run(*mJob,i+1U,&mBarrier);
                }
            });
        } catch (...) { Stop(); throw; }
    }
    ~FourWorkers() { Stop(); }
    FourWorkers(const FourWorkers &) = delete;
    FourWorkers &operator=(const FourWorkers &) = delete;
    void Submit(const Job &job) {
        mJob = &job;
        mEpoch.fetch_add(1U,std::memory_order_release); mEpoch.notify_all();
        Run(job,0U,&mBarrier);
    }
private:
    void Stop() {
        mStop.store(true,std::memory_order_relaxed);
        mEpoch.fetch_add(1U,std::memory_order_release); mEpoch.notify_all();
        for (auto &thread : mThreads) if (thread.joinable()) thread.join();
    }
    std::array<std::thread,3> mThreads;
    std::atomic<unsigned> mEpoch{0U};
    const Job *mJob = nullptr;
    std::atomic<bool> mStop{false};
    Barrier mBarrier;
};
} // namespace BogQuirkPlan
#endif
#endif
