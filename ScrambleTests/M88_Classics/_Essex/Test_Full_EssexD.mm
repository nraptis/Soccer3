//
//  Test_Full_EssexD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_EssexD : XCTestCase

@end

@implementation Test_Full_EssexD

- (void)testFull_EssexD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_EssexD_EachQuad_4x4();

    const M aExpected = {
        { 26,  8,  3, 17, 30, 12,  7, 21 },
        { 18,  0, 11, 25, 22,  4, 15, 29 },
        { 27, 16,  2,  9, 31, 20,  6, 13 },
        { 19, 24, 10,  1, 23, 28, 14,  5 },
        { 58, 40, 35, 49, 62, 44, 39, 53 },
        { 50, 32, 43, 57, 54, 36, 47, 61 },
        { 59, 48, 34, 41, 63, 52, 38, 45 },
        { 51, 56, 42, 33, 55, 60, 46, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_EssexD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_EssexD_8x8();

    const M aExpected = {
        { 53, 33, 55, 17,  7, 19,  5, 35 },
        { 52, 32, 54, 16,  6, 18,  4, 34 },
        { 37, 49, 39,  1, 23,  3, 21, 51 },
        { 36, 48, 38,  0, 22,  2, 20, 50 },
        { 61, 43, 63, 41, 15, 25, 13, 27 },
        { 60, 42, 62, 40, 14, 24, 12, 26 },
        { 45, 59, 47, 57, 31,  9, 29, 11 },
        { 44, 58, 46, 56, 30,  8, 28, 10 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
