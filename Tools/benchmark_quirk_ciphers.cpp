#include "../ScrambleTests/Cipher_Classics/QuirkCipherChecks.hpp"

#include <chrono>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <string>

namespace {
#if defined(__aarch64__)
constexpr std::size_t kBytes = 1024U*1024U;
constexpr unsigned kSamples = 17U;
constexpr unsigned kRepeats = 64U;
const auto kCiphers = QuirkCipherChecks::Make(127U,2671U,7903U);
const auto kHigh = TESTQuirkHighChecks::Plans(127U,2671U,7903U,TESTQuirkHigh::Update::kAdd);
const auto kLow = TESTQuirkLowChecks::Plans(127U,2671U,7903U,TESTQuirkLow::Update::kAdd);

__attribute__((noinline)) bool Run(bool pProduction, unsigned pCase,
                                  const std::uint8_t *pSource, std::uint8_t *pDestination) {
    const auto v = pCase%16U;
    const bool aInverse = pCase >= 16U;
    if (pProduction) {
        const auto &aCipher = *kCiphers[v];
        return aInverse ? aCipher.UnsealData(pSource,nullptr,pDestination,kBytes,nullptr)
                        : aCipher.SealData(pSource,nullptr,pDestination,kBytes,nullptr);
    }
    if (v < 8U) return aInverse ? TESTQuirkHighNEON::UnsealData(kHigh[v],pSource,pDestination,kBytes)
                               : TESTQuirkHighNEON::SealData(kHigh[v],pSource,pDestination,kBytes);
    return aInverse ? TESTQuirkLowNEON::UnsealData(kLow[v-8U],pSource,pDestination,kBytes)
                    : TESTQuirkLowNEON::SealData(kLow[v-8U],pSource,pDestination,kBytes);
}

double Median(std::vector<double> pValues) {
    std::sort(pValues.begin(),pValues.end());
    return pValues[pValues.size()/2U];
}

void Benchmark(const std::filesystem::path &pDirectory) {
    using QuirkCipherChecks::Require;
    std::vector<std::uint8_t> aSource(kBytes), aOutput(kBytes);
    std::mt19937_64 aRandom(20261123U);
    for (auto &aByte : aSource) aByte = static_cast<std::uint8_t>(aRandom());
    for (unsigned aWarm = 0U; aWarm < 3U; ++aWarm)
        for (unsigned aCase = 0U; aCase < 32U; ++aCase)
            for (bool aProduction : {false,true}) Require(Run(aProduction,aCase,aSource.data(),aOutput.data()), "Benchmark warm-up rejected");
    std::ofstream aRaw(pDirectory/"production-samples.csv"), aSummary(pDirectory/"production-summary.csv");
    Require(aRaw.good() && aSummary.good(), "Cannot write production timing results");
    aRaw << "direction,half,variant,sample,reference_us_per_1MiB,production_us_per_1MiB,production_over_reference\n";
    aSummary << "direction,half,variant,median_reference_us,median_production_us,median_paired_production_over_reference\n";
    std::array<std::vector<double>,32> aReference, aProduction, aRatios;
    std::uint64_t aChecksum = 0U;
    const auto aMeasure = [&](bool pProduction, unsigned pCase) {
        const auto aStart = std::chrono::steady_clock::now();
        for (unsigned i = 0U; i < kRepeats; ++i) {
            (void)Run(pProduction,pCase,aSource.data(),aOutput.data());
            asm volatile("" ::: "memory");
        }
        const auto aTime = std::chrono::duration<double,std::micro>(std::chrono::steady_clock::now()-aStart).count()/kRepeats;
        for (std::size_t i = 0U; i < kBytes; i += 4096U) aChecksum += aOutput[i];
        return aTime;
    };
    for (unsigned aSample = 0U; aSample < kSamples; ++aSample)
        for (unsigned aStep = 0U; aStep < 32U; ++aStep) {
            const auto aCase = (aStep+13U*aSample)%32U;
            const bool aProductionFirst = ((aSample+aCase)&1U)!=0U;
            const auto aFirst = aMeasure(aProductionFirst,aCase);
            const auto aSecond = aMeasure(!aProductionFirst,aCase);
            const auto aProd = aProductionFirst ? aFirst : aSecond;
            const auto aRef = aProductionFirst ? aSecond : aFirst;
            aProduction[aCase].push_back(aProd);
            aReference[aCase].push_back(aRef);
            aRatios[aCase].push_back(aProd/aRef);
            aRaw << (aCase<16U ? "encrypt" : "decrypt") << ',' << (aCase%16U<8U ? "High" : "Low") << ','
                 << char('A'+aCase%8U) << ',' << aSample << ',' << aRef << ',' << aProd << ',' << aProd/aRef << '\n';
        }
    std::printf("Paired runtime-dispatched test NEON versus independent production Kernel kernels.\n%u samples x %u passes; cached 1 MiB; one caller thread.\n",kSamples,kRepeats);
    for (unsigned aDirection = 0U; aDirection < 2U; ++aDirection)
        for (unsigned aHalf = 0U; aHalf < 2U; ++aHalf) {
            std::vector<double> aAllTimes, aAllRatios;
            for (unsigned v = 0U; v < 8U; ++v) {
                const auto aCase = 16U*aDirection+8U*aHalf+v;
                aSummary << (aDirection==0U ? "encrypt" : "decrypt") << ',' << (aHalf==0U ? "High" : "Low") << ','
                         << char('A'+v) << ',' << Median(aReference[aCase]) << ',' << Median(aProduction[aCase]) << ',' << Median(aRatios[aCase]) << '\n';
                aAllTimes.insert(aAllTimes.end(),aProduction[aCase].begin(),aProduction[aCase].end());
                aAllRatios.insert(aAllRatios.end(),aRatios[aCase].begin(),aRatios[aCase].end());
            }
            std::printf("%s %-4s A-H: production %.3f us/MiB; paired production/reference %.4f\n",
                        aDirection==0U ? "Encrypt" : "Decrypt",aHalf==0U ? "High" : "Low",Median(aAllTimes),Median(aAllRatios));
        }
    std::printf("Checksum: %llu\n",static_cast<unsigned long long>(aChecksum));
}
#endif

void Check() {
    TESTQuirkHighChecks::RunAll();
    std::puts("PASS: existing High reference checks (both operators, all eight directions).");
    TESTQuirkLowChecks::RunAll();
    std::puts("PASS: Low reference checks; 16,777,216 arithmetic cases plus inverses; oracle, directions, nibble-swap symmetry, validation and in-place.");
    QuirkCipherChecks::RunAll();
    std::puts("PASS: sixteen production ciphers; 16,777,216 arithmetic cases plus inverses; full blocks, oracle, in-place, errors, Zero, and mixed High/Low CryptexLayer round trips.");
#if IGNORE_SIMD
    std::puts("Production path: scalar fallback.");
#elif defined(__aarch64__)
    std::puts("Production path: NEON.");
#elif defined(__SSE2__)
    std::puts("Production path: SSE2.");
#else
    std::puts("Production path: scalar fallback.");
#endif
}
} // namespace

int main(int argc, char **argv) {
    std::setvbuf(stdout,nullptr,_IOLBF,0);
    try {
        if (argc != 2) {
            std::fprintf(stderr,"Usage: %s EXISTING_OUTPUT_DIRECTORY | --check\n",argv[0]);
            return 1;
        }
        Check();
        if (std::string(argv[1]) == "--check") return 0;
#if defined(__aarch64__)
        Benchmark(argv[1]);
        return 0;
#else
        std::fputs("NEON timing requires AArch64; --check is portable.\n",stderr);
        return 1;
#endif
    } catch (const std::exception &aError) {
        std::fprintf(stderr,"FAIL: %s\n",aError.what());
        return 1;
    }
}
