//
//  Test_Full_HawthorneC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HawthorneC : XCTestCase

@end

@implementation Test_Full_HawthorneC

- (void)testFull_HawthorneC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HawthorneC_EachQuad_4x4();

    const M aExpected = {
        {  9,  8,  2,  3, 13, 12,  6,  7 },
        { 11,  1,  0, 10, 15,  5,  4, 14 },
        { 16, 17, 27, 26, 20, 21, 31, 30 },
        { 18, 24, 25, 19, 22, 28, 29, 23 },
        { 41, 40, 34, 35, 45, 44, 38, 39 },
        { 43, 33, 32, 42, 47, 37, 36, 46 },
        { 48, 49, 59, 58, 52, 53, 63, 62 },
        { 50, 56, 57, 51, 54, 60, 61, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HawthorneC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HawthorneC_8x8();

    const M aExpected = {
        { 26, 18, 24, 16, 12,  4, 14,  6 },
        { 15,  7, 27, 19, 25, 17, 13,  5 },
        { 10,  2,  8,  0, 28, 20, 30, 22 },
        { 31, 23, 11,  3,  9,  1, 29, 21 },
        { 40, 32, 42, 34, 62, 54, 60, 52 },
        { 61, 53, 41, 33, 43, 35, 63, 55 },
        { 56, 48, 58, 50, 46, 38, 44, 36 },
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
