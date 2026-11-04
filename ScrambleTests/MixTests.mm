//
//  MixTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/6/26.
//


#import <XCTest/XCTest.h>
#include "TwistMix16.hpp"
#include "TwistMix32.hpp"
#include "TwistMix64.hpp"

#include <cstdint>
#include <unordered_set>

namespace {

std::uint32_t InverseMix32A(std::uint32_t pValue) {
    pValue ^= pValue >> 16U;
    pValue *= 0x7ED1B41DU;
    pValue ^= pValue >> 13U;
    pValue ^= pValue >> 26U;
    pValue *= 0xA5CB9243U;
    pValue ^= pValue >> 16U;
    return pValue;
}

std::uint32_t InverseMix32B(std::uint32_t pValue) {
    pValue ^= pValue >> 15U;
    pValue ^= pValue >> 30U;
    pValue *= 0x97132227U;
    pValue ^= pValue >> 15U;
    pValue ^= pValue >> 30U;
    pValue *= 0x333C4925U;
    pValue ^= pValue >> 16U;
    return pValue;
}

std::uint32_t InverseMix32C(std::uint32_t pValue) {
    pValue ^= pValue >> 16U;
    pValue *= 0x43021123U;
    pValue ^= pValue >> 15U;
    pValue ^= pValue >> 30U;
    pValue *= 0x1D69E2A5U;
    pValue ^= pValue >> 16U;
    return pValue;
}

std::uint64_t InverseMix64A(std::uint64_t pValue) {
    pValue ^= pValue >> 31U;
    pValue ^= pValue >> 62U;
    pValue *= 0x319642B2D24D8EC3ULL;
    pValue ^= pValue >> 27U;
    pValue ^= pValue >> 54U;
    pValue *= 0x96DE1B173F119089ULL;
    pValue ^= pValue >> 30U;
    pValue ^= pValue >> 60U;
    return pValue;
}

}


@interface MixTests : XCTestCase

@end

@implementation MixTests

- (void)test_Mix16 {

    const std::uint64_t aValueCount = 65536ULL;
    std::unordered_set<std::uint16_t> aSet;
    for (std::uint64_t aValue=0; aValue<aValueCount; aValue++) {
        std::uint16_t aNumber = static_cast<std::uint16_t>(aValue);
        aNumber = TwistMix16::DiffuseA(aNumber);
        aSet.insert(aNumber);
    }
    
    if (aSet.size() != aValueCount) {
        XCTFail("test_Mix16: got %zu unique values, expected 65536", aSet.size());
        return;
    }
    
    printf("test_Mix16: got %zu unique values, correct", aSet.size());
}

- (void)test_Mix32_A {

    const std::uint64_t aValueCount = 4294967296ULL;
    std::uint64_t aCount = 0;
    for (std::uint64_t aValue=0; aValue<aValueCount; aValue++) {
        std::uint32_t aNumber = static_cast<std::uint32_t>(aValue);
        aNumber = TwistMix32::DiffuseA(aNumber);
        if (InverseMix32A(aNumber) != static_cast<std::uint32_t>(aValue)) {
            XCTFail("test_Mix32_A: failed to recover input %llu.", aValue);
            return;
        }
        aCount++;
    }
    
    if (aCount != aValueCount) {
        XCTFail("test_Mix32_A: got %llu unique values, expected 4294967296", aCount);
        return;
    }
    
    printf("test_Mix32_A: got %llu unique values, correct", aCount);
}

- (void)test_Mix32_B {

    const std::uint64_t aValueCount = 4294967296ULL;
    std::uint64_t aCount = 0;
    for (std::uint64_t aValue=0; aValue<aValueCount; aValue++) {
        std::uint32_t aNumber = static_cast<std::uint32_t>(aValue);
        aNumber = TwistMix32::DiffuseB(aNumber);
        if (InverseMix32B(aNumber) != static_cast<std::uint32_t>(aValue)) {
            XCTFail("test_Mix32_B: failed to recover input %llu.", aValue);
            return;
        }
        aCount++;
    }
    
    if (aCount != aValueCount) {
        XCTFail("test_Mix32_B: got %llu unique values, expected 4294967296", aCount);
        return;
    }
    
    printf("test_Mix32_B: got %llu unique values, correct", aCount);
}

- (void)test_Mix32_C {

    const std::uint64_t aValueCount = 4294967296ULL;
    std::uint64_t aCount = 0;
    for (std::uint64_t aValue=0; aValue<aValueCount; aValue++) {
        std::uint32_t aNumber = static_cast<std::uint32_t>(aValue);
        aNumber = TwistMix32::DiffuseC(aNumber);
        if (InverseMix32C(aNumber) != static_cast<std::uint32_t>(aValue)) {
            XCTFail("test_Mix32_C: failed to recover input %llu.", aValue);
            return;
        }
        aCount++;
    }
    
    if (aCount != aValueCount) {
        XCTFail("test_Mix32_C: got %llu unique values, expected 4294967296", aCount);
        return;
    }
    
    printf("test_Mix32_C: got %llu unique values, correct", aCount);
}

@end
