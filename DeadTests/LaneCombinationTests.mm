//
//  LaneCombinationTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/4/26.
//

#import <XCTest/XCTest.h>

#include "Soccer2.hpp"
#include "LaneCombinations.hpp"

#include <cstdint>
#include <cstring>

@interface LaneCombinationTests : XCTestCase

@end

@implementation LaneCombinationTests

- (void)test_Weak {
    
    for (std::size_t aIndex=0; aIndex<LaneCombinations::mWeakCount; aIndex++) {
    
        const WeakLaneCombination aCombo = LaneCombinations::mWeak[aIndex];
        
        std::size_t aQuarters = 0;
        aQuarters += aCombo.mL3[0] * 4;
        aQuarters += aCombo.mL3[1] * 4;
        aQuarters += aCombo.mL2[0] * 2;
        aQuarters += aCombo.mL1[0] * 1;
        
        if ((aQuarters == 16) || (aQuarters == 15) || (aQuarters == 14) || (aQuarters == 13)) {
            // Fine
        } else {
            XCTFail("test_Weak: failed on %zu", aIndex);
            return;
        }
    }
}

- (void)test_Medium {
    
    for (std::size_t aIndex=0; aIndex<LaneCombinations::mNormalCount; aIndex++) {
    
        const NormalLaneCombination aCombo = LaneCombinations::mNormal[aIndex];
        
        std::size_t aQuarters = 0;
        aQuarters += aCombo.mL3[0] * 4;
        aQuarters += aCombo.mL3[1] * 4;
        aQuarters += aCombo.mL3[2] * 4;
        aQuarters += aCombo.mL2[0] * 2;
        aQuarters += aCombo.mL2[1] * 2;
        aQuarters += aCombo.mL1[0] * 1;
        aQuarters += aCombo.mL1[1] * 1;
        
        if ((aQuarters == 29) || (aQuarters == 30) || (aQuarters == 31) || (aQuarters == 32)) {
            // Fine
        } else {
            XCTFail("test_Medium: failed on %zu", aIndex);
            return;
        }
    }
}

- (void)test_Strong {
    
    for (std::size_t aIndex=0; aIndex<LaneCombinations::mStrongCount; aIndex++) {
    
        const StrongLaneCombination aCombo = LaneCombinations::mStrong[aIndex];

        std::size_t aQuarters = 0;
        aQuarters += aCombo.mL3[0] * 4;
        aQuarters += aCombo.mL3[1] * 4;
        aQuarters += aCombo.mL3[2] * 4;
        aQuarters += aCombo.mL3[3] * 4;
        aQuarters += aCombo.mL3[4] * 4;
        aQuarters += aCombo.mL3[5] * 4;
        aQuarters += aCombo.mL2[0] * 2;
        aQuarters += aCombo.mL2[1] * 2;
        aQuarters += aCombo.mL2[2] * 2;
        aQuarters += aCombo.mL2[3] * 2;
        aQuarters += aCombo.mL1[0] * 1;
        aQuarters += aCombo.mL1[1] * 1;
        aQuarters += aCombo.mL1[2] * 1;
        aQuarters += aCombo.mL1[3] * 1;
        
        if ((aQuarters == 61) || (aQuarters == 62) || (aQuarters == 63) || (aQuarters == 64)) {
            // Fine
        } else {
            XCTFail("test_Strong: failed on %zu", aIndex);
            return;
        }
    }
}

@end
