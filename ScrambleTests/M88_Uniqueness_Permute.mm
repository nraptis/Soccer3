//
//  M88_Uniqueness_Permute.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/23/26.
//

#import <XCTest/XCTest.h>
#include "M88.hpp"
#include <cstdint>
#include <unordered_set>
#include <set>
#include <vector>
#include "GutCheckValidator.hpp"
#include "Random.hpp"

std::vector<std::vector<std::uint8_t>>
GetQuad(const M88 &pMatrix, std::size_t pQuad) {

    std::vector<std::vector<std::uint8_t>> aResult(
        4,
        std::vector<std::uint8_t>(4, 0U)
    );

    const std::size_t qx = (pQuad & 1U) * 4U;
    const std::size_t qy = (pQuad >> 1U) * 4U;

    for (std::size_t y=0U; y<4U; y++) {
        for (std::size_t x=0U; x<4U; x++) {
            aResult[y][x] = pMatrix.mData[M88::Slot(qx + x, qy + y)];
        }
    }

    return aResult;
}

@interface M88_Uniqueness_Permute : XCTestCase

@end

@implementation M88_Uniqueness_Permute

- (void)test_dispatch_QuadA {

    std::unordered_set<std::vector<std::uint8_t>, ByteListHash> aMatrices[17];

    for (std::size_t aAmount=0; aAmount<=16; aAmount++) {

        for (std::size_t aQuadIndexA=0; aQuadIndexA<256; aQuadIndexA++) {

            for (std::size_t aQuadIndexB=0; aQuadIndexB<256; aQuadIndexB++) {

                M88 aM88;

                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
                }

                aM88.DispatchPermute(
                    aQuadIndexA,
                    aQuadIndexB,
                    0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0,
                    aAmount
                );

                std::vector<std::uint8_t> aList(64, 0);

                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    aList[aIndex] = aM88.mData[aIndex];
                }

                aMatrices[aAmount].insert(aList);
            }
        }
    }

    //
    // Amounts 1...15 should each have 1820 unique matrices.
    //

    for (std::size_t aAmount=1; aAmount<16; aAmount++) {

        std::size_t aCount = aMatrices[aAmount].size();
        
        if (aCount != 1820) {

            XCTFail(
                "test_dispatch_QuadA: amount %zu expected 1820 unique matrices, got %zu",
                aAmount,
                aCount
            );

            return;
        }
    }
    
    if (aMatrices[0] != aMatrices[16]) {

        XCTFail(
            "test_dispatch_QuadA: amount 0 and amount 16 produced different matrices"
        );

        return;
    }
}

- (void)test_dispatch_QuadB {

    std::unordered_set<std::vector<std::uint8_t>, ByteListHash> aMatrices[17];

    for (std::size_t aAmount=0; aAmount<=16; aAmount++) {

        for (std::size_t aQuadIndexA=0; aQuadIndexA<256; aQuadIndexA++) {

            for (std::size_t aQuadIndexB=0; aQuadIndexB<256; aQuadIndexB++) {

                M88 aM88;

                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
                }

                aM88.DispatchPermute(
                    0,0,aQuadIndexA, aQuadIndexB,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0,
                    aAmount
                );

                std::vector<std::uint8_t> aList(64, 0);

                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    aList[aIndex] = aM88.mData[aIndex];
                }

                aMatrices[aAmount].insert(aList);
            }
        }
    }

    //
    // Amounts 1...15 should each have 1820 unique matrices.
    //

    for (std::size_t aAmount=1; aAmount<16; aAmount++) {

        std::size_t aCount = aMatrices[aAmount].size();
        
        if (aCount != 1820) {

            XCTFail(
                "test_dispatch_QuadB: amount %zu expected 1820 unique matrices, got %zu",
                aAmount,
                aCount
            );

            return;
        }
    }
    
    if (aMatrices[0] != aMatrices[16]) {

        XCTFail(
            "test_dispatch_QuadB: amount 0 and amount 16 produced different matrices"
        );

        return;
    }
}

- (void)test_dispatch_QuadC {

    std::unordered_set<std::vector<std::uint8_t>, ByteListHash> aMatrices[17];

    for (std::size_t aAmount=0; aAmount<=16; aAmount++) {

        for (std::size_t aQuadIndexA=0; aQuadIndexA<256; aQuadIndexA++) {

            for (std::size_t aQuadIndexB=0; aQuadIndexB<256; aQuadIndexB++) {

                M88 aM88;

                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
                }

                aM88.DispatchPermute(
                    0,0,0,0,aQuadIndexA, aQuadIndexB,
                    0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0,
                    aAmount
                );

                std::vector<std::uint8_t> aList(64, 0);

                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    aList[aIndex] = aM88.mData[aIndex];
                }

                aMatrices[aAmount].insert(aList);
            }
        }
    }

    //
    // Amounts 1...15 should each have 1820 unique matrices.
    //

    for (std::size_t aAmount=1; aAmount<16; aAmount++) {

        std::size_t aCount = aMatrices[aAmount].size();
        
        if (aCount != 1820) {

            XCTFail(
                "test_dispatch_QuadC: amount %zu expected 1820 unique matrices, got %zu",
                aAmount,
                aCount
            );

            return;
        }
    }
    
    if (aMatrices[0] != aMatrices[16]) {

        XCTFail(
            "test_dispatch_QuadC: amount 0 and amount 16 produced different matrices"
        );

        return;
    }
}

