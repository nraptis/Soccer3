//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TriadA : XCTestCase

@end

@implementation Test_Full_TriadA


- (void)testFull_TriadA_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TriadA_EachQuad_2x2();

    const M aExpected = {
        {  2,  3, 16, 17,  6,  7, 20, 21 },
        { 10, 11, 24, 25, 14, 15, 28, 29 },
        {  0,  1, 18, 19,  4,  5, 22, 23 },
        {  8,  9, 26, 27, 12, 13, 30, 31 },
        { 34, 35, 48, 49, 38, 39, 52, 53 },
        { 42, 43, 56, 57, 46, 47, 60, 61 },
        { 32, 33, 50, 51, 36, 37, 54, 55 },
        { 40, 41, 58, 59, 44, 45, 62, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_TriadA_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TriadA_EachMini_2x2();

    const M aExpected = {
        {  1,  8,  3, 10,  5, 12,  7, 14 },
        {  0,  9,  2, 11,  4, 13,  6, 15 },
        { 17, 24, 19, 26, 21, 28, 23, 30 },
        { 16, 25, 18, 27, 20, 29, 22, 31 },
        { 33, 40, 35, 42, 37, 44, 39, 46 },
        { 32, 41, 34, 43, 36, 45, 38, 47 },
        { 49, 56, 51, 58, 53, 60, 55, 62 },
        { 48, 57, 50, 59, 52, 61, 54, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}


@end
