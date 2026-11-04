//
//  Test_Full_CrystalB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_CrystalB : XCTestCase

@end

@implementation Test_Full_CrystalB

- (void)testFull_CrystalB_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CrystalB_4x4();

    const M aExpected = {
        { 34, 35, 50, 51, 48, 49, 32, 33 },
        { 42, 43, 58, 59, 56, 57, 40, 41 },
        { 18, 19,  2,  3,  0,  1, 16, 17 },
        { 26, 27, 10, 11,  8,  9, 24, 25 },
        { 20, 21,  4,  5,  6,  7, 22, 23 },
        { 28, 29, 12, 13, 14, 15, 30, 31 },
        { 36, 37, 52, 53, 54, 55, 38, 39 },
        { 44, 45, 60, 61, 62, 63, 46, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_CrystalB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CrystalB_EachQuad_4x4();

    const M aExpected = {
        { 17, 25, 24, 16, 21, 29, 28, 20 },
        {  9,  1,  0,  8, 13,  5,  4, 12 },
        { 10,  2,  3, 11, 14,  6,  7, 15 },
        { 18, 26, 27, 19, 22, 30, 31, 23 },
        { 49, 57, 56, 48, 53, 61, 60, 52 },
        { 41, 33, 32, 40, 45, 37, 36, 44 },
        { 42, 34, 35, 43, 46, 38, 39, 47 },
        { 50, 58, 59, 51, 54, 62, 63, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_CrystalB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CrystalB_8x8();

    const M aExpected = {
        { 33, 41, 49, 57, 56, 48, 40, 32 },
        { 25, 17,  9,  1,  0,  8, 16, 24 },
        { 26, 18, 10,  2,  3, 11, 19, 27 },
        { 34, 42, 50, 58, 59, 51, 43, 35 },
        { 37, 45, 53, 61, 60, 52, 44, 36 },
        { 29, 21, 13,  5,  4, 12, 20, 28 },
        { 30, 22, 14,  6,  7, 15, 23, 31 },
        { 38, 46, 54, 62, 63, 55, 47, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
