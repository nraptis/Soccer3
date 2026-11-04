//
//  Test_Full_FukuokaA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_FukuokaA : XCTestCase

@end

@implementation Test_Full_FukuokaA

- (void)testFull_FukuokaA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FukuokaA_EachQuad_4x4();

    const M aExpected = {
        { 10, 11,  1,  0, 14, 15,  5,  4 },
        {  3,  9,  8,  2,  7, 13, 12,  6 },
        { 19, 18, 24, 25, 23, 22, 28, 29 },
        { 26, 16, 17, 27, 30, 20, 21, 31 },
        { 42, 43, 33, 32, 46, 47, 37, 36 },
        { 35, 41, 40, 34, 39, 45, 44, 38 },
        { 51, 50, 56, 57, 55, 54, 60, 61 },
        { 58, 48, 49, 59, 62, 52, 53, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_FukuokaA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FukuokaA_8x8();

    const M aExpected = {
        { 20, 28, 22, 30,  2, 10,  0,  8 },
        { 23, 31,  3, 11,  1,  9, 21, 29 },
        {  4, 12,  6, 14, 18, 26, 16, 24 },
        {  7, 15, 19, 27, 17, 25,  5, 13 },
        { 38, 46, 36, 44, 48, 56, 50, 58 },
        { 37, 45, 49, 57, 51, 59, 39, 47 },
        { 54, 62, 52, 60, 32, 40, 34, 42 },
        { 53, 61, 33, 41, 35, 43, 55, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
