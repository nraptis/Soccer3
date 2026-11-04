//
//  Test_Full_PeridotB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PeridotB : XCTestCase

@end

@implementation Test_Full_PeridotB

- (void)testFull_PeridotB_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotB_4x4();

    const M aExpected = {
        { 36, 37, 38, 39, 54, 55, 52, 53 },
        { 44, 45, 46, 47, 62, 63, 60, 61 },
        { 34, 35, 32, 33, 48, 49, 50, 51 },
        { 42, 43, 40, 41, 56, 57, 58, 59 },
        { 18, 19, 16, 17,  0,  1,  2,  3 },
        { 26, 27, 24, 25,  8,  9, 10, 11 },
        { 20, 21, 22, 23,  6,  7,  4,  5 },
        { 28, 29, 30, 31, 14, 15, 12, 13 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PeridotB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotB_EachQuad_4x4();

    const M aExpected = {
        { 18, 19, 27, 26, 22, 23, 31, 30 },
        { 17, 16, 24, 25, 21, 20, 28, 29 },
        {  9,  8,  0,  1, 13, 12,  4,  5 },
        { 10, 11,  3,  2, 14, 15,  7,  6 },
        { 50, 51, 59, 58, 54, 55, 63, 62 },
        { 49, 48, 56, 57, 53, 52, 60, 61 },
        { 41, 40, 32, 33, 45, 44, 36, 37 },
        { 42, 43, 35, 34, 46, 47, 39, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PeridotB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotB_8x8();

    const M aExpected = {
        { 52, 53, 54, 55, 63, 62, 61, 60 },
        { 51, 50, 49, 48, 56, 57, 58, 59 },
        { 43, 42, 41, 40, 32, 33, 34, 35 },
        { 44, 45, 46, 47, 39, 38, 37, 36 },
        { 20, 21, 22, 23, 31, 30, 29, 28 },
        { 19, 18, 17, 16, 24, 25, 26, 27 },
        { 11, 10,  9,  8,  0,  1,  2,  3 },
        { 12, 13, 14, 15,  7,  6,  5,  4 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
