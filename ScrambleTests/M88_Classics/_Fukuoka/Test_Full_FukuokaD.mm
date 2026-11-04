//
//  Test_Full_FukuokaD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_FukuokaD : XCTestCase

@end

@implementation Test_Full_FukuokaD

- (void)testFull_FukuokaD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FukuokaD_EachQuad_4x4();

    const M aExpected = {
        { 16, 25, 27, 18, 20, 29, 31, 22 },
        {  1, 17, 10, 26,  5, 21, 14, 30 },
        {  9,  0,  2, 11, 13,  4,  6, 15 },
        { 24,  8, 19,  3, 28, 12, 23,  7 },
        { 48, 57, 59, 50, 52, 61, 63, 54 },
        { 33, 49, 42, 58, 37, 53, 46, 62 },
        { 41, 32, 34, 43, 45, 36, 38, 47 },
        { 56, 40, 51, 35, 60, 44, 55, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_FukuokaD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FukuokaD_8x8();

    const M aExpected = {
        { 32, 56, 34, 58, 54, 46, 52, 44 },
        { 33, 57, 35, 59, 55, 47, 53, 45 },
        {  2, 40,  0, 42, 20, 62, 22, 60 },
        {  3, 41,  1, 43, 21, 63, 23, 61 },
        { 18, 10, 16,  8,  4, 28,  6, 30 },
        { 19, 11, 17,  9,  5, 29,  7, 31 },
        { 48, 26, 50, 24, 38, 12, 36, 14 },
        { 49, 27, 51, 25, 39, 13, 37, 15 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
