//
//  Test_Full_PasadenaB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PasadenaB : XCTestCase

@end

@implementation Test_Full_PasadenaB

- (void)testFull_PasadenaB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PasadenaB_EachQuad_4x4();

    const M aExpected = {
        {  2,  3,  9,  8,  6,  7, 13, 12 },
        { 11,  1,  0, 10, 15,  5,  4, 14 },
        { 27, 26, 16, 17, 31, 30, 20, 21 },
        { 18, 24, 25, 19, 22, 28, 29, 23 },
        { 34, 35, 41, 40, 38, 39, 45, 44 },
        { 43, 33, 32, 42, 47, 37, 36, 46 },
        { 59, 58, 48, 49, 63, 62, 52, 53 },
        { 50, 56, 57, 51, 54, 60, 61, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PasadenaB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PasadenaB_8x8();

    const M aExpected = {
        { 12,  4, 14,  6, 26, 18, 24, 16 },
        { 15,  7, 27, 19, 25, 17, 13,  5 },
        { 28, 20, 30, 22, 10,  2,  8,  0 },
        { 31, 23, 11,  3,  9,  1, 29, 21 },
        { 62, 54, 60, 52, 40, 32, 42, 34 },
        { 61, 53, 41, 33, 43, 35, 63, 55 },
        { 46, 38, 44, 36, 56, 48, 58, 50 },
        { 45, 37, 57, 49, 59, 51, 47, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
