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
PasswordXOR (strong only)
FourToadKernel (four sequential Toad stages, one pair and four windows per stage)
FourCrowKernel or FourRavenKernel (two independent two-bit shifts; Raven includes one XOR)
```

`Soccer3::mBitPlane` supplies the 4-by-4 grid. Each layer and pair column covers
all eight bits once; pair members are not circularly adjacent. Both rounds
reuse the selected numeric grid. Three 64-bit words select the representative,
row order, and column order through `BitPlaneFarm::Select`.
One `BitReverseKernel` follows the fourth layer (AD), including its Raven.
It reverses bits within each byte (bit 0 swaps with bit 7, etc.). Both rounds
use the same numeric row grid; it is not mirrored to compensate. Decryption
uses the identical reversal. There is no final bit reversal. All eight layers have separate offsets
and material assignments. No per-block material is generated.

Layer numbers below run from 1 through 8.

| Strength | XOR before FourToadKernel | Corvid after FourToadKernel | Material | Kernel applications |
| --- | --- | --- | ---: | ---: |
| Weak | None | Crow on 1, 3, 5, 7; Raven on 2, 4, 6, 8 | 4 MiB | 17 |
| Normal | None | Raven on every layer | 8 MiB | 17 |
| Strong | Every layer | Raven on every layer | 16 MiB | 25 |

There are eight FourToads (32 Toad stages), eight corvids incorporating
sixteen masked shifts, and one boundary bit reversal. `Soccer3::SeedEpilogue_Regular_D()` assigns named bit rows, rotation
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

Epilogue C selects the bit plane and eighteen window lists, then orders materials.
Epilogue D assembles byte shifts, assigns the named Cryptex inputs, and builds
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

Each unit also adds one distinct word to each of the sixteen
`mShiftMaskedRotationWordAALeft` / `AARight` through `BDLeft` / `BDRight`
accumulators: 18 words per accumulator per call, 684 per seed. All word inputs
occupy separate ranges from the shuffles. Their locations repeat within each
unit, spreading every accumulator's samples across almost the whole random block.

`SeedEpilogue_Regular_C` selects the bit plane and fills the chosen window lists.
`SeedEpilogue_Regular_D`, in `Soccer3Cryptex.cpp`, forms the final byte shifts
as `64 * selectedWindow + 1 + 2 * (offsetWord % 32)`. Every corvid has two
odd shifts. Pool A and the Left words supply the first shift of every layer;
pool B and the Right words supply the second. Both pools use slots 0–7 for
AA, AB, AC, AD, BA, BB, BC, BD. Stage C validates collisions for both pools.

All corvid masks use the first selected bit-plane row, labelled
`[a b] [c d] [e f] [g h]`, throughout both rounds. Their pairs are
`ac/eg`, `bd/fh`, `ae/cg`, `bf/dh`, `ad/eh`, `bc/fg`, `af/ch`, `be/dg`.
All sixteen pairs are unique, every plane is shifted four times, and each
consecutive pair of layers covers all eight planes. Each corvid gathers the
two pairs at separate byte offsets. FourRavenKernel then XORs one full material lane.

Chosen lists store `uint16_t` window indices. The receiving layers use
`mPlaneShiftAALeft` / `AARight` through `BDLeft` / `BDRight`, each holding a
mask and its final byte rotation.
Final sampling windows are `mToadCipherRotationAALeftA..H` and
`AARightA..H`, through `BDLeftA..H` and `BDRightA..H`.
For each layer, Left A–D feed frog 1, Left E–H frog 2, Right A–D frog 3,
and Right E–H frog 4. Kernel-input definitions, word accumulators, the bit
plane, and Cryptex state reside in `Soccer3Cryptex.cpp`; rotation-list storage
and selection reside in `Soccer3.cpp`. `Zero()` resets them once per seed.

The exhaustive generator and old `BitPlaneTool` bank are archived in `Dead Code`.
The app no longer has the generator menu/launch option. Whole old tool tests
were moved to `DeadTests`; active tests validate the bank, swaps, seeded sums,
nonoverlapping ranges, and the full vault. TenShot keeps its deliberate word
variations inside the test fixture, after production seeding.

The earlier seeded-bit-plane migration changed the cipher configuration and ciphertext; old
fixed-grid test results describe the previous construction.

### BitReverseKernel

The boundary cipher maps bit `b` to bit `7-b` inside each byte without moving
bytes. Seal and Unseal use the same operation. ARM64 NEON uses vector RBIT;
SSSE3 and AVX2 use nibble-reversal tables held in registers, and SSE2 uses
three masked bit-swap stages. The ISA path is selected at compile time.
A scalar tail handles arbitrary lengths. Unaligned buffers are supported;
nonempty source/output buffers must not overlap. No worker, material, or
per-block allocation is used. FourToadKernel's individual stages are unchanged.

### FourToadKernel

FourToadKernel groups the four stages of a layer into one call. For a 1 MiB block,
the caller and three persistent helper threads each process one quarter.
They pack the first stage's keys before transforming. On NEON, each of the
first three transforms also packs the next stage's keys directly from its
output registers. Two 256 KiB key buffers alternate: one borrowed from the
caller and one owned by the worker team. A barrier publishes the next keys
before the following stage begins. Decryption visits stages in reverse order
and subtracts the same key bytes. The four-lane update is explicitly unrolled
to retain its vectors in registers even in size-optimized builds.

Each of four offset 64-byte windows supplies both protected rows. Four source
bytes pack into `[A0 B0 A1 B1 A2 B2 A3 B3]` (A0 is the least-significant bit),
producing 16 key bytes per window. Source number `s` supplies destination
positions `4*g+s`, so neighboring bytes sample different windows. The packed
bits falling in the two protected positions supply an AND gate that toggles
the lowest writable key bit before those positions are cleared. This uses
all sampled bits and makes the lowest key bit nonlinear in the source rows.

Each resulting key is added modulo 64 to the destination's six writable
positions. Carries skip protected positions. Inversion regenerates the key
from the unchanged rows and subtracts. For each stage, FourToadKernel packs every
source window once and applies the gate before storing its key bytes. All
four offset reads use those precomputed keys. Soccer supplies the first
256 KiB of `mCollapseLaneC` as scratch. The first stage writes the destination
buffer, and the remaining three update it in place.

`FourToadKernel`, `FourCrowKernel`, and `FourRavenKernel` each keep their implementation,
backend selection, and reusable worker team in their own header/source pair.
Their only external project include is `Kernel.hpp`. FourCrowKernel and FourRavenKernel
own separate `Shift` types; Soccer3's `PlaneShift` records are planning data.
Both rotation kernels use four workers for 1 MiB calls, with two NEON masked
selects per vector instead of a chain of AND/OR combinations. Raven adds the
material XOR after forward rotation and removes it at each sampled position
during inverse rotation.

This removes the old TreeFrog even-flip argument for whole-block parity.
It still preserves the global parity of physical bit 0 within an individual
Toad stage: the same packing function is translated four times, so its lowest
key-bit contributions cancel in that aggregate. The boundary bit reversal
exchanges the row positions between rounds, reversing the orientation of
later carries relative to the preceding round. `BitPlaneParityRecoveryTests`
checks all 255 nonempty combinations of global row parities against the
complete vault; a passing bounded test does not prove the absence of other
invariants.
It is an experimental mixer, not a security proof. Functional checks and
bounded recovery attacks are distinct; results must name their tested
fixtures, row selections, and statistical limits.

### Flat rotation lists

Soccer3 owns eighteen separate `uint16_t[16384]` bases (**589,824 bytes**):
sixteen `mFlameToadRotationListBaseAALeft` / `AARight` through `BDLeft` /
`BDRight`, and two `mShiftMaskedRotationListBaseA` / `B`. Each base has a `ListAvailable` prefix. All eighteen bases each supply
a `ListChosen` array of eight window indices.

Each base starts at 0..16383 once per seed and retains its permutation across
the 38 fresh `mRandom` generations. `Shuffle_CROWSCIMASSORMATEX()` explicitly
gives each list one forward partial Fisher–Yates pass per call, using
little-endian 16-bit choices and out-of-range rejection. There is no backward
shuffle or extra epilogue shuffle. The byte budgets appear below; the base-list
storage size is not the shuffle-input budget.

Stage C selects from both masked-shift pools first, then from the two
FourToadKernel lists for each layer in execution order. The eighteen selections
supply sixteen corvid-shift windows and 128 FourToadKernel windows.

Selection prefers the completed prefix, then scans the remaining tail from
the opposite end. Missing or malformed bases fall back to numeric candidates.
Every candidate still passes all collision checks; no fallback accepts an
invalid last-eight slice. Selection returns `void` and fills all eight values.
Within the eighteen active lists, a counting bound guarantees
that numeric candidates remain even at the eighth choice. Zero offset-word
values are valid and produce byte offset 1.

`mRotationWindowBlocked[16384]` tracks subset differences within the current
list and resets on every selection. `mRotationWindowSingleBlocked[16384]`
tracks selected windows, complements, and the window containing each masked
byte shift's inverse across all eighteen selections. `Zero()` clears the
shared exclusions for each new seed. Window zero and the self-inverse half
turn are excluded. Aggregate counters report shuffle bytes, base candidates,
and fallback candidate attempts without another per-list statistics array.

Each eight-value list requires **256 different subset sums**, including the
empty sum, modulo 16384 windows. Each masked-shift list additionally requires distinct
actual byte sums modulo 1048576, because intra-window offsets can carry into
another window. Blocking both signs of subset differences excludes signed
relations using each selected rotation at most once. It does not forbid
repeated multiples of a rotation. Combination sums are not blocked across
lists: a frog's windows and its layer's masked shift do not share a combined
subset-sum guarantee. Sequential rejection does not imply uniform sampling
over all valid configurations.

`ValidateCryptexInputs` checks the final cipher values independently, including
window/byte ranges, global single exclusions, all eighteen subset groups,
and an odd shift from the assigned pool A window for each layer. Every seed starts with `Zero()`;
only successful stage D marks encryption ready. The single-shift plan changes ciphertext. Archives encrypted with the
previous two-shift plan require that version to decrypt.
The old rotation farm and Pack/Plane/Chunk files are preserved in `Dead Code`;
their standalone fallback test is in `DeadTests`. Active selection/fallback,
collision, and encryption roundtrip tests use the flat Soccer3 storage.

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

The eight active intra-window offsets come from the Left accumulated words;
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
## Main-app kernel timings

Normal app launch prepares and measures exactly five active kernels:
`FourToadKernel`, `FourCrowKernel`, `FourRavenKernel`, `PasswordXORKernel`, and `BitReverseKernel`.
Archived Bog, Quirk, FlameToad, EightRaven, and ShiftMasked implementations are
excluded from the mainline build and benchmark registry.

`KernelBenchmarkSet` constructs the kernels and their borrowed material/cache
buffers before calling the shared `QBTests` executor. Normal launch uses
`QBTests::Execute(set.GetKernels(), 100, 0.1, 0.1)`: 100 calls per direction,
10 fastest and 10 slowest discarded, and the mean of the remaining 80 printed
in an appropriate time unit. At least one sample is always retained.

Every timed call processes exactly `Kernel::kBlockBytes` (1,048,576 bytes).
Construction, allocation, material generation, input randomization, worker
startup, warm-up, output consumption, and reporting occur outside the timer.
Encryption and decryption use separate timer gates. The executor checks call
success and prints timings; it does not perform correctness comparisons.
Each kernel retains its normal worker model. This measures warm-buffer kernel
calls with representative fixed settings.

For a saved main-app report with code coverage disabled, run:

```sh
./Tools/run_cipher_benchmarks.sh
```

An optional first argument selects a new report directory. The launcher builds
and executes `Scramble.app` with `--benchmark-output /path/to/new/directory`
and `--benchmark-exit`. This report mode uses `RunKernelBenchmarks`: 1,000 calls
per direction, discards the slowest 5%, and prints each result as it completes.
Existing report directories are never overwritten. It does not seed Soccer3
or alter the configured cryptex.

`summary.csv` contains trimmed means and min/max samples for each direction;
`samples.csv` retains all raw timings in collection order. `metadata.txt`
records block size, compiler/backend, warm-ups, trimming, coverage detection,
and completion. The CSV name column is `kernel`. Use optimized builds with
coverage disabled for speed comparisons.

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

### CaptureWeakestPredictorTest

Run `Tools/run_capture_weakest.sh` for an overnight capture. It selects only
`CaptureWeakestPredictorTest/testCaptureWeakestPredictor`, uses Release mode,
disables test timeouts and parallel tests, and retains its console log and
Xcode result bundle under `Statistical Outputs/CaptureWeakestPredictorTest/`.
The test holds an activity assertion to prevent idle system sleep while running.
It releases the assertion when it exits. Invalid configuration fails visibly.
The same method can be run individually in Xcode's `StatisticalTests` scheme.
It uses **weak only**, continues until stopped, and has
**no security pass/fail threshold**. Every run seeds a new random password,
nonce, template, and set of 64 unknown bits. It shares ManyShot's fixture recipe,
so the same campaign seed and zero-based fixture index reproduce that fixture.

Each run performs 65 discovery probes, 4,096 training queries, and 4,096
validation queries. It freezes all 64 predictors, evaluates them on 16,384
screening blocks, and chooses the predictor with the largest absolute deviation
from 50%. It then evaluates the same frozen predictors on **262,144 separately
seeded verification blocks**, regardless of the screen result. Polarity is never
flipped after either challenge. The result for the screen-selected predictor is
kept separately from the maximum selected afterward on verification data.

A startup line prints the replay seed and output directory. The console and
`progress.json` show the current fixture and block count at each phase change
and every 32,768 blocks within a phase. The recorder saves each completed
fixture before starting the next one. After every five
attempted runs, one console line reports cumulative verification averages
strictly above and below 50%, their predictor counts, the exact-50% count,
the overall average, corresponding shuffled-label controls, the most deviant
match in either direction, and the screen-selected predictors' fresh mean.
These are **match percentages**, not Pearson coefficients. Side-conditioned
means naturally differ from 50% even under chance; they and the largest observed
deviation are descriptive statistics, not significance claims. Errors are
recorded separately and excluded from the rates. The loop continues after an
observed correlation or a reported API error.

The default directory is
`Statistical Outputs/CaptureWeakestPredictorTest/<timestamp-seed-session>/`:

- `progress.json` records the active password, nonce, replay seed, fixture
  index, phase, and latest block count. After an interruption, the timestamp
  shows when that fixture last reported progress.
- `summary.json` is atomically replaced after each fixture and includes cumulative
  counts, averages, controls, the most deviant predictor, and its full replay record.
- `runs.jsonl` appends one record per fixture, with all 64 predictor
  definitions, raw screening/verification/control hit counts, per-run averages,
  password, nonce, bit addresses, seeds, sample counts, and runtime.
- `weakest-run-N-template.bin`: the exact 1 MiB template for a new checkpoint's
  strongest observation. Previous captures remain available. Predictor bit
  addresses are zero-based from the start of the block; bit 0 is the byte's LSB.
  Prediction is `ciphertext_bit_a XOR ciphertext_bit_b XOR polarity`, omitting
  bit B when it is null. Each replay record includes the template ciphertext's
  SHA-256 to detect a changed cipher configuration when reproducing the capture.

Every progress file, run record, and summary identifies the cipher plan as
`fourtoad-corvid-per-layer-v1`, separating these captures from earlier layouts.
Configuration is saved immediately on startup. To continue after stopping,
use the campaign seed and `next_fixture_index` from the last summary. An
interrupted fixture starts from its first block. If saving fails, the
checkpoint JSON is printed for manual capture. Each invocation gets a new
session directory.

Optional environment variables can be set in the test scheme or before invoking
the launcher. The launcher forwards them to the XCTest process.

| Variable | Default | Meaning |
| --- | --- | --- |
| `SOCCER_CAPTURE_SEED` | Random uint64 | Decimal or `0x` campaign seed |
| `SOCCER_CAPTURE_FIRST_FIXTURE` | `0` | Zero-based starting fixture for replay |
| `SOCCER_CAPTURE_RUNS` | `0` | Zero runs indefinitely; positive values stop after that many attempts |
| `SOCCER_CAPTURE_VERIFICATION_SAMPLES` | `262144` | Fresh blocks per predictor per run, 1–16,777,216 |
| `SOCCER_CAPTURE_OUTPUT` | Project directory above | Parent directory for the new session |

To reproduce a captured fixture, use its campaign seed and fixture index and
set the run count to 1. Keep its verification sample count and the same source
version. Run serially and disable Xcode test timeouts for the indefinite run.
The separate `CaptureWeakestPredictorReportingTests` class exercises accounting,
checkpoint serialization, and a bounded weak-encryption smoke run. Its smoke
reports go in `Statistical Outputs/ReportingTests/`.
