//
//  Test_Full_CobaltD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_CobaltD : XCTestCase

@end

@implementation Test_Full_CobaltD

- (void)testFull_CobaltD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CobaltD_EachQuad_4x4();

    const M aExpected = {
        { 11,  3, 18, 10, 15,  7, 22, 14 },
        { 25, 17,  2, 26, 29, 21,  6, 30 },
        {  9,  1, 16,  8, 13,  5, 20, 12 },
        { 27, 19,  0, 24, 31, 23,  4, 28 },
        { 43, 35, 50, 42, 47, 39, 54, 46 },
        { 57, 49, 34, 58, 61, 53, 38, 62 },
        { 41, 33, 48, 40, 45, 37, 52, 44 },
        { 59, 51, 32, 56, 63, 55, 36, 60 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_CobaltD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CobaltD_8x8();

    const M aExpected = {
        { 31, 23, 15,  7, 46, 38, 30, 22 },
        { 61, 53, 45, 37, 14,  6, 62, 54 },
        { 29, 21, 13,  5, 44, 36, 28, 20 },
        { 59, 51, 43, 35, 12,  4, 60, 52 },
        { 27, 19, 11,  3, 42, 34, 26, 18 },
        { 57, 49, 41, 33, 10,  2, 58, 50 },
        { 25, 17,  9,  1, 40, 32, 24, 16 },
        { 63, 55, 47, 39,  8,  0, 56, 48 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
