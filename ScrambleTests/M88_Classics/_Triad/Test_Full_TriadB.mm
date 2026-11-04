//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TriadB : XCTestCase

@end

@implementation Test_Full_TriadB

- (void)testFull_TriadB_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TriadB_EachQuad_2x2();

    const M aExpected = {
        { 16, 17,  0,  1, 20, 21,  4,  5 },
        { 24, 25,  8,  9, 28, 29, 12, 13 },
        {  2,  3, 18, 19,  6,  7, 22, 23 },
        { 10, 11, 26, 27, 14, 15, 30, 31 },
        { 48, 49, 32, 33, 52, 53, 36, 37 },
        { 56, 57, 40, 41, 60, 61, 44, 45 },
        { 34, 35, 50, 51, 38, 39, 54, 55 },
        { 42, 43, 58, 59, 46, 47, 62, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_TriadB_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TriadB_EachMini_2x2();

    const M aExpected = {
        {  8,  0, 10,  2, 12,  4, 14,  6 },
        {  1,  9,  3, 11,  5, 13,  7, 15 },
        { 24, 16, 26, 18, 28, 20, 30, 22 },
        { 17, 25, 19, 27, 21, 29, 23, 31 },
        { 40, 32, 42, 34, 44, 36, 46, 38 },
        { 33, 41, 35, 43, 37, 45, 39, 47 },
        { 56, 48, 58, 50, 60, 52, 62, 54 },
        { 49, 57, 51, 59, 53, 61, 55, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}


@end
