# FlameToad overhaul — 2026-11-03

Status: complete. All 78 selected XCTest checks passed. See report.md for results and limits.
This folder contains synthetic-fixture results, not user data.

- Native arm64 NEON, scalar, and x86_64 SSE2 cipher reference/inverse checks passed.
- NEON reference/inverse/buffer checks also passed ASan/UBSan.
- 23 focused XCTest checks passed (functional-4.log).
- Main-app cipher benchmark: see ../../BenchmarkResults/flame-toad-20261103-1810/.
- Primitive parity diagnostic is deliberately separate from full-plan security results.
- Full attack results and final conclusions are in report.md and results-summary.json.

No source files were deleted in this task. Four Cascade-related deletions were
already present in the working tree when the task began and were left unchanged.

## Construction and interpretation

All strengths execute two rounds of four full-size 1 MiB layers. Each layer:
four FlameToads on the four BitPlaneTool pairs, strong-only PasswordXOR, two
complementary masked byte rotations, then the scheduled trailing PasswordXOR.
There is one rotate-by-three of every byte after the first four layers.
Weak/normal/strong consume exactly 4/8/16 material lanes and 53/57/65 cipher
applications. They keep the same seeded plan across independent blocks.

The fixed row grid reused by both rounds is:

```text
Layer 0/4: [0 3] [1 6] [5 7] [2 4]
Layer 1/5: [2 7] [3 5] [0 4] [1 6]
Layer 2/6: [4 6] [2 7] [1 3] [0 5]
Layer 3/7: [1 5] [0 4] [2 6] [3 7]
```

Rotation selection shuffles windows 1..16383 and consumes exactly 144:
128 sampling rotations plus 16 masked-rotation windows. The exclusions cover
complements of one-, two-, and three-value sums, preventing zero sums of up to
four distinct selections. They do not cover arbitrary larger subsets or all
signed combinations. Plain greedy selection exhausted all candidates after
93–98 selections in five exploratory simulations, so the implementation uses
a seeded odd multiplier of canonical values 1..4095. This supplies enough
values by construction, but deliberately restricts the family of possible
sets. Intra-window byte offsets use a corresponding bounded construction.

The larger shuffle consumes the four existing 64 KiB Stage1 fold outputs.
Every one of their 32768 words has an assigned role; no extra material is
generated. The obsolete final fold and premium-seed buffer are disconnected.
Legacy mask banks/shuffles and all historical source files remain on disk.
Active Cryptex factories, old row/rotation banks, and unused cipher pools are
removed. Ten obsolete construction test bodies remain under #if 0 with an
explicit skipped replacement test, rather than appearing to pass.

## Known structure and next experiments

FlameToad uses four offset windows, each supplying 16 packed bytes from two
protected rows. Each source updates every fourth destination byte. A two-bit
AND folds the otherwise discarded packed positions into the lowest writable
key bit. Addition modulo 64 updates the other six positions; the inverse
regenerates the same keys from the preserved rows and subtracts.

Although the complete mapping is invertible, the derived mask is not an
independent random stream. Four translated copies of the same packing rule
make aggregate physical bit-0 parity invariant inside one FlameToad. The
primitive diagnostic reproduced this in 896/896 cases. This is not by itself
a full-vault attack, because the boundary rotation changes row positions.
The added aggregate-plane attack measures the complete vault explicitly.

The next speed experiment should pre-pack each source window once per cipher
call, then read the four offsets from that packed buffer. The current path
packs the same source window four times across a complete call. This could
reduce packing work without changing ciphertext, but needs 256 KiB of
non-aliasing scratch for a 1 MiB block. The existing EncryptionLayer scratch
aliases a cipher input/output during most calls, so it cannot be used for
this purpose without changing the buffer plumbing. No such optimization was
mixed into this baseline.

The next cryptanalysis campaign should vary row grids and structured plaintext
families, with frozen held-out predictors. Passing the present fixtures is
not a basis for reducing rounds. Source-specific packing/gating is a separate
candidate if we want to remove the primitive's aggregate parity cancellation;
it would change the cipher and needs its own baseline.

These changes alter ciphertext. The current version parameter does not
reconstruct the archived Cryptex layout; retaining files is not a migration
or backward-decryption implementation.

## Deliberately retained cleanup items

- Legacy mask storage/shuffles still consume 8168 Stage1 words at strong
  strength (about 24.9% of the layout). These words affect the retained mask
  bank, not the active vault's masks. Thus every source word is assigned, but
  this is not a claim that every word affects current ciphertext.
- Old cipher IDs, direct historical-cipher tests, BitPlaneFarm sources, and
  Cryptex/EncryptionPlan files remain for historical experiments. The active
  factories and build-source lists no longer depend on Cryptex.
- The stored plan, selected/base/block rotation lists, and material cursor
  remain useful for validation and diagnostics. They are intentionally kept.
