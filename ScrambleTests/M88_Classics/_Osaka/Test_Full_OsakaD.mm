//
//  Test_Full_OsakaD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_OsakaD : XCTestCase

@end

@implementation Test_Full_OsakaD

- (void)testFull_OsakaD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OsakaD_EachQuad_4x4();

    const M aExpected = {
        { 17, 25,  9,  1, 21, 29, 13,  5 },
        { 26, 24, 18, 16, 30, 28, 22, 20 },
        { 27, 19,  3, 11, 31, 23,  7, 15 },
        {  0,  2,  8, 10,  4,  6, 12, 14 },
        { 49, 57, 41, 33, 53, 61, 45, 37 },
        { 58, 56, 50, 48, 62, 60, 54, 52 },
        { 59, 51, 35, 43, 63, 55, 39, 47 },
        { 32, 34, 40, 42, 36, 38, 44, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_OsakaD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OsakaD_8x8();

    const M aExpected = {
        { 34,  1, 50, 17, 48, 19, 32,  3 },
        { 40, 43, 56, 59, 26, 25, 10,  9 },
        { 54, 35, 38, 51, 36, 49, 52, 33 },
        { 60, 41, 44, 57, 14, 27, 30, 11 },
        { 20, 55,  4, 39,  6, 37, 22, 53 },
        { 62, 61, 46, 45, 12, 15, 28, 31 },
        {  0, 21, 16,  5, 18,  7,  2, 23 },
        { 42, 63, 58, 47, 24, 13,  8, 29 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
