//
//  Test_Full_BrassA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_BrassA : XCTestCase

@end

@implementation Test_Full_BrassA

- (void)testFull_BrassA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BrassA_EachQuad_4x4();

    const M aExpected = {
        {  9, 27, 11, 25, 13, 31, 15, 29 },
        {  2, 16,  0, 18,  6, 20,  4, 22 },
        { 10, 26,  8, 24, 14, 30, 12, 28 },
        {  3, 19,  1, 17,  7, 23,  5, 21 },
        { 41, 59, 43, 57, 45, 63, 47, 61 },
        { 34, 48, 32, 50, 38, 52, 36, 54 },
        { 42, 58, 40, 56, 46, 62, 44, 60 },
        { 35, 51, 33, 49, 39, 55, 37, 53 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_BrassA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BrassA_8x8();

    const M aExpected = {
        { 27, 61, 29, 63, 31, 57, 25, 59 },
        { 21, 55, 23, 49, 17, 51, 19, 53 },
        { 11, 45, 13, 47, 15, 41,  9, 43 },
        {  5, 39,  7, 33,  1, 35,  3, 37 },
        { 28, 60, 30, 62, 24, 56, 26, 58 },
        { 22, 54, 16, 48, 18, 50, 20, 52 },
        { 12, 44, 14, 46,  8, 40, 10, 42 },
        {  6, 38,  0, 32,  2, 34,  4, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
