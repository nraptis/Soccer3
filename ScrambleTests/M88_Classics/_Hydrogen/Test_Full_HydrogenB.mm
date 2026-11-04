//
//  Test_Full_HydrogenB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HydrogenB : XCTestCase

@end

@implementation Test_Full_HydrogenB

- (void)testFull_HydrogenB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HydrogenB_EachQuad_4x4();

    const M aExpected = {
        { 19, 18, 10, 11, 23, 22, 14, 15 },
        { 27, 26,  2,  3, 31, 30,  6,  7 },
        { 24, 25,  1,  0, 28, 29,  5,  4 },
        { 16, 17,  9,  8, 20, 21, 13, 12 },
        { 51, 50, 42, 43, 55, 54, 46, 47 },
        { 59, 58, 34, 35, 63, 62, 38, 39 },
        { 56, 57, 33, 32, 60, 61, 37, 36 },
        { 48, 49, 41, 40, 52, 53, 45, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HydrogenB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HydrogenB_8x8();

    const M aExpected = {
        { 46, 38, 44, 36, 28, 20, 30, 22 },
        { 47, 39, 45, 37, 29, 21, 31, 23 },
        { 62, 54, 60, 52, 12,  4, 14,  6 },
        { 63, 55, 61, 53, 13,  5, 15,  7 },
        { 56, 48, 58, 50, 10,  2,  8,  0 },
        { 57, 49, 59, 51, 11,  3,  9,  1 },
        { 40, 32, 42, 34, 26, 18, 24, 16 },
        { 41, 33, 43, 35, 27, 19, 25, 17 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
