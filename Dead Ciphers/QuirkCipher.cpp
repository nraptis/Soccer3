#include "QuirkHigh.hpp"
#include "QuirkLow.hpp"

// Emit every independent implementation in the library, even before the
// composer selects them. Each has its own fixed-mask, fixed-direction kernel.
template class QuirkCipher<true, false, false, false>;
template class QuirkCipher<true, false, false, true>;
template class QuirkCipher<true, false, true, false>;
template class QuirkCipher<true, false, true, true>;
template class QuirkCipher<true, true, false, false>;
template class QuirkCipher<true, true, false, true>;
template class QuirkCipher<true, true, true, false>;
template class QuirkCipher<true, true, true, true>;
template class QuirkCipher<false, false, false, false>;
template class QuirkCipher<false, false, false, true>;
template class QuirkCipher<false, false, true, false>;
template class QuirkCipher<false, false, true, true>;
template class QuirkCipher<false, true, false, false>;
template class QuirkCipher<false, true, false, true>;
template class QuirkCipher<false, true, true, false>;
template class QuirkCipher<false, true, true, true>;
