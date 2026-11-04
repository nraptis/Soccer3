//
//  Test_Full_SapporoC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SapporoC : XCTestCase

@end

@implementation Test_Full_SapporoC

- (void)testFull_SapporoC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SapporoC_EachQuad_4x4();

    const M aExpected = {
        { 18, 24, 25, 19, 22, 28, 29, 23 },
        { 16, 17, 27, 26, 20, 21, 31, 30 },
        { 11,  1,  0, 10, 15,  5,  4, 14 },
        {  9,  8,  2,  3, 13, 12,  6,  7 },
        { 50, 56, 57, 51, 54, 60, 61, 55 },
        { 48, 49, 59, 58, 52, 53, 63, 62 },
        { 43, 33, 32, 42, 47, 37, 36, 46 },
        { 41, 40, 34, 35, 45, 44, 38, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SapporoC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SapporoC_8x8();

    const M aExpected = {
        { 45, 37, 57, 49, 59, 51, 47, 39 },
        { 56, 48, 58, 50, 46, 38, 44, 36 },
        { 61, 53, 41, 33, 43, 35, 63, 55 },
        { 40, 32, 42, 34, 62, 54, 60, 52 },
        { 31, 23, 11,  3,  9,  1, 29, 21 },
        { 10,  2,  8,  0, 28, 20, 30, 22 },
        { 15,  7, 27, 19, 25, 17, 13,  5 },
        { 26, 18, 24, 16, 12,  4, 14,  6 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
