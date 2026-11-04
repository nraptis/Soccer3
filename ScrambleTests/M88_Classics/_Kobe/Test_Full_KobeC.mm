//
//  Test_Full_KobeC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_KobeC : XCTestCase

@end

@implementation Test_Full_KobeC

- (void)testFull_KobeC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KobeC_EachQuad_4x4();

    const M aExpected = {
        {  2,  8,  9,  3,  6, 12, 13,  7 },
        { 11, 10,  0,  1, 15, 14,  4,  5 },
        { 27, 17, 16, 26, 31, 21, 20, 30 },
        { 18, 19, 25, 24, 22, 23, 29, 28 },
        { 34, 40, 41, 35, 38, 44, 45, 39 },
        { 43, 42, 32, 33, 47, 46, 36, 37 },
        { 59, 49, 48, 58, 63, 53, 52, 62 },
        { 50, 51, 57, 56, 54, 55, 61, 60 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_KobeC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KobeC_8x8();

    const M aExpected = {
        {  5, 13, 17, 25, 19, 27,  7, 15 },
        {  6, 14,  4, 12, 16, 24, 18, 26 },
        { 21, 29,  1,  9,  3, 11, 23, 31 },
        { 22, 30, 20, 28,  0,  8,  2, 10 },
        { 55, 63, 35, 43, 33, 41, 53, 61 },
        { 52, 60, 54, 62, 34, 42, 32, 40 },
        { 39, 47, 51, 59, 49, 57, 37, 45 },
        { 36, 44, 38, 46, 50, 58, 48, 56 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
