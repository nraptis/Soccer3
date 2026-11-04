//
//  Test_Full_BronzeD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_BronzeD : XCTestCase

@end

@implementation Test_Full_BronzeD

- (void)testFull_BronzeD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BronzeD_EachQuad_4x4();

    const M aExpected = {
        { 26, 17, 25, 16, 30, 21, 29, 20 },
        {  8,  3,  9,  0, 12,  7, 13,  4 },
        { 24, 19, 27, 18, 28, 23, 31, 22 },
        { 10,  1, 11,  2, 14,  5, 15,  6 },
        { 58, 49, 57, 48, 62, 53, 61, 52 },
        { 40, 35, 41, 32, 44, 39, 45, 36 },
        { 56, 51, 59, 50, 60, 55, 63, 54 },
        { 42, 33, 43, 34, 46, 37, 47, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_BronzeD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BronzeD_8x8();

    const M aExpected = {
        { 61, 51, 45, 35, 60, 50, 44, 34 },
        { 27, 17, 11,  1, 28, 18, 12,  2 },
        { 59, 49, 43, 33, 58, 48, 42, 32 },
        { 25, 23,  9,  7, 26, 16, 10,  0 },
        { 57, 55, 41, 39, 56, 54, 40, 38 },
        { 31, 21, 15,  5, 24, 22,  8,  6 },
        { 63, 53, 47, 37, 62, 52, 46, 36 },
        { 29, 19, 13,  3, 30, 20, 14,  4 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
