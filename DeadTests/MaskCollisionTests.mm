//
//  MaskCollisionTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/6/26.
//

#import <XCTest/XCTest.h>
#include "Soccer2.hpp"
#include "SoccerMaskBank.hpp"
#include <cstdio>
#include <cstdint>

namespace {

std::size_t CountOnes(std::uint8_t aByte) {
    const std::size_t aResult = static_cast<std::size_t>(__builtin_popcount(static_cast<unsigned int>(aByte)));
    return aResult;
}

std::size_t BitDifference(std::uint8_t aByteA, std::uint8_t aByteB) {
    const std::uint8_t aDifferenceMap = aByteA ^ aByteB;
    const std::size_t aDifference = CountOnes(aDifferenceMap);
    return aDifference;
}

}

@interface MaskCollisionTests : XCTestCase

@end

@implementation MaskCollisionTests

- (void)test_MaskBalance {
    
    std::size_t aCount = SoccerMaskBank::mMaskGridHeight;

    for (std::size_t aMaskListIndex=0; aMaskListIndex<aCount; aMaskListIndex++) {
        for (std::size_t aMaskIndex = 0; aMaskIndex < SoccerMaskBank::mMaskGridWidth; aMaskIndex++) {
             
            std::uint8_t aMask = SoccerMaskBank::mMaskGrid[aMaskListIndex][aMaskIndex];
            
            std::size_t aOnes = CountOnes(aMask);
            if (aOnes < 3) {
                XCTFail("test_MaskBalance: expected min ones to be 3, got %zu", aOnes);
                return;
            }
            if (aOnes > 5) {
                XCTFail("test_MaskBalance: expected max ones to be 5, got %zu", aOnes);
                return;
            }
        }
    }
    
    std::size_t aGlobalMin = 256;
    std::size_t aGlobalMax = 0;
    
    for (std::size_t aMaskListIndex=0; aMaskListIndex<aCount; aMaskListIndex++) {
        
        std::size_t aMinDifference = 256;
        std::size_t aMaxDifference = 0;
        
        for (std::size_t aIndexA = 1; aIndexA < SoccerMaskBank::mMaskGridWidth; aIndexA++) {
            
            std::uint8_t aMaskA = SoccerMaskBank::mMaskGrid[aMaskListIndex][aIndexA];
            
            for (std::size_t aIndexB = 0U; aIndexB < aIndexA; aIndexB++) {
                
                std::uint8_t aMaskB = SoccerMaskBank::mMaskGrid[aMaskListIndex][aIndexB];
                
                const std::size_t aDifference = BitDifference(aMaskA, aMaskB);
                
                if (aDifference < aMinDifference) {
                    aMinDifference = aDifference;
                }
                if (aDifference > aMaxDifference) {
                    aMaxDifference = aDifference;
                }
            }
        }
        
        if (aMinDifference < 4) {
            XCTFail("test_MaskBalance: expected min difference to be 4, got %zu", aMinDifference);
            return;
        }
        
        if (aMaxDifference < 8) {
            XCTFail("test_MaskBalance: expected min difference to be 8, got %zu", aMaxDifference);
            return;
        }
        
        if (aMinDifference < aGlobalMin) {
            aGlobalMin = aMinDifference;
        }
        
        if (aMaxDifference > aGlobalMax) {
            aGlobalMax = aMaxDifference;
        }
        
    }
    
    printf("For all mask lists, global minmax differences [%zu and %zu]\n", aGlobalMin, aGlobalMax);
    printf("%zu mask lists have been tested, each with %zu masks.\n", aCount, std::size_t(SoccerMaskBank::mMaskGridWidth));
    
}

@end
