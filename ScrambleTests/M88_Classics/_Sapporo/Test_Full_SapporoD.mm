//
//  Test_Full_SapporoD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SapporoD : XCTestCase

@end

@implementation Test_Full_SapporoD

- (void)testFull_SapporoD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SapporoD_EachQuad_4x4();

    const M aExpected = {
        { 24, 25, 19, 18, 28, 29, 23, 22 },
        { 26, 16, 17, 27, 30, 20, 21, 31 },
        {  1,  0, 10, 11,  5,  4, 14, 15 },
        {  3,  9,  8,  2,  7, 13, 12,  6 },
        { 56, 57, 51, 50, 60, 61, 55, 54 },
        { 58, 48, 49, 59, 62, 52, 53, 63 },
        { 33, 32, 42, 43, 37, 36, 46, 47 },
        { 35, 41, 40, 34, 39, 45, 44, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SapporoD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SapporoD_8x8();

    const M aExpected = {
        { 57, 49, 59, 51, 47, 39, 45, 37 },
        { 44, 36, 56, 48, 58, 50, 46, 38 },
        { 41, 33, 43, 35, 63, 55, 61, 53 },
        { 60, 52, 40, 32, 42, 34, 62, 54 },
        { 11,  3,  9,  1, 29, 21, 31, 23 },
        { 30, 22, 10,  2,  8,  0, 28, 20 },
        { 27, 19, 25, 17, 13,  5, 15,  7 },
        { 14,  6, 26, 18, 24, 16, 12,  4 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
