# Soccer

Soccer3 is a 21st generation password expander for offline file encryption,
developed by a cryptography-focused engineer with 17+ years of experience and
about 41 months of concentrated work on this design.

![alt text](https://raw.githubusercontent.com/nraptis/Soccer/refs/heads/main/image.png)

## Encrypt and decrypt one block

This example encrypts the string `Hello, Soccer!` inside one zero-padded L3
block, prints the first 64 encrypted bytes, then decrypts the block and prints
the recovered string.

```cpp
#include "Soccer3.hpp"

#include <cstddef>
#include <cstdio>
#include <cstdint>
#include <cstring>
#include <string>
#include <vector>

int main() {
    const std::uint64_t aNonce = 0xF00DFACECAFEBEEFULL;
    const std::string aPassword = "readme-password";

    std::vector<std::uint8_t> aPasswordBytes(aPassword.begin(), aPassword.end());
    std::vector<std::uint8_t> aOriginal(SOCCER_BLOCK_SIZE, 0U);

    const std::string aMessage = "Hello, Soccer!";
    std::memcpy(aOriginal.data(), aMessage.data(), aMessage.size());

    // Encrypt generates the ack word. You need this to decrypt.
    std::uint32_t aAckWord = 0U;
    if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kStrong,
                                      aPasswordBytes.data(),
                                      aPasswordBytes.size(),
                                      aNonce,
                                      &aAckWord)) {
        std::printf("Failed to seed encryption\n");
        
        // Factory reset when finished with your task.
        Soccer3::Zero();
        
        return 1;
    }

    // Encrypt in 1 MiB blocks.
    std::vector<std::uint8_t> aEncrypted(SOCCER_BLOCK_SIZE, 0U);
    Soccer3::EncryptBlock(aOriginal.data(), aEncrypted.data());
    
    // Factory reset when finished with your task.
    Soccer3::Zero();

    std::printf("Encrypted first 64 bytes:\n");
    for (std::size_t aIndex=0U; aIndex<64U; aIndex++) {
        std::printf("%02X%s",
                    static_cast<unsigned int>(aEncrypted[aIndex]),
                    ((aIndex + 1U) % 16U == 0U) ? "\n" : " ");
    }

    std::vector<std::uint8_t> aUnencrypted(SOCCER_BLOCK_SIZE, 0U);
    if (!Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kStrong,
                                      aPasswordBytes.data(),
                                      aPasswordBytes.size(),
                                      aNonce,
                                      aAckWord)) {
        std::printf("Failed to seed decryption\n");
                                            
        // Factory reset when finished with your task.
        Soccer3::Zero();
        
        return 1;
    }

    Soccer3::DecryptBlock(aEncrypted.data(), aUnencrypted.data());
    if (std::memcmp(aOriginal.data(),
                    aUnencrypted.data(),
                    SOCCER_BLOCK_SIZE) != 0) {
        std::printf("Failed to decrypt block\n");
            
        // Factory reset when finished with your task.
        Soccer3::Zero();
        
        return 1;
    }
    
    // Factory reset when finished with your task.
    Soccer3::Zero();

    const std::string aRecovered(
        reinterpret_cast<const char *>(aUnencrypted.data()),
        aMessage.size());
    std::printf("Unencrypted: %s\n", aRecovered.c_str());
    return 0;
}
```

When encrypting, store the nonce and the ack word with the ciphertext.
The same nonce is required for decryption, and the ack word lets Soccer stop
early when the password is wrong. This matters because seeding is deliberately
expensive and can take about 40 seconds.

## Current plan and seed layout

All strengths use `Cryptex`: eight full-size 1 MiB layers named AA, AB, AC, AD, BA, BB, BC, and BD.
Each layer executes the same structure:

```text
FlameToad(pair 0, four windows)
FlameToad(pair 1, four windows)
FlameToad(pair 2, four windows)
FlameToad(pair 3, four windows)
PasswordXOR (strong only)
ShiftMasked (first member of each pair)
ShiftMasked (second member of each pair)
PasswordXOR (when scheduled)
```

`Soccer3::mBitPlane` supplies the 4-by-4 grid. Each layer and pair column covers
all eight bits once; pair members are not circularly adjacent. Both rounds
reuse the selected numeric grid. Three 64-bit words select the representative,
row order, and column order through `BitPlaneFarm::Select`.
One `BitReverseCipher` follows all of layer 3, including its trailing XOR.
It reverses bits within each byte (bit 0 swaps with bit 7, etc.). Both rounds
use the same numeric row grid; it is not mirrored to compensate. Decryption
uses the identical reversal. There is no final bit reversal. All eight layers have separate offsets
and material assignments. No per-block material is generated.

| Strength | XOR before rotations | XOR after rotations | Material | Cipher applications |
| --- | --- | --- | ---: | ---: |
| Weak | None | Layers 2, 3, 6, 7 | 4 MiB | 53 |
| Normal | None | Every layer | 8 MiB | 57 |
| Strong | Every layer | Every layer | 16 MiB | 65 |

There are 32 FlameToads, 16 masked byte rotations, and one boundary bit
reversal. `Soccer3::SeedEpilogue_Regular_D()` assigns named bit rows, rotation
masks, sampling windows, ordered material pointers, and a packed-row cache.
`Cryptex.cpp` reads those values directly. `Build(pStrength)` validates the prepared inputs, then executes one of three
manually spelled-out branches: weak, strong, or normal as the fallback.
There are no layer-building loops, cipher factories, or plan objects.

`CryptexLayer::Add` takes ownership of each cipher. `Clear()` frees all eight
layers; execution reverses both layer and cipher order for decryption.
`Zero()` wipes and frees the old ciphers; `Build()` runs once into those empty
layers during seeding. Rebuilding individual stages without `Zero()` is unsupported. The
public class and header are now `Soccer3` / `soccer/Soccer3.hpp`; clients must
rename their includes and class references and rebuild/link the library.
The separate test-strength path in Soccer remains unchanged.

The replaced plan, vault, round, and layer implementations are preserved in
`Dead Code/CryptexMigration`, with prior tests under `DeadTests/CryptexMigration`.
The much older Cryptex and EncryptionPlan remain in their existing archive.
The Cryptex migration preserved the cipher sequence. The subsequent seed-shuffle
layout below changes seeded configurations and ciphertext; archived results
from earlier seed layouts do not describe this version.

### Seed lifecycle

Both seed entry points call `Zero()` once, before validation and seeding.
`Zero()` wipes material and cipher state, clears counters and selected inputs,
and restores the expander/material/workspace pointer tables plus identity
rotation and cross-permutation lists. The delegate registration is retained.
The test-mode length returns to 1 MiB; configure smaller test buffers after
seeding. Invalid seed arguments also discard any previous configuration.

Epilogue C contains bit-plane selection, window farming, byte-shift assembly,
and material ordering. Epilogue D assigns the named Cryptex inputs and builds
the cipher stack once. The former seed-reset, one-time initialization, selection, farming,
and input-preparation helpers are removed. Soccer operations must be serialized;
concurrent or independently repeated seed-stage calls are unsupported.

Cross permutations reset to identity before every warm-up and regular pool
rebuild, then receive that round's shuffle. These algorithmic per-round resets
remain separate from the new-seed initialization in `Zero()`. Tests that invoked
removed helpers or rebuilt individual stages have intentionally not been migrated in this cleanup.

### Seeded bit-plane farm

`BitPlanePair` holds two bit indices; `BitPlaneRow` and `BitPlaneColumn` each
hold four pairs. A `BitPlane` contains four columns (32 bytes), with `GetRow`,
`SetRow`, `GetCol`, and `SetCol` helpers. Every row and column covers bits 0–7
exactly once, and adjacent pairs including `[0,7]` are invalid.
`BitPlane::IsValid()` checks those rules before vault construction.

The readable `BitPlaneFarmData.inc` bank contains **588 representatives**
(**18,816 bytes**), covering all 211,392 labeled grids under row/column
permutations. `BitPlaneFarm::Select(planeWord, rowWord, columnWord, &result)`
copies `planeWord % 588`, then applies the `% 24` row and column permutations.
All 64-bit values are accepted; the small modulo remainder bias remains.
Selection is approximately uniform over representatives, not labeled grids:
symmetries give different representatives 144, 288, or 576 labeled variants.

Soccer stores `mBitPlaneWordA`, `mBitPlaneWordB`, and `mBitPlaneWordC` beside
`mBitPlane`. Every `Shuffle_CROWSCIMASSORMATEX()` call visits 18 equal units.
Each unit adds one separate little-endian 64-bit word to each accumulator:
A selects the bank entry, B the row permutation, and C the column permutation.
Unsigned addition wraps modulo 2^64. Each accumulator receives 18 words per
call, or 684 across the 38 seed generations. The epilogue selects the plane
from the completed sums. `Zero()` and both seed entry points reset the words
and clear the plane. `mPremiumSeed` and the fixed selectors are absent.

Each unit also adds one distinct word to each of `mFreeRotationWordA` through
`mFreeRotationWordP`: 18 words per accumulator per call, 684 per seed.
A/B belong to layer AA, C/D to AB, through O/P on BD. All word inputs occupy
separate ranges from the shuffles. Their locations repeat within each unit,
spreading every accumulator's samples across almost the whole random block.

`SeedEpilogue_Regular_C` directly selects the bit plane, farms windows, and
forms byte shifts as `64 * selectedWindow + offset`.
Ordinarily `offset = 1 + word % 63`. When the first shift in a layer is even,
the second uses `offset = 1 + 2 * (word % 32)`, keeping at least one odd shift.
The farmer checks actual byte subset sums before accepting a window; assembly
validates them again. All word values, including zero, are valid. Modulo 63
has a small remainder bias.

The pack stores only `uint16_t` window indices, including `mWindowFreeA/B`.
The final byte shifts are `mShiftMaskedCipherRotationAA..AH` for round A and
`mShiftMaskedCipherRotationBA..BH` for round B. Consecutive pairs feed each
layer. Sampling windows are `mFlameToadCipherRotationAAA..BDP` (round, layer,
then window within that layer). All Cryptex input definitions, word sums,
selected grid/pack, and Cryptex state reside in `Soccer3Cryptex.cpp`.
`ShiftMaskedCipher` replaces the active `ShiftMaskCipher` name; its numeric
cipher ID and forward/reverse operations are unchanged.
`Zero()` and both seed entry points clear words and derived inputs.

The exhaustive generator and old `BitPlaneTool` bank are archived in `Dead Code`.
The app no longer has the generator menu/launch option. Whole old tool tests
were moved to `DeadTests`; active tests validate the bank, swaps, seeded sums,
nonoverlapping ranges, and the full vault. TenShot keeps its deliberate word
variations inside the test fixture, after production seeding.

This migration changes the seeded cipher configuration and ciphertext; old
fixed-grid test results describe the previous construction.

### BitReverseCipher

The boundary cipher maps bit `b` to bit `7-b` inside each byte without moving
bytes. Seal and Unseal use the same operation. ARM64 NEON uses vector RBIT;
SSSE3 and AVX2 use nibble-reversal tables held in registers, and SSE2 uses
three masked bit-swap stages. The ISA path is selected at compile time.
A scalar tail handles arbitrary lengths. Unaligned buffers are supported;
nonempty source/output buffers must not overlap. No worker, material, or
per-block allocation is used. FlameToad's individual passes are unchanged.

### FlameToad

Each of four offset 64-byte windows supplies both protected rows. Four source
bytes pack into `[A0 B0 A1 B1 A2 B2 A3 B3]` (A0 is the least-significant bit),
producing 16 key bytes per window. Source number `s` supplies destination
positions `4*g+s`, so neighboring bytes sample different windows. The packed
bits falling in the two protected positions supply an AND gate that toggles
the lowest writable key bit before those positions are cleared. This uses
all sampled bits and makes the lowest key bit nonlinear in the source rows.

Each resulting key is added modulo 64 to the destination's six writable
positions. Carries skip protected positions. Inversion regenerates the key
from the unchanged rows and subtracts. The combined cipher packs every source
window once into a 256 KiB cache, then gathers four offset views and adds or
subtracts directly. It never materializes a 1 MiB mask. Soccer reuses the first
256 KiB of `mCollapseLaneC` after seeding; the B/D lanes remain the data
ping-pong buffers. All FlameToads share the cache sequentially and rebuild it
for every encryption or decryption call.

The optional seventh constructor argument is a non-owning
`std::span<std::uint8_t>` with at least `length/4` bytes. It must outlive the
cipher and must not overlap input, output, or key material. Concurrent calls
need separate caches. Omitting it retains the direct packing path. There is
no allocation or physical source-buffer rotation. NEON, SSE2, and scalar
implementations are checked against the independent gather/add/scatter
reference, including decryption after overwriting the cache. This optimization
preserves the previous FlameToad ciphertext and the vault's operation order.

This removes the old TreeFrog even-flip argument for whole-block parity.
It still preserves the global parity of physical bit 0 within an individual
FlameToad: the same packing function is translated four times, so its lowest
key-bit contributions cancel in that aggregate. The boundary bit reversal
exchanges the row positions between rounds, reversing the orientation of
later carries relative to the preceding round. `BitPlaneParityRecoveryTests`
checks all 255 nonempty combinations of global row parities against the
complete vault; a passing bounded test does not prove the absence of other
invariants.
It is an experimental mixer, not a security proof. Functional checks and
bounded recovery attacks are distinct; results must name their tested
fixtures, row selections, and statistical limits.

### Window rotation farming

The active seed path uses one data-only `Soccer3::mWindowRotationPack`.
`WindowRotationPackChunk.hpp` holds `mWindowFreeA/B` and `mWindowA..P` as
**64-byte window indices**, all `uint16_t`. Four chunks form a plane; two
planes form the pack: 144 values in 288 bytes.
Within a chunk, A..D feed frog 1, E..H frog 2, I..L frog 3, and M..P frog 4.
Cryptex reads the named inputs prepared from the pack and accumulated words.
The eight masks and four rows of pairs are shared between both rounds.

`WindowRotationFarm.cpp` provides the separate farming functions. Each plane
uses nine eight-value jobs:

| Chunk | Free-rotation job | Window jobs |
| --- | --- | --- |
| A | a (two of its eight values) | b: A..H, c: I..P |
| B | a (two of its eight values) | d: A..H, e: I..P |
| C | a (two of its eight values) | f: A..H, g: I..P |
| D | a (two of its eight values) | h: A..H, i: I..P |

Soccer retains eighteen `uint16_t[16384]` base lists, taking **589,824 bytes**.
They start at 0..16383 once per seed and retain their permutations across the
38 fresh `mRandom` generations. `Shuffle_CROWSCIMASSORMATEX()` gives every
list one forward partial Fisher–Yates pass per call, using little-endian
16-bit choices and out-of-range rejection. There is no backward pass.
Each list retains its permutation across calls; every call starts at index 0.
Positions fixed by the final partial pass are preferred for farming.
The byte budgets are in the table below; 589,824 bytes is the base-list
storage size, not the current shuffle-input budget.

If the preferred prefix is exhausted, farming scans the remaining list from
its opposite end. Missing or malformed lists fall back to numeric window
candidates; every candidate still passes the window and byte collision checks.
Missing offset entropy defaults to 1. These fallbacks are deterministic, so
seeding encryption and decryption produces the same pack. There is no full
epilogue re-shuffle. The independent `FarmPack` API uses as much shuffle entropy
as supplied and applies the same fallbacks to finish all eighteen jobs.
`mWindowRotationFarmBuffers` supplies the shared selection scratch.
`mWindowRotationBlocked[16384]` tracks combination exclusions within the
current job; `mWindowRotation[8]` holds its selections. These reset each job.
`mWindowRotationSingleBlocked[16384]` persists across all 18 jobs, blocking
selected window slots, their complements, and the window containing each
free byte rotation's inverse. Zero and the self-inverse half turn are excluded.
Free values get a separate offset from 1..63; each layer retains at least one
odd free rotation. Statistics distinguish shuffle bytes, list candidates read, and fallback candidate attempts.

Each job requires **256 different subset sums**, including the empty sum,
modulo 16384 windows. Free jobs additionally check actual byte sums modulo
1048576, because adding intra-window offsets can carry into another window.
The temporary block map records both signs of differences between existing
subset sums. This excludes signed relations using each selected rotation at
most once. It does not forbid repeated multiples of a rotation.

Combination sums are not blocked across jobs. A frog's windows and its
layer's free rotations do **not** share a combined subset-sum guarantee.
The archived farmer checked those six-value groups; this layout checks eight
window values across two frogs, and eight free rotations across four layers.
Neither set of constraints implies the other. Sequential rejection also does
not promise uniform selection over every valid eighteen-job pack.

`WindowRotationFarm::IsValid(pack)` checks window ranges, single exclusions,
and all eighteen window-subset groups. Its overload accepting sixteen final
byte shifts also checks matching windows, offsets 1..63, odd pairs, and
actual byte-subset sums. Production assembly and Cryptex construction use
the complete validation before installing ciphers. Each seed entry point calls `Zero()` first. Failed or cancelled seeding leaves
encryption unavailable because only successful epilogue D marks it ready.
The epilogues do not clear or reset state a second time.
`RotationPack` and `RotationSelection` remain in `Dead Code`; no active source
includes them. Whole retired tests are preserved in `DeadTests`. The old
rotation-only fixture checks are commented out; dedicated pack/migration
and full-vault tests cover the current implementation.

### Seed material

`RandomShuffleLayout.hpp` divides each 32 KiB `mRandom` block into **18 equal
1,820-byte units**, covering 32,760 bytes and leaving eight unused. Each
`ShuffleCROWUnit` receives one rotation list, the bit-plane accumulator
references, its list index, and its byte offset. The layout within each unit is:

| Use | Bytes per unit | Work |
| --- | ---: | --- |
| Free-rotation words | 128 | One word for each of sixteen accumulators |
| Bit-plane words | 24 | One word for each of three accumulators |
| Rotation base list | 1,492 / 1,380 / 1,156 | One forward partial pass: weak / normal / strong |
| Materials, sources, workspaces | Three × 4 × active lanes | One requested pass on each list |
| Expanders | 64 | One requested pass on sixteen entries |
| Cross permutations | 16 × active lanes | One requested pass on one active cross list |

Small shuffles receive four choice words per array entry. Their choice word
is one byte; the large rotation shuffle uses 16-bit choices. These are
allocated budgets: a small shuffle can finish early and leave unused bytes.
Cross-list assignments rotate across units and generations so active lanes
receive nearly equal numbers of shuffles. All ranges are disjoint, including
the separately executed `Shuffle_CROPER`. The final generation has no
subsequent cross shuffle, as in the existing seed flow.

| Strength | Active lanes | Rotation bytes per list per call | All 18 lists across 38 calls |
| --- | ---: | ---: | ---: |
| Weak | 4 | 1,492 | 1,020,528 |
| Normal | 8 | 1,380 | 943,920 |
| Strong | 16 | 1,156 | 790,704 |

The policy identifier is `window-pack-forward-units-v4`. The unit budgets
favor the longer lists; strong assigns about 63.5% of each unit to its large
rotation list. Small ordering/expander lists receive 18 requested passes per
call, intentionally following the repeated-unit design.

`Shuffle_MEWBlockZero` uses a separate 32 KiB seed-material block before
`mRandom` is populated. Its three-pass claimed-list handling is unchanged.
The prelude's eight passes per ordering list and the epilogue's 32,760
material swaps are also unchanged and remain candidates for simplification.

Free intra-window offsets now come from the sixteen accumulated words;
rotation farming no longer reads the two Stage2 lane tails. There is no
additional expander output or per-block material. This changes seeded plans
and ciphertext; it is not a compatibility-preserving format change.

The final four 64 KiB collapse outputs retain a separate purpose:
`RandomShuffleLayout.hpp` also defines their material allocation, using
word ordinals 0–32759 for material-pointer
shuffles and 32760–32767 for reversal selection. Weak and normal consume
only their required reversal choices. `TwistMix64::DiffuseA` mixes those
64-bit words before reduction. The old `Soccer3::mMasks`, mask-bank selection,
and mask shuffles are removed. `SoccerMaskBank` is archived in `Dead Code`;
the active plan still derives its two complementary masks from the bit grid.

These are allocation and local-relationship checks, not a security proof.
The pack and boundary-reversal changes require new full-cipher statistical
measurements; results from
the former multiplier-based rotation selection describe that older policy.
`DiscardableTestTenShot` uses the real seeded plane for its first trial, then
adds nine reproducible test-only word variations and rebuilds the vault.
`Zero()` clears both the words and the derived grid; no selector override
persists across seeding.

The resumable chosen-plaintext campaign is documented in
[Tools/STRONG_SECURITY_SWEEP.md](Tools/STRONG_SECURITY_SWEEP.md). It records
all row pairs, 128 sample offsets, 16 byte rotations, material indices, and
rotation-policy identifier and per-job shuffle totals. It distinguishes challenge findings from
fresh confirmation and retains family-wise correction and shuffled labels.

This revision changes ciphertext for existing password/nonce pairs.
Encryption and decryption must use the same implementation; the reserved
`pVersion` argument does not select old layouts. The removed Cryptex backend
cannot decrypt earlier experimental constructions through the current API.

## License

Soccer is available under the
[PolyForm Noncommercial License 1.0.0](LICENSE.md). You may use, study, modify,
and redistribute the software for noncommercial purposes. Commercial use,
including selling the software or derivatives, is not permitted under this
license.

## Final 180 Hearts

![Final 180 Hearts](https://raw.githubusercontent.com/nraptis/Soccer/refs/heads/main/180_heart_demo_a.png)

## 14 "best" of 2,667,804

![14 best of 2,667,804](https://raw.githubusercontent.com/nraptis/Soccer/refs/heads/main/180_heart_demo_b.png)

## Misleading Data, we lost days of work due to scoring bias!

![Misleading scoring data](https://raw.githubusercontent.com/nraptis/Soccer/refs/heads/main/misleading_graph.png)
## Main-app cipher timings

Normal app launch measures the four remaining cipher classes automatically
(five entries, including cached and direct FlameToad).
**Benchmarks → Run All Ciphers (1,000 × 1 MiB)** runs the report again.
It runs in the background and prints each result to the console as it finishes,
then shows the report directory. It does not
seed Soccer3 or change its configured encryption plan.

For comparable Release timings with code-coverage counters disabled, run:

```sh
"/Users/icarus/Desktop/Codex Maga/Soccer/Tools/run_cipher_benchmarks.sh"
```

The launcher builds and executes the main `Scramble.app`, not an XCTest.
An optional first argument selects a new output directory. Reports default
to `BenchmarkResults/ciphers-YYYYMMDD-HHMMSS`. Existing reports are never
overwritten. In Xcode, use a Release Run configuration with coverage disabled;
no launch argument is needed. `--readme-example` runs the older seed demo instead.
`--benchmark-output /path/to/new/directory` selects the report folder;
`--benchmark-exit` exits the app after completion.

Each call receives freshly randomized 1 MiB input, with randomization,
construction, material generation, round-trip verification and warmups all
outside the timer. Only `SealData` is measured. Each cipher reuses its fixed
synthetic materials and representative parameters. The input sequence is the
same for each cipher. Each cipher completes its 1,000 calls before the next one.
Both execution and report order start with FlameToad (cached/direct),
PasswordXOR, ShiftMasked, and BitReverse. Only PasswordXOR needs a material buffer;
the benchmark now allocates one lane. Source,
worker and destination are distinct, and buffers are reused without cache
flushing. This is a warm-input standalone measurement, not whole-plan speed.

The 1,000 measured calls process **1,000 MiB = 0.9765625 GiB per cipher**.
The summary reports median, fastest-to-p95 range, p99, maximum, and throughput.
Trimmed mean/throughput exclude exactly the slowest 50 calls; raw throughput
includes all 1,000. `samples.csv` retains every timing and its inclusion flag,
`summary.csv` contains per-cipher statistics, and `metadata.txt` records build,
backend, coverage detection, parameters and completion. Do not compare Debug
or coverage-instrumented timings with an optimized uninstrumented run.

## Mask-list feasibility

`python3 Tools/analyze_mask_options.py` prints exact bounds and constructs
example sets without reading a mask bank. `Tools/mask_options.json` is the
saved result. The four-one witness consists of the 14 nonconstant affine
Boolean functions on three input bits.

For 8-bit masks with exactly three ones, minimum distance 3 is equivalent to
minimum distance 4: equal-weight masks always have even distance. At most
eight masks fit, so there are zero valid lists of each length 15–19.
Each position can belong to at most three masks (the other two positions
cannot repeat); counting ones gives `3 × masks <= 8 × 3`.

Fourteen is the maximum for four-one, distance-4 lists. Allowing weights 2, 4 and 6 gives a
16-mask, distance-4 construction; allowing distance 2 gives all 56 three-one
masks. Neither alternative is installed automatically, and Hamming distance
between masks does not establish statistical attack resistance.

## Archived GateCipher experiment

The implementation and its tests are now in `Dead Ciphers` and `DeadTests`.
The following describes the historical experiment, not the active plan.

`GateCipher{}` applies the AES S-box to each byte; `UnsealData` applies its
inverse. It preserves byte positions and needs no material lanes, masks,
worker buffer or per-block state. It accepts lengths divisible by 256 with
distinct, non-overlapping source/destination buffers. The S-box and inverse
are specified in [FIPS 197, sections 5.1.1 and 5.3.2](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197-upd1.pdf).

Two static 256-byte tables hold the forward and reverse substitutions. Each
byte is one indexed lookup; there is no runtime table construction, arithmetic
S-box calculation, hardware AES instruction or byte rotation. Zero length
succeeds without buffers. These input-indexed memory accesses are not
constant-time. Historical benchmark reports record the static lookup backend.
Gate is absent from the current production plan and benchmark catalog.
This is a public nonlinear building block, not full AES
or standalone encryption; it belongs between keyed operations and movers.

The previous two-Gate-per-layer plan failed the Strong statistical recovery experiment
on November 1, 2026: both fixtures recovered all 64 unknown template bits on
all 16,384 challenge and 8,192 confirmation blocks. Attack controls passed.
Gate's within-byte substitution did not replace the removed distant sampling
relationships. The current FlameToad vault is a different construction;
those archived results do not evaluate it.

### RandomManyShot

Run `DiscardableTestRandomManyShot/testRandomManyShotAllStrengths` in the
StatisticalTests target (shared `StatisticalTests` scheme). This bundle contains
the eight test classes moved from `ScrambleTests/Attack Tests` and runs serially.
It repeats **five weak, five normal, five strong** trials,
using the same random fixtures for comparisons between strengths. The default
is ten batches: 50 trials per strength, 150 total. Set `SOCCER_MANY_SHOT_BATCHES`
(1–1000) in the test environment to change that count. Set
`SOCCER_MANY_SHOT_SEED` to a decimal or `0x` uint64 value to replay; otherwise
the test generates a seed and prints it with every summary.

One line is printed after each five completed trials, showing pass/fail,
the strength's running worst prediction percentage, failed trials, screening
and significance counts, fresh confirmations, errors, elapsed time, and total
percentage complete. Trials continue after findings; the final assertion
reports any failed trials. API errors cannot count as passes.

The exact **52%** cutoff is a screening rule, separate from statistical
significance. A frozen predictor reaching 52% on 16,384 held-out challenges
fails the trial and gets 8,192 fresh confirmation challenges. The existing
training/validation procedure, campaign-wide significance correction, and
shuffled-label controls remain in use. An unconfirmed finding is still a
screen failure. This is a long experiment; focused scheduling, reporting,
threshold, and biased-control checks do not substitute for running it.
