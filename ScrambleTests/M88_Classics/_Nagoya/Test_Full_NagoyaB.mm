//
//  Test_Full_NagoyaB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NagoyaB : XCTestCase

@end

@implementation Test_Full_NagoyaB

- (void)testFull_NagoyaB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NagoyaB_EachQuad_4x4();

    const M aExpected = {
        {  2, 27, 17, 10,  6, 31, 21, 14 },
        {  1, 11, 18, 26,  5, 15, 22, 30 },
        {  3, 24, 16,  9,  7, 28, 20, 13 },
        {  0,  8, 19, 25,  4, 12, 23, 29 },
        { 34, 59, 49, 42, 38, 63, 53, 46 },
        { 33, 43, 50, 58, 37, 47, 54, 62 },
        { 35, 56, 48, 41, 39, 60, 52, 45 },
        { 32, 40, 51, 57, 36, 44, 55, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NagoyaB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NagoyaB_8x8();

    const M aExpected = {
        {  4, 21, 38, 55, 54, 35, 20,  1 },
        { 28,  9, 12, 29, 46, 63, 62, 43 },
        {  6, 23, 36, 53, 52, 33, 22,  3 },
        { 30, 11, 14, 31, 44, 61, 60, 41 },
        { 18,  7, 48, 37, 32, 49,  2, 19 },
        { 10, 27, 26, 15, 56, 45, 40, 57 },
        { 16,  5, 50, 39, 34, 51,  0, 17 },
        {  8, 25, 24, 13, 58, 47, 42, 59 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
