//
//  Test_Full_BrassB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_BrassB : XCTestCase

@end

@implementation Test_Full_BrassB

- (void)testFull_BrassB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BrassB_EachQuad_4x4();

    const M aExpected = {
        {  3, 10,  2,  9,  7, 14,  6, 13 },
        { 19, 26, 16, 27, 23, 30, 20, 31 },
        {  1,  8,  0, 11,  5, 12,  4, 15 },
        { 17, 24, 18, 25, 21, 28, 22, 29 },
        { 35, 42, 34, 41, 39, 46, 38, 45 },
        { 51, 58, 48, 59, 55, 62, 52, 63 },
        { 33, 40, 32, 43, 37, 44, 36, 47 },
        { 49, 56, 50, 57, 53, 60, 54, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_BrassB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BrassB_8x8();

    const M aExpected = {
        {  6, 12, 22, 28,  5, 11, 21, 27 },
        { 38, 44, 54, 60, 39, 45, 55, 61 },
        {  0, 14, 16, 30,  7, 13, 23, 29 },
        { 32, 46, 48, 62, 33, 47, 49, 63 },
        {  2,  8, 18, 24,  1, 15, 17, 31 },
        { 34, 40, 50, 56, 35, 41, 51, 57 },
        {  4, 10, 20, 26,  3,  9, 19, 25 },
        { 36, 42, 52, 58, 37, 43, 53, 59 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
