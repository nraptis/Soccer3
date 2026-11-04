//
//  Test_Full_PasadenaC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PasadenaC : XCTestCase

@end

@implementation Test_Full_PasadenaC

- (void)testFull_PasadenaC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PasadenaC_EachQuad_4x4();

    const M aExpected = {
        { 16,  0, 27, 11, 20,  4, 31, 15 },
        { 24, 17, 19, 26, 28, 21, 23, 30 },
        {  9, 25,  2, 18, 13, 29,  6, 22 },
        {  1,  8, 10,  3,  5, 12, 14,  7 },
        { 48, 32, 59, 43, 52, 36, 63, 47 },
        { 56, 49, 51, 58, 60, 53, 55, 62 },
        { 41, 57, 34, 50, 45, 61, 38, 54 },
        { 33, 40, 42, 35, 37, 44, 46, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PasadenaC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PasadenaC_8x8();

    const M aExpected = {
        { 40,  2, 42,  0, 62, 20, 60, 22 },
        { 41,  3, 43,  1, 63, 21, 61, 23 },
        { 56, 32, 58, 34, 46, 54, 44, 52 },
        { 57, 33, 59, 35, 47, 55, 45, 53 },
        { 26, 48, 24, 50, 12, 38, 14, 36 },
        { 27, 49, 25, 51, 13, 39, 15, 37 },
        { 10, 18,  8, 16, 28,  4, 30,  6 },
        { 11, 19,  9, 17, 29,  5, 31,  7 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
