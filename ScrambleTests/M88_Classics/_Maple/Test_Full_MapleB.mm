//
//  Test_Full_MapleB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_MapleB : XCTestCase

@end

@implementation Test_Full_MapleB

- (void)testFull_MapleB_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleB_4x4();

    const M aExpected = {
        { 18, 19, 16, 17,  0,  1,  2,  3 },
        { 26, 27, 24, 25,  8,  9, 10, 11 },
        { 34, 35, 32, 33, 48, 49, 50, 51 },
        { 42, 43, 40, 41, 56, 57, 58, 59 },
        { 36, 37, 38, 39, 54, 55, 52, 53 },
        { 44, 45, 46, 47, 62, 63, 60, 61 },
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

- (void)testFull_MapleB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleB_EachQuad_4x4();

    const M aExpected = {
        {  9,  8,  0,  1, 13, 12,  4,  5 },
        { 17, 16, 24, 25, 21, 20, 28, 29 },
        { 18, 19, 27, 26, 22, 23, 31, 30 },
        { 10, 11,  3,  2, 14, 15,  7,  6 },
        { 41, 40, 32, 33, 45, 44, 36, 37 },
        { 49, 48, 56, 57, 53, 52, 60, 61 },
        { 50, 51, 59, 58, 54, 55, 63, 62 },
        { 42, 43, 35, 34, 46, 47, 39, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_MapleB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleB_8x8();

    const M aExpected = {
        { 26, 18, 24, 16, 17, 25, 19, 27 },
        { 34, 42, 32, 40, 41, 33, 43, 35 },
        { 51, 59, 49, 57, 56, 48, 58, 50 },
        { 11,  3,  9,  1,  0,  8,  2, 10 },
        { 12,  4, 14,  6,  7, 15,  5, 13 },
        { 52, 60, 54, 62, 63, 55, 61, 53 },
        { 37, 45, 39, 47, 46, 38, 44, 36 },
        { 29, 21, 31, 23, 22, 30, 20, 28 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
