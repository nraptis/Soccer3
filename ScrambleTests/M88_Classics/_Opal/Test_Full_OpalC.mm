//
//  Test_Full_OpalC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_OpalC : XCTestCase

@end

@implementation Test_Full_OpalC

- (void)testFull_OpalC_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalC_4x4();

    const M aExpected = {
        { 20, 21, 18, 19, 34, 35, 36, 37 },
        { 28, 29, 26, 27, 42, 43, 44, 45 },
        { 22, 23, 16, 17, 32, 33, 38, 39 },
        { 30, 31, 24, 25, 40, 41, 46, 47 },
        {  6,  7,  0,  1, 48, 49, 54, 55 },
        { 14, 15,  8,  9, 56, 57, 62, 63 },
        {  4,  5,  2,  3, 50, 51, 52, 53 },
        { 12, 13, 10, 11, 58, 59, 60, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_OpalC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalC_EachQuad_4x4();

    const M aExpected = {
        { 10,  9, 17, 18, 14, 13, 21, 22 },
        { 11,  8, 16, 19, 15, 12, 20, 23 },
        {  3,  0, 24, 27,  7,  4, 28, 31 },
        {  2,  1, 25, 26,  6,  5, 29, 30 },
        { 42, 41, 49, 50, 46, 45, 53, 54 },
        { 43, 40, 48, 51, 47, 44, 52, 55 },
        { 35, 32, 56, 59, 39, 36, 60, 63 },
        { 34, 33, 57, 58, 38, 37, 61, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_OpalC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalC_8x8();

    const M aExpected = {
        { 12, 11, 19, 20, 44, 43, 51, 52 },
        { 13, 10, 18, 21, 45, 42, 50, 53 },
        { 14,  9, 17, 22, 46, 41, 49, 54 },
        { 15,  8, 16, 23, 47, 40, 48, 55 },
        {  7,  0, 24, 31, 39, 32, 56, 63 },
        {  6,  1, 25, 30, 38, 33, 57, 62 },
        {  5,  2, 26, 29, 37, 34, 58, 61 },
        {  4,  3, 27, 28, 36, 35, 59, 60 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
