//
//  Test_Full_FukuokaB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_FukuokaB : XCTestCase

@end

@implementation Test_Full_FukuokaB

- (void)testFull_FukuokaB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FukuokaB_EachQuad_4x4();

    const M aExpected = {
        { 11,  1,  0, 10, 15,  5,  4, 14 },
        {  2,  3,  9,  8,  6,  7, 13, 12 },
        { 18, 24, 25, 19, 22, 28, 29, 23 },
        { 27, 26, 16, 17, 31, 30, 20, 21 },
        { 43, 33, 32, 42, 47, 37, 36, 46 },
        { 34, 35, 41, 40, 38, 39, 45, 44 },
        { 50, 56, 57, 51, 54, 60, 61, 55 },
        { 59, 58, 48, 49, 63, 62, 52, 53 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_FukuokaB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FukuokaB_8x8();

    const M aExpected = {
        { 22, 30,  2, 10,  0,  8, 20, 28 },
        { 21, 29, 23, 31,  3, 11,  1,  9 },
        {  6, 14, 18, 26, 16, 24,  4, 12 },
        {  5, 13,  7, 15, 19, 27, 17, 25 },
        { 36, 44, 48, 56, 50, 58, 38, 46 },
        { 39, 47, 37, 45, 49, 57, 51, 59 },
        { 52, 60, 32, 40, 34, 42, 54, 62 },
        { 55, 63, 53, 61, 33, 41, 35, 43 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
