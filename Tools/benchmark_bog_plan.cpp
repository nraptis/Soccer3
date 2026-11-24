#include "BogQuirkPlan.hpp"
#include "../ScrambleTests/__CipherMock/TESTBogChecks.hpp"
#include "Cryptex.hpp"
#include "FourToadKernel.hpp"
#include "FourCrowKernel.hpp"
#include "FourRavenKernel.hpp"
#include "PasswordXORKernel.hpp"
#include "BitReverseKernel.hpp"
#include <chrono>
#include <bit>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <string>

#if defined(__aarch64__)
namespace {
using TESTBogChecks::Require;
using namespace BogQuirkPlan;
constexpr std::size_t kBytes = 1048576U;
constexpr unsigned kSamples = 17U, kRepeats = 16U;

struct Fixture {
    std::array<std::vector<std::uint8_t>,16> materials;
    std::array<const std::uint8_t *,16> pointers{};
    std::vector<std::uint8_t> packed = std::vector<std::uint8_t>(kBytes/4U);
    Cryptex weak,normal,strong;

    Fixture() {
        std::mt19937_64 random(20261123U);
        for (unsigned i = 0U; i < materials.size(); ++i) {
            materials[i].resize(kBytes);
            for (auto &b : materials[i]) b = static_cast<std::uint8_t>(random());
            pointers[i] = materials[i].data();
        }
        Build(weak,EncryptionStrength::kWeak);
        Build(normal,EncryptionStrength::kNormal);
        Build(strong,EncryptionStrength::kStrong);
    }
    void Build(Cryptex &p, EncryptionStrength strength) {
        // Reproduce the current published schedule using representative,
        // deterministic parameters. Seed expansion and Build are not timed.
        CryptexLayer *layers[] = {&p.mLayerAA,&p.mLayerAB,&p.mLayerAC,&p.mLayerAD,&p.mLayerBA,&p.mLayerBB,&p.mLayerBC,&p.mLayerBD};
        constexpr std::array<std::array<unsigned,8>,4> rows = {{
            {0U,1U,2U,3U,4U,5U,6U,7U}, {0U,2U,1U,3U,4U,6U,5U,7U},
            {0U,3U,1U,2U,4U,7U,5U,6U}, {0U,4U,1U,5U,2U,6U,3U,7U}}};
        std::mt19937_64 random(20261123U);
        for (unsigned i = 0U; i < 8U; ++i) {
            auto &layer = *layers[i];
            if (strength == EncryptionStrength::kStrong) layer.Add(new PasswordXORKernel(pointers[2U*i]));
            std::array<FourToadKernel::Stage,4> stages{};
            for (unsigned j = 0U; j < 4U; ++j) {
                stages[j].mRowA = rows[i%4U][2U*j]; stages[j].mRowB = rows[i%4U][2U*j+1U];
                for (auto &offset : stages[j].mWindowRotations) offset = random()%16384U;
            }
            layer.Add(new FourToadKernel(stages[0],stages[1],stages[2],stages[3],packed));
            const auto shifts = Shifts(i);
            if (strength == EncryptionStrength::kWeak && i%2U == 0U) layer.Add(new FourCrowKernel(shifts[0],shifts[1]));
            else {
                const auto material = strength == EncryptionStrength::kWeak ? pointers[i/2U] :
                    strength == EncryptionStrength::kStrong ? pointers[2U*i+1U] : pointers[i];
                layer.Add(new FourRavenKernel(shifts[0],shifts[1],material));
            }
            if (i == 3U) layer.Add(new BitReverseKernel);
        }
    }
};

void ReferenceStage(const Stage &p, bool inverse, const std::uint8_t *src, std::uint8_t *dst, std::size_t len) {
    bool result = false;
    if (p.kind == Kind::kBog) result = inverse ? p.bog.UnsealData(src,nullptr,dst,len) : p.bog.SealData(src,nullptr,dst,len);
    else if (p.kind == Kind::kHigh) {
        const TESTQuirkHigh q(p.windows[0],p.windows[1],p.windows[2],p.variant&4U,p.variant&2U,p.variant&1U,TESTQuirkHigh::Update::kAdd);
        result = inverse ? q.UnsealData(src,nullptr,dst,len) : q.SealData(src,nullptr,dst,len);
    } else if (p.kind == Kind::kLow) {
        const TESTQuirkLow q(p.windows[0],p.windows[1],p.windows[2],p.variant&4U,p.variant&2U,p.variant&1U,TESTQuirkLow::Update::kAdd);
        result = inverse ? q.UnsealData(src,nullptr,dst,len) : q.SealData(src,nullptr,dst,len);
    } else if (p.kind == Kind::kReverse) {
        const BitReverseKernel q;
        result = q.SealData(src,nullptr,dst,len,nullptr);
    } else if (p.material) {
        const FourRavenKernel q(p.shifts[0],p.shifts[1],p.material);
        result = inverse ? q.UnsealData(src,nullptr,dst,len,nullptr) : q.SealData(src,nullptr,dst,len,nullptr);
    } else {
        const FourCrowKernel q(p.shifts[0],p.shifts[1]);
        result = inverse ? q.UnsealData(src,nullptr,dst,len,nullptr) : q.SealData(src,nullptr,dst,len,nullptr);
    }
    Require(result,"Plan reference rejected input");
}

void Check(Fixture &fixture, const std::array<Plan,3> &plans, FourWorkers &workers, bool pPlanOnly = false) {
    if (!pPlanOnly) {
        TESTBogChecks::RunAll();
        std::puts("PASS: all 24 Bog presets; 393,216 arithmetic cases plus inverses; independent oracle, NEON, wrapping, unaligned, in-place, range and empty input.");
    }
    std::mt19937_64 random(20261123U);
    for (std::size_t len : std::array<std::size_t,3>{256U,1280U,kBytes}) {
        std::vector<std::uint8_t> source(len),expected(len),tmp(len),actual(len),scratch(len),recovered(len),second(len);
        for (auto &b : source) b = static_cast<std::uint8_t>(random());
        for (const auto &plan : plans) {
            if (len < kBytes) {
                expected = source;
                for (const auto &stage : plan.stages) {
                    ReferenceStage(stage,false,expected.data(),tmp.data(),len);
                    expected.swap(tmp);
                }
            } else Run({plan.stages,source.data(),scratch.data(),expected.data(),len,false},0U,nullptr);
            workers.Submit({plan.stages,source.data(),scratch.data(),actual.data(),len,false});
            Require(actual == expected,"Four-worker proposal differs from serial/reference sequence");
            workers.Submit({plan.stages,actual.data(),scratch.data(),recovered.data(),len,true});
            Require(recovered == source,"Four-worker proposal failed round trip");
            Run({plan.stages,actual.data(),scratch.data(),recovered.data(),len,true},0U,nullptr);
            Require(recovered == source,"Serial proposal failed round trip");
            if (len < kBytes) {
                expected = actual;
                for (auto i = plan.stages.size(); i-- > 0U;) {
                    ReferenceStage(plan.stages[i],true,expected.data(),tmp.data(),len);
                    expected.swap(tmp);
                }
                Require(expected == source,"Reference sequence failed inverse round trip");
            }
        }
        if (len == kBytes)
            for (auto *baseline : {&fixture.weak,&fixture.normal,&fixture.strong}) {
                Require(baseline->SealData(source.data(),scratch.data(),second.data(),actual.data(),len,nullptr),"Current schedule seal rejected");
                Require(baseline->UnsealData(actual.data(),scratch.data(),second.data(),recovered.data(),len,nullptr),"Current schedule inverse rejected");
                Require(recovered == source,"Current schedule round trip failed");
            }
    }
    std::puts("PASS: 4/6/8-layer pipelines match readable references and production move/reverse ciphers; serial/four-worker round trips at 256 B, uneven 1280 B, and 1 MiB; all current schedules round-trip.");
}

struct Case {
    std::string name;
    Cryptex *baseline = nullptr;
    const Plan *plan = nullptr;
    const Stage *component = nullptr;
    bool parallel = false;
};
__attribute__((noinline)) bool RunCase(const Case &p, bool inverse, FourWorkers &workers,
    const std::uint8_t *src, std::uint8_t *scratch, std::uint8_t *second, std::uint8_t *dst) {
    if (p.baseline) return inverse ? p.baseline->UnsealData(src,scratch,second,dst,kBytes,nullptr) :
        p.baseline->SealData(src,scratch,second,dst,kBytes,nullptr);
    if (p.plan) {
        const Job job{p.plan->stages,src,scratch,dst,kBytes,inverse};
        if (p.parallel) workers.Submit(job); else Run(job,0U,nullptr);
    } else (inverse ? p.component->unseal : p.component->seal)(*p.component,src,dst,kBytes,0U,kBytes);
    return true;
}
double Median(std::vector<double> values) {
    std::sort(values.begin(),values.end());
    return values[values.size()/2U];
}

std::string StageName(const Stage &p) {
    if (p.kind == Kind::kBog) return std::string("Bog")+char('A'+(6U-static_cast<unsigned>(p.bog.mHotPair))/2U)+char('A'+static_cast<unsigned>(p.bog.mPackOrder));
    if (p.kind == Kind::kHigh || p.kind == Kind::kLow) return std::string(p.kind == Kind::kHigh ? "QuirkHigh" : "QuirkLow")+char('A'+p.variant);
    if (p.kind == Kind::kReverse) return "BitReverse";
    return p.material ? "FourRavenKernel" : "FourCrowKernel";
}
void ExportPlans(const std::array<Plan,3> &plans, const std::filesystem::path &dir) {
    std::ofstream file(dir/"plans.csv");
    Require(file.good(),"Cannot write plan definitions");
    file << "layers,stage,cipher,window_a,window_b,window_c\n";
    for (const auto &plan : plans)
        for (std::size_t i = 0U; i < plan.stages.size(); ++i) {
            const auto &p = plan.stages[i];
            file << plan.layers << ',' << i << ',' << StageName(p) << ',' << p.windows[0] << ',' << p.windows[1] << ',' << p.windows[2] << '\n';
        }
}

void Benchmark(Fixture &fixture, const std::array<Plan,3> &plans, FourWorkers &workers, const std::filesystem::path &dir) {
    std::vector<Case> cases = {{"current Weak",&fixture.weak},{"current Normal",&fixture.normal},{"current Strong",&fixture.strong}};
    for (const auto &plan : plans) {
        cases.push_back({std::to_string(plan.layers)+" layers serial",nullptr,&plan,nullptr,false});
        cases.push_back({std::to_string(plan.layers)+" layers four workers",nullptr,&plan,nullptr,true});
    }
    std::vector<Stage> components;
    for (auto kind : {Kind::kBog,Kind::kHigh,Kind::kLow,Kind::kMove,Kind::kReverse})
        for (const auto &p : plans[2].stages) {
            if (p.kind != kind) continue;
            if (kind == Kind::kBog) {
                if (p.bog.mPackOrder != TESTBog::PackOrder::kABC) continue;
            } else if (kind == Kind::kMove) {
                // Keep both the Crow and Raven examples.
            } else if (std::any_of(components.begin(),components.end(),[&](const Stage &s){return s.kind==kind;})) continue;
            if (kind == Kind::kMove && std::any_of(components.begin(),components.end(),[&](const Stage &s){return s.kind==kind && bool(s.material)==bool(p.material);} )) continue;
            components.push_back(p);
        }
    for (const auto &p : components) cases.push_back({StageName(p),nullptr,nullptr,&p,false});
    std::vector<std::uint8_t> src(kBytes),scratch(kBytes),second(kBytes),dst(kBytes);
    std::mt19937_64 random(20261123U);
    for (auto &b : src) b = static_cast<std::uint8_t>(random());
    for (unsigned warm = 0U; warm < 2U; ++warm)
        for (const auto &p : cases)
            for (bool inverse : {false,true}) Require(RunCase(p,inverse,workers,src.data(),scratch.data(),second.data(),dst.data()),"Warm-up failed");
    std::ofstream raw(dir/"samples.csv"),summary(dir/"summary.csv");
    Require(raw.good() && summary.good(),"Cannot write plan timings");
    raw << "case,direction,sample,us_per_1MiB\n";
    summary << "case,direction,median_us_per_1MiB,min_us,max_us,layers,bogs,quirks,movements,materials,execution\n";
    const auto count = cases.size()*2U;
    std::vector<std::vector<double>> times(count);
    std::uint64_t checksum = 0U;
    for (unsigned sample = 0U; sample < kSamples; ++sample)
        for (std::size_t step = 0U; step < count; ++step) {
            const auto index = (step+11U*sample)%count;
            const bool inverse = index%2U != 0U;
            const auto &p = cases[index/2U];
            const auto start = std::chrono::steady_clock::now();
            for (unsigned repeat = 0U; repeat < kRepeats; ++repeat) {
                (void)RunCase(p,inverse,workers,src.data(),scratch.data(),second.data(),dst.data());
                asm volatile("" ::: "memory");
            }
            const double us = std::chrono::duration<double,std::micro>(std::chrono::steady_clock::now()-start).count()/kRepeats;
            times[index].push_back(us);
            raw << p.name << ',' << (inverse ? "decrypt" : "encrypt") << ',' << sample << ',' << us << '\n';
            for (std::size_t i = 0U; i < kBytes; i += 4096U) checksum += dst[i];
        }
    for (std::size_t i = 0U; i < count; ++i) {
        const auto &p = cases[i/2U];
        const auto median = Median(times[i]);
        summary << p.name << ',' << (i%2U ? "decrypt" : "encrypt") << ',' << median << ',' << *std::min_element(times[i].begin(),times[i].end()) << ',' << *std::max_element(times[i].begin(),times[i].end()) << ',';
        if (p.plan) summary << p.plan->layers << ',' << p.plan->bogCount << ',' << p.plan->quirkCount << ',' << p.plan->layers << ',' << p.plan->materialCount << ',' << (p.parallel ? "4 workers" : "serial");
        else summary << ",,,,,";
        summary << '\n';
        std::printf("%-24s %-7s %9.3f us/MiB\n",p.name.c_str(),i%2U ? "decrypt" : "encrypt",median);
    }
    std::printf("Checksum: %llu\n",static_cast<unsigned long long>(checksum));
    ExportPlans(plans,dir);
}

unsigned Parity(const std::vector<std::uint8_t> &bytes) {
    std::uint64_t combined = 0U;
    for (std::size_t i = 0U; i < bytes.size(); i += 8U) {
        std::uint64_t word;
        std::memcpy(&word,bytes.data()+i,8U);
        combined ^= word;
    }
    return std::popcount(combined)&1U;
}
void ParityScreen(const std::array<Plan,3> &plans, FourWorkers &workers, const std::filesystem::path &dir) {
    // A small screen of the same one-known-block parity predictor used by
    // WholeBlockParityRecoveryTests. One fixed geometry/material fixture;
    // passing this screen does not establish resistance to other attacks.
    constexpr unsigned kTrials = 512U;
    const double cutoff = 0.5+std::sqrt(std::log(6.0/1e-6)/(2.0*kTrials));
    std::ofstream file(dir/"parity-screen.csv");
    Require(file.good(),"Cannot write parity screen");
    file << "layers,trials,correct,accuracy,two_sided_best,cutoff,passes\n";
    std::vector<std::uint8_t> plain(kBytes),cipher(kBytes),scratch(kBytes);
    for (const auto &plan : plans) {
        std::fill(plain.begin(),plain.end(),0U);
        workers.Submit({plan.stages,plain.data(),scratch.data(),cipher.data(),kBytes,false});
        const auto offset = Parity(cipher);
        std::mt19937_64 random(0xF1A0E9A317ULL);
        unsigned correct = 0U;
        for (unsigned i = 0U; i < kTrials; ++i) {
            for (std::size_t pos = 0U; pos < kBytes; pos += 8U) {
                const auto word = random();
                std::memcpy(plain.data()+pos,&word,8U);
            }
            const auto wanted = i&1U;
            if (Parity(plain) != wanted) plain[0] ^= 1U;
            workers.Submit({plan.stages,plain.data(),scratch.data(),cipher.data(),kBytes,false});
            correct += (Parity(cipher)^offset) == wanted;
        }
        const double accuracy = double(correct)/kTrials;
        const double best = std::max(accuracy,1.0-accuracy);
        file << plan.layers << ',' << kTrials << ',' << correct << ',' << accuracy << ',' << best << ',' << cutoff << ',' << (best<cutoff) << '\n';
        std::printf("Parity screen: %u layers, %u balanced challenges, prediction %.2f%%, two-sided best %.2f%%, cutoff %.2f%%: %s\n",
                    plan.layers,kTrials,100.0*accuracy,100.0*best,100.0*cutoff,best<cutoff ? "PASS" : "FAIL");
    }
}
} // namespace
#endif

int main(int argc, char **argv) {
    std::setvbuf(stdout,nullptr,_IOLBF,0);
    try {
#if defined(__aarch64__)
        if (argc != 2) { std::fprintf(stderr,"Usage: %s OUTPUT_DIRECTORY | --check\n",argv[0]); return 1; }
        Fixture fixture;
        const std::array<Plan,3> plans = {Plan(4U,fixture.pointers),Plan(6U,fixture.pointers),Plan(8U,fixture.pointers)};
        FourWorkers workers;
        const std::string argument = argv[1];
        Check(fixture,plans,workers,argument == "--plan-check");
        if (argument != "--check" && argument != "--plan-check") {
            Benchmark(fixture,plans,workers,argv[1]);
            ParityScreen(plans,workers,argv[1]);
        }
#else
        (void)argc; (void)argv;
        TESTBogChecks::RunAll();
        std::puts("PASS: portable Bog reference checks; NEON plan timing requires AArch64.");
#endif
        return 0;
    } catch (const std::exception &error) {
        std::fprintf(stderr,"FAIL: %s\n",error.what()); return 1;
    }
}
