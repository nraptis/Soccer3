//
//  Test_Full_GooseD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GooseD : XCTestCase

@end

@implementation Test_Full_GooseD

- (void)testFull_GooseD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GooseD_EachQuad_4x4();

    const M aExpected = {
        { 16, 24,  0,  8, 20, 28,  4, 12 },
        { 19, 27,  3, 11, 23, 31,  7, 15 },
        { 18, 26,  2, 10, 22, 30,  6, 14 },
        { 17, 25,  1,  9, 21, 29,  5, 13 },
        { 48, 56, 32, 40, 52, 60, 36, 44 },
        { 51, 59, 35, 43, 55, 63, 39, 47 },
        { 50, 58, 34, 42, 54, 62, 38, 46 },
        { 49, 57, 33, 41, 53, 61, 37, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GooseD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GooseD_8x8();

    const M aExpected = {
        { 32, 40, 48, 56,  0,  8, 16, 24 },
        { 39, 47, 55, 63,  7, 15, 23, 31 },
        { 38, 46, 54, 62,  6, 14, 22, 30 },
        { 37, 45, 53, 61,  5, 13, 21, 29 },
        { 36, 44, 52, 60,  4, 12, 20, 28 },
        { 35, 43, 51, 59,  3, 11, 19, 27 },
        { 34, 42, 50, 58,  2, 10, 18, 26 },
        { 33, 41, 49, 57,  1,  9, 17, 25 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
