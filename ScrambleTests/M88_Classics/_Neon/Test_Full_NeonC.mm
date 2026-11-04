//
//  Test_Full_NeonC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NeonC : XCTestCase

@end

@implementation Test_Full_NeonC


- (void)testFull_NeonC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NeonC_EachQuad_4x4();

    const M aExpected = {
        {  1,  0, 24, 25,  5,  4, 28, 29 },
        {  9,  8, 16, 17, 13, 12, 20, 21 },
        { 10, 11, 19, 18, 14, 15, 23, 22 },
        {  2,  3, 27, 26,  6,  7, 31, 30 },
        { 33, 32, 56, 57, 37, 36, 60, 61 },
        { 41, 40, 48, 49, 45, 44, 52, 53 },
        { 42, 43, 51, 50, 46, 47, 55, 54 },
        { 34, 35, 59, 58, 38, 39, 63, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NeonC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NeonC_8x8();

    const M aExpected = {
        {  3, 11,  1,  9, 49, 57, 51, 59 },
        {  2, 10,  0,  8, 48, 56, 50, 58 },
        { 19, 27, 17, 25, 33, 41, 35, 43 },
        { 18, 26, 16, 24, 32, 40, 34, 42 },
        { 21, 29, 23, 31, 39, 47, 37, 45 },
        { 20, 28, 22, 30, 38, 46, 36, 44 },
        {  5, 13,  7, 15, 55, 63, 53, 61 },
        {  4, 12,  6, 14, 54, 62, 52, 60 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
