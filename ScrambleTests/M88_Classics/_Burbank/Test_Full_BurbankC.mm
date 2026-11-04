//
//  Test_Full_BurbankC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_BurbankC : XCTestCase

@end

@implementation Test_Full_BurbankC

- (void)testFull_BurbankC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BurbankC_EachQuad_4x4();

    const M aExpected = {
        { 18, 27, 11,  2, 22, 31, 15,  6 },
        { 19, 17, 10,  8, 23, 21, 14, 12 },
        { 25, 16,  0,  9, 29, 20,  4, 13 },
        { 24, 26,  1,  3, 28, 30,  5,  7 },
        { 50, 59, 43, 34, 54, 63, 47, 38 },
        { 51, 49, 42, 40, 55, 53, 46, 44 },
        { 57, 48, 32, 41, 61, 52, 36, 45 },
        { 56, 58, 33, 35, 60, 62, 37, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_BurbankC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BurbankC_8x8();

    const M aExpected = {
        { 36, 39, 52, 55, 22, 21,  6,  5 },
        { 44, 47, 60, 63, 30, 29, 14, 13 },
        { 38, 51, 54, 35, 20,  1,  4, 17 },
        { 46, 59, 62, 43, 28,  9, 12, 25 },
        { 50, 49, 34, 33,  0,  3, 16, 19 },
        { 58, 57, 42, 41,  8, 11, 24, 27 },
        { 48, 37, 32, 53,  2, 23, 18,  7 },
        { 56, 45, 40, 61, 10, 31, 26, 15 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
