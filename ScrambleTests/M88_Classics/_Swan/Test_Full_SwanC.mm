//
//  Test_Full_SwanC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SwanC : XCTestCase

@end

@implementation Test_Full_SwanC

- (void)testFull_SwanC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwanC_EachQuad_4x4();

    const M aExpected = {
        { 10, 11,  8,  9, 14, 15, 12, 13 },
        {  2,  3,  0,  1,  6,  7,  4,  5 },
        { 26, 25, 24, 27, 30, 29, 28, 31 },
        { 18, 17, 16, 19, 22, 21, 20, 23 },
        { 42, 43, 40, 41, 46, 47, 44, 45 },
        { 34, 35, 32, 33, 38, 39, 36, 37 },
        { 58, 57, 56, 59, 62, 61, 60, 63 },
        { 50, 49, 48, 51, 54, 53, 52, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SwanC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwanC_8x8();

    const M aExpected = {
        { 30, 31, 28, 29, 26, 27, 24, 25 },
        { 22, 23, 20, 21, 18, 19, 16, 17 },
        { 14, 15, 12, 13, 10, 11,  8,  9 },
        {  6,  7,  4,  5,  2,  3,  0,  1 },
        { 62, 61, 60, 59, 58, 57, 56, 63 },
        { 54, 53, 52, 51, 50, 49, 48, 55 },
        { 46, 45, 44, 43, 42, 41, 40, 47 },
        { 38, 37, 36, 35, 34, 33, 32, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
