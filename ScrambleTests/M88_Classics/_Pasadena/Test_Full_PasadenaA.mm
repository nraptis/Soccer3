//
//  Test_Full_PasadenaA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PasadenaA : XCTestCase

@end

@implementation Test_Full_PasadenaA

- (void)testFull_PasadenaA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PasadenaA_EachQuad_4x4();

    const M aExpected = {
        {  3,  9,  8,  2,  7, 13, 12,  6 },
        { 10, 11,  1,  0, 14, 15,  5,  4 },
        { 26, 16, 17, 27, 30, 20, 21, 31 },
        { 19, 18, 24, 25, 23, 22, 28, 29 },
        { 35, 41, 40, 34, 39, 45, 44, 38 },
        { 42, 43, 33, 32, 46, 47, 37, 36 },
        { 58, 48, 49, 59, 62, 52, 53, 63 },
        { 51, 50, 56, 57, 55, 54, 60, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PasadenaA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PasadenaA_8x8();

    const M aExpected = {
        { 14,  6, 26, 18, 24, 16, 12,  4 },
        { 13,  5, 15,  7, 27, 19, 25, 17 },
        { 30, 22, 10,  2,  8,  0, 28, 20 },
        { 29, 21, 31, 23, 11,  3,  9,  1 },
        { 60, 52, 40, 32, 42, 34, 62, 54 },
        { 63, 55, 61, 53, 41, 33, 43, 35 },
        { 44, 36, 56, 48, 58, 50, 46, 38 },
        { 47, 39, 45, 37, 57, 49, 59, 51 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
