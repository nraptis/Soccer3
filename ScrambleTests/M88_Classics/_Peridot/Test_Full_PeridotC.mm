//
//  Test_Full_PeridotC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PeridotC : XCTestCase

@end

@implementation Test_Full_PeridotC

- (void)testFull_PeridotC_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotC_4x4();

    const M aExpected = {
        { 36, 37, 20, 21, 18, 19, 34, 35 },
        { 44, 45, 28, 29, 26, 27, 42, 43 },
        { 52, 53,  4,  5,  2,  3, 50, 51 },
        { 60, 61, 12, 13, 10, 11, 58, 59 },
        { 54, 55,  6,  7,  0,  1, 48, 49 },
        { 62, 63, 14, 15,  8,  9, 56, 57 },
        { 38, 39, 22, 23, 16, 17, 32, 33 },
        { 46, 47, 30, 31, 24, 25, 40, 41 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PeridotC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotC_EachQuad_4x4();

    const M aExpected = {
        { 18, 10,  9, 17, 22, 14, 13, 21 },
        { 26,  2,  1, 25, 30,  6,  5, 29 },
        { 27,  3,  0, 24, 31,  7,  4, 28 },
        { 19, 11,  8, 16, 23, 15, 12, 20 },
        { 50, 42, 41, 49, 54, 46, 45, 53 },
        { 58, 34, 33, 57, 62, 38, 37, 61 },
        { 59, 35, 32, 56, 63, 39, 36, 60 },
        { 51, 43, 40, 48, 55, 47, 44, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PeridotC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotC_8x8();

    const M aExpected = {
        { 38, 30, 29, 37, 34, 26, 25, 33 },
        { 46, 22, 21, 45, 42, 18, 17, 41 },
        { 54, 14, 13, 53, 50, 10,  9, 49 },
        { 62,  6,  5, 61, 58,  2,  1, 57 },
        { 63,  7,  4, 60, 59,  3,  0, 56 },
        { 55, 15, 12, 52, 51, 11,  8, 48 },
        { 47, 23, 20, 44, 43, 19, 16, 40 },
        { 39, 31, 28, 36, 35, 27, 24, 32 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
