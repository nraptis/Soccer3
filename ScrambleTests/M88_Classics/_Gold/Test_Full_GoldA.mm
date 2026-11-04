//
//  Test_Full_GoldA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GoldA : XCTestCase

@end

@implementation Test_Full_GoldA

- (void)testFull_GoldA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GoldA_EachQuad_4x4();

    const M aExpected = {
        {  8, 26, 10, 24, 12, 30, 14, 28 },
        { 16,  2, 18,  0, 20,  6, 22,  4 },
        {  3, 19,  1, 17,  7, 23,  5, 21 },
        { 11, 27,  9, 25, 15, 31, 13, 29 },
        { 40, 58, 42, 56, 44, 62, 46, 60 },
        { 48, 34, 50, 32, 52, 38, 54, 36 },
        { 35, 51, 33, 49, 39, 55, 37, 53 },
        { 43, 59, 41, 57, 47, 63, 45, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GoldA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GoldA_8x8();

    const M aExpected = {
        { 16, 54, 22, 52, 20, 50, 18, 48 },
        { 24, 62, 30, 60, 28, 58, 26, 56 },
        { 32,  6, 38,  4, 36,  2, 34,  0 },
        { 40, 14, 46, 12, 44, 10, 42,  8 },
        {  7, 39,  5, 37,  3, 35,  1, 33 },
        { 15, 47, 13, 45, 11, 43,  9, 41 },
        { 23, 55, 21, 53, 19, 51, 17, 49 },
        { 31, 63, 29, 61, 27, 59, 25, 57 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
