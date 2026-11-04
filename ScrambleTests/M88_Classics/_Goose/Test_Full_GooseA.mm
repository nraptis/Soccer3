//
//  Test_Full_GooseA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GooseA : XCTestCase

@end

@implementation Test_Full_GooseA

- (void)testFull_GooseA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GooseA_EachQuad_4x4();

    const M aExpected = {
        { 17, 18, 19, 16, 21, 22, 23, 20 },
        { 25, 26, 27, 24, 29, 30, 31, 28 },
        {  1,  2,  3,  0,  5,  6,  7,  4 },
        {  9, 10, 11,  8, 13, 14, 15, 12 },
        { 49, 50, 51, 48, 53, 54, 55, 52 },
        { 57, 58, 59, 56, 61, 62, 63, 60 },
        { 33, 34, 35, 32, 37, 38, 39, 36 },
        { 41, 42, 43, 40, 45, 46, 47, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GooseA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GooseA_8x8();

    const M aExpected = {
        { 33, 34, 35, 36, 37, 38, 39, 32 },
        { 41, 42, 43, 44, 45, 46, 47, 40 },
        { 49, 50, 51, 52, 53, 54, 55, 48 },
        { 57, 58, 59, 60, 61, 62, 63, 56 },
        {  1,  2,  3,  4,  5,  6,  7,  0 },
        {  9, 10, 11, 12, 13, 14, 15,  8 },
        { 17, 18, 19, 20, 21, 22, 23, 16 },
        { 25, 26, 27, 28, 29, 30, 31, 24 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
