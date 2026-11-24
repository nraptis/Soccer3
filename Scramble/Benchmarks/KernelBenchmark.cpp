#include "KernelBenchmark.hpp"
#include "KernelBenchmarkSet.hpp"

#include <cstdio>
#include <exception>

// Keep the menu/CLI entry point, using the same prepared set and executor as
// the launch benchmark. Its historical run count and upper-tail trim remain.
bool RunKernelBenchmarks(const char *pOutputDirectory) try {
    KernelBenchmarkSet kernels;
    return QBTests::Execute(kernels.GetKernels(),1000U,0.0,0.05,pOutputDirectory);
} catch (const std::exception &error) {
    std::fprintf(stderr,"Kernel benchmark setup failed: %s\n",error.what());
    return false;
}
