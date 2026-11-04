//
//  Test_Full_BrassD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_BrassD : XCTestCase

@end

@implementation Test_Full_BrassD

- (void)testFull_BrassD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BrassD_EachQuad_4x4();

    const M aExpected = {
        { 25, 18, 24, 17, 29, 22, 28, 21 },
        { 11,  0,  8,  1, 15,  4, 12,  5 },
        { 27, 16, 26, 19, 31, 20, 30, 23 },
        {  9,  2, 10,  3, 13,  6, 14,  7 },
        { 57, 50, 56, 49, 61, 54, 60, 53 },
        { 43, 32, 40, 33, 47, 36, 44, 37 },
        { 59, 48, 58, 51, 63, 52, 62, 55 },
        { 41, 34, 42, 35, 45, 38, 46, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_BrassD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BrassD_8x8();

    const M aExpected = {
        { 59, 53, 43, 37, 58, 52, 42, 36 },
        { 25, 19,  9,  3, 26, 20, 10,  4 },
        { 57, 51, 41, 35, 56, 50, 40, 34 },
        { 31, 17, 15,  1, 24, 18,  8,  2 },
        { 63, 49, 47, 33, 62, 48, 46, 32 },
        { 29, 23, 13,  7, 30, 16, 14,  0 },
        { 61, 55, 45, 39, 60, 54, 44, 38 },
        { 27, 21, 11,  5, 28, 22, 12,  6 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
