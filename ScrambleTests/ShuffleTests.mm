//
//  ShuffleTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/1/26.
//

#import <XCTest/XCTest.h>

#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"
#include "TwistShuffle.hpp"
#include "Random.hpp"

#include <cstdint>
#include <cstring>
#include <vector>
#include <unordered_set>
#include <unordered_map>

@interface ShuffleTests : XCTestCase

@end

@implementation ShuffleTests

- (void)test_IndexShuffleMovesAllSlots2 {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[2];
        std::size_t aModified[2];
        for (std::size_t aValue=0; aValue<2; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList2(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<2; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<2; aIndex++) {
        if (aCounter[aIndex] < 200) {
            XCTFail("test_IndexShuffleMovesAllSlots2: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots2_Multi {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[2];
        std::size_t aModified[2];
        for (std::size_t aValue=0; aValue<2; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList2(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<2; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<2; aIndex++) {
        if (aCounter[aIndex] < 200) {
            XCTFail("test_IndexShuffleMovesAllSlots2_Multi: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot2 {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[2];
        for (std::size_t aValue=0; aValue<2; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList2(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<2; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<2; aIndex++) {
        if (aGlyph[aIndex].size() != 2) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot2: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot2_Multi {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[2];
        for (std::size_t aValue=0; aValue<2; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList2(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<2; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<2; aIndex++) {
        if (aGlyph[aIndex].size() != 2) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot2_Multi: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots4 {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[4];
        std::size_t aModified[4];
        for (std::size_t aValue=0; aValue<4; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList4(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<4; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<4; aIndex++) {
        if (aCounter[aIndex] < 400) {
            XCTFail("test_IndexShuffleMovesAllSlots4: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots4_Multi {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[4];
        std::size_t aModified[4];
        for (std::size_t aValue=0; aValue<4; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList4(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<4; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<4; aIndex++) {
        if (aCounter[aIndex] < 400) {
            XCTFail("test_IndexShuffleMovesAllSlots4_Multi: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot4 {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[4];
        for (std::size_t aValue=0; aValue<4; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList4(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<4; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<4; aIndex++) {
        if (aGlyph[aIndex].size() != 4) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot4: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot4_Multi {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[4];
        for (std::size_t aValue=0; aValue<4; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList4(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<4; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<4; aIndex++) {
        if (aGlyph[aIndex].size() != 4) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot4_Multi: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots8 {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[8];
        std::size_t aModified[8];
        for (std::size_t aValue=0; aValue<8; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList8(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<8; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<8; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots8: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots8_Multi {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[8];
        std::size_t aModified[8];
        for (std::size_t aValue=0; aValue<8; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList8(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<8; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<8; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots8_Multi: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot8 {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[8];
        for (std::size_t aValue=0; aValue<8; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList8(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<8; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<8; aIndex++) {
        if (aGlyph[aIndex].size() != 8) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot8: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot8_Multi {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[8];
        for (std::size_t aValue=0; aValue<8; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList8(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<8; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<8; aIndex++) {
        if (aGlyph[aIndex].size() != 8) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot8_Multi: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots16 {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[16];
        std::size_t aModified[16];
        for (std::size_t aValue=0; aValue<16; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList16(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<16; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots16: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots16_Multi {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[16];
        std::size_t aModified[16];
        for (std::size_t aValue=0; aValue<16; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList16(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<16; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots16_Multi: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot16 {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[16];
        for (std::size_t aValue=0; aValue<16; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList16(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<16; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        if (aGlyph[aIndex].size() != 16) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot16: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot16_Multi {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[16];
        for (std::size_t aValue=0; aValue<16; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList16(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<16; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<16; aIndex++) {
        if (aGlyph[aIndex].size() != 16) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot16_Multi: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots32 {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[32];
        std::size_t aModified[32];
        for (std::size_t aValue=0; aValue<32; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList32(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<32; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<32; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots32: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots32_Multi {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[32];
        std::size_t aModified[32];
        for (std::size_t aValue=0; aValue<32; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList32(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<32; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<32; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots32_Multi: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot32 {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[32];
        for (std::size_t aValue=0; aValue<32; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList32(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<32; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<32; aIndex++) {
        if (aGlyph[aIndex].size() != 32) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot32: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot32_Multi {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[32];
        for (std::size_t aValue=0; aValue<32; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList32(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<32; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<32; aIndex++) {
        if (aGlyph[aIndex].size() != 32) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot32_Multi: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots64 {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[64];
        std::size_t aModified[64];
        for (std::size_t aValue=0; aValue<64; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList64(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<64; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots64: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots64_Multi {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[64];
        std::size_t aModified[64];
        for (std::size_t aValue=0; aValue<64; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList64(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<64; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots64_Multi: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot64 {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[64];
        for (std::size_t aValue=0; aValue<64; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList64(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<64; aIndex++) {
        if (aGlyph[aIndex].size() != 64) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot64: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot64_Multi {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[64];
        for (std::size_t aValue=0; aValue<64; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList64(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<64; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<64; aIndex++) {
        if (aGlyph[aIndex].size() != 64) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot64_Multi: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots128 {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[128];
        std::size_t aModified[128];
        for (std::size_t aValue=0; aValue<128; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList128(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<128; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<128; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots128: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots128_Multi {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[128];
        std::size_t aModified[128];
        for (std::size_t aValue=0; aValue<128; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList128(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<128; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<128; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots128_Multi: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot128 {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[128];
        for (std::size_t aValue=0; aValue<128; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList128(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<128; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<128; aIndex++) {
        if (aGlyph[aIndex].size() != 128) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot128: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot128_Multi {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[128];
        for (std::size_t aValue=0; aValue<128; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList128(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<128; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<128; aIndex++) {
        if (aGlyph[aIndex].size() != 128) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot128_Multi: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots256 {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[256];
        std::size_t aModified[256];
        for (std::size_t aValue=0; aValue<256; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList256(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<256; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<256; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots256: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesAllSlots256_Multi {
    
    std::unordered_map<std::size_t, std::size_t> aCounter;
    
    for (std::size_t aTrial=0; aTrial<1000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aOriginal[256];
        std::size_t aModified[256];
        for (std::size_t aValue=0; aValue<256; aValue++) {

            aOriginal[aValue] = aValue;
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList256(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<256; aIndex++) {
            if (aOriginal[aIndex] != aModified[aIndex]) {
                aCounter[aIndex]++;
            }
        }
    }
    
    for (std::size_t aIndex=0; aIndex<256; aIndex++) {
        if (aCounter[aIndex] < 800) {
            XCTFail("test_IndexShuffleMovesAllSlots256_Multi: failed on %zu, got %zu times changed", aIndex, aCounter[aIndex]);
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot256 {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[256];
        for (std::size_t aValue=0; aValue<256; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList256(aModified, aEntropy, 0, 1024, 1);
        
        for (std::size_t aIndex=0; aIndex<256; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<256; aIndex++) {
        if (aGlyph[aIndex].size() != 256) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot256: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

- (void)test_IndexShuffleMovesEverySlotToEverySlot256_Multi {
    
    std::unordered_map<std::size_t, std::unordered_set<std::size_t>> aGlyph;
    
    for (std::size_t aTrial=0; aTrial<25000; aTrial++) {
        
        std::uint8_t aEntropy[1024];
        std::size_t aModified[256];
        for (std::size_t aValue=0; aValue<256; aValue++) {
            aModified[aValue] = aValue;
        }
        
        for (std::size_t aIndex=0; aIndex<1024; aIndex++) {
            aEntropy[aIndex] = Random::GetByte();
        }
        
        TwistShuffle::ShuffleList256(aModified, aEntropy, 0, 1024, 32);
        
        for (std::size_t aIndex=0; aIndex<256; aIndex++) {
            aGlyph[aIndex].insert(aModified[aIndex]);
        }
    }
    
    for (std::size_t aIndex=0; aIndex<256; aIndex++) {
        if (aGlyph[aIndex].size() != 256) {
            XCTFail("test_IndexShuffleMovesEverySlotToEverySlot256_Multi: failed on %zu, got %zu values of 255", aIndex, aGlyph[aIndex].size());
            return;
        }
    }
}

@end
