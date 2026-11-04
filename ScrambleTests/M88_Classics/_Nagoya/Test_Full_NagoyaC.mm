//
//  Test_Full_NagoyaC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NagoyaC : XCTestCase

@end

@implementation Test_Full_NagoyaC

- (void)testFull_NagoyaC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NagoyaC_EachQuad_4x4();

    const M aExpected = {
        { 24, 25,  9,  8, 28, 29, 13, 12 },
        { 19, 17,  0,  2, 23, 21,  4,  6 },
        { 27, 26, 10, 11, 31, 30, 14, 15 },
        { 18, 16,  1,  3, 22, 20,  5,  7 },
        { 56, 57, 41, 40, 60, 61, 45, 44 },
        { 51, 49, 32, 34, 55, 53, 36, 38 },
        { 59, 58, 42, 43, 63, 62, 46, 47 },
        { 50, 48, 33, 35, 54, 52, 37, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NagoyaC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NagoyaC_8x8();

    const M aExpected = {
        { 48, 39, 32, 51,  2, 17, 18,  5 },
        { 56, 47, 40, 59, 10, 25, 26, 13 },
        { 50, 55, 34, 35,  0,  1, 16, 21 },
        { 58, 63, 42, 43,  8,  9, 24, 29 },
        { 38, 53, 54, 33, 20,  3,  4, 23 },
        { 46, 61, 62, 41, 28, 11, 12, 31 },
        { 36, 37, 52, 49, 22, 19,  6,  7 },
        { 44, 45, 60, 57, 30, 27, 14, 15 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
