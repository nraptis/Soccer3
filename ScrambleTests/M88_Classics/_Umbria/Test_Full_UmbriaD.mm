//
//  Test_Full_UmbriaD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_UmbriaD : XCTestCase

@end

@implementation Test_Full_UmbriaD

- (void)testFull_UmbriaD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_UmbriaD_EachQuad_4x4();

    const M aExpected = {
        { 27,  9, 10, 24, 31, 13, 14, 28 },
        {  3, 17,  2, 16,  7, 21,  6, 20 },
        { 18,  1, 19,  0, 22,  5, 23,  4 },
        { 26, 25, 11,  8, 30, 29, 15, 12 },
        { 59, 41, 42, 56, 63, 45, 46, 60 },
        { 35, 49, 34, 48, 39, 53, 38, 52 },
        { 50, 33, 51, 32, 54, 37, 55, 36 },
        { 58, 57, 43, 40, 62, 61, 47, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_UmbriaD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_UmbriaD_8x8();

    const M aExpected = {
        { 63, 11, 61, 27, 45, 25, 47,  9 },
        { 46, 58, 44, 10, 28,  8, 30, 56 },
        { 15, 59, 13, 43, 29, 41, 31, 57 },
        { 62, 42, 60, 26, 12, 24, 14, 40 },
        { 55,  1, 53,  3, 37, 19, 39, 17 },
        { 38, 48, 36, 50, 20,  2, 22,  0 },
        {  7, 49,  5, 51, 21, 35, 23, 33 },
        { 54, 32, 52, 34,  4, 18,  6, 16 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
