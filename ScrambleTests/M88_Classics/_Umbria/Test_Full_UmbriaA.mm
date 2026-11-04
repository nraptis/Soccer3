//
//  Test_Full_UmbriaA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_UmbriaA : XCTestCase

@end

@implementation Test_Full_UmbriaA

- (void)testFull_UmbriaA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_UmbriaA_EachQuad_4x4();

    const M aExpected = {
        {  0, 18,  1, 19,  4, 22,  5, 23 },
        {  8, 26, 25, 11, 12, 30, 29, 15 },
        { 24, 27,  9, 10, 28, 31, 13, 14 },
        { 16,  3, 17,  2, 20,  7, 21,  6 },
        { 32, 50, 33, 51, 36, 54, 37, 55 },
        { 40, 58, 57, 43, 44, 62, 61, 47 },
        { 56, 59, 41, 42, 60, 63, 45, 46 },
        { 48, 35, 49, 34, 52, 39, 53, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_UmbriaA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_UmbriaA_8x8();

    const M aExpected = {
        { 17, 55,  1, 53,  3, 37, 19, 39 },
        {  0, 38, 48, 36, 50, 20,  2, 22 },
        { 33,  7, 49,  5, 51, 21, 35, 23 },
        { 16, 54, 32, 52, 34,  4, 18,  6 },
        {  9, 63, 11, 61, 27, 45, 25, 47 },
        { 56, 46, 58, 44, 10, 28,  8, 30 },
        { 57, 15, 59, 13, 43, 29, 41, 31 },
        { 40, 62, 42, 60, 26, 12, 24, 14 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
