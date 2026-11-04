//
//  Test_Full_BronzeA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_BronzeA : XCTestCase

@end

@implementation Test_Full_BronzeA

- (void)testFull_BronzeA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BronzeA_EachQuad_4x4();

    const M aExpected = {
        { 10, 24,  8, 26, 14, 28, 12, 30 },
        {  1, 19,  3, 17,  5, 23,  7, 21 },
        { 11, 27,  9, 25, 15, 31, 13, 29 },
        {  2, 18,  0, 16,  6, 22,  4, 20 },
        { 42, 56, 40, 58, 46, 60, 44, 62 },
        { 33, 51, 35, 49, 37, 55, 39, 53 },
        { 43, 59, 41, 57, 47, 63, 45, 61 },
        { 34, 50, 32, 48, 38, 54, 36, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_BronzeA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BronzeA_8x8();

    const M aExpected = {
        { 29, 63, 31, 57, 25, 59, 27, 61 },
        { 19, 53, 21, 55, 23, 49, 17, 51 },
        { 13, 47, 15, 41,  9, 43, 11, 45 },
        {  3, 37,  5, 39,  7, 33,  1, 35 },
        { 30, 62, 24, 56, 26, 58, 28, 60 },
        { 20, 52, 22, 54, 16, 48, 18, 50 },
        { 14, 46,  8, 40, 10, 42, 12, 44 },
        {  4, 36,  6, 38,  0, 32,  2, 34 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
