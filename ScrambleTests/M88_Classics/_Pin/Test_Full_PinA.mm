//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PinA : XCTestCase

@end

@implementation Test_Full_PinA

- (void)testFull_PinA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PinA_8x8();

    const M aExpected = {
        { 56, 48, 40, 32, 24, 16,  8,  0 },
        { 57, 14, 22, 30, 38, 46, 54,  1 },
        { 58, 13, 42, 34, 26, 18, 53,  2 },
        { 59, 12, 43, 28, 36, 19, 52,  3 },
        { 60, 11, 44, 27, 35, 20, 51,  4 },
        { 61, 10, 45, 37, 29, 21, 50,  5 },
        { 62,  9, 17, 25, 33, 41, 49,  6 },
        { 63, 55, 47, 39, 31, 23, 15,  7 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
