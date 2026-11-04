//
//  Test_Full_MerciaA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_MerciaA : XCTestCase

@end

@implementation Test_Full_MerciaA

- (void)testFull_MerciaA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MerciaA_EachQuad_4x4();

    const M aExpected = {
        {  2,  9, 27, 16,  6, 13, 31, 20 },
        { 10,  1, 19, 24, 14,  5, 23, 28 },
        {  3, 17, 26,  8,  7, 21, 30, 12 },
        { 11, 25, 18,  0, 15, 29, 22,  4 },
        { 34, 41, 59, 48, 38, 45, 63, 52 },
        { 42, 33, 51, 56, 46, 37, 55, 60 },
        { 35, 49, 58, 40, 39, 53, 62, 44 },
        { 43, 57, 50, 32, 47, 61, 54, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_MerciaA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MerciaA_8x8();

    const M aExpected = {
        { 14, 24, 12, 26, 60, 42, 62, 40 },
        { 15, 25, 13, 27, 61, 43, 63, 41 },
        { 30,  8, 28, 10, 44, 58, 46, 56 },
        { 31,  9, 29, 11, 45, 59, 47, 57 },
        {  6, 18,  4, 34, 52, 32, 54, 16 },
        {  7, 19,  5, 35, 53, 33, 55, 17 },
        { 22,  2, 20, 50, 36, 48, 38,  0 },
        { 23,  3, 21, 51, 37, 49, 39,  1 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
