#pragma once
#include "GateCipher.hpp"
#include <algorithm>
#include <array>
#include <cstdint>
#include <vector>

// Independent reference: brute-force multiplicative inverse in GF(2^8),
// followed by the FIPS 197 affine transform. No production tables are read.
inline std::array<std::uint8_t, 256> GateReference() {
    const auto multiply = [](unsigned a, unsigned b) {
        unsigned result = 0;
        while (b) {
            if (b & 1U) result ^= a;
            a <<= 1U;
            if (a & 256U) a ^= 0x11bU;
            b >>= 1U;
        }
        return result;
    };
    std::array<std::uint8_t, 256> result{};
    for (unsigned x = 0; x < 256; ++x) {
        unsigned inverse = 0;
        if (x) for (unsigned candidate = 1; candidate < 256; ++candidate) {
            if (multiply(x, candidate) == 1) { inverse = candidate; break; }
        }
        unsigned y = inverse ^ 0x63U;
        for (unsigned n = 1; n <= 4; ++n) y ^= ((inverse << n) | (inverse >> (8U - n))) & 255U;
        result[x] = static_cast<std::uint8_t>(y);
    }
    return result;
}

// Independent mapping and buffer checks; not app code.
inline const char *CheckGateCipher() {
    GateCipher cipher{};
    const auto table = GateReference();
    constexpr std::uint8_t firstRow[] = {0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76};
    constexpr std::uint8_t firstColumn[] = {0x63,0xca,0xb7,0x04,0x09,0x53,0xd0,0x51,0xcd,0x60,0xe0,0xe7,0xba,0x70,0xe1,0x8c};
    for (unsigned i = 0; i < 16; ++i) {
        if (table[i] != firstRow[i] || table[16*i] != firstColumn[i]) return "FIPS reference";
    }
    std::array<bool, 256> seen{};
    for (auto value : table) { if (seen[value]) return "reference is not bijective"; seen[value] = true; }
    const std::size_t lengths[] = {256U,512U,768U,1024U,1048576U};
    for (const auto length : lengths) {
        const unsigned shifts = length == 256 ? 256 : 1;
        for (unsigned shift = 0; shift < shifts; ++shift) {
            std::vector<std::uint8_t> source(length+16,0xC3), output(length+16,0xA5), restored(length+16,0xB6);
            for (std::size_t i = 0; i < length; ++i) source[i+1] = static_cast<std::uint8_t>(i + shift);
            const auto original = source;
            std::array<std::uint8_t, 17> worker{};
            const auto originalWorker = worker;
            CipherErrorCode error = CipherErrorCode::kNullCipher;
            if (!cipher.SealData(source.data()+1, worker.data(), output.data()+3, length, &error) || error != CipherErrorCode::kNone) return "SealData";
            for (std::size_t i = 0; i < length; ++i) if (output[i+3] != table[source[i+1]]) return "SubBytes/reference mismatch or byte permutation";
            if (!cipher.UnsealData(output.data()+3, nullptr, restored.data()+5, length, &error) || error != CipherErrorCode::kNone) return "UnsealData";
            if (!std::equal(source.begin()+1, source.begin()+1+length, restored.begin()+5)) return "round trip";
            if (source != original || worker != originalWorker) return "source/worker changed";
            if (!std::all_of(output.begin(), output.begin()+3, [](auto x){return x==0xA5;}) ||
                !std::all_of(output.begin()+3+length, output.end(), [](auto x){return x==0xA5;}) ||
                !std::all_of(restored.begin(), restored.begin()+5, [](auto x){return x==0xB6;}) ||
                !std::all_of(restored.begin()+5+length, restored.end(), [](auto x){return x==0xB6;})) return "boundary write";
            // Inverse accepts arbitrary bytes, not only this run's ciphertext.
            if (!cipher.UnsealData(source.data()+1, nullptr, output.data()+3, length, nullptr)) return "inverse arbitrary input";
            for (std::size_t i = 0; i < length; ++i) if (table[output[i+3]] != source[i+1]) return "inverse reference";
        }
    }
    cipher.Zero();
    std::array<std::uint8_t, 256> source{}, output{};
    source.fill(0x53);
    if (!cipher.SealData(source.data(), nullptr, output.data(), source.size(), nullptr) ||
        !std::all_of(output.begin(), output.end(), [](auto value) { return value == 0xed; })) return "Zero changed stateless transform";
    return nullptr;
}
