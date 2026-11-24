#ifndef SOCCER_QUIRK_LOW_HPP_
#define SOCCER_QUIRK_LOW_HPP_

#include "QuirkCipher.hpp"

// Preserve/sample the LOW nibble; add the key into the HIGH nibble mod 16.
// A..H directions: FFF, FFR, FRF, FRR, RFF, RFR, RRF, RRR.
using QuirkLowA = QuirkCipher<false, false, false, false>;
using QuirkLowB = QuirkCipher<false, false, false, true>;
using QuirkLowC = QuirkCipher<false, false, true, false>;
using QuirkLowD = QuirkCipher<false, false, true, true>;
using QuirkLowE = QuirkCipher<false, true, false, false>;
using QuirkLowF = QuirkCipher<false, true, false, true>;
using QuirkLowG = QuirkCipher<false, true, true, false>;
using QuirkLowH = QuirkCipher<false, true, true, true>;

extern template class QuirkCipher<false, false, false, false>;
extern template class QuirkCipher<false, false, false, true>;
extern template class QuirkCipher<false, false, true, false>;
extern template class QuirkCipher<false, false, true, true>;
extern template class QuirkCipher<false, true, false, false>;
extern template class QuirkCipher<false, true, false, true>;
extern template class QuirkCipher<false, true, true, false>;
extern template class QuirkCipher<false, true, true, true>;

#endif
