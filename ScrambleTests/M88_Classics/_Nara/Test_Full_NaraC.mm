//
//  Test_Full_NaraC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NaraC : XCTestCase

@end

@implementation Test_Full_NaraC

- (void)testFull_NaraC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NaraC_EachQuad_4x4();

    const M aExpected = {
        {  1,  8, 10,  3,  5, 12, 14,  7 },
        {  9, 25,  2, 18, 13, 29,  6, 22 },
        { 24, 17, 19, 26, 28, 21, 23, 30 },
        { 16,  0, 27, 11, 20,  4, 31, 15 },
        { 33, 40, 42, 35, 37, 44, 46, 39 },
        { 41, 57, 34, 50, 45, 61, 38, 54 },
        { 56, 49, 51, 58, 60, 53, 55, 62 },
        { 48, 32, 59, 43, 52, 36, 63, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NaraC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NaraC_8x8();

    const M aExpected = {
        { 11, 19,  9, 17, 29,  5, 31,  7 },
        { 10, 18,  8, 16, 28,  4, 30,  6 },
        { 27, 49, 25, 51, 13, 39, 15, 37 },
        { 26, 48, 24, 50, 12, 38, 14, 36 },
        { 57, 33, 59, 35, 47, 55, 45, 53 },
        { 56, 32, 58, 34, 46, 54, 44, 52 },
        { 41,  3, 43,  1, 63, 21, 61, 23 },
        { 40,  2, 42,  0, 62, 20, 60, 22 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
