//
//  Test_Full_MerciaC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_MerciaC : XCTestCase

@end

@implementation Test_Full_MerciaC

- (void)testFull_MerciaC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MerciaC_EachQuad_4x4();

    const M aExpected = {
        { 25, 18,  0, 11, 29, 22,  4, 15 },
        { 17, 26,  8,  3, 21, 30, 12,  7 },
        { 24, 10,  1, 19, 28, 14,  5, 23 },
        { 16,  2,  9, 27, 20,  6, 13, 31 },
        { 57, 50, 32, 43, 61, 54, 36, 47 },
        { 49, 58, 40, 35, 53, 62, 44, 39 },
        { 56, 42, 33, 51, 60, 46, 37, 55 },
        { 48, 34, 41, 59, 52, 38, 45, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_MerciaC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MerciaC_8x8();

    const M aExpected = {
        { 49, 39, 51, 37,  3, 21,  1, 23 },
        { 48, 38, 50, 36,  2, 20,  0, 22 },
        { 33, 55, 35, 53, 19,  5, 17,  7 },
        { 32, 54, 34, 52, 18,  4, 16,  6 },
        { 57, 45, 59, 29, 11, 31,  9, 47 },
        { 56, 44, 58, 28, 10, 30,  8, 46 },
        { 41, 61, 43, 13, 27, 15, 25, 63 },
        { 40, 60, 42, 12, 26, 14, 24, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
