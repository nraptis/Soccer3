//
//  Test_Full_PalladiumD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PalladiumD : XCTestCase

@end

@implementation Test_Full_PalladiumD

- (void)testFull_PalladiumD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PalladiumD_EachQuad_4x4();

    const M aExpected = {
        {  9,  0, 10,  1, 13,  4, 14,  5 },
        { 25, 16, 26, 17, 29, 20, 30, 21 },
        { 11,  2,  8,  3, 15,  6, 12,  7 },
        { 27, 18, 24, 19, 31, 22, 28, 23 },
        { 41, 32, 42, 33, 45, 36, 46, 37 },
        { 57, 48, 58, 49, 61, 52, 62, 53 },
        { 43, 34, 40, 35, 47, 38, 44, 39 },
        { 59, 50, 56, 51, 63, 54, 60, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PalladiumD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PalladiumD_8x8();

    const M aExpected = {
        { 28, 18, 12,  2, 29, 19, 13,  3 },
        { 60, 50, 44, 34, 61, 51, 45, 35 },
        { 26, 16, 10,  0, 27, 17, 11,  1 },
        { 58, 48, 42, 32, 59, 49, 43, 33 },
        { 24, 22,  8,  6, 25, 23,  9,  7 },
        { 56, 54, 40, 38, 57, 55, 41, 39 },
        { 30, 20, 14,  4, 31, 21, 15,  5 },
        { 62, 52, 46, 36, 63, 53, 47, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
