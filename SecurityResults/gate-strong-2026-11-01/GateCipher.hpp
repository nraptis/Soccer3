#ifndef SOCCER_GATE_CIPHER_HPP_
#define SOCCER_GATE_CIPHER_HPP_

#include <array>
#include <cstddef>
#include <cstdint>
#include "Cipher.hpp"
#include "Jelly.hpp"
#if !IGNORE_SIMD && defined(__SSSE3__)
#include <immintrin.h>
#endif

namespace GateCipherDetail {
// FIPS 197, Table 4. AES SubBytes only, with no key or byte permutation.
// https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197-upd1.pdf
alignas(64) inline constexpr std::array<std::uint8_t, 256> kSBox = {
    0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
    0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
    0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
    0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
    0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
    0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
    0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
    0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
    0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
    0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
    0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
    0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
    0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
    0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
    0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
    0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16
};

constexpr std::array<std::uint8_t, 256> InvertSBox() {
    std::array<std::uint8_t, 256> result{};
    for (std::size_t i = 0; i < kSBox.size(); ++i) result[kSBox[i]] = static_cast<std::uint8_t>(i);
    return result;
}
alignas(64) inline constexpr auto kInverseSBox = InvertSBox();
} // namespace GateCipherDetail

// GateCipher{} maps every byte x to AES_SBox[x]; Unseal uses AES_InvSBox[x].
// These are inverse operations, NOT the same operation applied twice.
// No key/material lanes, masks, rotations, allocation, worker use or call state.
// Supports any byte length and unaligned, non-overlapping buffers; zero length
// succeeds with null buffers. Zero() is inherited and does nothing.
//
// This is a public nonlinear component, not standalone encryption or full AES.
// It adds no cross-byte diffusion. Use it between keyed operations and movers;
// a public substitution appended to ciphertext can simply be undone by anyone.
// Hardware and vector-table paths avoid data-indexed memory lookups. The scalar
// fallback/tail uses fixed-operation GF arithmetic instead of a cache-indexed LUT.
class GateCipher final : public Cipher {
public:
    GateCipher() : Cipher(CipherType::kGateCipher) {}

    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply<false>(pSource, pDestination, pLength, pErrorCode);
    }
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength,
                    CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply<true>(pSource, pDestination, pLength, pErrorCode);
    }
    static constexpr const char *BackendName() {
#if JELLY_USE_NEON && defined(__aarch64__) && defined(__ARM_FEATURE_AES)
        return "ARM AES + NEON (SubBytes only)";
#elif !IGNORE_SIMD && defined(__AES__) && defined(__SSSE3__)
        return "AES-NI + SSSE3 (SubBytes only)";
#elif JELLY_USE_NEON && defined(__aarch64__)
        return "NEON register-table lookup";
#elif !IGNORE_SIMD && defined(__SSSE3__)
        return "SSSE3 register-table lookup";
#else
        return "scalar GF arithmetic";
#endif
    }

private:
    static std::uint8_t Multiply(std::uint8_t a, std::uint8_t b) {
        unsigned result = 0;
        for (unsigned i = 0; i < 8; ++i) {
            result ^= a & (0U - (b & 1U));
            a = static_cast<std::uint8_t>((a << 1U) ^ (0x1bU & (0U - (a >> 7U))));
            b >>= 1U;
        }
        return static_cast<std::uint8_t>(result);
    }
    static std::uint8_t Inverse(std::uint8_t x) {
        // x^254 in GF(2^8), with 0 mapping to 0. No data-dependent branches.
        const auto x2 = Multiply(x, x), x4 = Multiply(x2, x2), x8 = Multiply(x4, x4);
        const auto x16 = Multiply(x8, x8), x32 = Multiply(x16, x16);
        const auto x64 = Multiply(x32, x32), x128 = Multiply(x64, x64);
        return Multiply(Multiply(Multiply(x2, x4), Multiply(x8, x16)),
                        Multiply(Multiply(x32, x64), x128));
    }
    static std::uint8_t Rotate(std::uint8_t x, unsigned n) {
        return static_cast<std::uint8_t>((x << n) | (x >> (8U - n)));
    }
    template <bool Unseal>
    static std::uint8_t Scalar(std::uint8_t x) {
        if constexpr (Unseal) return Inverse(Rotate(x, 1) ^ Rotate(x, 3) ^ Rotate(x, 6) ^ 0x05U);
        const auto y = Inverse(x);
        return y ^ Rotate(y, 1) ^ Rotate(y, 2) ^ Rotate(y, 3) ^ Rotate(y, 4) ^ 0x63U;
    }

    template <bool Unseal>
    static bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
                      std::size_t pLength, CipherErrorCode *pErrorCode) {
        if (pLength == 0) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone); return true; }
        if (!pSource || !pDestination) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer); return false; }
        const auto a = reinterpret_cast<std::uintptr_t>(pSource);
        const auto b = reinterpret_cast<std::uintptr_t>(pDestination);
        if ((a <= b ? b - a : a - b) < pLength) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer); return false;
        }
        std::size_t i = 0;
