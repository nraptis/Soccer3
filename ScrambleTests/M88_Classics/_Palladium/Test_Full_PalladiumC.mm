//
//  Test_Full_PalladiumC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PalladiumC : XCTestCase

@end

@implementation Test_Full_PalladiumC

- (void)testFull_PalladiumC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PalladiumC_EachQuad_4x4();

    const M aExpected = {
        {  1, 17,  3, 19,  5, 21,  7, 23 },
        { 10, 26,  8, 24, 14, 30, 12, 28 },
        {  0, 16,  2, 18,  4, 20,  6, 22 },
        {  9, 25, 11, 27, 13, 29, 15, 31 },
        { 33, 49, 35, 51, 37, 53, 39, 55 },
        { 42, 58, 40, 56, 46, 62, 44, 60 },
        { 32, 48, 34, 50, 36, 52, 38, 54 },
        { 41, 57, 43, 59, 45, 61, 47, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PalladiumC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PalladiumC_8x8();

    const M aExpected = {
        {  3, 35,  1, 33,  7, 39,  5, 37 },
        { 13, 45, 11, 43,  9, 41, 15, 47 },
        { 19, 51, 17, 49, 23, 55, 21, 53 },
        { 29, 61, 27, 59, 25, 57, 31, 63 },
        {  2, 34,  0, 32,  6, 38,  4, 36 },
        { 12, 44, 10, 42,  8, 40, 14, 46 },
        { 18, 50, 16, 48, 22, 54, 20, 52 },
        { 28, 60, 26, 58, 24, 56, 30, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
