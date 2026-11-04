//
//  Test_Full_XenonA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_XenonA : XCTestCase

@end

@implementation Test_Full_XenonA

- (void)testFull_XenonA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_XenonA_EachQuad_4x4();

    const M aExpected = {
        { 19,  1, 10, 24, 23,  5, 14, 28 },
        { 27,  9,  2, 16, 31, 13,  6, 20 },
        { 11,  0, 18, 25, 15,  4, 22, 29 },
        {  3,  8, 26, 17,  7, 12, 30, 21 },
        { 51, 33, 42, 56, 55, 37, 46, 60 },
        { 59, 41, 34, 48, 63, 45, 38, 52 },
        { 43, 32, 50, 57, 47, 36, 54, 61 },
        { 35, 40, 58, 49, 39, 44, 62, 53 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_XenonA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_XenonA_8x8();

    const M aExpected = {
        { 47,  9, 31, 11, 29, 59, 45, 57 },
        { 46,  8, 30, 10, 28, 58, 44, 56 },
        { 63, 25, 15, 27, 13, 43, 61, 41 },
        { 62, 24, 14, 26, 12, 42, 60, 40 },
        { 23,  1, 21,  3, 37, 51, 39, 49 },
        { 22,  0, 20,  2, 36, 50, 38, 48 },
        {  7, 17,  5, 19, 53, 35, 55, 33 },
        {  6, 16,  4, 18, 52, 34, 54, 32 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
