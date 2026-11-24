//
//  ByteStripStitch.hpp
//  ScrambleTests
//
//  Created by Amada Badger on 11/11/26.
//

#ifndef ByteStripStitch_hpp
#define ByteStripStitch_hpp

#include "ByteWindow.hpp"
#include "ByteWindowBitStrip.hpp"

// PACKING SKETCHBOOK: TWO ROWS FROM EACH OF FOUR WINDOWS
//
// A source window has 64 BYTES, hence eight horizontal 64-BIT strips.
// Eight strips (two from each window) contain 512 bits and fill 64 output bytes.
// A hypothetical 32-byte window has 32-bit strips: 4 * 2 * 32 = 256 bits,
// filling 32 output bytes. BYTE_WINDOW_SIZE remains 64 in these mock functions.
//
// Exactly 64 distinct position symbols, shown in groups of eight:
//   abcdefgh ijklmnop qrstuvwx yzABCDEF GHIJKLMN OPQRSTUV WXYZ0123 456789+/
// A symbol labels a source BYTE position, not a literal bit value. The two
// occurrences of 'a' below are different bits: row 2 at byte a, row 5 at byte a.
// '-' means the bit is not sampled; it does not mean its value is zero.
//
// Full 64-byte source window (columns increase left to right):
//   row 7: -------- -------- -------- -------- -------- -------- -------- --------
//   row 6: -------- -------- -------- -------- -------- -------- -------- --------
//   row 5: abcdefgh ijklmnop qrstuvwx yzABCDEF GHIJKLMN OPQRSTUV WXYZ0123 456789+/
//   row 4: -------- -------- -------- -------- -------- -------- -------- --------
//   row 3: -------- -------- -------- -------- -------- -------- -------- --------
//   row 2: abcdefgh ijklmnop qrstuvwx yzABCDEF GHIJKLMN OPQRSTUV WXYZ0123 456789+/
//   row 1: -------- -------- -------- -------- -------- -------- -------- --------
//   row 0: -------- -------- -------- -------- -------- -------- -------- --------
//
// Full hypothetical 32-byte source window:
//   row 7: -------- -------- -------- --------
//   row 6: -------- -------- -------- --------
//   row 5: abcdefgh ijklmnop qrstuvwx yzABCDEF
//   row 4: -------- -------- -------- --------
//   row 3: -------- -------- -------- --------
//   row 2: abcdefgh ijklmnop qrstuvwx yzABCDEF
//   row 1: -------- -------- -------- --------
//   row 0: -------- -------- -------- --------
//
// These pictures apply independently to each of the four sampled windows.
// Rows 2 and 5 are only an example; the two selected row indices can differ.
// Within one reversible cipher stage, select the SAME two protected row
// indices in every sampled window and leave those rows unchanged globally.
//
// HOW TWO ROWS FILL AN EIGHT-BIT BYTE
//
// For a quartet 'abcd', the eight output bits, low bit -> high bit, are:
//   StitchA: a2 a5 b2 b5 c2 c5 d2 d5
//   StitchB: d2 d5 a2 a5 b2 b5 c2 c5
//   StitchC: c2 c5 d2 d5 a2 a5 b2 b5
//   StitchD: b2 b5 c2 c5 d2 d5 a2 a5
// Thus a2 lands at bit 0, 2, 4, 6; a5 at bit 1, 3, 5, 7.
// EVERY sampled bit changes bit position across these four functions, while
// staying in the same output byte. The four functions retain the same source
// neighborhoods; this is bit-significance variety, not wider byte diffusion.
//
// FULL 32-BYTE OUTPUT EXAMPLE, STITCH A
//
// W0/W1/W2/W3 are the four sampled windows (arguments A/B/C/D).
// EACH bracket below is ONE byte: four symbols, two sampled bits per symbol.
// Read across each line, then down. All 32 output bytes are shown:
//   [W0:abcd] [W1:abcd] [W2:abcd] [W3:abcd]
//   [W0:efgh] [W1:efgh] [W2:efgh] [W3:efgh]
//   [W0:ijkl] [W1:ijkl] [W2:ijkl] [W3:ijkl]
//   [W0:mnop] [W1:mnop] [W2:mnop] [W3:mnop]
//   [W0:qrst] [W1:qrst] [W2:qrst] [W3:qrst]
//   [W0:uvwx] [W1:uvwx] [W2:uvwx] [W3:uvwx]
//   [W0:yzAB] [W1:yzAB] [W2:yzAB] [W3:yzAB]
//   [W0:CDEF] [W1:CDEF] [W2:CDEF] [W3:CDEF]
// For a 64-byte output, continue with GHIJ KLMN OPQR STUV WXYZ 0123 4567 89+/.
// B/C/D use the same window interleave with their corresponding quartets below.
//
// TWELVE CANDIDATES
//
// Each line lists ALL source positions for ONE window, in output bit-pair
// order. Every space-delimited quartet becomes eight bits (one packed byte).
// Apply the same layout to each window and interleave W0,W1,W2,W3 as above.
// The 32-position examples use the same local rule as the full 64-position
// examples. No input position is duplicated or omitted.
//
// 01-07: each original quartet stays together. NEON can change its bit order
// with shift/mask constants, using the SAME instruction shape as StitchA.
// 08-12: move positions across quartet boundaries. One fixed vqtbl1q_u8 per
// 16-byte input vector can implement any listed permutation, then use the
// same packing core. Specialized shuffle instructions may also be useful.
// Candidate 05 reverses each row pair to [row5,row2]; all others use [row2,row5].
//
// 01 StitchA: adjacent
//   64: abcd efgh ijkl mnop qrst uvwx yzAB CDEF GHIJ KLMN OPQR STUV WXYZ 0123 4567 89+/
//   32: abcd efgh ijkl mnop qrst uvwx yzAB CDEF
//
// 02 StitchB: pair rotate +1
//   64: dabc hefg lijk pmno tqrs xuvw ByzA FCDE JGHI NKLM ROPQ VSTU ZWXY 3012 7456 /89+
//   32: dabc hefg lijk pmno tqrs xuvw ByzA FCDE
//
// 03 StitchC: pair rotate +2
//   64: cdab ghef klij opmn stqr wxuv AByz EFCD IJGH MNKL QROP UVST YZWX 2301 6745 +/89
//   32: cdab ghef klij opmn stqr wxuv AByz EFCD
//
// 04 StitchD: pair rotate +3
//   64: bcda fghe jkli nopm rstq vwxu zABy DEFC HIJG LMNK PQRO TUVS XYZW 1230 5674 9+/8
//   32: bcda fghe jkli nopm rstq vwxu zABy DEFC
//
// 05 Adjacent, swap the two rows
//   64: abcd efgh ijkl mnop qrst uvwx yzAB CDEF GHIJ KLMN OPQR STUV WXYZ 0123 4567 89+/
//   32: abcd efgh ijkl mnop qrst uvwx yzAB CDEF
//
// 06 Reverse each quartet
//   64: dcba hgfe lkji ponm tsrq xwvu BAzy FEDC JIHG NMLK RQPO VUTS ZYXW 3210 7654 /+98
//   32: dcba hgfe lkji ponm tsrq xwvu BAzy FEDC
//
// 07 Swap neighbors in each quartet
//   64: badc fehg jilk nmpo rqts vuxw zyBA DCFE HGJI LKNM PORQ TSVU XWZY 1032 5476 98/+
//   32: badc fehg jilk nmpo rqts vuxw zyBA DCFE
//
// 08 Even / odd
//   64: aceg bdfh ikmo jlnp qsuw rtvx yACE zBDF GIKM HJLN OQSU PRTV WY02 XZ13 468+ 579/
//   32: aceg bdfh ikmo jlnp qsuw rtvx yACE zBDF
//
// 09 Stride four (4 x 4 transpose)
//   64: aeim bfjn cgko dhlp quyC rvzD swAE txBF GKOS HLPT IMQU JNRV W048 X159 Y26+ Z37/
//   32: aeim bfjn cgko dhlp quyC rvzD swAE txBF
//
// 10 Diagonals
//   64: afkp bglm chin dejo qvAF rwBC sxyD tuzE GLQV HMRS INOT JKPU W16/ X278 Y349 Z05+
//   32: afkp bglm chin dejo qvAF rwBC sxyD tuzE
//
// 11 Interleave the two halves
//   64: aibj ckdl emfn gohp qyrz sAtB uCvD wExF GOHP IQJR KSLT MUNV W4X5 Y6Z7 0819 2+3/
//   32: aibj ckdl emfn gohp qyrz sAtB uCvD wExF
//
// 12 Reverse each 16-position chunk
//   64: ponm lkji hgfe dcba FEDC BAzy xwvu tsrq VUTS RQPO NMLK JIHG /+98 7654 3210 ZYXW
//   32: ponm lkji hgfe dcba FEDC BAzy xwvu tsrq
//
// NEON / SIMD IMPLEMENTATION NOTES
//
// These bool-strip functions are readable reference implementations. A fast
// cipher should extract directly from raw source bytes, avoiding bool arrays.
// AArch64 NEON has 16 byte lanes in a 128-bit vector: "groups of eight" are
// useful for drawing OUTPUT BITS, not a reason to use eight-byte input loads.
// With two rows, four source bytes already supply eight bits.
//
// For A/B/C/D and source-byte position j in a quartet:
//   outputPair = (j + rotation) % 4, with rotation = 0,1,2,3.
//   shift1 = 2*outputPair - row1; shift2 = 2*outputPair + 1 - row2.
//   weight1 = 1 << (2*outputPair); weight2 = weight1 << 1.
// Vector shifts and masks place the selected bits at nonoverlapping weights.
// Two levels of pairwise addition join four source positions into one byte.
// Four 16-byte input loads yield a 16-byte packed vector per 64-byte window.
// Four windows give four vectors. vst4q_u8 can interleave them, or a cipher
// can use them directly with destination lanes loaded by vld4q_u8.
// For 32-byte windows, two 16-byte input loads yield eight packed bytes;
// four such vectors can be interleaved with vst4_u8.
//
// A and its pair rotations have the same operation count, but actual speed
// still depends on compiler scheduling and the target CPU. 64-byte windows
// naturally fill each 16-byte packed vector. 32-byte windows halve work per
// window but double the number of windows for a fixed-size block. They do not
// guarantee equal or better throughput: address/wrap overhead and key-cache
// layout matter. Compare equal TOTAL byte counts, including the full stage.
//
// Four windows with two rows reuse each source load for both extracted bits.
// Eight windows with one row require more source streams in a direct packer;
// a cached implementation has different costs. Four offsets in each of two
// sequential stages give eight offset selections, but different dependencies
// from eight offsets in one stage: stage two samples stage one's result.
//
// Packing stops before the nonlinear gate, protected-bit clearing, and update.
// The eventual cipher must reduce/combine eight packed bits into six writable
// key bits, preserve the two sampled rows, and apply an invertible update.
//
// Intrinsic reference:
// https://arm-software.github.io/acle/neon_intrinsics/advsimd.html

