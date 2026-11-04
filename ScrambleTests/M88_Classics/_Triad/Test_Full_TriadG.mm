//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TriadG : XCTestCase

@end

@implementation Test_Full_TriadG

- (void)testFull_TriadG_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TriadG_EachQuad_2x2();

    const M aExpected = {
        {  0,  1, 16, 17,  4,  5, 20, 21 },
        {  8,  9, 24, 25, 12, 13, 28, 29 },
        { 18, 19,  2,  3, 22, 23,  6,  7 },
        { 26, 27, 10, 11, 30, 31, 14, 15 },
        { 32, 33, 48, 49, 36, 37, 52, 53 },
        { 40, 41, 56, 57, 44, 45, 60, 61 },
        { 50, 51, 34, 35, 54, 55, 38, 39 },
        { 58, 59, 42, 43, 62, 63, 46, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_TriadG_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TriadG_EachMini_2x2();

    const M aExpected = {
        {  0,  8,  2, 10,  4, 12,  6, 14 },
        {  9,  1, 11,  3, 13,  5, 15,  7 },
        { 16, 24, 18, 26, 20, 28, 22, 30 },
        { 25, 17, 27, 19, 29, 21, 31, 23 },
        { 32, 40, 34, 42, 36, 44, 38, 46 },
        { 41, 33, 43, 35, 45, 37, 47, 39 },
        { 48, 56, 50, 58, 52, 60, 54, 62 },
        { 57, 49, 59, 51, 61, 53, 63, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}



@end
