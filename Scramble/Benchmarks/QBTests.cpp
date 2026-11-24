#include "QBTests.hpp"

#include <algorithm>
#include <atomic>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <exception>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <numeric>
#include <random>
#include <stdexcept>
#include <vector>

#if defined(__APPLE__)
#include <mach-o/getsect.h>
#include <mach-o/ldsyms.h>
#endif

namespace {
using Clock = std::chrono::steady_clock;
using Bytes = std::vector<std::uint8_t>;
constexpr std::size_t kBytes = Kernel::kBlockBytes;
constexpr std::size_t kWarmups = 4U;
constexpr std::uint64_t kSeed = 0xB06A017C1F3E2045ULL;
volatile std::uint64_t gOutputSink = 0U;

void Randomize(Bytes &bytes, std::mt19937_64 &random) {
    std::size_t i = 0U;
    for (; bytes.size()-i >= sizeof(std::uint64_t); i += sizeof(std::uint64_t)) {
        const auto word = random();
        std::memcpy(bytes.data()+i,&word,sizeof(word));
    }
    for (; i < bytes.size(); ++i) bytes[i] = static_cast<std::uint8_t>(random());
}

std::size_t TrimCount(std::size_t runs, double fraction) {
    if (!(fraction > 0.0)) return 0U;
    if (fraction >= 1.0) return runs-1U;
    return std::min(runs-1U,static_cast<std::size_t>(std::floor(fraction*static_cast<double>(runs))));
}

double TrimmedMean(const std::vector<double> &times, std::size_t low, std::size_t high) {
    auto sorted = times;
    std::sort(sorted.begin(),sorted.end());
    const auto first = sorted.begin()+low;
    const auto last = sorted.end()-high;
    return std::accumulate(first,last,0.0)/static_cast<double>(times.size()-low-high);
}

void FormatTime(double nanoseconds, char (&buffer)[32]) {
    double value = nanoseconds;
    const char *unit = "ns";
    if (nanoseconds >= 1.0e9) { value /= 1.0e9; unit = "s"; }
    else if (nanoseconds >= 1.0e6) { value /= 1.0e6; unit = "ms"; }
    else if (nanoseconds >= 1.0e3) { value /= 1.0e3; unit = "us"; }
    std::snprintf(buffer,sizeof(buffer),"%.3f %s",value,unit);
}

const char *PrintInstrumentation() {
#if defined(__APPLE__)
    // Inspect the linked executable, since kernel objects can be instrumented
    // even when this benchmark's own translation unit was compiled cleanly.
    for (const char *segment : {"__DATA", "__DATA_CONST", "__DATA_DIRTY"}) {
        unsigned long bytes = 0U;
        (void)getsectiondata(&_mh_execute_header,segment,"__llvm_prf_cnts",&bytes);
        if (bytes != 0U) {
            std::printf("Coverage instrumentation: PRESENT in the linked executable.\n"
                        "Rebuild with code coverage disabled to measure kernel speed.\n");
            return "present";
        }
    }
    std::printf("Coverage instrumentation: absent\n");
    return "absent";
#else
    std::printf("Coverage instrumentation: not inspected on this platform\n");
    return "not inspected";
#endif
}

void WriteSamples(std::ofstream &samples, const QBTests::Entry &entry,
                  const char *direction, const std::vector<double> &times) {
    for (std::size_t i = 0U; i < times.size(); ++i)
        samples << entry.mName << ',' << entry.mGroup << ',' << direction << ','
                << i+1U << ',' << times[i]/1000.0 << '\n';
}

template<bool Inverse>
bool Measure(const Kernel &kernel, const std::uint8_t *src, std::uint8_t *worker,
             std::uint8_t *dst, double &nanoseconds) {
    std::atomic_signal_fence(std::memory_order_seq_cst);
    const auto start = Clock::now();
    std::atomic_signal_fence(std::memory_order_seq_cst);
    const bool ok = Inverse ? kernel.UnsealData(src,worker,dst,kBytes,nullptr)
                            : kernel.SealData(src,worker,dst,kBytes,nullptr);
    std::atomic_signal_fence(std::memory_order_seq_cst);
    const auto stop = Clock::now();
    nanoseconds = std::chrono::duration<double,std::nano>(stop-start).count();
    return ok;
}
} // namespace

