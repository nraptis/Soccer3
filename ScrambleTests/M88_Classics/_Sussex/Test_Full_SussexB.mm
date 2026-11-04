//
//  Test_Full_SussexB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SussexB : XCTestCase

@end

@implementation Test_Full_SussexB

- (void)testFull_SussexB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SussexB_EachQuad_4x4();

    const M aExpected = {
        { 19, 25, 11,  1, 23, 29, 15,  5 },
        { 26, 18,  0,  8, 30, 22,  4, 12 },
        { 10, 24, 16,  2, 14, 28, 20,  6 },
        {  3, 17, 27,  9,  7, 21, 31, 13 },
        { 51, 57, 43, 33, 55, 61, 47, 37 },
        { 58, 50, 32, 40, 62, 54, 36, 44 },
        { 42, 56, 48, 34, 46, 60, 52, 38 },
        { 35, 49, 59, 41, 39, 53, 63, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SussexB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SussexB_8x8();

    const M aExpected = {
        { 38, 52, 32, 50, 16,  2, 22,  4 },
        { 39, 53, 33, 51, 17,  3, 23,  5 },
        { 54, 36, 48, 34,  0, 18,  6, 20 },
        { 55, 37, 49, 35,  1, 19,  7, 21 },
        { 28, 58, 44, 56, 46,  8, 30, 10 },
        { 29, 59, 45, 57, 47,  9, 31, 11 },
        { 12, 42, 60, 40, 62, 24, 14, 26 },
        { 13, 43, 61, 41, 63, 25, 15, 27 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
