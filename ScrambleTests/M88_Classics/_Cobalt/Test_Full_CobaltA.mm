//
//  Test_Full_CobaltA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_CobaltA : XCTestCase

@end

@implementation Test_Full_CobaltA

- (void)testFull_CobaltA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CobaltA_EachQuad_4x4();

    const M aExpected = {
        { 27,  9, 25, 11, 31, 13, 29, 15 },
        { 19,  1, 17,  3, 23,  5, 21,  7 },
        {  0, 16,  2, 18,  4, 20,  6, 22 },
        { 24,  8, 26, 10, 28, 12, 30, 14 },
        { 59, 41, 57, 43, 63, 45, 61, 47 },
        { 51, 33, 49, 35, 55, 37, 53, 39 },
        { 32, 48, 34, 50, 36, 52, 38, 54 },
        { 56, 40, 58, 42, 60, 44, 62, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_CobaltA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_CobaltA_8x8();

    const M aExpected = {
        { 63, 25, 57, 27, 59, 29, 61, 31 },
        { 55, 17, 49, 19, 51, 21, 53, 23 },
        { 47,  9, 41, 11, 43, 13, 45, 15 },
        { 39,  1, 33,  3, 35,  5, 37,  7 },
        {  8, 40, 10, 42, 12, 44, 14, 46 },
        {  0, 32,  2, 34,  4, 36,  6, 38 },
        { 56, 24, 58, 26, 60, 28, 62, 30 },
        { 48, 16, 50, 18, 52, 20, 54, 22 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
