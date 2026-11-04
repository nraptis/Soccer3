//
//  Test_Full_HeliumD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HeliumD : XCTestCase

@end

@implementation Test_Full_HeliumD

- (void)testFull_HeliumD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HeliumD_EachQuad_4x4();

    const M aExpected = {
        {  8,  9, 17, 16, 12, 13, 21, 20 },
        {  0,  1, 25, 24,  4,  5, 29, 28 },
        {  3,  2, 26, 27,  7,  6, 30, 31 },
        { 11, 10, 18, 19, 15, 14, 22, 23 },
        { 40, 41, 49, 48, 44, 45, 53, 52 },
        { 32, 33, 57, 56, 36, 37, 61, 60 },
        { 35, 34, 58, 59, 39, 38, 62, 63 },
        { 43, 42, 50, 51, 47, 46, 54, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HeliumD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HeliumD_8x8();

    const M aExpected = {
        { 17, 25, 19, 27, 35, 43, 33, 41 },
        { 16, 24, 18, 26, 34, 42, 32, 40 },
        {  1,  9,  3, 11, 51, 59, 49, 57 },
        {  0,  8,  2, 10, 50, 58, 48, 56 },
        {  7, 15,  5, 13, 53, 61, 55, 63 },
        {  6, 14,  4, 12, 52, 60, 54, 62 },
        { 23, 31, 21, 29, 37, 45, 39, 47 },
        { 22, 30, 20, 28, 36, 44, 38, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
