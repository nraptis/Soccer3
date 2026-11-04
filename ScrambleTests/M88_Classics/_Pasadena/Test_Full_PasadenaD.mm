//
//  Test_Full_PasadenaD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PasadenaD : XCTestCase

@end

@implementation Test_Full_PasadenaD

- (void)testFull_PasadenaD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PasadenaD_EachQuad_4x4();

    const M aExpected = {
        {  1, 17, 10, 26,  5, 21, 14, 30 },
        { 16, 25, 27, 18, 20, 29, 31, 22 },
        { 24,  8, 19,  3, 28, 12, 23,  7 },
        {  9,  0,  2, 11, 13,  4,  6, 15 },
        { 33, 49, 42, 58, 37, 53, 46, 62 },
        { 48, 57, 59, 50, 52, 61, 63, 54 },
        { 56, 40, 51, 35, 60, 44, 55, 39 },
        { 41, 32, 34, 43, 45, 36, 38, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PasadenaD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PasadenaD_8x8();

    const M aExpected = {
        { 10, 32,  8, 34, 28, 54, 30, 52 },
        { 11, 33,  9, 35, 29, 55, 31, 53 },
        { 40, 48, 42, 50, 62, 38, 60, 36 },
        { 41, 49, 43, 51, 63, 39, 61, 37 },
        { 56, 18, 58, 16, 46,  4, 44,  6 },
        { 57, 19, 59, 17, 47,  5, 45,  7 },
        { 26,  2, 24,  0, 12, 20, 14, 22 },
        { 27,  3, 25,  1, 13, 21, 15, 23 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
