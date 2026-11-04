//
//  Test_Full_IronB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_IronB : XCTestCase

@end

@implementation Test_Full_IronB

- (void)testFull_IronB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_IronB_EachQuad_4x4();

    const M aExpected = {
        { 26, 17, 27, 18, 30, 21, 31, 22 },
        { 10,  1,  9,  0, 14,  5, 13,  4 },
        { 24, 19, 25, 16, 28, 23, 29, 20 },
        {  8,  3, 11,  2, 12,  7, 15,  6 },
        { 58, 49, 59, 50, 62, 53, 63, 54 },
        { 42, 33, 41, 32, 46, 37, 45, 36 },
        { 56, 51, 57, 48, 60, 55, 61, 52 },
        { 40, 35, 43, 34, 44, 39, 47, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_IronB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_IronB_8x8();

    const M aExpected = {
        { 61, 51, 45, 35, 62, 52, 46, 36 },
        { 29, 19, 13,  3, 28, 18, 12,  2 },
        { 59, 49, 43, 33, 60, 50, 44, 34 },
        { 27, 17, 11,  1, 26, 16, 10,  0 },
        { 57, 55, 41, 39, 58, 48, 42, 32 },
        { 25, 23,  9,  7, 24, 22,  8,  6 },
        { 63, 53, 47, 37, 56, 54, 40, 38 },
        { 31, 21, 15,  5, 30, 20, 14,  4 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
