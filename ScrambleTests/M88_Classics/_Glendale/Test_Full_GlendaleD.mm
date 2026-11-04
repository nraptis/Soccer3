//
//  Test_Full_GlendaleD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GlendaleD : XCTestCase

@end

@implementation Test_Full_GlendaleD

- (void)testFull_GlendaleD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GlendaleD_EachQuad_4x4();

    const M aExpected = {
        {  3,  2,  8,  9,  7,  6, 12, 13 },
        {  1, 11, 10,  0,  5, 15, 14,  4 },
        { 26, 27, 17, 16, 30, 31, 21, 20 },
        { 24, 18, 19, 25, 28, 22, 23, 29 },
        { 35, 34, 40, 41, 39, 38, 44, 45 },
        { 33, 43, 42, 32, 37, 47, 46, 36 },
        { 58, 59, 49, 48, 62, 63, 53, 52 },
        { 56, 50, 51, 57, 60, 54, 55, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GlendaleD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GlendaleD_8x8();

    const M aExpected = {
        { 15,  7, 13,  5, 25, 17, 27, 19 },
        { 26, 18, 14,  6, 12,  4, 24, 16 },
        { 31, 23, 29, 21,  9,  1, 11,  3 },
        { 10,  2, 30, 22, 28, 20,  8,  0 },
        { 61, 53, 63, 55, 43, 35, 41, 33 },
        { 40, 32, 60, 52, 62, 54, 42, 34 },
        { 45, 37, 47, 39, 59, 51, 57, 49 },
        { 56, 48, 44, 36, 46, 38, 58, 50 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