- (void)test_dispatch_QuadD {

    std::unordered_set<std::vector<std::uint8_t>, ByteListHash> aMatrices[17];

    for (std::size_t aAmount=0; aAmount<=16; aAmount++) {

        for (std::size_t aQuadIndexA=0; aQuadIndexA<256; aQuadIndexA++) {

            for (std::size_t aQuadIndexB=0; aQuadIndexB<256; aQuadIndexB++) {

                M88 aM88;

                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    aM88.mData[aIndex] = static_cast<std::uint8_t>(aIndex);
                }

                aM88.DispatchPermute(
                    0,0,0,0,0,0,aQuadIndexA, aQuadIndexB,
                    0,
                    0, 0, 0, 0, 0, 0, 0,
                    aAmount
                );

                std::vector<std::uint8_t> aList(64, 0);

                for (std::size_t aIndex=0; aIndex<64; aIndex++) {
                    aList[aIndex] = aM88.mData[aIndex];
                }

                aMatrices[aAmount].insert(aList);
            }
        }
    }

    //
    // Amounts 1...15 should each have 1820 unique matrices.
    //

    for (std::size_t aAmount=1; aAmount<16; aAmount++) {

        std::size_t aCount = aMatrices[aAmount].size();
        
        if (aCount != 1820) {

            XCTFail(
                "test_dispatch_QuadD: amount %zu expected 1820 unique matrices, got %zu",
                aAmount,
                aCount
            );

            return;
        }
    }
    
    if (aMatrices[0] != aMatrices[16]) {

        XCTFail(
            "test_dispatch_QuadD: amount 0 and amount 16 produced different matrices"
        );

        return;
    }
}

- (void)test_dispatch_Randoms {
    
    constexpr std::size_t kTrialCount = 100000U;
    
    for (std::size_t aTrial=0U; aTrial<kTrialCount; aTrial++) {
        
        M88 aM88;
        
        //
        // Original matrix:
        //
        //  0  1  2 ...  7
        //  8  9 10 ... 15
        // ...
        // 56 57 58 ... 63
        //
        
        for (std::size_t aIndex=0U; aIndex<64U; aIndex++) {
            aM88.mData[aIndex] =
            static_cast<std::uint8_t>(aIndex);
        }
        
        aM88.DispatchPermute(Random::GetByte(), Random::GetByte(),
                             Random::GetByte(), Random::GetByte(),
                             Random::GetByte(), Random::GetByte(),
                             Random::GetByte(), Random::GetByte(),
                             Random::GetByte(), Random::GetByte(),
                             Random::GetByte(), Random::GetByte(),
                             Random::GetByte(), Random::GetByte(),
                             Random::GetByte(), Random::GetByte(),
                             Random::Get(1, 15)
                             );
        
        //
        // Verify that the matrix still contains exactly
        // the values 0...63.
        //
        
        bool aFound[64] = { false };
        
        for (std::size_t aIndex=0U; aIndex<64U; aIndex++) {
            const std::uint8_t aValue = aM88.mData[aIndex];
            
            if (aValue >= 64U) {
                
                XCTFail("test_dispatch_Randoms: trial %zu contains out-of-range value %u",
                        aTrial,
                        static_cast<unsigned int>(aValue)
                        );
                
                return;
            }
            
            if (aFound[aValue]) {
                XCTFail("test_dispatch_Randoms: trial %zu contains duplicate value %u",
                        aTrial,
                        static_cast<unsigned int>(aValue)
                        );
                
                return;
            }
            
            aFound[aValue] = true;
        }
        
        //
        // Verify exactly 16 positions changed.
        //
        
        std::size_t aChangedCount = 0U;
        for (std::size_t aIndex=0U; aIndex<64U; aIndex++) {
            if (aM88.mData[aIndex] != static_cast<std::uint8_t>(aIndex)) {
                aChangedCount++;
            }
        }
        
        if (aChangedCount != 16U) {
            
            XCTFail("test_dispatch_Randoms: trial %zu expected 16 changed bytes, got %zu",
                    aTrial,
                    aChangedCount
                    );
            
            return;
        }
        
        //
        // Verify exactly 4 positions changed in each quad.
        //
        
        for (std::size_t aQuad=0U; aQuad<4U; aQuad++) {
            
            std::vector<std::vector<std::uint8_t>> aQuadData =
            GetQuad(aM88, aQuad);
            
            const std::size_t qx = (aQuad & 1U) * 4U;
            const std::size_t qy = (aQuad >> 1U) * 4U;
            
            std::size_t aQuadChangedCount = 0U;
            
            for (std::size_t y=0U; y<4U; y++) {
                for (std::size_t x=0U; x<4U; x++) {
                    const std::size_t aSlot =
                    M88::Slot(qx + x, qy + y);
                    
                    const std::uint8_t aOriginal =
                    static_cast<std::uint8_t>(aSlot);
                    
                    if (aQuadData[y][x] != aOriginal) {
                        aQuadChangedCount++;
                    }
                }
            }
            
            if (aQuadChangedCount != 4U) {
                
                XCTFail("test_dispatch_Randoms: trial %zu quad %zu expected 4 changed bytes, got %zu",
                        aTrial,
                        aQuad,
                        aQuadChangedCount
                        );
                
                return;
            }
        }
    }
}

@end
