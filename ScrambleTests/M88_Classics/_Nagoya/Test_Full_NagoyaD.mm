//
//  Test_Full_NagoyaD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NagoyaD : XCTestCase

@end

@implementation Test_Full_NagoyaD

- (void)testFull_NagoyaD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NagoyaD_EachQuad_4x4();

    const M aExpected = {
        { 19, 16,  0,  3, 23, 20,  4,  7 },
        { 27, 25, 10,  8, 31, 29, 14, 12 },
        { 18, 17,  1,  2, 22, 21,  5,  6 },
        { 24, 26,  9, 11, 28, 30, 13, 15 },
        { 51, 48, 32, 35, 55, 52, 36, 39 },
        { 59, 57, 42, 40, 63, 61, 46, 44 },
        { 50, 49, 33, 34, 54, 53, 37, 38 },
        { 56, 58, 41, 43, 60, 62, 45, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NagoyaD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NagoyaD_8x8();

    const M aExpected = {
        { 50, 37, 34, 49,  0, 19, 16,  7 },
        { 58, 45, 42, 57,  8, 27, 24, 15 },
        { 38, 39, 54, 51, 20, 17,  4,  5 },
        { 46, 47, 62, 59, 28, 25, 12, 13 },
        { 36, 55, 52, 35, 22,  1,  6, 21 },
        { 44, 63, 60, 43, 30,  9, 14, 29 },
        { 48, 53, 32, 33,  2,  3, 18, 23 },
        { 56, 61, 40, 41, 10, 11, 26, 31 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
