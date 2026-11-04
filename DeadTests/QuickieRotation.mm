//
//  QuickieRotation.mm
//  HolyStorms
//

#import <XCTest/XCTest.h>

#import "PrintExamplesHelper.hpp"
#import "RotateCipher.hpp"
#import "RotateMaskCipher.hpp"

@interface QuickieRotation : XCTestCase

@end

@implementation QuickieRotation

- (void)testRotationByOne {
    const std::uint8_t aOriginal[16] = {
        0xAA, 0xAA, 0xBB, 0xBB, 0xCC, 0xCC, 0xDD, 0xDD,
        0xAA, 0xAA, 0xBB, 0xBB, 0xCC, 0xCC, 0xDD, 0xDD,
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aRotateCipherResult[sizeof(aOriginal)] = {};
    std::uint8_t aRotateMaskCipherResult[sizeof(aOriginal)] = {};
    CipherErrorCode aErrorCode = CipherErrorCode::kNone;

    RotateCipher aRotateCipher(1u);
    (void)aRotateCipher.SealData(aOriginal,
                                 aWorker,
                                 aRotateCipherResult,
                                 sizeof(aOriginal),
                                 &aErrorCode);

    RotateMaskCipher aRotateMaskCipher(0xFFu, 1u);
    (void)aRotateMaskCipher.SealData(aOriginal,
                                     aWorker,
                                     aRotateMaskCipherResult,
                                     sizeof(aOriginal),
                                     &aErrorCode);

    printf("\nQuickieRotation (shift = 1)\n");
    printf("Original:         %s\n",
           PrintExamplesHelper::HexArray(aOriginal,
                                         sizeof(aOriginal)).c_str());
    printf("RotateCipher:     %s\n",
           PrintExamplesHelper::HexArray(aRotateCipherResult,
                                         sizeof(aRotateCipherResult)).c_str());
    printf("RotateMaskCipher: %s\n",
           PrintExamplesHelper::HexArray(aRotateMaskCipherResult,
                                         sizeof(aRotateMaskCipherResult)).c_str());
}

@end
