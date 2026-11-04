//
//  M88_Uniqueness_Mini.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/23/26.
//

#import <XCTest/XCTest.h>
#include "M88.hpp"
#include <cstdint>
#include <unordered_set>
#include <vector>

@interface M88_Uniqueness_Mini : XCTestCase

@end

@implementation M88_Uniqueness_Mini

- (void)test_dispatch_Mini {

    std::vector<std::vector<std::uint8_t>> aMatrices;
    
    int aMaxDifference = -1;
    int aMinDifference = 65;
    
    for (std::size_t aOperationIndex=0; aOperationIndex<256; aOperationIndex++) {
        M88 aM88;
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
        }
        
        aM88.DispatchMini(static_cast<std::uint8_t>(aOperationIndex));
        
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
                    XCTFail("test_dispatch_Mini: expected different dispatch bytes to have different result matrices.");
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
    
    if (aMinDifference < 2) {
        XCTFail("test_dispatch_Mini: expected min differences 2, got %d", aMinDifference);
        return;
    }
    
    if (aMaxDifference < 8) {
        XCTFail("test_dispatch_Mini: expected max differences 8, got %d", aMaxDifference);
        return;
    }
}

@end
