//
//  Test_Full_KobeD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_KobeD : XCTestCase

@end

@implementation Test_Full_KobeD

- (void)testFull_KobeD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KobeD_EachQuad_4x4();

    const M aExpected = {
        {  3,  2,  8,  9,  7,  6, 12, 13 },
        { 10,  0,  1, 11, 14,  4,  5, 15 },
        { 26, 27, 17, 16, 30, 31, 21, 20 },
        { 19, 25, 24, 18, 23, 29, 28, 22 },
        { 35, 34, 40, 41, 39, 38, 44, 45 },
        { 42, 32, 33, 43, 46, 36, 37, 47 },
        { 58, 59, 49, 48, 62, 63, 53, 52 },
        { 51, 57, 56, 50, 55, 61, 60, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_KobeD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KobeD_8x8();

    const M aExpected = {
        {  7, 15,  5, 13, 17, 25, 19, 27 },
        {  4, 12, 16, 24, 18, 26,  6, 14 },
        { 23, 31, 21, 29,  1,  9,  3, 11 },
        { 20, 28,  0,  8,  2, 10, 22, 30 },
        { 53, 61, 55, 63, 35, 43, 33, 41 },
        { 54, 62, 34, 42, 32, 40, 52, 60 },
        { 37, 45, 39, 47, 51, 59, 49, 57 },
        { 38, 46, 50, 58, 48, 56, 36, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