#if JELLY_USE_NEON && defined(__aarch64__) && defined(__ARM_FEATURE_AES)
        // AESE/AESD with a zero key also shuffle bytes. Undo that permutation
        // so each result remains in the same byte position on every backend.
        const uint8x16_t undoShiftRows = {0,13,10,7,4,1,14,11,8,5,2,15,12,9,6,3};
        const uint8x16_t undoInverseShiftRows = {0,5,10,15,4,9,14,3,8,13,2,7,12,1,6,11};
        const auto shuffle = Unseal ? undoInverseShiftRows : undoShiftRows;
        const auto zero = vdupq_n_u8(0);
        for (; pLength - i >= 16; i += 16) {
            const auto x = vld1q_u8(pSource + i);
            const auto y = Unseal ? vaesdq_u8(x, zero) : vaeseq_u8(x, zero);
            vst1q_u8(pDestination + i, vqtbl1q_u8(y, shuffle));
        }
#elif !IGNORE_SIMD && defined(__AES__) && defined(__SSSE3__)
        const auto shuffle = Unseal ? _mm_setr_epi8(0,5,10,15,4,9,14,3,8,13,2,7,12,1,6,11)
                                    : _mm_setr_epi8(0,13,10,7,4,1,14,11,8,5,2,15,12,9,6,3);
        const auto zero = _mm_setzero_si128();
        for (; pLength - i >= 16; i += 16) {
            const auto x = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + i));
            const auto y = Unseal ? _mm_aesdeclast_si128(x, zero) : _mm_aesenclast_si128(x, zero);
            _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + i), _mm_shuffle_epi8(y, shuffle));
        }
#elif JELLY_USE_NEON && defined(__aarch64__)
        const auto &table = Unseal ? GateCipherDetail::kInverseSBox : GateCipherDetail::kSBox;
        const auto t0 = vld1q_u8_x4(table.data()), t1 = vld1q_u8_x4(table.data() + 64);
        const auto t2 = vld1q_u8_x4(table.data() + 128), t3 = vld1q_u8_x4(table.data() + 192);
        for (; pLength - i >= 16; i += 16) {
            const auto x = vld1q_u8(pSource + i);
            const auto y0 = vqtbl4q_u8(t0, x);
            const auto y1 = vqtbl4q_u8(t1, vsubq_u8(x, vdupq_n_u8(64)));
            const auto y2 = vqtbl4q_u8(t2, vsubq_u8(x, vdupq_n_u8(128)));
            const auto y3 = vqtbl4q_u8(t3, vsubq_u8(x, vdupq_n_u8(192)));
            vst1q_u8(pDestination + i, vorrq_u8(vorrq_u8(y0, y1), vorrq_u8(y2, y3)));
        }
#elif !IGNORE_SIMD && defined(__SSSE3__)
        const auto &table = Unseal ? GateCipherDetail::kInverseSBox : GateCipherDetail::kSBox;
        const auto nibble = _mm_set1_epi8(15);
        for (; pLength - i >= 16; i += 16) {
            const auto x = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + i));
            const auto low = _mm_and_si128(x, nibble);
            const auto high = _mm_and_si128(_mm_srli_epi16(x, 4), nibble);
            auto y = _mm_setzero_si128();
            // Visit ALL sixteen table rows, independent of the input bytes.
            for (int row = 0; row < 16; ++row) {
                const auto values = _mm_loadu_si128(reinterpret_cast<const __m128i *>(table.data() + row * 16));
                const auto selected = _mm_cmpeq_epi8(high, _mm_set1_epi8(static_cast<char>(row)));
                y = _mm_or_si128(y, _mm_and_si128(_mm_shuffle_epi8(values, low), selected));
            }
            _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + i), y);
        }
#endif
        for (; i < pLength; ++i) pDestination[i] = Scalar<Unseal>(pSource[i]);
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
};
#endif // SOCCER_GATE_CIPHER_HPP_
