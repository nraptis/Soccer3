//
//  M88_Uniqueness_Full.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/23/26.
//

#import <XCTest/XCTest.h>
#include "M88.hpp"
#include <cstdint>
#include <unordered_set>
#include <vector>

@interface M88_Uniqueness_Full : XCTestCase

@end

@implementation M88_Uniqueness_Full

- (void)test_dispatch_FullAB {

    std::vector<std::vector<std::uint8_t>> aMatrices;
    
    int aMaxDifference = -1;
    int aMinDifference = 65;
    
    for (std::size_t aOperationIndex=0; aOperationIndex<256; aOperationIndex++) {
        M88 aM88;
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
        }
        
        aM88.DispatchFullA(static_cast<std::uint8_t>(aOperationIndex));
        
        std::vector<std::uint8_t> aList(64, 0);
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aList[aIndex] = aM88.mData[aIndex];
        }
        
        aMatrices.push_back(aList);
    }
    
    for (std::size_t aOperationIndex=0; aOperationIndex<256; aOperationIndex++) {
        M88 aM88;
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
        }
        
        aM88.DispatchFullB(static_cast<std::uint8_t>(aOperationIndex));
        
        std::vector<std::uint8_t> aList(64, 0);
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aList[aIndex] = aM88.mData[aIndex];
        }
        
        aMatrices.push_back(aList);
    }
    
    for (std::size_t aIndexA=0; aIndexA<aMatrices.size(); aIndexA++) {
        
        std::vector<std::uint8_t> aMatrixA = aMatrices[aIndexA];
        
        for (std::size_t aIndexB=0; aIndexB<aMatrices.size(); aIndexB++) {
            if (aIndexB != aIndexA) {
        
                std::vector<std::uint8_t> aMatrixB = aMatrices[aIndexB];
                
                int aDifferences = 0;
                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    if (aMatrixA[aIndex] != aMatrixB[aIndex]) {
                        aDifferences++;
                    }
                }
                if (aDifferences <= 0) {
                    XCTFail("test_dispatch_FullAB: expected different dispatch bytes to have different result matrices.");
                    return;
                }
                if (aDifferences > aMaxDifference) {
                    aMaxDifference = aDifferences;
                }
                if (aDifferences < aMinDifference) {
                    aMinDifference = aDifferences;
                }
            }
        }
    }
    
    if (aMinDifference < 24) {
        XCTFail("test_dispatch_FullAB: expected min differences 24, got %d", aMinDifference);
        return;
    }
    
    if (aMaxDifference < 64) {
        XCTFail("test_dispatch_FullAB: expected max differences 64, got %d", aMaxDifference);
        return;
    }
}


@end