bool QBTests::Execute(std::span<const Entry> pKernels, std::size_t pRuns,
                      double pDiscardLowest, double pDiscardHighest,
                      const char *pOutputDirectory) try {
    const auto runs = std::max(std::size_t{1U},pRuns);
    const auto low = TrimCount(runs,pDiscardLowest);
    const auto high = std::min(TrimCount(runs,pDiscardHighest),runs-low-1U);
    const auto kept = runs-low-high;
    const auto entries = pKernels;
    Bytes source(kBytes),worker(kBytes),encrypted(kBytes),decrypted(kBytes);
    std::vector<double> sealTimes(runs),unsealTimes(runs);
    const bool saveReports = pOutputDirectory != nullptr;
    std::ofstream summary,samples,metadata;
    if (saveReports) {
        const std::filesystem::path directory(pOutputDirectory);
        if (std::filesystem::exists(directory))
            throw std::runtime_error("output directory already exists; use a new directory");
        std::filesystem::create_directories(directory);
        summary.open(directory/"summary.csv");
        samples.open(directory/"samples.csv");
        metadata.open(directory/"metadata.txt");
        if (!summary || !samples || !metadata) throw std::runtime_error("cannot open timing reports");
        summary << std::fixed << std::setprecision(6);
        samples << std::fixed << std::setprecision(6);
        summary << "kernel,group,direction,bytes_per_call,calls,discarded_fastest,discarded_slowest,kept,trimmed_mean_us,min_us,max_us\n";
        samples << "kernel,group,direction,trial,microseconds\n";
    }

    std::printf("\nMainline kernel speed benchmark\n");
    std::printf("Prepared entries: %zu (construction and material preparation excluded)\n",entries.size());
    std::printf("Block: %zu bytes (%.2f MiB) | %zu measured runs per direction\n",
                kBytes,static_cast<double>(kBytes)/(1024.0*1024.0),runs);
    std::printf("Discard: %zu fastest + %zu slowest | Keep: %zu | Untimed warm-ups: %zu\n",
                low,high,kept,kWarmups);
#if !IGNORE_SIMD && (defined(__ARM_NEON) || defined(__ARM_NEON__))
    const char *backend = "NEON";
#elif !IGNORE_SIMD && (defined(__SSE2__) || defined(_M_X64))
    const char *backend = "SIMD / portable, as implemented by each kernel";
#else
    const char *backend = "scalar";
#endif
#if defined(__OPTIMIZE_SIZE__)
    const char *build = "optimized for size";
#elif defined(__OPTIMIZE__)
    const char *build = "optimized";
#else
    const char *build = "unoptimized";
#endif
    std::printf("Backend: %s | Build: %s | One caller; kernels retain their normal worker usage\n",backend,build);
    std::printf("Kernel worker teams start during untimed warm-up.\n");
    const auto *instrumentation = PrintInstrumentation();
    if (saveReports) {
        std::printf("Reports: %s\n",pOutputDirectory);
        metadata << "compiler=" << __VERSION__ << "\nbytes_per_call=" << kBytes
                 << "\nkernels=" << entries.size() << "\nruns_per_direction=" << runs
                 << "\ndiscarded_fastest=" << low << "\ndiscarded_slowest=" << high
                 << "\nretained=" << kept << "\nwarmups_per_direction=" << kWarmups
                 << "\ninput_seed=" << kSeed << "\nbackend=" << backend << "\nbuild=" << build
                 << "\ncoverage_counters=" << instrumentation
                 << "\ntiming=SealData and UnsealData calls only; direction-specific timer gates"
                 << "\nsetup=caller-prepared kernels and material; executor setup, input generation, warm-up and reporting untimed"
                 << "\nexecution=one caller; each kernel retains its own worker model"
                 << "\nsamples=all raw samples in collection order; means trim sorted tails\n";
    }
    std::fflush(stdout);

    // Warm the whole set before collecting samples, including code pages
    // and both output buffers, so startup work does not fall on the first row.
    std::mt19937_64 warmRandom(kSeed);
    Randomize(source,warmRandom);
    for (auto &entry : entries) {
        for (std::size_t warm = 0U; warm < kWarmups; ++warm) {
            if (!entry.mKernel->SealData(source.data(),worker.data(),encrypted.data(),kBytes,nullptr) ||
                !entry.mKernel->UnsealData(encrypted.data(),worker.data(),decrypted.data(),kBytes,nullptr)) {
                std::printf("%-32s execution failed during warm-up\n",entry.mName);
                std::fflush(stdout);
                return false;
            }
        }
    }

    const char *previousGroup = nullptr;
    std::uint64_t checksum = 0U;
    for (auto &entry : entries) {
        if (!previousGroup || std::strcmp(previousGroup,entry.mGroup) != 0) {
            std::printf("\n%s\n%-32s %16s %16s\n",entry.mGroup,"Kernel","Encrypt mean","Decrypt mean");
            previousGroup = entry.mGroup;
            std::fflush(stdout);
        }
        // Reset per kernel so all variants receive the same input sequence.
        std::mt19937_64 random(kSeed);
        for (std::size_t run = 0U; run < runs; ++run) {
            Randomize(source,random);
            const bool sealed = Measure<false>(*entry.mKernel,source.data(),worker.data(),encrypted.data(),sealTimes[run]);
            if (!sealed) {
                std::printf("%-32s encryption failed on run %zu\n",entry.mName,run+1U);
                std::fflush(stdout);
                return false;
            }
            const bool unsealed = Measure<true>(*entry.mKernel,encrypted.data(),worker.data(),decrypted.data(),unsealTimes[run]);
            if (!unsealed) {
                std::printf("%-32s decryption failed on run %zu\n",entry.mName,run+1U);
                std::fflush(stdout);
                return false;
            }
            // Consume outputs after both timers; no comparisons or assertions.
            const auto index = (run*104729U)%kBytes;
            checksum = checksum*131U + encrypted[index] + decrypted[index];
        }
        char sealText[32],unsealText[32];
        const double sealMean = TrimmedMean(sealTimes,low,high);
        const double unsealMean = TrimmedMean(unsealTimes,low,high);
        FormatTime(sealMean,sealText);
        FormatTime(unsealMean,unsealText);
        std::printf("%-32s %16s %16s\n",entry.mName,sealText,unsealText);
        std::fflush(stdout);
        if (saveReports) {
            const auto writeDirection = [&](const char *direction, const std::vector<double> &times, double mean) {
                const auto extrema = std::minmax_element(times.begin(),times.end());
                summary << entry.mName << ',' << entry.mGroup << ',' << direction << ','
                        << kBytes << ',' << runs << ',' << low << ',' << high << ',' << kept << ','
                        << mean/1000.0 << ',' << *extrema.first/1000.0 << ',' << *extrema.second/1000.0 << '\n';
                WriteSamples(samples,entry,direction,times);
            };
            writeDirection("encrypt",sealTimes,sealMean);
            writeDirection("decrypt",unsealTimes,unsealMean);
            summary.flush(); samples.flush();
            if (!summary || !samples) throw std::runtime_error("timing report write failed");
        }
    }
    gOutputSink = checksum;
    if (saveReports) {
        metadata << "status=complete\n";
        metadata.flush();
        if (!metadata) throw std::runtime_error("metadata write failed");
    }
    std::printf("\nFinished: %zu kernels. Means include kernel execution only.\n",entries.size());
    std::fflush(stdout);
    return true;
} catch (const std::exception &error) {
    std::fprintf(stderr,"Kernel speed benchmark failed: %s\n",error.what());
    return false;
}
