//
//  Test_Full_IronC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_IronC : XCTestCase

@end

@implementation Test_Full_IronC

- (void)testFull_IronC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_IronC_EachQuad_4x4();

    const M aExpected = {
        {  8, 24, 10, 26, 12, 28, 14, 30 },
        {  3, 19,  1, 17,  7, 23,  5, 21 },
        { 11, 25,  9, 27, 15, 29, 13, 31 },
        {  2, 16,  0, 18,  6, 20,  4, 22 },
        { 40, 56, 42, 58, 44, 60, 46, 62 },
        { 35, 51, 33, 49, 39, 55, 37, 53 },
        { 43, 57, 41, 59, 47, 61, 45, 63 },
        { 34, 48, 32, 50, 38, 52, 36, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_IronC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_IronC_8x8();

    const M aExpected = {
        { 31, 63, 25, 57, 27, 59, 29, 61 },
        { 21, 53, 23, 55, 17, 49, 19, 51 },
        { 15, 47,  9, 41, 11, 43, 13, 45 },
        {  5, 37,  7, 39,  1, 33,  3, 35 },
        { 30, 56, 24, 58, 26, 60, 28, 62 },
        { 20, 54, 22, 48, 16, 50, 18, 52 },
        { 14, 40,  8, 42, 10, 44, 12, 46 },
        {  4, 38,  6, 32,  0, 34,  2, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
