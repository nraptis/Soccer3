//
//  Test_Full_HydrogenD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HydrogenD : XCTestCase

@end

@implementation Test_Full_HydrogenD

- (void)testFull_HydrogenD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HydrogenD_EachQuad_4x4();

    const M aExpected = {
        { 25, 24,  0,  1, 29, 28,  4,  5 },
        { 17, 16,  8,  9, 21, 20, 12, 13 },
        { 18, 19, 11, 10, 22, 23, 15, 14 },
        { 26, 27,  3,  2, 30, 31,  7,  6 },
        { 57, 56, 32, 33, 61, 60, 36, 37 },
        { 49, 48, 40, 41, 53, 52, 44, 45 },
        { 50, 51, 43, 42, 54, 55, 47, 46 },
        { 58, 59, 35, 34, 62, 63, 39, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HydrogenD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HydrogenD_8x8();

    const M aExpected = {
        { 58, 50, 56, 48,  8,  0, 10,  2 },
        { 59, 51, 57, 49,  9,  1, 11,  3 },
        { 42, 34, 40, 32, 24, 16, 26, 18 },
        { 43, 35, 41, 33, 25, 17, 27, 19 },
        { 44, 36, 46, 38, 30, 22, 28, 20 },
        { 45, 37, 47, 39, 31, 23, 29, 21 },
        { 60, 52, 62, 54, 14,  6, 12,  4 },
        { 61, 53, 63, 55, 15,  7, 13,  5 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
