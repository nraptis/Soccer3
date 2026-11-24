# Overnight strong experiment

This document describes the historical two-shift sweep and its output format.
The current Cryptex runs one masked shift per layer. Its XCTest parity and
statistical suites run against that active plan.

Historical invocation:

```sh
"/Users/icarus/Desktop/Codex Maga/Soccer/Tools/run_strong_security_overnight.sh" "/Users/icarus/Desktop/Codex Maga/Soccer/SecurityResults/strong-overnight"
```

This builds an optimized native executable and runs for up to eight hours. It uses synthetic passwords/nonces, not user documents. It was built for the two-shift strong plan. Repeat the same command to resume. A changed source fingerprint or protocol requires a new output folder. A partial trial restarts; completed trials are retained. The eight-hour bound is checked between encryption calls; setup may finish before it stops. `caffeinate` prevents idle sleep during the run.

The campaign covers 64 fixed strong FlameToad vault plans using PasswordXOR mutations. First two fixtures reproduce the statistical regression inputs. Later fixtures vary passwords/nonces, templates, and contiguous/stride-8/stride-64 clusters, plus distributed unknown flags. Every layout balances all eight bit planes.

That strong vault had two rounds of four full-size layers. Each layer
runs four FlameToadCipher ciphers, PasswordXOR, two complementary masked byte
rotations, and PasswordXOR. One BitReverseKernel follows layer 3; there
is no final bit reversal. The two rounds reuse the same numeric row pairs,
with separate rotations and XOR material lanes.

The strong plan uses 32 FlameToads, 16 masked rotations, one bit reversal, and
16 full-size PasswordXOR mutations (65 cipher applications; 16 MiB material).
It consumes exactly 128 sampled-window rotations plus 16 masked byte rotations.
The three bit-plane selection words are accumulated from fresh `mRandom`
blocks during seeding, so passwords/nonces vary the grid as well as material
and rotations. TenShot uses the seeded grid first, then applies nine test-only
word deltas and rebuilds the vault with the same materials and rotations.

Configuration records include all eight layers, row pairs, four sampling
rotations per FlameToad (in 64-byte windows), both masked rotations (in bytes),
XOR material indices, all three bit-plane words, the `seeded-word-sums-v1`
bit-plane policy, the rotation-policy identifier, eighteen-job shuffle totals,
and the bit-reversal boundary. The
analyzer also accepts archived TreeFrog and Cryptex records. The historical
`ten_shot_diagnostic.cpp` is retained but retired from active execution.

The old TreeFrog whole-block parity invariant is checked separately by
`WholeBlockParityRecoveryTests`. `BitPlaneParityRecoveryTests` additionally
learns predictors between all 255 nonempty combinations of aggregate bit
planes, then checks them on independent blocks. A single FlameToad still
preserves aggregate bit-0 parity; its four identical packing functions are
translated copies. These full-vault tests include the boundary bit reversal.
This bounded single/two-bit search cannot
rule out larger or more complicated parity relationships. The rotation
sampler uses eighteen flat eight-value lists in Soccer3, with global
single-rotation duplicate/inverse exclusions. Each round has one list for its
eight masked shifts and two window lists per layer. Subset sums must differ
within each list; combinations spanning lists are unrestricted. The policy is
`flat-window-lists-forward-units-v4`: eighteen persistent base lists each receive
one forward partial shuffle per random-block generation. Strong allocates
1,156 bytes per list per call, totaling 790,704 across all lists and 38 calls.
Each 32 KiB random block contains eighteen equal 1,820-byte units (eight bytes
remain unused). Every unit also adds one distinct word to each of the sixteen
free-offset and three bit-plane accumulators, and reserves separate small-list
shuffle ranges. Selection prefers positions fixed by the final forward pass,
then scans its opposite tail or numeric candidates, with all collision checks.
Chosen arrays hold window indices; named Cryptex inputs hold final byte shifts,
validated after each accumulated word supplies its 1..63 offset.
This policy
does not sample uniformly from all valid sets.

Before fitting an attack, protocol 3 encrypts/decrypts the template to verify that the configured plan reverses; failure aborts instead of becoming a pass. This victim-side check is separate from the attacker budget.

Each trial uses 65 discovery queries, 4096 training queries, 4096 validation queries, 32768 held-out challenges, and 16384 fresh confirmation challenges. Predictions search individual ciphertext bits and two-bit parities. The attacker freezes the model before either challenge. Shuffled-label controls must pass. Significance uses the existing conservative tail bound and family alpha 1e-6, corrected for all 4096 planned flag hypotheses (64 fixtures × 64 flags), even if the run ends early. Confirmation uses the same correction; a challenge finding remains a finding even when confirmation is underpowered.

This is more extensive sampling of the existing statistical attack, not an exhaustive search or a new security definition. It cannot establish general security. Do not choose production parameters merely because they rank lower in this sample; assess any hypothesis on a separate campaign.

The build cache fingerprints the source, build script, compiler version and architecture, and records `bin/build_manifest.json`.

Outputs: `results.jsonl` (full configurations and predictors), `run_config.txt` (protocol/build identity), `ranking.csv`, `summary.json`, and `report.html`. The report ranks confirmed leakage, significant flags, then best observed prediction accuracy; current configurations include all eight layers, XOR assignments, masks, row pairs and byte rotations. This is observational: parameters differ together across fixtures. Do not interpret differences across configurations as isolated causal effects.

Exit codes: 0 completed without detected challenge leakage; 2 at least one completed trial found leakage; 3 incomplete due to time/signal; 1 execution/control failure. Missing trials and API errors are never security passes. The report distinguishes significant from confirmed flags; zero exact recovered plaintexts does not negate bit leakage. `seconds` includes attack fitting and is not a cipher speed benchmark.

To refresh a report while a run is active:

```sh
python3 "/Users/icarus/Desktop/Codex Maga/Soccer/Tools/analyze_strong_security_sweep.py" "/path/to/results"
```

The public API still repeats independent 1 MiB encryption using one configured plan, with no added per-block keys or material. These changes alter newly generated ciphertext compared with earlier mutator-category layouts; the current version parameter does not reconstruct old layouts.

Protocol 3 uses one trial per fixture. Older protocol result folders cannot be resumed with this build; their archived source and results remain separate.
