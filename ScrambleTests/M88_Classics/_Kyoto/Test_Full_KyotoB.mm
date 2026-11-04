//
//  Test_Full_KyotoB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_KyotoB : XCTestCase

@end

@implementation Test_Full_KyotoB

- (void)testFull_KyotoB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KyotoB_EachQuad_4x4();

    const M aExpected = {
        { 17, 24, 26, 19, 21, 28, 30, 23 },
        {  0, 16, 11, 27,  4, 20, 15, 31 },
        {  8,  1,  3, 10, 12,  5,  7, 14 },
        { 25,  9, 18,  2, 29, 13, 22,  6 },
        { 49, 56, 58, 51, 53, 60, 62, 55 },
        { 32, 48, 43, 59, 36, 52, 47, 63 },
        { 40, 33, 35, 42, 44, 37, 39, 46 },
        { 57, 41, 50, 34, 61, 45, 54, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_KyotoB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KyotoB_8x8();

    const M aExpected = {
        { 34, 58, 32, 56, 52, 44, 54, 46 },
        { 35, 59, 33, 57, 53, 45, 55, 47 },
        {  0, 42,  2, 40, 22, 60, 20, 62 },
        {  1, 43,  3, 41, 23, 61, 21, 63 },
        { 16,  8, 18, 10,  6, 30,  4, 28 },
        { 17,  9, 19, 11,  7, 31,  5, 29 },
        { 50, 24, 48, 26, 36, 14, 38, 12 },
        { 51, 25, 49, 27, 37, 15, 39, 13 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
