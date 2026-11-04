//
//  Test_Full_CrystalC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_CrystalC : XCTestCase

@end

@implementation Test_Full_CrystalC

- (void)testFull_CrystalC_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CrystalC_4x4();

    const M aExpected = {
        { 52, 53, 50, 51,  2,  3,  4,  5 },
        { 60, 61, 58, 59, 10, 11, 12, 13 },
        { 54, 55, 48, 49,  0,  1,  6,  7 },
        { 62, 63, 56, 57,  8,  9, 14, 15 },
        { 38, 39, 32, 33, 16, 17, 22, 23 },
        { 46, 47, 40, 41, 24, 25, 30, 31 },
        { 36, 37, 34, 35, 18, 19, 20, 21 },
        { 44, 45, 42, 43, 26, 27, 28, 29 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_CrystalC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CrystalC_EachQuad_4x4();

    const M aExpected = {
        { 26, 25,  1,  2, 30, 29,  5,  6 },
        { 27, 24,  0,  3, 31, 28,  4,  7 },
        { 19, 16,  8, 11, 23, 20, 12, 15 },
        { 18, 17,  9, 10, 22, 21, 13, 14 },
        { 58, 57, 33, 34, 62, 61, 37, 38 },
        { 59, 56, 32, 35, 63, 60, 36, 39 },
        { 51, 48, 40, 43, 55, 52, 44, 47 },
        { 50, 49, 41, 42, 54, 53, 45, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_CrystalC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CrystalC_8x8();

    const M aExpected = {
        { 60, 59, 35, 36, 28, 27,  3,  4 },
        { 61, 58, 34, 37, 29, 26,  2,  5 },
        { 62, 57, 33, 38, 30, 25,  1,  6 },
        { 63, 56, 32, 39, 31, 24,  0,  7 },
        { 55, 48, 40, 47, 23, 16,  8, 15 },
        { 54, 49, 41, 46, 22, 17,  9, 14 },
        { 53, 50, 42, 45, 21, 18, 10, 13 },
        { 52, 51, 43, 44, 20, 19, 11, 12 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
