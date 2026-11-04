//
//  Test_Full_JewelC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_JewelC : XCTestCase

@end

@implementation Test_Full_JewelC

- (void)testFull_JewelC_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JewelC_4x4();

    const M aExpected = {
        { 32, 33, 16, 17, 22, 23, 38, 39 },
        { 40, 41, 24, 25, 30, 31, 46, 47 },
        { 48, 49,  0,  1,  6,  7, 54, 55 },
        { 56, 57,  8,  9, 14, 15, 62, 63 },
        { 50, 51,  2,  3,  4,  5, 52, 53 },
        { 58, 59, 10, 11, 12, 13, 60, 61 },
        { 34, 35, 18, 19, 20, 21, 36, 37 },
        { 42, 43, 26, 27, 28, 29, 44, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JewelC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JewelC_EachQuad_4x4();

    const M aExpected = {
        { 16,  8, 11, 19, 20, 12, 15, 23 },
        { 24,  0,  3, 27, 28,  4,  7, 31 },
        { 25,  1,  2, 26, 29,  5,  6, 30 },
        { 17,  9, 10, 18, 21, 13, 14, 22 },
        { 48, 40, 43, 51, 52, 44, 47, 55 },
        { 56, 32, 35, 59, 60, 36, 39, 63 },
        { 57, 33, 34, 58, 61, 37, 38, 62 },
        { 49, 41, 42, 50, 53, 45, 46, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JewelC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JewelC_8x8();

    const M aExpected = {
        { 32, 24, 27, 35, 36, 28, 31, 39 },
        { 40, 16, 19, 43, 44, 20, 23, 47 },
        { 48,  8, 11, 51, 52, 12, 15, 55 },
        { 56,  0,  3, 59, 60,  4,  7, 63 },
        { 57,  1,  2, 58, 61,  5,  6, 62 },
        { 49,  9, 10, 50, 53, 13, 14, 54 },
        { 41, 17, 18, 42, 45, 21, 22, 46 },
        { 33, 25, 26, 34, 37, 29, 30, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