class ByteStripStitch {
public:
    // A/B/C/D in parameter names identify sampled windows; 1/2 identify rows.
    // Output bytes alternate these four windows. A is FourToad's raw packing.
    // B/C/D rotate each byte's four bit-pairs by one/two/three positions.
    static ByteWindow StitchA(ByteWindowBitStrip pStripA1,
                              ByteWindowBitStrip pStripA2,
                              ByteWindowBitStrip pStripB1,
                              ByteWindowBitStrip pStripB2,
                              ByteWindowBitStrip pStripC1,
                              ByteWindowBitStrip pStripC2,
                              ByteWindowBitStrip pStripD1,
                              ByteWindowBitStrip pStripD2);

    static ByteWindow StitchB(ByteWindowBitStrip pStripA1,
                              ByteWindowBitStrip pStripA2,
                              ByteWindowBitStrip pStripB1,
                              ByteWindowBitStrip pStripB2,
                              ByteWindowBitStrip pStripC1,
                              ByteWindowBitStrip pStripC2,
                              ByteWindowBitStrip pStripD1,
                              ByteWindowBitStrip pStripD2);

    static ByteWindow StitchC(ByteWindowBitStrip pStripA1,
                              ByteWindowBitStrip pStripA2,
                              ByteWindowBitStrip pStripB1,
                              ByteWindowBitStrip pStripB2,
                              ByteWindowBitStrip pStripC1,
                              ByteWindowBitStrip pStripC2,
                              ByteWindowBitStrip pStripD1,
                              ByteWindowBitStrip pStripD2);

    static ByteWindow StitchD(ByteWindowBitStrip pStripA1,
                              ByteWindowBitStrip pStripA2,
                              ByteWindowBitStrip pStripB1,
                              ByteWindowBitStrip pStripB2,
                              ByteWindowBitStrip pStripC1,
                              ByteWindowBitStrip pStripC2,
                              ByteWindowBitStrip pStripD1,
                              ByteWindowBitStrip pStripD2);
};

#endif /* ByteStripStitch_hpp */
