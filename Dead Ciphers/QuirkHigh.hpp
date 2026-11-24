#ifndef SOCCER_QUIRK_HIGH_HPP_
#define SOCCER_QUIRK_HIGH_HPP_

#include "QuirkCipher.hpp"

// Preserve/sample the HIGH nibble; add the key into the LOW nibble mod 16.
// A..H directions: FFF, FFR, FRF, FRR, RFF, RFR, RRF, RRR.
using QuirkHighA = QuirkCipher<true, false, false, false>;
using QuirkHighB = QuirkCipher<true, false, false, true>;
using QuirkHighC = QuirkCipher<true, false, true, false>;
using QuirkHighD = QuirkCipher<true, false, true, true>;
using QuirkHighE = QuirkCipher<true, true, false, false>;
using QuirkHighF = QuirkCipher<true, true, false, true>;
using QuirkHighG = QuirkCipher<true, true, true, false>;
using QuirkHighH = QuirkCipher<true, true, true, true>;

extern template class QuirkCipher<true, false, false, false>;
extern template class QuirkCipher<true, false, false, true>;
extern template class QuirkCipher<true, false, true, false>;
extern template class QuirkCipher<true, false, true, true>;
extern template class QuirkCipher<true, true, false, false>;
extern template class QuirkCipher<true, true, false, true>;
extern template class QuirkCipher<true, true, true, false>;
extern template class QuirkCipher<true, true, true, true>;

#endif
