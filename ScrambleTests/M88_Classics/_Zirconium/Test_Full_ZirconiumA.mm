//
//  Test_Full_ZirconiumA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ZirconiumA : XCTestCase

@end

@implementation Test_Full_ZirconiumA


- (void)testFull_ZirconiumA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ZirconiumA_EachQuad_4x4();

    const M aExpected = {
        { 16,  0, 18,  2, 20,  4, 22,  6 },
        {  8, 24, 10, 26, 12, 28, 14, 30 },
        {  9, 25, 11, 27, 13, 29, 15, 31 },
        {  1, 17,  3, 19,  5, 21,  7, 23 },
        { 48, 32, 50, 34, 52, 36, 54, 38 },
        { 40, 56, 42, 58, 44, 60, 46, 62 },
        { 41, 57, 43, 59, 45, 61, 47, 63 },
        { 33, 49, 35, 51, 37, 53, 39, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ZirconiumA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ZirconiumA_8x8();

    const M aExpected = {
        { 40,  8, 42, 10, 44, 12, 46, 14 },
        { 32,  0, 34,  2, 36,  4, 38,  6 },
        { 24, 56, 26, 58, 28, 60, 30, 62 },
        { 16, 48, 18, 50, 20, 52, 22, 54 },
        { 25, 57, 27, 59, 29, 61, 31, 63 },
        { 17, 49, 19, 51, 21, 53, 23, 55 },
        {  9, 41, 11, 43, 13, 45, 15, 47 },
        {  1, 33,  3, 35,  5, 37,  7, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
