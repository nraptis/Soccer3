//
//  Test_Full_SussexD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SussexD : XCTestCase

@end

@implementation Test_Full_SussexD

- (void)testFull_SussexD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SussexD_EachQuad_4x4();

    const M aExpected = {
        { 19,  1, 11, 25, 23,  5, 15, 29 },
        { 26,  8,  0, 18, 30, 12,  4, 22 },
        { 16, 24, 10,  2, 20, 28, 14,  6 },
        { 27, 17,  3,  9, 31, 21,  7, 13 },
        { 51, 33, 43, 57, 55, 37, 47, 61 },
        { 58, 40, 32, 50, 62, 44, 36, 54 },
        { 48, 56, 42, 34, 52, 60, 46, 38 },
        { 59, 49, 35, 41, 63, 53, 39, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SussexD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SussexD_8x8();

    const M aExpected = {
        { 38, 50, 32,  2, 16,  4, 22, 52 },
        { 39, 51, 33,  3, 17,  5, 23, 53 },
        { 54, 34, 48, 18,  0, 20,  6, 36 },
        { 55, 35, 49, 19,  1, 21,  7, 37 },
        { 44, 58, 46, 56, 30,  8, 28, 10 },
        { 45, 59, 47, 57, 31,  9, 29, 11 },
        { 60, 42, 62, 40, 14, 24, 12, 26 },
        { 61, 43, 63, 41, 15, 25, 13, 27 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
