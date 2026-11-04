#include "CipherBenchmark.hpp"
#include "PasswordXORCipher.hpp"
#include "ShiftMaskedCipher.hpp"
#include "BitReverseCipher.hpp"
#include "FlameToadCipher.hpp"

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <memory>
#include <numeric>
#include <random>
#include <span>
#include <stdexcept>
#include <vector>

#if defined(__APPLE__)
#include <mach-o/getsect.h>
#include <mach-o/ldsyms.h>
#endif

namespace {
using Bytes = std::vector<std::uint8_t>;
using Clock = std::chrono::steady_clock;
constexpr std::size_t kBytes = 1U << 20U;
constexpr std::size_t kTrials = 1000U;
constexpr std::size_t kWarmups = 8U;
constexpr std::size_t kRetained = 950U; // Discard only the slowest 5%.
constexpr std::uint64_t kSeed = 0xB31C7249A506DE8FULL;

void Randomize(Bytes &pBytes, std::mt19937_64 &pRandom) {
    for (std::size_t i = 0; i < pBytes.size(); i += sizeof(std::uint64_t)) {
        const auto word = pRandom();
        std::memcpy(pBytes.data() + i, &word, sizeof(word));
    }
}

struct Entry {
    const char *mName;
    const char *mGroup;
    std::unique_ptr<Cipher> mCipher;
    std::array<double, kTrials> mMicroseconds{};
};

std::vector<Entry> MakeCiphers(const Bytes &pMaterial, std::span<std::uint8_t> pPackedRows) {
    constexpr std::uint8_t mask = 0xA5U;
    constexpr std::int32_t rotation = 131071;
    std::vector<Entry> entries;
#define ADD_CIPHER(Type, ...) entries.push_back({#Type, group, std::make_unique<Type>(__VA_ARGS__), {}})
    // Execution order and report order are both defined here.
    const char *group = "Priority ciphers";
    ADD_CIPHER(FlameToadCipher, 0U, 3U, 2053U, 6151U, 10007U, 14009U, pPackedRows);
    ADD_CIPHER(FlameToadCipher, 0U, 3U, 2053U, 6151U, 10007U, 14009U);
    entries.back().mName = "FlameToadCipher (direct)";
    ADD_CIPHER(PasswordXORCipher, pMaterial.data());
    ADD_CIPHER(ShiftMaskedCipher, mask, rotation);
    ADD_CIPHER(BitReverseCipher);
#undef ADD_CIPHER
    return entries;
}

void Require(bool pSuccess, CipherErrorCode pError, const char *pName) {
    if (!pSuccess || pError != CipherErrorCode::kNone) {
        throw std::runtime_error(std::string(pName) + " failed: error " +
                                 std::to_string(static_cast<unsigned>(pError)));
    }
}
} // namespace

