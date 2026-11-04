//
//  Test_Full_HawthorneD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HawthorneD : XCTestCase

@end

@implementation Test_Full_HawthorneD

- (void)testFull_HawthorneD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HawthorneD_EachQuad_4x4();

    const M aExpected = {
        {  3,  9,  8,  2,  7, 13, 12,  6 },
        {  1,  0, 10, 11,  5,  4, 14, 15 },
        { 26, 16, 17, 27, 30, 20, 21, 31 },
        { 24, 25, 19, 18, 28, 29, 23, 22 },
        { 35, 41, 40, 34, 39, 45, 44, 38 },
        { 33, 32, 42, 43, 37, 36, 46, 47 },
        { 58, 48, 49, 59, 62, 52, 53, 63 },
        { 56, 57, 51, 50, 60, 61, 55, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HawthorneD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HawthorneD_8x8();

    const M aExpected = {
        { 14,  6, 26, 18, 24, 16, 12,  4 },
        { 27, 19, 25, 17, 13,  5, 15,  7 },
        { 30, 22, 10,  2,  8,  0, 28, 20 },
        { 11,  3,  9,  1, 29, 21, 31, 23 },
        { 60, 52, 40, 32, 42, 34, 62, 54 },
        { 41, 33, 43, 35, 63, 55, 61, 53 },
        { 44, 36, 56, 48, 58, 50, 46, 38 },
        { 57, 49, 59, 51, 47, 39, 45, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
