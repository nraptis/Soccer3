//
//  M88_Uniqueness_Quarter.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/23/26.
//

#import <XCTest/XCTest.h>
#include "M88.hpp"
#include <cstdint>
#include <unordered_set>
#include <vector>

@interface M88_Uniqueness_Quarter : XCTestCase

@end

@implementation M88_Uniqueness_Quarter

- (void)test_dispatch_QuadA {

    std::vector<std::vector<std::uint8_t>> aMatrices;
    
    int aMaxDifference = -1;
    int aMinDifference = 65;
    
    for (std::size_t aOperationIndex=0; aOperationIndex<256; aOperationIndex++) {
        M88 aM88;
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
        }
        
        aM88.DispatchQuadA(static_cast<std::uint8_t>(aOperationIndex));
        
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
                    XCTFail("test_dispatch_QuadA: expected different dispatch bytes to have different result matrices.");
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
    
    if (aMinDifference < 8) {
        XCTFail("test_dispatch_QuadA: expected min differences 8, got %d", aMinDifference);
        return;
    }
    
    if (aMaxDifference < 16) {
        XCTFail("test_dispatch_QuadA: expected max differences 16, got %d", aMaxDifference);
        return;
    }
}

- (void)test_dispatch_QuadB {

    std::vector<std::vector<std::uint8_t>> aMatrices;
    
    int aMaxDifference = -1;
    int aMinDifference = 65;
    
    for (std::size_t aOperationIndex=0; aOperationIndex<256; aOperationIndex++) {
        M88 aM88;
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
        }
        
        aM88.DispatchQuadB(static_cast<std::uint8_t>(aOperationIndex));
        
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
                    XCTFail("test_dispatch_QuadB: expected different dispatch bytes to have different result matrices.");
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
    
    if (aMinDifference < 8) {
        XCTFail("test_dispatch_QuadB: expected min differences 8, got %d", aMinDifference);
        return;
    }
    
    if (aMaxDifference < 16) {
        XCTFail("test_dispatch_QuadB: expected max differences 16, got %d", aMaxDifference);
        return;
    }
}

- (void)test_dispatch_QuadC {

    std::vector<std::vector<std::uint8_t>> aMatrices;
    
    int aMaxDifference = -1;
    int aMinDifference = 65;
    
    for (std::size_t aOperationIndex=0; aOperationIndex<256; aOperationIndex++) {
        M88 aM88;
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
        }
        
        aM88.DispatchQuadC(static_cast<std::uint8_t>(aOperationIndex));
        
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
                    XCTFail("test_dispatch_QuadC: expected different dispatch bytes to have different result matrices.");
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
    
    if (aMinDifference < 8) {
        XCTFail("test_dispatch_QuadC: expected min differences 8, got %d", aMinDifference);
        return;
    }
    
    if (aMaxDifference < 16) {
        XCTFail("test_dispatch_QuadC: expected max differences 16, got %d", aMaxDifference);
        return;
    }
}

- (void)test_dispatch_QuadD {

    std::vector<std::vector<std::uint8_t>> aMatrices;
    
    int aMaxDifference = -1;
    int aMinDifference = 65;
    
    for (std::size_t aOperationIndex=0; aOperationIndex<256; aOperationIndex++) {
        M88 aM88;
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
        }
        
        aM88.DispatchQuadD(static_cast<std::uint8_t>(aOperationIndex));
        
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
                    XCTFail("test_dispatch_QuadD: expected different dispatch bytes to have different result matrices.");
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
    
    if (aMinDifference < 8) {
        XCTFail("test_dispatch_QuadD: expected min differences 8, got %d", aMinDifference);
        return;
    }
    
    if (aMaxDifference < 16) {
        XCTFail("test_dispatch_QuadD: expected max differences 16, got %d", aMaxDifference);
        return;
    }
}

@end
