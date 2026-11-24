#ifndef SOCCER_QB_TESTS_HPP_
#define SOCCER_QB_TESTS_HPP_

#include <cstddef>
#include <span>
#include "../Encrypter/Kernel.hpp"

// One human-readable speed executor for any prepared Kernel implementations.
// Each timed call processes exactly Kernel::kBlockBytes bytes. Kernel creation
// and material preparation happen before Execute; allocation, input generation,
// warm-up, trimming, reporting and printing are outside its timing gates.
class QBTests {
public:
    struct Entry {
        const char *mGroup;
        const char *mName;
        const Kernel *mKernel;
    };

    // Fractions are per tail: (100, 0.1, 0.1) drops 10 fastest + 10 slowest
    // samples and prints the mean of the remaining 80, separately for each
    // direction. Counts round down. Zero runs becomes one run; if trims
    // overlap, reduce the high trim so at least one sample always remains.
    // This executor borrows the instances: their owner, names and any
    // material/cache buffers must outlive this call. An optional new output
    // directory receives the timing CSVs.
    static bool Execute(std::span<const Entry> pKernels,
                        std::size_t pRuns = 100U,
                        double pDiscardLowest = 0.1,
                        double pDiscardHighest = 0.1,
                        const char *pOutputDirectory = nullptr);
};

#endif // SOCCER_QB_TESTS_HPP_
