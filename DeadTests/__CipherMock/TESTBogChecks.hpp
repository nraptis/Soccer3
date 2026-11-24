#ifndef TESTBogChecks_hpp
#define TESTBogChecks_hpp

#include "TESTBog.hpp"
#include "TESTBogNEON.hpp"
#include <algorithm>
#include <limits>
#include <random>
#include <stdexcept>
#include <vector>

namespace TESTBogChecks {
inline void Require(bool pCondition, const char *pMessage) {
    if (!pCondition) throw std::runtime_error(pMessage);
}
inline std::array<TESTBog,24> Plans(std::size_t a, std::size_t b, std::size_t c) {
    return {TestBogAA(a,b,c),TestBogAB(a,b,c),TestBogAC(a,b,c),TestBogAD(a,b,c),TestBogAE(a,b,c),TestBogAF(a,b,c),
            TestBogBA(a,b,c),TestBogBB(a,b,c),TestBogBC(a,b,c),TestBogBD(a,b,c),TestBogBE(a,b,c),TestBogBF(a,b,c),
            TestBogCA(a,b,c),TestBogCB(a,b,c),TestBogCC(a,b,c),TestBogCD(a,b,c),TestBogCE(a,b,c),TestBogCF(a,b,c),
            TestBogDA(a,b,c),TestBogDB(a,b,c),TestBogDC(a,b,c),TestBogDD(a,b,c),TestBogDE(a,b,c),TestBogDF(a,b,c)};
}

// Independent oracle: remove/insert the contiguous two-bit hole using two
// fields, rather than the reference's per-bit loops or NEON's carry bridge.
inline unsigned Pack(unsigned value, unsigned shift) {
    const unsigned lowMask = (1U<<shift)-1U;
    return (value&lowMask)|((value>>(shift+2U))<<shift);
}
inline unsigned Deposit(unsigned value, unsigned shift) {
    const unsigned lowMask = (1U<<shift)-1U;
    return (value&lowMask)|((value>>shift)<<(shift+2U));
}
inline void Oracle(const TESTBog &pPlan, const std::uint8_t *src, std::uint8_t *dst,
                    std::size_t len, bool inverse = false) {
    const unsigned shift = static_cast<unsigned>(pPlan.mHotPair);
    const unsigned mask = 3U<<shift;
    const auto count = len/256U;
    for (std::size_t i = 0U; i < len; ++i) {
        const unsigned a = (src[(i+(pPlan.mWindowA%count)*256U)%len]>>shift)&3U;
        const unsigned b = (src[(i+(pPlan.mWindowB%count)*256U)%len]>>shift)&3U;
        const unsigned c = (src[(i+(pPlan.mWindowC%count)*256U)%len]>>shift)&3U;
        unsigned key = 0U;
        switch (pPlan.mPackOrder) {
            case TESTBog::PackOrder::kABC: key = a*16U+b*4U+c; break;
            case TESTBog::PackOrder::kACB: key = a*16U+c*4U+b; break;
            case TESTBog::PackOrder::kBAC: key = b*16U+a*4U+c; break;
            case TESTBog::PackOrder::kBCA: key = b*16U+c*4U+a; break;
            case TESTBog::PackOrder::kCAB: key = c*16U+a*4U+b; break;
            case TESTBog::PackOrder::kCBA: key = c*16U+b*4U+a; break;
        }
        const unsigned old = Pack(src[i],shift);
        const unsigned changed = (inverse ? old+64U-key : old+key)%64U;
        dst[i] = static_cast<std::uint8_t>((src[i]&mask)|Deposit(changed,shift));
    }
}

inline void CheckPresetsAndArithmetic() {
    const auto plans = Plans(1U,2U,3U);
    std::array<std::uint8_t,1024> source{},actual{},expected{},recovered{};
    [[maybe_unused]] std::array<std::uint8_t,1024> simd{};
    for (unsigned family = 0U; family < 4U; ++family) {
        const unsigned shift = 6U-2U*family;
        const unsigned mask = 3U<<shift;
        for (unsigned value = 0U; value < 256U; ++value) {
            Require(TESTBog::PackWritable(value,mask)==Pack(value,shift), "Bog pack helper mismatch");
            Require(TESTBog::UnpackWritable(Pack(value,shift),mask)==(value&(~mask&255U)), "Bog unpack helper mismatch");
        }
        for (unsigned a = 0U; a < 4U; ++a)
            for (unsigned b = 0U; b < 4U; ++b)
                for (unsigned c = 0U; c < 4U; ++c) {
                    for (unsigned i = 0U; i < 256U; ++i) {
                        source[i] = static_cast<std::uint8_t>(i);
                        source[256U+i] = static_cast<std::uint8_t>(((i+1U)&(~mask&255U))|(a<<shift));
                        source[512U+i] = static_cast<std::uint8_t>(((i+7U)&(~mask&255U))|(b<<shift));
                        source[768U+i] = static_cast<std::uint8_t>(((i+13U)&(~mask&255U))|(c<<shift));
                    }
                    for (unsigned order = 0U; order < 6U; ++order) {
                        const auto &plan = plans[6U*family+order];
                        Require(static_cast<unsigned>(plan.mHotPair)==shift && static_cast<unsigned>(plan.mPackOrder)==order, "Bog preset mismatch");
                        Oracle(plan,source.data(),expected.data(),source.size());
                        Require(plan.SealData(source.data(),nullptr,actual.data(),source.size()), "Bog arithmetic rejected");
                        Require(actual==expected, "Bog exhaustive arithmetic mismatch");
                        Require(plan.UnsealData(actual.data(),nullptr,recovered.data(),actual.size()), "Bog inverse rejected");
                        Require(recovered==source, "Bog exhaustive round trip failed");
                        for (std::size_t i = 0U; i < source.size(); ++i) Require((actual[i]&mask)==(source[i]&mask), "Bog changed hot bits");
#if defined(__aarch64__)
                        Require(TESTBogNEON::SealData(plan,source.data(),simd.data(),source.size()), "Bog NEON arithmetic rejected");
                        Require(simd==expected, "Bog NEON exhaustive arithmetic mismatch");
                        Require(TESTBogNEON::UnsealData(plan,simd.data(),recovered.data(),simd.size()), "Bog NEON inverse rejected");
                        Require(recovered==source, "Bog NEON exhaustive round trip failed");
#endif
                    }
                }
    }
}

inline void CheckBlocks() {
    std::mt19937_64 random(20261123U);
    constexpr auto max = std::numeric_limits<std::size_t>::max();
    const std::array<std::array<std::size_t,3>,5> offsets = {{
        {0U,0U,0U}, {0U,1U,2U}, {1U,1U,2U}, {127U,2671U,7903U}, {max,max-1U,7U}}};
    for (std::size_t len : {256U,512U,768U,1280U,65536U,1048576U}) {
        std::vector<std::uint8_t> input(len+2U),output(len+6U,0xA5U),expected(len),recovered(len),inPlace(len),simd(len);
        auto *src = input.data()+1U;
        auto *dst = output.data()+3U;
        for (std::size_t i = 0U; i < len; ++i) src[i] = static_cast<std::uint8_t>(random());
        const auto original = input;
        for (std::size_t o = 0U; o < offsets.size(); ++o) {
            if (len > 65536U && o != 3U) continue;
            for (const auto &plan : Plans(offsets[o][0],offsets[o][1],offsets[o][2])) {
                for (bool inverse : {false,true}) {
                    Oracle(plan,src,expected.data(),len,inverse);
                    const auto run = [&](const std::uint8_t *s, std::uint8_t *d) {
                        return inverse ? plan.UnsealData(s,nullptr,d,len) : plan.SealData(s,nullptr,d,len);
                    };
                    Require(run(src,dst), "Bog valid block rejected");
                    Require(std::equal(expected.begin(),expected.end(),dst), "Bog block oracle mismatch");
                    Require(input==original, "Bog changed separate source");
                    std::copy_n(src,len,inPlace.data());
                    Require(run(inPlace.data(),inPlace.data()) && inPlace==expected, "Bog in-place mismatch");
                    Require(inverse ? plan.SealData(dst,nullptr,recovered.data(),len) : plan.UnsealData(dst,nullptr,recovered.data(),len), "Bog block inverse rejected");
                    Require(std::equal(recovered.begin(),recovered.end(),src), "Bog full-block round trip failed");
#if defined(__aarch64__)
                    Require(inverse ? TESTBogNEON::UnsealData(plan,src,simd.data(),len) : TESTBogNEON::SealData(plan,src,simd.data(),len), "Bog NEON block rejected");
                    Require(simd==expected, "Bog NEON block oracle mismatch");
                    std::copy_n(src,len,simd.data());
                    Require(inverse ? TESTBogNEON::UnsealData(plan,simd.data(),simd.data(),len) : TESTBogNEON::SealData(plan,simd.data(),simd.data(),len), "Bog NEON in-place rejected");
                    Require(simd==expected, "Bog NEON in-place mismatch");
                    const auto kernel = inverse ? TESTBogNEON::GetKernel<true>(plan) : TESTBogNEON::GetKernel<false>(plan);
                    for (std::size_t part = 0U; part < 3U; ++part)
                        kernel(plan,src,simd.data(),len,(len/256U*part/3U)*256U,(len/256U*(part+1U)/3U)*256U);
                    Require(simd==expected, "Bog NEON partitioned ranges mismatch");
#endif
                    for (std::size_t i : {0U,1U,2U}) Require(output[i]==0xA5U && output[len+3U+i]==0xA5U, "Bog wrote outside destination");
                }
            }
        }
    }
}

inline void CheckCallsAndSequences() {
    const auto plans = Plans(1U,7U,13U);
    for (const auto &plan : plans)
        for (bool inverse : {false,true}) {
            std::array<std::uint8_t,1025> src{};
            const auto run = [&](const TESTBog &p, const std::uint8_t *s, std::uint8_t *d, std::size_t len) {
                const auto result = inverse ? p.UnsealData(s,nullptr,d,len) : p.SealData(s,nullptr,d,len);
#if defined(__aarch64__)
                const auto neon = inverse ? TESTBogNEON::UnsealData(p,s,d,len) : TESTBogNEON::SealData(p,s,d,len);
                Require(neon==result, "Bog call result differs on NEON");
#endif
                return result;
            };
            Require(run(plan,nullptr,nullptr,0U), "Bog zero length rejected");
            Require(run(plan,src.data(),src.data()+256U,256U), "Bog adjacent buffers rejected");
        }
    std::mt19937_64 random(20261123U);
    std::array<std::uint8_t,8192> source{},a{},b{};
    for (auto &byte : source) byte = static_cast<std::uint8_t>(random());
    a = source;
    for (unsigned i = 0U; i < 24U; ++i) {
        const auto &plan = plans[6U*(i%4U)+i/4U];
        Require(plan.SealData(a.data(),nullptr,b.data(),a.size()), "Bog sequence rejected");
        a.swap(b);
    }
    Require(a!=source, "Bog sequence canceled to identity");
    for (unsigned i = 24U; i-- > 0U;) {
        const auto &plan = plans[6U*(i%4U)+i/4U];
        Require(plan.UnsealData(a.data(),nullptr,b.data(),a.size()), "Bog inverse sequence rejected");
        a.swap(b);
    }
    Require(a==source, "Bog sequence round trip failed");
}
inline void RunAll() {
    CheckPresetsAndArithmetic();
    CheckBlocks();
    CheckCallsAndSequences();
}
} // namespace TESTBogChecks
#endif