bool RunCipherBenchmarks(const char *pOutputDirectory) try {
    const std::filesystem::path directory(pOutputDirectory);
    if (std::filesystem::exists(directory)) {
        throw std::runtime_error("output directory already exists; use a new directory");
    }
    std::filesystem::create_directories(directory);
    std::ofstream metadata(directory / "metadata.txt");
    std::ofstream summary(directory / "summary.csv");
    std::ofstream samples(directory / "samples.csv");
    if (!metadata || !summary || !samples) throw std::runtime_error("cannot open reports");

    metadata << "compiler=" << __VERSION__ << "\ncompiled=" << __DATE__ << ' ' << __TIME__
             << "\nblock_bytes=" << kBytes << "\ntrials_per_cipher=" << kTrials
             << "\nwarmups_per_cipher=" << kWarmups << "\nseed=" << kSeed
             << "\nmode=SealData; distinct source/worker/destination buffers"
             << "\nmask=0xA5\nbyte_rotation=131071"
             << "\ntwo_rows=0,3"
             << "\nflame_window_offsets=2053,6151,10007,14009"
             << "\nflame_backend=packed-once; direct packing comparison also included"
             << "\ntrim=slowest 50 of 1000; nearest-rank quantiles"
             << "\ninput_randomization=outside timer; fresh input each call; same sequence per cipher"
             << "\nsetup=outside timer; fixed synthetic materials; no KDF"
             << "\norder=priority ciphers first, then grouped by type; 1000 consecutive calls per cipher"
             << "\ncache=warm input; no cache flushing; standalone cipher measurement"
             << "\nraw samples retained, including every excluded outlier\n";
#if JELLY_USE_NEON
    metadata << "backend=NEON\n";
#elif defined(__AVX2__) && !IGNORE_SIMD
    metadata << "backend=AVX2\n";
#elif defined(__SSE2__) && !IGNORE_SIMD
    metadata << "backend=x86 SIMD where supported; scalar fallback otherwise\n";
#else
    metadata << "backend=scalar\n";
#endif
#if defined(__OPTIMIZE__)
    metadata << "optimized=yes\n";
#else
    metadata << "optimized=no\n";
    std::printf("WARNING: unoptimized build; use Release for useful timings.\n");
#endif
#if defined(__APPLE__)
    // A linked profiling runtime alone does not mean any code is instrumented.
    unsigned long counterBytes = 0;
    (void)getsectiondata(&_mh_execute_header, "__DATA", "__llvm_prf_cnts", &counterBytes);
    const bool coverage = counterBytes != 0;
    metadata << "coverage_instrumentation=" << (coverage ? "yes" : "no") << '\n';
    if (coverage) {
        std::printf("WARNING: code coverage is enabled and can distort timings. Use Tools/run_cipher_benchmarks.sh.\n");
    }
#endif
    Bytes material(kBytes);
    std::mt19937_64 materialRandom(kSeed);
    Randomize(material, materialRandom);
    Bytes packedRows(kBytes/4U);
    auto entries = MakeCiphers(material,packedRows);
    Bytes source(kBytes), worker(kBytes), destination(kBytes), restored(kBytes);
    CipherErrorCode error = CipherErrorCode::kNone;
    std::printf("\nCipher benchmark: %zu ciphers, 1000 x 1 MiB each (1000 MiB = 0.9765625 GiB).\n"
                "Only SealData is timed. Excluding slowest 5%% from trimmed statistics.\n"
                "Priority ciphers run first; each result prints as soon as it finishes.\n"
                "Reports: %s\n", entries.size(), pOutputDirectory);
    std::fflush(stdout);
    summary << "cipher,group,bytes_per_call,calls,excluded_slowest,fastest_us,p50_us,p95_us,p99_us,max_us,trimmed_mean_us,trimmed_MiB_s,raw_MiB_s,raw_total_seconds\n";
    samples << "cipher,trial,microseconds,retained\n";
    summary << std::fixed << std::setprecision(6);
    samples << std::fixed << std::setprecision(6);
    std::uint64_t checksum = 0;
    const auto wallStart = Clock::now();
    const char *previousGroup = nullptr;
    for (auto &entry : entries) {
        if (!previousGroup || std::strcmp(previousGroup, entry.mGroup) != 0) {
            std::printf("\n%s\n%-32s %10s %10s %10s %13s %11s\n", entry.mGroup,
                        "Cipher", "median us", "fastest us", "p95 us", "trim MiB/s", "raw MiB/s");
            previousGroup = entry.mGroup;
            std::fflush(stdout);
        }
        // Reset the generator so every cipher gets the same fresh inputs.
        std::mt19937_64 inputRandom(kSeed ^ 1U);
        Randomize(source, materialRandom);
        // Untimed correctness guard and per-cipher page/cache warmup.
        const bool sealed = entry.mCipher->SealData(source.data(), worker.data(), destination.data(), kBytes, &error);
        Require(sealed, error, entry.mName);
        const bool unsealed = entry.mCipher->UnsealData(destination.data(), worker.data(), restored.data(), kBytes, &error);
        Require(unsealed, error, entry.mName);
        if (source != restored) throw std::runtime_error(std::string(entry.mName) + " round trip failed");
        for (std::size_t i = 0; i < kWarmups; ++i) {
            const bool ok = entry.mCipher->SealData(source.data(), worker.data(), destination.data(), kBytes, &error);
            Require(ok, error, entry.mName);
        }
        for (std::size_t trial = 0; trial < kTrials; ++trial) {
            Randomize(source, inputRandom); // Deliberately BEFORE timer.
            error = CipherErrorCode::kNone;
            std::atomic_signal_fence(std::memory_order_seq_cst);
            const auto start = Clock::now();
            const bool ok = entry.mCipher->SealData(source.data(), worker.data(), destination.data(), kBytes, &error);
            std::atomic_signal_fence(std::memory_order_seq_cst);
            const auto stop = Clock::now();
            Require(ok, error, entry.mName);
            entry.mMicroseconds[trial] = std::chrono::duration<double, std::micro>(stop - start).count();
            // Observable output, outside timing; fences prevent moving stores past stop.
            checksum = (checksum * 131U) ^ destination[(trial * 104729U) % kBytes];
        }
        std::array<std::size_t, kTrials> ranks;
        std::iota(ranks.begin(), ranks.end(), 0U);
        std::stable_sort(ranks.begin(), ranks.end(), [&](auto a, auto b) { return entry.mMicroseconds[a] < entry.mMicroseconds[b]; });
        std::array<bool, kTrials> retained{};
        double trimmedSum = 0;
        for (std::size_t i = 0; i < kRetained; ++i) { retained[ranks[i]] = true; trimmedSum += entry.mMicroseconds[ranks[i]]; }
        const double rawSum = std::accumulate(entry.mMicroseconds.begin(), entry.mMicroseconds.end(), 0.0);
        const auto quantile = [&](std::size_t rank) { return entry.mMicroseconds[ranks[rank - 1U]]; };
        const auto mean = trimmedSum / kRetained;
        const auto trimmedRate = 1.0e6 / mean; // Exactly one MiB per call.
        const auto rawRate = 1.0e6 * kTrials / rawSum;
        std::printf("%-32s %10.2f %10.2f %10.2f %13.1f %11.1f\n", entry.mName, quantile(500), quantile(1), quantile(950), trimmedRate, rawRate);
        summary << entry.mName << ',' << entry.mGroup << ',' << kBytes << ',' << kTrials << ',' << kTrials - kRetained
                << ',' << quantile(1) << ',' << quantile(500) << ',' << quantile(950) << ',' << quantile(990)
                << ',' << quantile(1000) << ',' << mean << ',' << trimmedRate << ',' << rawRate << ',' << rawSum / 1.0e6 << '\n';
        for (std::size_t i = 0; i < kTrials; ++i) samples << entry.mName << ',' << i + 1 << ',' << entry.mMicroseconds[i] << ',' << retained[i] << '\n';
        std::fflush(stdout);
        summary.flush(); samples.flush();
        if (!summary || !samples) throw std::runtime_error("report write failed");
    }
    metadata << "checksum=" << checksum << "\nwall_seconds="
             << std::chrono::duration<double>(Clock::now() - wallStart).count() << "\nstatus=complete\n";
    metadata.flush(); summary.flush(); samples.flush();
    if (!metadata || !summary || !samples) throw std::runtime_error("report write failed");
    std::printf("Finished. All %zu ciphers passed the untimed round-trip guard.\n", entries.size());
    std::fflush(stdout);
    return true;
} catch (const std::exception &error) {
    std::fprintf(stderr, "Cipher benchmark failed: %s\n", error.what());
    return false;
}
