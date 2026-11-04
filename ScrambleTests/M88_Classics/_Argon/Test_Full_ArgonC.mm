//
//  Test_Full_ArgonC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ArgonC : XCTestCase

@end

@implementation Test_Full_ArgonC


- (void)testFull_ArgonC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ArgonC_EachQuad_4x4();

    const M aExpected = {
        {  8, 26, 17,  3, 12, 30, 21,  7 },
        {  0, 18, 25, 11,  4, 22, 29, 15 },
        { 16, 27,  9,  2, 20, 31, 13,  6 },
        { 24, 19,  1, 10, 28, 23,  5, 14 },
        { 40, 58, 49, 35, 44, 62, 53, 39 },
        { 32, 50, 57, 43, 36, 54, 61, 47 },
        { 48, 59, 41, 34, 52, 63, 45, 38 },
        { 56, 51, 33, 42, 60, 55, 37, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ArgonC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ArgonC_8x8();

    const M aExpected = {
        { 16, 54, 32, 52, 34,  4, 18,  6 },
        { 17, 55, 33, 53, 35,  5, 19,  7 },
        {  0, 38, 48, 36, 50, 20,  2, 22 },
        {  1, 39, 49, 37, 51, 21,  3, 23 },
        { 40, 62, 42, 60, 26, 12, 24, 14 },
        { 41, 63, 43, 61, 27, 13, 25, 15 },
        { 56, 46, 58, 44, 10, 28,  8, 30 },
        { 57, 47, 59, 45, 11, 29,  9, 31 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
