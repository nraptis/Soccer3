//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ShearC : XCTestCase

@end

@implementation Test_Full_ShearC

- (void)testFull_ShearC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ShearC_EachQuad_4x4();

    const M aExpected = {
        { 16, 25, 18, 27, 20, 29, 22, 31 },
        { 24,  1, 26,  3, 28,  5, 30,  7 },
        {  0,  9,  2, 11,  4, 13,  6, 15 },
        {  8, 17, 10, 19, 12, 21, 14, 23 },
        { 48, 57, 50, 59, 52, 61, 54, 63 },
        { 56, 33, 58, 35, 60, 37, 62, 39 },
        { 32, 41, 34, 43, 36, 45, 38, 47 },
        { 40, 49, 42, 51, 44, 53, 46, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}


- (void)testFull_ShearC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ShearC_8x8();

    const M aExpected = {
        { 32, 49, 34, 51, 36, 53, 38, 55 },
        { 40, 57, 42, 59, 44, 61, 46, 63 },
        { 48,  1, 50,  3, 52,  5, 54,  7 },
        { 56,  9, 58, 11, 60, 13, 62, 15 },
        {  0, 17,  2, 19,  4, 21,  6, 23 },
        {  8, 25, 10, 27, 12, 29, 14, 31 },
        { 16, 33, 18, 35, 20, 37, 22, 39 },
        { 24, 41, 26, 43, 28, 45, 30, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
