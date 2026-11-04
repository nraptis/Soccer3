//
//  Test_Full_BrassC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_BrassC : XCTestCase

@end

@implementation Test_Full_BrassC

- (void)testFull_BrassC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BrassC_EachQuad_4x4();

    const M aExpected = {
        { 17,  1, 19,  3, 21,  5, 23,  7 },
        { 24,  8, 26, 10, 28, 12, 30, 14 },
        { 18,  0, 16,  2, 22,  4, 20,  6 },
        { 25, 11, 27,  9, 29, 15, 31, 13 },
        { 49, 33, 51, 35, 53, 37, 55, 39 },
        { 56, 40, 58, 42, 60, 44, 62, 46 },
        { 50, 32, 48, 34, 54, 36, 52, 38 },
        { 57, 43, 59, 41, 61, 47, 63, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_BrassC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BrassC_8x8();

    const M aExpected = {
        { 36,  4, 34,  2, 32,  0, 38,  6 },
        { 42, 10, 40,  8, 46, 14, 44, 12 },
        { 52, 20, 50, 18, 48, 16, 54, 22 },
        { 58, 26, 56, 24, 62, 30, 60, 28 },
        { 37,  3, 35,  1, 33,  7, 39,  5 },
        { 43,  9, 41, 15, 47, 13, 45, 11 },
        { 53, 19, 51, 17, 49, 23, 55, 21 },
        { 59, 25, 57, 31, 63, 29, 61, 27 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
