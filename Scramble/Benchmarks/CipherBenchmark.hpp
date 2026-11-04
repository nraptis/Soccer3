#pragma once

// App diagnostic, independent of Soccer3's seed/material state and XCTest.
// Writes summary.csv, samples.csv and metadata.txt into a new directory.
// 1,000 timed SealData calls per available cipher, each on a fresh random 1 MiB.
// Priority families run first, then the rest grouped by type. Prints each
// result immediately after that cipher's 1,000 calls finish.
bool RunCipherBenchmarks(const char *pOutputDirectory);
