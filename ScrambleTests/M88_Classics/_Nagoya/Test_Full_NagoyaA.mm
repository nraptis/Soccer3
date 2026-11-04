//
//  Test_Full_NagoyaA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NagoyaA : XCTestCase

@end

@implementation Test_Full_NagoyaA

- (void)testFull_NagoyaA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NagoyaA_EachQuad_4x4();

    const M aExpected = {
        { 10,  2, 27, 17, 14,  6, 31, 21 },
        { 11, 18, 26,  1, 15, 22, 30,  5 },
        {  9,  3, 24, 16, 13,  7, 28, 20 },
        {  8, 19, 25,  0, 12, 23, 29,  4 },
        { 42, 34, 59, 49, 46, 38, 63, 53 },
        { 43, 50, 58, 33, 47, 54, 62, 37 },
        { 41, 35, 56, 48, 45, 39, 60, 52 },
        { 40, 51, 57, 32, 44, 55, 61, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NagoyaA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NagoyaA_8x8();

    const M aExpected = {
        { 20,  1,  4, 21, 38, 55, 54, 35 },
        { 12, 29, 46, 63, 62, 43, 28,  9 },
        { 22,  3,  6, 23, 36, 53, 52, 33 },
        { 14, 31, 44, 61, 60, 41, 30, 11 },
        {  2, 19, 18,  7, 48, 37, 32, 49 },
        { 26, 15, 56, 45, 40, 57, 10, 27 },
        {  0, 17, 16,  5, 50, 39, 34, 51 },
        { 24, 13, 58, 47, 42, 59,  8, 25 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
