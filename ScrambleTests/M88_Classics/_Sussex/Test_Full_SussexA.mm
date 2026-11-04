//
//  Test_Full_SussexA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SussexA : XCTestCase

@end

@implementation Test_Full_SussexA

- (void)testFull_SussexA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SussexA_EachQuad_4x4();

    const M aExpected = {
        {  2, 16, 24, 10,  6, 20, 28, 14 },
        {  9, 27, 17,  3, 13, 31, 21,  7 },
        { 25, 19,  1, 11, 29, 23,  5, 15 },
        { 18, 26,  8,  0, 22, 30, 12,  4 },
        { 34, 48, 56, 42, 38, 52, 60, 46 },
        { 41, 59, 49, 35, 45, 63, 53, 39 },
        { 57, 51, 33, 43, 61, 55, 37, 47 },
        { 50, 58, 40, 32, 54, 62, 44, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SussexA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SussexA_8x8();

    const M aExpected = {
        { 10, 44, 58, 46, 56, 30,  8, 28 },
        { 11, 45, 59, 47, 57, 31,  9, 29 },
        { 26, 60, 42, 62, 40, 14, 24, 12 },
        { 27, 61, 43, 63, 41, 15, 25, 13 },
        { 52, 38, 50, 32,  2, 16,  4, 22 },
        { 53, 39, 51, 33,  3, 17,  5, 23 },
        { 36, 54, 34, 48, 18,  0, 20,  6 },
        { 37, 55, 35, 49, 19,  1, 21,  7 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
