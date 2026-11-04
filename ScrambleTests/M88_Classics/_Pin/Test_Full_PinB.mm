//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PinB : XCTestCase

@end

@implementation Test_Full_PinB

- (void)testFull_PinB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PinB_8x8();

    const M aExpected = {
        {  7, 15, 23, 31, 39, 47, 55, 63 },
        {  6, 49, 41, 33, 25, 17,  9, 62 },
        {  5, 50, 21, 29, 37, 45, 10, 61 },
        {  4, 51, 20, 35, 27, 44, 11, 60 },
        {  3, 52, 19, 36, 28, 43, 12, 59 },
        {  2, 53, 18, 26, 34, 42, 13, 58 },
        {  1, 54, 46, 38, 30, 22, 14, 57 },
        {  0,  8, 16, 24, 32, 40, 48, 56 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
