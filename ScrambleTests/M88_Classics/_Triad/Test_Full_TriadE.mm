//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TriadE : XCTestCase

@end

@implementation Test_Full_TriadE

- (void)testFull_TriadE_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TriadE_EachQuad_2x2();

    const M aExpected = {
        { 16, 17,  2,  3, 20, 21,  6,  7 },
        { 24, 25, 10, 11, 28, 29, 14, 15 },
        { 18, 19,  0,  1, 22, 23,  4,  5 },
        { 26, 27,  8,  9, 30, 31, 12, 13 },
        { 48, 49, 34, 35, 52, 53, 38, 39 },
        { 56, 57, 42, 43, 60, 61, 46, 47 },
        { 50, 51, 32, 33, 54, 55, 36, 37 },
        { 58, 59, 40, 41, 62, 63, 44, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_TriadE_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TriadE_EachMini_2x2();

    const M aExpected = {
        {  8,  1, 10,  3, 12,  5, 14,  7 },
        {  9,  0, 11,  2, 13,  4, 15,  6 },
        { 24, 17, 26, 19, 28, 21, 30, 23 },
        { 25, 16, 27, 18, 29, 20, 31, 22 },
        { 40, 33, 42, 35, 44, 37, 46, 39 },
        { 41, 32, 43, 34, 45, 36, 47, 38 },
        { 56, 49, 58, 51, 60, 53, 62, 55 },
        { 57, 48, 59, 50, 61, 52, 63, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
