//
//  Test_Full_JuniperC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_JuniperC : XCTestCase

@end

@implementation Test_Full_JuniperC

- (void)testFull_JuniperC_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperC_4x4();

    const M aExpected = {
        { 34, 35, 18, 19, 36, 37, 52, 53 },
        { 42, 43, 26, 27, 44, 45, 60, 61 },
        { 48, 49, 32, 33, 22, 23, 38, 39 },
        { 56, 57, 40, 41, 30, 31, 46, 47 },
        {  0,  1, 16, 17,  6,  7, 54, 55 },
        {  8,  9, 24, 25, 14, 15, 62, 63 },
        { 50, 51,  2,  3, 20, 21,  4,  5 },
        { 58, 59, 10, 11, 28, 29, 12, 13 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JuniperC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperC_EachQuad_4x4();

    const M aExpected = {
        { 17,  9, 18, 26, 21, 13, 22, 30 },
        { 24, 16, 11, 19, 28, 20, 15, 23 },
        {  0,  8,  3, 27,  4, 12,  7, 31 },
        { 25,  1, 10,  2, 29,  5, 14,  6 },
        { 49, 41, 50, 58, 53, 45, 54, 62 },
        { 56, 48, 43, 51, 60, 52, 47, 55 },
        { 32, 40, 35, 59, 36, 44, 39, 63 },
        { 57, 33, 42, 34, 61, 37, 46, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JuniperC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperC_8x8();

    const M aExpected = {
        { 50, 42, 11, 51,  4, 28, 29, 37 },
        { 58, 34,  3, 59, 12, 20, 21, 45 },
        { 48, 40,  9, 49,  6, 30, 31, 39 },
        { 56, 32,  1, 57, 14, 22, 23, 47 },
        { 41, 17, 16,  8, 63,  7, 38, 62 },
        { 33, 25, 24,  0, 55, 15, 46, 54 },
        { 43, 19, 18, 10, 61,  5, 36, 60 },
        { 35, 27, 26,  2, 53, 13, 44, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
