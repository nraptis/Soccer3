//
//  Test_Full_KobeA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_KobeA : XCTestCase

@end

@implementation Test_Full_KobeA

- (void)testFull_KobeA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KobeA_EachQuad_4x4();

    const M aExpected = {
        { 17,  1, 26, 10, 21,  5, 30, 14 },
        { 25, 16, 18, 27, 29, 20, 22, 31 },
        {  8, 24,  3, 19, 12, 28,  7, 23 },
        {  0,  9, 11,  2,  4, 13, 15,  6 },
        { 49, 33, 58, 42, 53, 37, 62, 46 },
        { 57, 48, 50, 59, 61, 52, 54, 63 },
        { 40, 56, 35, 51, 44, 60, 39, 55 },
        { 32, 41, 43, 34, 36, 45, 47, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_KobeA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KobeA_8x8();

    const M aExpected = {
        { 35,  9, 33, 11, 53, 31, 55, 29 },
        { 34,  8, 32, 10, 52, 30, 54, 28 },
        { 51, 43, 49, 41, 37, 61, 39, 63 },
        { 50, 42, 48, 40, 36, 60, 38, 62 },
        { 17, 59, 19, 57,  7, 45,  5, 47 },
        { 16, 58, 18, 56,  6, 44,  4, 46 },
        {  1, 25,  3, 27, 23, 15, 21, 13 },
        {  0, 24,  2, 26, 22, 14, 20, 12 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
