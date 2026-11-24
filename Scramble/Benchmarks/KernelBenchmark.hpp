#pragma once

// App diagnostic, independent of Soccer3's seed/material state and XCTest.
// Writes summary.csv, samples.csv and metadata.txt into a new directory.
// Prepares the five active kernels, then uses the same QBTests executor as the
// launch benchmark. 1,000 calls per direction on Kernel::kBlockBytes buffers;
// discard the slowest 5%. Prints each result as soon as it finishes.
bool RunKernelBenchmarks(const char *pOutputDirectory);
