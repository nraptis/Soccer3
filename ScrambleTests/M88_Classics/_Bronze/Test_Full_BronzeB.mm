//
//  Test_Full_BronzeB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_BronzeB : XCTestCase

@end

@implementation Test_Full_BronzeB

- (void)testFull_BronzeB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BronzeB_EachQuad_4x4();

    const M aExpected = {
        {  2, 11,  1, 10,  6, 15,  5, 14 },
        { 18, 27, 19, 24, 22, 31, 23, 28 },
        {  0,  9,  3,  8,  4, 13,  7, 12 },
        { 16, 25, 17, 26, 20, 29, 21, 30 },
        { 34, 43, 33, 42, 38, 47, 37, 46 },
        { 50, 59, 51, 56, 54, 63, 55, 60 },
        { 32, 41, 35, 40, 36, 45, 39, 44 },
        { 48, 57, 49, 58, 52, 61, 53, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_BronzeB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_BronzeB_8x8();

    const M aExpected = {
        {  4, 14, 20, 30,  3, 13, 19, 29 },
        { 36, 46, 52, 62, 37, 47, 53, 63 },
        {  6,  8, 22, 24,  5, 15, 21, 31 },
        { 38, 40, 54, 56, 39, 41, 55, 57 },
        {  0, 10, 16, 26,  7,  9, 23, 25 },
        { 32, 42, 48, 58, 33, 43, 49, 59 },
        {  2, 12, 18, 28,  1, 11, 17, 27 },
        { 34, 44, 50, 60, 35, 45, 51, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
