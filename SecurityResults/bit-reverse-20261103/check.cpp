#include "BitReverseCipherChecks.hpp"
#include <cstdio>
int main() {
    const auto failure=CheckBitReverseCipher();
    if(failure){std::fprintf(stderr,"FAIL: %s\n",failure);return 1;}
    std::puts("PASS: every byte value, forward/inverse reference, tails, unaligned 1 MiB, guards, overlap/null rejection");
}
