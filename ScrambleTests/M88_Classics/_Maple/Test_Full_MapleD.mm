//
//  Test_Full_MapleD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_MapleD : XCTestCase

@end

@implementation Test_Full_MapleD

- (void)testFull_MapleD_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleD_4x4();

    const M aExpected = {
        { 50, 51, 52, 53,  4,  5,  2,  3 },
        { 58, 59, 60, 61, 12, 13, 10, 11 },
        { 34, 35, 36, 37, 20, 21, 18, 19 },
        { 42, 43, 44, 45, 28, 29, 26, 27 },
        { 32, 33, 38, 39, 22, 23, 16, 17 },
        { 40, 41, 46, 47, 30, 31, 24, 25 },
        { 48, 49, 54, 55,  6,  7,  0,  1 },
        { 56, 57, 62, 63, 14, 15,  8,  9 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_MapleD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleD_EachQuad_4x4();

    const M aExpected = {
        { 25, 26,  2,  1, 29, 30,  6,  5 },
        { 17, 18, 10,  9, 21, 22, 14, 13 },
        { 16, 19, 11,  8, 20, 23, 15, 12 },
        { 24, 27,  3,  0, 28, 31,  7,  4 },
        { 57, 58, 34, 33, 61, 62, 38, 37 },
        { 49, 50, 42, 41, 53, 54, 46, 45 },
        { 48, 51, 43, 40, 52, 55, 47, 44 },
        { 56, 59, 35, 32, 60, 63, 39, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_MapleD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleD_8x8();

    const M aExpected = {
        { 49, 54, 60, 59,  3,  4, 14,  9 },
        { 48, 55, 61, 58,  2,  5, 15,  8 },
        { 33, 38, 44, 43, 19, 20, 30, 25 },
        { 32, 39, 45, 42, 18, 21, 31, 24 },
        { 40, 47, 37, 34, 26, 29, 23, 16 },
        { 41, 46, 36, 35, 27, 28, 22, 17 },
        { 56, 63, 53, 50, 10, 13,  7,  0 },
        { 57, 62, 52, 51, 11, 12,  6,  1 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
