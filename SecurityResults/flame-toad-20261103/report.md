# FlameToad overhaul: measured baseline

Completed 2026-11-03. All 78 selected XCTest cases passed: 23 functional,
50 recovery/security checks, and 5 additional aggregate-plane parity checks.
All measurements use synthetic fixtures and the fixed row selectors {2026,17}.
The full statistical run took 31.5 minutes including the other attack suites.

## Results

| Strength | Statistical fixture 0 | Statistical fixture 1 | Significant flags | Whole-block parity: best orientation | Aggregate-plane parity: best prediction |
| --- | ---: | ---: | ---: | ---: | ---: |
| Weak | 51.0559% | 51.0132% | 0/128 | 51.9531% | 53.4668% |
| Normal | 50.9644% | 50.6714% | 0/128 | 51.0742% | 52.7344% |
| Strong | 50.7935% | 51.0132% | 0/128 | 50.5859% | 52.7344% |

The statistical test uses 65 discovery calls, 4096 training calls, 4096
validation calls, and 16384 held-out challenges per fixture. Its frozen
predictors search single ciphertext bits and two-bit parities for 64 hidden
plaintext flags. The unchanged conservative cutoff is about 52.4560%
(family alpha 1e-6 over 384 hypotheses). No fixture triggered confirmation;
“0 confirmed” here does not mean a separate confirmation batch was run.
Shuffled-label controls passed. The full 60-trial TenShot and 64-fixture
strong overnight campaigns were not run in this pass; their quick controls
and standalone runner self-test passed, and the runner is updated.

Whole-block parity used 1024 challenge blocks per fixture and a two-sided
58.9214% cutoff. Aggregate-plane parity selected one predictor for each of
255 nonempty plaintext-plane combinations from all 255 ciphertext-plane
combinations, using 256 training blocks. Predictions were frozen before
2048 fresh challenges per fixture; cutoff 57.3024%, corrected for all six
fixtures and real/shuffled labels. Its 52–53% maxima are not comparable to
the statistical test's 16,384-sample maxima without accounting for sample
size and hypothesis count.

The 21-query attack, adapted cross-bit recovery and diffusion checks,
XOR-superposition attack, multi-bit parity recovery, and exact plaintext
recovery all passed on weak, normal, and strong. Controls that deliberately
leak information were detected. These are bounded attacks on the listed
fixtures, not a proof of cryptographic security or key-recovery resistance.

## Important structural finding

One FlameToad preserves the global parity of physical bit 0, because four
translated copies of the same packing rule cancel in that aggregate. The
primitive diagnostic confirmed this in 896/896 cases. Whole-block parity
was preserved in 444/896 cases, so the old always-even-flip argument no
longer applies to all bits together.

A separate strong-fixture diagnostic appended an inverse bit rotation
immediately after the boundary rotation, canceling only that operation.
With the rest of the eight-layer stack unchanged, one known block let the
attacker predict bit-0 plane parity in **256/256 fresh blocks**. Round-trip
validation still passed. The production plan was not modified.

**Keep the boundary rotation.** It is currently doing essential work against
this invariant. The full-plan parity tests passed with it present; that does
not establish that there are no higher-order or nonlinear aggregate relations.

## Speed

The main-app Release/NEON benchmark used 1000 fresh 1 MiB inputs per cipher,
with input generation outside the timer. Raw samples, including outliers,
are retained in ../../BenchmarkResults/flame-toad-20261103-1810/.

| Cipher | Median microseconds per MiB |
| --- | ---: |
| TreeFrogTwo | 21.667 |
| FlameToadCipher | 173.666 |
| GateCipher | 316.292 |

FlameToad is about 8.0 times the standalone TreeFrog cost, and 55% of the
standalone Gate cost. The measured FlameToad constructor used rows 0/3 and
window offsets 2053,6151,10007,14009. It does not physically rotate buffers.

Whole-vault measurements used 8 warmups and 128 timed calls in each direction,
fresh input outside timing, and a round-trip check after every call. Seeding
and verification are excluded from the reported medians. These are separate
measurements, taken after the attack batch to avoid CPU contention.

| Strength | Encrypt ms/MiB | Decrypt ms/MiB | Encrypt MiB/s |
| --- | ---: | ---: | ---: |
| Weak | 6.061 | 6.004 | 164.98 |
| Normal | 6.260 | 6.296 | 159.73 |
| Strong | 6.629 | 6.617 | 150.85 |

## Packing recommendation

Use one 256 KiB packed-row buffer per executing FlameToad, reused across
calls. Pack each 64-byte input window into 16 bytes once; read four offset
windows from that one buffer to obtain the 64 mask bytes. This can preserve
ciphertext exactly while reducing packing work by four. Rebuild when either
protected row changes. Several consecutive operations preserving exactly the
same two rows could share a cache; different row pairs generally cannot.

The existing layer scratch alternates as input/output and cannot safely be
used for this cache. An existing seeding buffer such as mCollapseLaneA is a
candidate for reuse after setup, with explicit non-aliasing plumbing. No
packing-cache optimization was mixed into this baseline.

The proposed Prefrog layout (A -> bits 0/1, B -> 2/3, C -> 4/5, D -> 6/7)
changes the mask construction: each mask byte draws from four windows,
instead of four bytes of one window. If tried, fuse those four samplings
into one loop and make the bit-position assignments explicit; four separate
full-buffer passes are unnecessary. Treat it as a separate cipher experiment,
not an implementation-only optimization of this measured mapping.

## Next steps

1. Optimize packing with the shared cache, requiring byte-for-byte agreement
   with the current independent reference on NEON/SSE2/scalar and full plans.
2. Keep the boundary rotation and run the prepared wider row-grid and
   structured-plaintext campaigns. Do not reduce rounds from these fixtures.
3. If changing the mixing rule, test source-specific packing/gating against
   the known primitive parity cancellation. Also examine modular aggregate
   sums; the present parity search does not cover every such relation.

## Implementation and reproducibility

- FlameToadCipher.hpp: two rows, four window offsets, NEON/SSE2/scalar,
  reversible six-bit addition, no worker allocation in this baseline.
- RotationSelection.hpp: exactly 144 L3 values, zero excluded, complements
  of one/two/three-value sums excluded. A structured admissible family was
  needed because plain greedy sampling exhausted the pool before 144 values.
  It is not uniform over all valid rotation sets; see audit-notes.md.
- Soccer2 now runs only EncryptionVault, with 4/8/16 XOR material lanes.
  Cryptex source files remain, but are excluded from the active app/library.
- Obsolete construction tests are explicitly skipped with their original
  bodies retained. Direct historical cipher tests remain available.
- No files were deleted in this task. Preexisting Cascade-file deletions in
  the user's working tree were left unchanged.
- Ciphertext layout changed; the existing version parameter does not restore
  old Cryptex decryption. Historical files are not a migration implementation.

results-summary.json contains all six exact plans and rotation assignments.
source_sha256.json identifies the final source contents. The three XCTest
logs, standalone checks, timing data, and diagnostic sources/logs are retained.
The diagnostic .cpp files were built against the same native production
objects; their temporary executables are under /private/tmp/soccer-flame-overhaul.
