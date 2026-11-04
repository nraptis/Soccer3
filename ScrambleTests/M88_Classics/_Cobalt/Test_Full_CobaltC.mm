//
//  Test_Full_CobaltC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_CobaltC : XCTestCase

@end

@implementation Test_Full_CobaltC

- (void)testFull_CobaltC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CobaltC_EachQuad_4x4();

    const M aExpected = {
        { 10, 26,  8, 24, 14, 30, 12, 28 },
        { 18,  2, 16,  0, 22,  6, 20,  4 },
        {  3, 17,  1, 19,  7, 21,  5, 23 },
        { 11, 25,  9, 27, 15, 29, 13, 31 },
        { 42, 58, 40, 56, 46, 62, 44, 60 },
        { 50, 34, 48, 32, 54, 38, 52, 36 },
        { 35, 49, 33, 51, 39, 53, 37, 55 },
        { 43, 57, 41, 59, 47, 61, 45, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_CobaltC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CobaltC_8x8();

    const M aExpected = {
        { 22, 54, 20, 52, 18, 50, 16, 48 },
        { 30, 62, 28, 60, 26, 58, 24, 56 },
        { 38,  6, 36,  4, 34,  2, 32,  0 },
        { 46, 14, 44, 12, 42, 10, 40,  8 },
        {  7, 37,  5, 35,  3, 33,  1, 39 },
        { 15, 45, 13, 43, 11, 41,  9, 47 },
        { 23, 53, 21, 51, 19, 49, 17, 55 },
        { 31, 61, 29, 59, 27, 57, 25, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
