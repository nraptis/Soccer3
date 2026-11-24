#ifndef SOCCER_BOG_HPP_
#define SOCCER_BOG_HPP_

#include "BogCipher.hpp"

// First suffix: hot pair A/B/C/D = 11000000/00110000/00001100/00000011.
// Second suffix: pack order A..F = ABC, ACB, BAC, BCA, CAB, CBA.
using BogAA = BogCipher<6U,0U>;
using BogAB = BogCipher<6U,1U>;
using BogAC = BogCipher<6U,2U>;
using BogAD = BogCipher<6U,3U>;
using BogAE = BogCipher<6U,4U>;
using BogAF = BogCipher<6U,5U>;
using BogBA = BogCipher<4U,0U>;
using BogBB = BogCipher<4U,1U>;
using BogBC = BogCipher<4U,2U>;
using BogBD = BogCipher<4U,3U>;
using BogBE = BogCipher<4U,4U>;
using BogBF = BogCipher<4U,5U>;
using BogCA = BogCipher<2U,0U>;
using BogCB = BogCipher<2U,1U>;
using BogCC = BogCipher<2U,2U>;
using BogCD = BogCipher<2U,3U>;
using BogCE = BogCipher<2U,4U>;
using BogCF = BogCipher<2U,5U>;
using BogDA = BogCipher<0U,0U>;
using BogDB = BogCipher<0U,1U>;
using BogDC = BogCipher<0U,2U>;
using BogDD = BogCipher<0U,3U>;
using BogDE = BogCipher<0U,4U>;
using BogDF = BogCipher<0U,5U>;

extern template class BogCipher<6U,0U>;
extern template class BogCipher<6U,1U>;
extern template class BogCipher<6U,2U>;
extern template class BogCipher<6U,3U>;
extern template class BogCipher<6U,4U>;
extern template class BogCipher<6U,5U>;
extern template class BogCipher<4U,0U>;
extern template class BogCipher<4U,1U>;
extern template class BogCipher<4U,2U>;
extern template class BogCipher<4U,3U>;
extern template class BogCipher<4U,4U>;
extern template class BogCipher<4U,5U>;
extern template class BogCipher<2U,0U>;
extern template class BogCipher<2U,1U>;
extern template class BogCipher<2U,2U>;
extern template class BogCipher<2U,3U>;
extern template class BogCipher<2U,4U>;
extern template class BogCipher<2U,5U>;
extern template class BogCipher<0U,0U>;
extern template class BogCipher<0U,1U>;
extern template class BogCipher<0U,2U>;
extern template class BogCipher<0U,3U>;
extern template class BogCipher<0U,4U>;
extern template class BogCipher<0U,5U>;

#endif // SOCCER_BOG_HPP_
