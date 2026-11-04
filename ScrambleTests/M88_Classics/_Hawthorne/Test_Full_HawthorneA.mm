//
//  Test_Full_HawthorneA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HawthorneA : XCTestCase

@end

@implementation Test_Full_HawthorneA

- (void)testFull_HawthorneA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HawthorneA_EachQuad_4x4();

    const M aExpected = {
        { 19, 26, 24, 17, 23, 30, 28, 21 },
        {  2, 18,  9, 25,  6, 22, 13, 29 },
        { 10,  3,  1,  8, 14,  7,  5, 12 },
        { 27, 11, 16,  0, 31, 15, 20,  4 },
        { 51, 58, 56, 49, 55, 62, 60, 53 },
        { 34, 50, 41, 57, 38, 54, 45, 61 },
        { 42, 35, 33, 40, 46, 39, 37, 44 },
        { 59, 43, 48, 32, 63, 47, 52, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HawthorneA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HawthorneA_8x8();

    const M aExpected = {
        { 46, 54, 44, 52, 56, 32, 58, 34 },
        { 47, 55, 45, 53, 57, 33, 59, 35 },
        { 12, 38, 14, 36, 26, 48, 24, 50 },
        { 13, 39, 15, 37, 27, 49, 25, 51 },
        { 28,  4, 30,  6, 10, 18,  8, 16 },
        { 29,  5, 31,  7, 11, 19,  9, 17 },
        { 62, 20, 60, 22, 40,  2, 42,  0 },
        { 63, 21, 61, 23, 41,  3, 43,  1 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
