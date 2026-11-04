//
//  Test_Full_SteelA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SteelA : XCTestCase

@end

@implementation Test_Full_SteelA

- (void)testFull_SteelA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SteelA_EachQuad_4x4();

    const M aExpected = {
        { 19,  1, 17,  3, 23,  5, 21,  7 },
        { 26,  8, 24, 10, 30, 12, 28, 14 },
        { 18,  2, 16,  0, 22,  6, 20,  4 },
        { 25,  9, 27, 11, 29, 13, 31, 15 },
        { 51, 33, 49, 35, 55, 37, 53, 39 },
        { 58, 40, 56, 42, 62, 44, 60, 46 },
        { 50, 34, 48, 32, 54, 38, 52, 36 },
        { 57, 41, 59, 43, 61, 45, 63, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SteelA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SteelA_8x8();

    const M aExpected = {
        { 38,  4, 36,  2, 34,  0, 32,  6 },
        { 44, 10, 42,  8, 40, 14, 46, 12 },
        { 54, 20, 52, 18, 50, 16, 48, 22 },
        { 60, 26, 58, 24, 56, 30, 62, 28 },
        { 37,  5, 35,  3, 33,  1, 39,  7 },
        { 43, 11, 41,  9, 47, 15, 45, 13 },
        { 53, 21, 51, 19, 49, 17, 55, 23 },
        { 59, 27, 57, 25, 63, 31, 61, 29 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
