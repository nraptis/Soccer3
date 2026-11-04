//
//  Test_Full_OpalA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_OpalA : XCTestCase

@end

@implementation Test_Full_OpalA

- (void)testFull_OpalA_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalA_4x4();

    const M aExpected = {
        {  2,  3,  4,  5, 52, 53, 50, 51 },
        { 10, 11, 12, 13, 60, 61, 58, 59 },
        {  0,  1,  6,  7, 54, 55, 48, 49 },
        {  8,  9, 14, 15, 62, 63, 56, 57 },
        { 16, 17, 22, 23, 38, 39, 32, 33 },
        { 24, 25, 30, 31, 46, 47, 40, 41 },
        { 18, 19, 20, 21, 36, 37, 34, 35 },
        { 26, 27, 28, 29, 44, 45, 42, 43 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_OpalA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalA_EachQuad_4x4();

    const M aExpected = {
        {  1,  2, 26, 25,  5,  6, 30, 29 },
        {  0,  3, 27, 24,  4,  7, 31, 28 },
        {  8, 11, 19, 16, 12, 15, 23, 20 },
        {  9, 10, 18, 17, 13, 14, 22, 21 },
        { 33, 34, 58, 57, 37, 38, 62, 61 },
        { 32, 35, 59, 56, 36, 39, 63, 60 },
        { 40, 43, 51, 48, 44, 47, 55, 52 },
        { 41, 42, 50, 49, 45, 46, 54, 53 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_OpalA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalA_8x8();

    const M aExpected = {
        {  3,  4, 28, 27, 35, 36, 60, 59 },
        {  2,  5, 29, 26, 34, 37, 61, 58 },
        {  1,  6, 30, 25, 33, 38, 62, 57 },
        {  0,  7, 31, 24, 32, 39, 63, 56 },
        {  8, 15, 23, 16, 40, 47, 55, 48 },
        {  9, 14, 22, 17, 41, 46, 54, 49 },
        { 10, 13, 21, 18, 42, 45, 53, 50 },
        { 11, 12, 20, 19, 43, 44, 52, 51 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
