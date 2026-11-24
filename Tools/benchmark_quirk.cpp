#include "../ScrambleTests/__CipherMock/TESTQuirkHighChecks.hpp"

#include <chrono>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <string>

#if defined(__aarch64__)
namespace {
constexpr std::size_t kBytes = 1024U * 1024U;
constexpr unsigned kSamples = 11U;
constexpr unsigned kRepeats = 32U;
const auto kPlans = TESTQuirkHighChecks::Plans(127U, 2671U, 7903U);
const auto kXorPlans = TESTQuirkHighChecks::Plans(127U, 2671U, 7903U, TESTQuirkHigh::Update::kXor);
const auto kAddPlans = TESTQuirkHighChecks::Plans(127U, 2671U, 7903U, TESTQuirkHigh::Update::kAdd);

const char *DefaultUpdateName() {
    return TESTQuirkHigh::kDefaultUpdate == TESTQuirkHigh::Update::kAdd ? "ADD" : "XOR";
}

__attribute__((noinline)) bool Run(unsigned pCase, const std::uint8_t *pSource,
                                  std::uint8_t *pDestination) {
    const auto &aPlan = kPlans[pCase % 8U];
    if (pCase < 8U) return aPlan.SealData(pSource, nullptr, pDestination, kBytes);
    return TESTQuirkHighNEON::SealData(aPlan, pSource, pDestination, kBytes);
}

void Benchmark(const std::string &pLabel, const std::filesystem::path &pDirectory) {
    std::vector<std::uint8_t> aSource(kBytes), aOutput(kBytes);
    std::mt19937_64 aRandom(20261123U);
    for (auto &aByte : aSource) aByte = static_cast<std::uint8_t>(aRandom());
    for (unsigned aWarm = 0U; aWarm < 3U; ++aWarm)
        for (unsigned aCase = 0U; aCase < 16U; ++aCase)
            TESTQuirkHighChecks::Require(Run(aCase, aSource.data(), aOutput.data()), "Warm-up input rejected");

    std::ofstream aSamplesFile(pDirectory / (pLabel + "-samples.csv"));
    std::ofstream aSummaryFile(pDirectory / (pLabel + "-summary.csv"));
    TESTQuirkHighChecks::Require(aSamplesFile.good() && aSummaryFile.good(), "Cannot write benchmark results");
    aSamplesFile << "implementation,variant,reverse_a,reverse_b,reverse_c,sample,us_per_1MiB,update\n";
    aSummaryFile << "implementation,variant,reverse_a,reverse_b,reverse_c,median_us_per_1MiB,min_us,max_us,GiB_per_second,update\n";
    std::array<std::array<double, kSamples>, 16> aTimes{};
    std::uint64_t aChecksum = 0U;
    for (unsigned aSample = 0U; aSample < kSamples; ++aSample) {
        for (unsigned aStep = 0U; aStep < 16U; ++aStep) {
            const auto aCase = (aStep + 5U * aSample) % 16U;
            const auto &aPlan = kPlans[aCase % 8U];
            const auto aStart = std::chrono::steady_clock::now();
            for (unsigned aRepeat = 0U; aRepeat < kRepeats; ++aRepeat) {
                // Valid inputs were checked above; the noinline call and memory
                // barrier keep identical repeated outputs observable to the compiler.
                (void)Run(aCase, aSource.data(), aOutput.data());
                asm volatile("" ::: "memory");
            }
            const auto aStop = std::chrono::steady_clock::now();
            const double aUs = std::chrono::duration<double, std::micro>(aStop - aStart).count() / kRepeats;
            aTimes[aCase][aSample] = aUs;
            aSamplesFile << (aCase < 8U ? "reference" : "NEON") << ',' << char('A' + aCase % 8U) << ','
                         << aPlan.mReverseA << ',' << aPlan.mReverseB << ',' << aPlan.mReverseC << ','
                         << aSample << ',' << aUs << ',' << DefaultUpdateName() << '\n';
            for (std::size_t i = 0U; i < kBytes; i += 4096U) aChecksum += aOutput[i];
        }
    }
    std::printf("%s: 1 MiB; 256-byte windows; offsets 127,2671,7903; 16-byte chunk-order reversal only.\n", pLabel.c_str());
    std::printf("Default update: %s into the existing low nibble.\n", DefaultUpdateName());
    std::printf("Single caller thread; warm buffers; %u samples x %u passes, median (min..max).\n", kSamples, kRepeats);
    std::puts("implementation variant ABC  us/1MiB                   GiB/s");
    for (unsigned aCase = 0U; aCase < 16U; ++aCase) {
        auto aSorted = aTimes[aCase];
        std::sort(aSorted.begin(), aSorted.end());
        const double aMedian = aSorted[kSamples / 2U];
        const double aGiB = (kBytes / (1024.0 * 1024.0 * 1024.0)) / (aMedian * 1e-6);
        const auto &aPlan = kPlans[aCase % 8U];
        const char *aImplementation = aCase < 8U ? "reference" : "NEON";
        std::printf("%-14s %c      %c%c%c %9.3f (%8.3f..%8.3f) %7.2f\n", aImplementation,
                    'A' + aCase % 8U, aPlan.mReverseA ? 'R' : 'F', aPlan.mReverseB ? 'R' : 'F',
                    aPlan.mReverseC ? 'R' : 'F', aMedian, aSorted.front(), aSorted.back(), aGiB);
        aSummaryFile << aImplementation << ',' << char('A' + aCase % 8U) << ','
                     << aPlan.mReverseA << ',' << aPlan.mReverseB << ',' << aPlan.mReverseC << ','
                     << aMedian << ',' << aSorted.front() << ',' << aSorted.back() << ',' << aGiB << ',' << DefaultUpdateName() << '\n';
    }
    std::printf("Checksum: %llu\n", static_cast<unsigned long long>(aChecksum));
}

__attribute__((noinline)) bool RunOperator(bool pAdd, bool pInverse, unsigned pVariant,
                                          const std::uint8_t *pSource, std::uint8_t *pDestination) {
    const auto &aPlan = (pAdd ? kAddPlans : kXorPlans)[pVariant];
    return pInverse ? TESTQuirkHighNEON::UnsealData(aPlan, pSource, pDestination, kBytes)
                    : TESTQuirkHighNEON::SealData(aPlan, pSource, pDestination, kBytes);
}

double Median(std::vector<double> pValues) {
    std::sort(pValues.begin(), pValues.end());
    return pValues[pValues.size() / 2U];
}

void CompareOperators(const std::string &pLabel, const std::filesystem::path &pDirectory) {
    constexpr unsigned kPairedSamples = 17U;
    constexpr unsigned kPairedRepeats = 64U;
    std::vector<std::uint8_t> aSource(kBytes), aOutput(kBytes);
    std::mt19937_64 aRandom(20261123U);
    for (auto &aByte : aSource) aByte = static_cast<std::uint8_t>(aRandom());
    for (unsigned aWarm = 0U; aWarm < 3U; ++aWarm)
        for (unsigned aCase = 0U; aCase < 16U; ++aCase)
            for (bool aAdd : {false, true})
                TESTQuirkHighChecks::Require(RunOperator(aAdd, aCase >= 8U, aCase % 8U,
                    aSource.data(), aOutput.data()), "Operator warm-up rejected input");

    std::ofstream aRaw(pDirectory / (pLabel + "-operators-samples.csv"));
    std::ofstream aSummary(pDirectory / (pLabel + "-operators-summary.csv"));
    TESTQuirkHighChecks::Require(aRaw.good() && aSummary.good(), "Cannot write operator comparison");
    aRaw << "direction,variant,sample,xor_us_per_1MiB,add_us_per_1MiB,add_over_xor\n";
    aSummary << "direction,variant,median_xor_us,median_add_us,median_paired_add_over_xor\n";
    std::array<std::vector<double>, 16> aXorTimes, aAddTimes, aRatios;
    const auto aMeasure = [&](bool pAdd, unsigned pCase) {
        const auto aStart = std::chrono::steady_clock::now();
        for (unsigned aRepeat = 0U; aRepeat < kPairedRepeats; ++aRepeat) {
            (void)RunOperator(pAdd, pCase >= 8U, pCase % 8U, aSource.data(), aOutput.data());
            asm volatile("" ::: "memory");
        }
        return std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - aStart).count() / kPairedRepeats;
    };
    for (unsigned aSample = 0U; aSample < kPairedSamples; ++aSample) {
        for (unsigned aStep = 0U; aStep < 16U; ++aStep) {
            const auto aCase = (aStep + 7U * aSample) % 16U;
            const bool aAddFirst = ((aSample + aCase) & 1U) != 0U;
            const auto aFirst = aMeasure(aAddFirst, aCase);
            const auto aSecond = aMeasure(!aAddFirst, aCase);
            const auto aAdd = aAddFirst ? aFirst : aSecond;
            const auto aXor = aAddFirst ? aSecond : aFirst;
            aXorTimes[aCase].push_back(aXor);
            aAddTimes[aCase].push_back(aAdd);
            aRatios[aCase].push_back(aAdd / aXor);
            aRaw << (aCase < 8U ? "encrypt" : "decrypt") << ',' << char('A' + aCase % 8U)
                 << ',' << aSample << ',' << aXor << ',' << aAdd << ',' << aAdd / aXor << '\n';
        }
    }
    std::puts("Paired NEON ADD/XOR: all eight directions, encryption and decryption; alternate timing order.");
    std::printf("%u samples x %u passes per operator; values >1 mean ADD takes longer.\n", kPairedSamples, kPairedRepeats);
    std::vector<double> aAllRatios;
    for (unsigned aDirection = 0U; aDirection < 2U; ++aDirection) {
        std::vector<double> aDirectionRatios;
        for (unsigned i = 0U; i < 8U; ++i) {
            const auto aCase = aDirection * 8U + i;
            aSummary << (aDirection == 0U ? "encrypt" : "decrypt") << ',' << char('A' + i) << ','
                     << Median(aXorTimes[aCase]) << ',' << Median(aAddTimes[aCase]) << ',' << Median(aRatios[aCase]) << '\n';
            aDirectionRatios.insert(aDirectionRatios.end(), aRatios[aCase].begin(), aRatios[aCase].end());
        }
        std::printf("%s median paired ADD/XOR ratio: %.4f\n", aDirection == 0U ? "Encrypt" : "Decrypt", Median(aDirectionRatios));
        aAllRatios.insert(aAllRatios.end(), aDirectionRatios.begin(), aDirectionRatios.end());
    }
    std::printf("Overall median paired ADD/XOR ratio: %.4f\n", Median(aAllRatios));
}
} // namespace
#endif

int main(int argc, char **argv) {
    std::setvbuf(stdout, nullptr, _IOLBF, 0);
    try {
        TESTQuirkHighChecks::RunAll();
        std::puts("PASS: both updates, eight presets; 16,777,216 nibble cases plus inverses; chunk/lane directions; wrap/unaligned/in-place; invalid inputs; reversible sequences.");
#if defined(__aarch64__)
        std::puts("PASS: explicit NEON matches the scalar implementation and independent byte-index oracle.");
#endif
        if (argc == 2 && std::string(argv[1]) == "--check") return 0;
#if defined(__aarch64__)
        if (argc != 3) {
            std::fprintf(stderr, "Usage: %s LABEL EXISTING_OUTPUT_DIRECTORY | --check\n", argv[0]);
            return 1;
        }
        Benchmark(argv[1], argv[2]);
        CompareOperators(argv[1], argv[2]);
        return 0;
#else
        std::fputs("Timing requires AArch64 NEON. Use --check for portable scalar validation.\n", stderr);
        return 1;
#endif
    } catch (const std::exception &aError) {
        std::fprintf(stderr, "FAIL: %s\n", aError.what());
        return 1;
    }
}
