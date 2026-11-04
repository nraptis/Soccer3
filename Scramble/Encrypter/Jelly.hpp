//
//  Jelly.h
//  JellyCiphers
//
//  Created by icarus black on 7/1/26.
//

#ifndef Jelly_h
#define Jelly_h

#ifndef IGNORE_SIMD
#define IGNORE_SIMD 0
#endif

#if !IGNORE_SIMD && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#define JELLY_USE_NEON 1
#else
#define JELLY_USE_NEON 0
#endif

#if !IGNORE_SIMD && (defined(__AVX2__) || defined(__SSSE3__))
#define JELLY_USE_SIMD 1
#else
#define JELLY_USE_SIMD 0
#endif

#if JELLY_USE_NEON
#include <arm_neon.h>
#endif

#if JELLY_USE_SIMD
#include <immintrin.h>
#endif

#define SOCCER_BLOCK_SIZE 1048576
#define SOCCER_BLOCK_QUARTER 262144

#endif /* Jelly_h */
