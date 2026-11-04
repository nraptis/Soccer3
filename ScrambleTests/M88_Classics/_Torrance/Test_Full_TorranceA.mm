//
//  Test_Full_TorranceA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TorranceA : XCTestCase

@end

@implementation Test_Full_TorranceA

- (void)testFull_TorranceA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TorranceA_EachQuad_4x4();

    const M aExpected = {
        { 10, 26,  1, 17, 14, 30,  5, 21 },
        { 27, 18, 16, 25, 31, 22, 20, 29 },
        { 19,  3, 24,  8, 23,  7, 28, 12 },
        {  2, 11,  9,  0,  6, 15, 13,  4 },
        { 42, 58, 33, 49, 46, 62, 37, 53 },
        { 59, 50, 48, 57, 63, 54, 52, 61 },
        { 51, 35, 56, 40, 55, 39, 60, 44 },
        { 34, 43, 41, 32, 38, 47, 45, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_TorranceA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TorranceA_8x8();

    const M aExpected = {
        { 29, 55, 31, 53, 11, 33,  9, 35 },
        { 28, 54, 30, 52, 10, 32,  8, 34 },
        { 63, 39, 61, 37, 41, 49, 43, 51 },
        { 62, 38, 60, 36, 40, 48, 42, 50 },
        { 47,  5, 45,  7, 57, 19, 59, 17 },
        { 46,  4, 44,  6, 56, 18, 58, 16 },
        { 13, 21, 15, 23, 27,  3, 25,  1 },
        { 12, 20, 14, 22, 26,  2, 24,  0 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
