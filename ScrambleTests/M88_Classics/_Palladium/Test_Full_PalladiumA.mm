//
//  Test_Full_PalladiumA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PalladiumA : XCTestCase

@end

@implementation Test_Full_PalladiumA

- (void)testFull_PalladiumA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PalladiumA_EachQuad_4x4();

    const M aExpected = {
        { 27, 11, 25,  9, 31, 15, 29, 13 },
        { 18,  2, 16,  0, 22,  6, 20,  4 },
        { 24,  8, 26, 10, 28, 12, 30, 14 },
        { 19,  3, 17,  1, 23,  7, 21,  5 },
        { 59, 43, 57, 41, 63, 47, 61, 45 },
        { 50, 34, 48, 32, 54, 38, 52, 36 },
        { 56, 40, 58, 42, 60, 44, 62, 46 },
        { 51, 35, 49, 33, 55, 39, 53, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PalladiumA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PalladiumA_8x8();

    const M aExpected = {
        { 62, 30, 56, 24, 58, 26, 60, 28 },
        { 52, 20, 54, 22, 48, 16, 50, 18 },
        { 46, 14, 40,  8, 42, 10, 44, 12 },
        { 36,  4, 38,  6, 32,  0, 34,  2 },
        { 63, 31, 57, 25, 59, 27, 61, 29 },
        { 53, 21, 55, 23, 49, 17, 51, 19 },
        { 47, 15, 41,  9, 43, 11, 45, 13 },
        { 37,  5, 39,  7, 33,  1, 35,  3 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
