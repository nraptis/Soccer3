//
//  Test_Full_KryptonC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_KryptonC : XCTestCase

@end

@implementation Test_Full_KryptonC

- (void)testFull_KryptonC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KryptonC_EachQuad_4x4();

    const M aExpected = {
        { 24, 10,  1, 19, 28, 14,  5, 23 },
        { 16,  2,  9, 27, 20,  6, 13, 31 },
        {  0, 11, 25, 18,  4, 15, 29, 22 },
        {  8,  3, 17, 26, 12,  7, 21, 30 },
        { 56, 42, 33, 51, 60, 46, 37, 55 },
        { 48, 34, 41, 59, 52, 38, 45, 63 },
        { 32, 43, 57, 50, 36, 47, 61, 54 },
        { 40, 35, 49, 58, 44, 39, 53, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_KryptonC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KryptonC_8x8();

    const M aExpected = {
        { 57, 31,  9, 29, 11, 45, 59, 47 },
        { 56, 30,  8, 28, 10, 44, 58, 46 },
        { 41, 15, 25, 13, 27, 61, 43, 63 },
        { 40, 14, 24, 12, 26, 60, 42, 62 },
        {  1, 23,  3, 21, 51, 37, 49, 39 },
        {  0, 22,  2, 20, 50, 36, 48, 38 },
        { 17,  7, 19,  5, 35, 53, 33, 55 },
        { 16,  6, 18,  4, 34, 52, 32, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
