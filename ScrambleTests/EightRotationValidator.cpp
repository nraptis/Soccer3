//
//  EightRotationValidator.cpp
//  ScrambleTests
//
//  Created by Icarus Black on 11/4/26.
//

#include "EightRotationValidator.hpp"
#include <cstring>

// For a VALID n-rotation list, the next rotation is banned if it equals
// the difference of two subset sums. There are 3^n signed expressions,
// but only 16,384 possible residues; different expressions can overlap.
// Counts below INCLUDE zero and exclude production's extra/global bans.
//
//   n     Expressions     Minimum banned     Maximum banned
//   1               3                  2                  3
//   2               9                  4                  9
//   3              27                  8                 27
//   4              81                 16                 81
//   5             243                 32                243
//   6             729                 64                729
//   7           2,187                128              2,187
//   8           6,561                256              6,561
//   9          19,683                512             16,384
//  10          59,049              1,024             16,384
//  11         177,147              2,048             16,384
//  12         531,441              4,096             16,384
//
// Minimum: [8192, 4096, ...] makes subset sums a subgroup of size 2^n.
// It includes 8192, which this validator permits but production excludes.
// The production-eligible example [1, 2, 4, ...] instead bans 2^(n+1)-1
// values (plus 8192's separate ban for n <= 12, plus other jobs' bans).
// Maxima through n=8 are attained by [1, 3, 9, ...]. Valid examples attain
// the full pool for each n=9..12 too, but these are DIFFERENT selections:
// a selection that already bans everything cannot accept another rotation.

namespace {
// One entry per possible subset sum, not one entry per expression.
// 16 KiB suffices even when the signed combinations number in the millions.
bool cEightRotationScratch[RWIN_SIZE];
constexpr std::size_t kMaximumRotationCount = 14U;
static_assert((std::size_t{1U} << kMaximumRotationCount) == RWIN_SIZE);
} // namespace

std::size_t EightRotationValidator::ComplimentWindow(std::size_t pRotation) {
    return (RWIN_SIZE - (pRotation % RWIN_SIZE)) % RWIN_SIZE;
}

bool EightRotationValidator::Valid(std::size_t *pRotationArray, std::size_t pRotationArrayCount) {
    std::memset(cEightRotationScratch, 0, sizeof(cEightRotationScratch));
    if (pRotationArrayCount > kMaximumRotationCount) { return false; }
    if (pRotationArrayCount != 0U && pRotationArray == nullptr) { return false; }
    return Valid_Helper(pRotationArray, pRotationArrayCount, 0U);
}

bool EightRotationValidator::Valid_Helper(const std::size_t *pRotationArray,
                                          std::size_t pRotationArrayCount,
                                          std::size_t pRotationSum) {
    if (pRotationArrayCount == 0U) {
        // Two different subsets reaching the same sum mean a collision.
        // The empty subset visits zero, so nonempty zero sums fail too.
        if (cEightRotationScratch[pRotationSum]) { return false; }
        cEightRotationScratch[pRotationSum] = true;
        return true;
    }

    // Every subset either excludes or includes this rotation. This checks
    // 2^n sums instead of spelling out all 3^n signed combinations.
    if (!Valid_Helper(pRotationArray + 1U, pRotationArrayCount - 1U, pRotationSum)) {
        return false;
    }
    const std::size_t aRotation = pRotationArray[0U] % RWIN_SIZE;
    const std::size_t aRotationSum = (pRotationSum + aRotation) % RWIN_SIZE;
    return Valid_Helper(pRotationArray + 1U, pRotationArrayCount - 1U, aRotationSum);
}

bool EightRotationValidator::Valid(std::size_t pRotationA, std::size_t pRotationB) {
    const std::size_t aRotationA = pRotationA % RWIN_SIZE;
    const std::size_t aRotationB = pRotationB % RWIN_SIZE;

    const std::size_t aComplimentA = ComplimentWindow(aRotationA);
    const std::size_t aComplimentB = ComplimentWindow(aRotationB);

    // Single rotations. Their complements are zero exactly when they are zero.
    if (aRotationA == 0U) { return false; }
    if (aRotationB == 0U) { return false; }

    // A, B: every rotation/complement combination.
    if ((aRotationA + aRotationB) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB) % RWIN_SIZE == 0U) { return false; }

    return true;
}

