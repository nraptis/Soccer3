//
//  Test_Full_TokyoC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TokyoC : XCTestCase

@end

@implementation Test_Full_TokyoC

- (void)testFull_TokyoC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TokyoC_EachQuad_4x4();

    const M aExpected = {
        { 18, 19, 25, 24, 22, 23, 29, 28 },
        { 16, 26, 27, 17, 20, 30, 31, 21 },
        { 11, 10,  0,  1, 15, 14,  4,  5 },
        {  9,  3,  2,  8, 13,  7,  6, 12 },
        { 50, 51, 57, 56, 54, 55, 61, 60 },
        { 48, 58, 59, 49, 52, 62, 63, 53 },
        { 43, 42, 32, 33, 47, 46, 36, 37 },
        { 41, 35, 34, 40, 45, 39, 38, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_TokyoC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TokyoC_8x8();

    const M aExpected = {
        { 44, 36, 46, 38, 58, 50, 56, 48 },
        { 57, 49, 45, 37, 47, 39, 59, 51 },
        { 60, 52, 62, 54, 42, 34, 40, 32 },
        { 41, 33, 61, 53, 63, 55, 43, 35 },
        { 30, 22, 28, 20,  8,  0, 10,  2 },
        { 11,  3, 31, 23, 29, 21,  9,  1 },
        { 14,  6, 12,  4, 24, 16, 26, 18 },
        { 27, 19, 15,  7, 13,  5, 25, 17 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