bool EightRotationValidator::Valid(std::size_t pRotationA, std::size_t pRotationB, std::size_t pRotationC) {
    const std::size_t aRotationA = pRotationA % RWIN_SIZE;
    const std::size_t aRotationB = pRotationB % RWIN_SIZE;
    const std::size_t aRotationC = pRotationC % RWIN_SIZE;

    const std::size_t aComplimentA = ComplimentWindow(aRotationA);
    const std::size_t aComplimentB = ComplimentWindow(aRotationB);
    const std::size_t aComplimentC = ComplimentWindow(aRotationC);

    // Single rotations. Their complements are zero exactly when they are zero.
    if (aRotationA == 0U) { return false; }
    if (aRotationB == 0U) { return false; }
    if (aRotationC == 0U) { return false; }

    // A, B: every rotation/complement combination.
    if ((aRotationA + aRotationB) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB) % RWIN_SIZE == 0U) { return false; }

    // A, C: every rotation/complement combination.
    if ((aRotationA + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentC) % RWIN_SIZE == 0U) { return false; }

    // B, C: every rotation/complement combination.
    if ((aRotationB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationB + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aComplimentC) % RWIN_SIZE == 0U) { return false; }

    // A, B, C: every rotation/complement combination.
    if ((aRotationA + aRotationB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aRotationB + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aComplimentC) % RWIN_SIZE == 0U) { return false; }

    return true;
}

bool EightRotationValidator::Valid(std::size_t pRotationA, std::size_t pRotationB, std::size_t pRotationC, std::size_t pRotationD) {
    const std::size_t aRotationA = pRotationA % RWIN_SIZE;
    const std::size_t aRotationB = pRotationB % RWIN_SIZE;
    const std::size_t aRotationC = pRotationC % RWIN_SIZE;
    const std::size_t aRotationD = pRotationD % RWIN_SIZE;

    const std::size_t aComplimentA = ComplimentWindow(aRotationA);
    const std::size_t aComplimentB = ComplimentWindow(aRotationB);
    const std::size_t aComplimentC = ComplimentWindow(aRotationC);
    const std::size_t aComplimentD = ComplimentWindow(aRotationD);

    // Single rotations. Their complements are zero exactly when they are zero.
    if (aRotationA == 0U) { return false; }
    if (aRotationB == 0U) { return false; }
    if (aRotationC == 0U) { return false; }
    if (aRotationD == 0U) { return false; }

    // A, B: every rotation/complement combination.
    if ((aRotationA + aRotationB) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB) % RWIN_SIZE == 0U) { return false; }

    // A, C: every rotation/complement combination.
    if ((aRotationA + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentC) % RWIN_SIZE == 0U) { return false; }

    // A, D: every rotation/complement combination.
    if ((aRotationA + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentD) % RWIN_SIZE == 0U) { return false; }

    // B, C: every rotation/complement combination.
    if ((aRotationB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationB + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aComplimentC) % RWIN_SIZE == 0U) { return false; }

    // B, D: every rotation/complement combination.
    if ((aRotationB + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationB + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aComplimentD) % RWIN_SIZE == 0U) { return false; }

    // C, D: every rotation/complement combination.
    if ((aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }

    // A, B, C: every rotation/complement combination.
    if ((aRotationA + aRotationB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aRotationB + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aComplimentC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aRotationC) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aComplimentC) % RWIN_SIZE == 0U) { return false; }

    // A, B, D: every rotation/complement combination.
    if ((aRotationA + aRotationB + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aRotationB + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aComplimentD) % RWIN_SIZE == 0U) { return false; }

    // A, C, D: every rotation/complement combination.
    if ((aRotationA + aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }

    // B, C, D: every rotation/complement combination.
    if ((aRotationB + aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationB + aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationB + aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationB + aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentB + aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }

    // A, B, C, D: every rotation/complement combination.
    if ((aRotationA + aRotationB + aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aRotationB + aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aRotationB + aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aRotationB + aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aRotationA + aComplimentB + aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aRotationB + aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aRotationC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aRotationC + aComplimentD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aComplimentC + aRotationD) % RWIN_SIZE == 0U) { return false; }
    if ((aComplimentA + aComplimentB + aComplimentC + aComplimentD) % RWIN_SIZE == 0U) { return false; }

    return true;
}
