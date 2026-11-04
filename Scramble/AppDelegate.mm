//
//  AppDelegate.mm
//  Scramble
//
//  Created by icarus black on 6/26/26.
//

/*
Priority ciphers
Cipher                            median us fastest us     p95 us    trim MiB/s   raw MiB/s
FlameToadCipher                      133.79     130.58     402.17        5133.0      4807.4
FlameToadCipher (direct)             187.58     185.88     677.92        3277.5      3044.7
PasswordXORCipher                    121.79     115.50     172.79        7917.3      7705.5
ShiftMaskedCipher                    127.50     125.67     189.08        7206.7      6990.8
BitReverseCipher                     121.71     120.38     181.17        7445.6      7163.8
*/

#import "AppDelegate.h"

#include <atomic>
#include "Soccer3.hpp"
#include "TimeLog.hpp"
#include "Random.hpp"
#include "Benchmarks/CipherBenchmark.hpp"

#include <chrono>
#include <cstddef>
#include <cstdlib>
#include <cstdio>
#include <cstdint>
#include <cstring>
#include <string>
#include <vector>

/*
 
4 exanders
kdf: 19.16
smain: 3.60
sgrow: 1.90
tmain: 60.71
tgrow: 55.90
 ------
8 exanders
kdf: 34.20
smain: 6.45
sgrow: 3.40
tmain: 121.07
tgrow: 111.47
 ------
16 exanders (old numbers)
kdf: 64.66
seed: 12.19 + 6.42
twist_all: 243.09 + 223.80
twist_grow: 223.80

16 exanders (new numbers)
kdf: 38.33
seed: 14.93
twist_all: 74.10
twist_grow: 13.21
 
*/

/*

4 exanders
arx_a: 8.06 (6 loop)
arx_b: 5.62 (4 loop)
diffuse_a: 0.74
diffuse_b: 0.77
------
8 exanders
arx_a: 16.19 (6 loop)
arx_b: 11.25 (4 loop)
diffuse_a: 1.49
diffuse_b: 1.53
------
16 exanders
arx_a: 32.58
arx_b: 22.60
diffuse_a: 2.99
diffuse_b: 3.09

*/


/*

kdf: 19.13
smain: 3.61
sgrow: 1.16
tmain: 61.48
tgrow: 34.68

kdf: 35.07
smain: 6.63
sgrow: 2.14
tmain: 124.78
tgrow: 70.45

kdf: 66.69
smain: 12.59
sgrow: 4.06
tmain: 249.68
tgrow: 140.83

*/


namespace {

constexpr std::size_t kMediumLaneCount = 8U;
constexpr std::size_t kCiphertextPreviewByteCount = 128U;
constexpr std::size_t kCiphertextPreviewLineByteCount = 32U;

bool IsRunningUnderXCTest() {
    return (std::getenv("XCTestConfigurationFilePath") != nullptr) ||
           (std::getenv("XCTestBundlePath") != nullptr);
}

struct SoccerAvalancheScore {
    std::size_t mDifferentBytes = 0U;
    std::size_t mDifferentBits = 0U;
};

SoccerAvalancheScore ScoreBuffers(const std::uint8_t *pBufferA,
                                  const std::uint8_t *pBufferB,
                                  std::size_t pByteCount) {
    SoccerAvalancheScore aScore;

    for (std::size_t aIndex=0U; aIndex<pByteCount; aIndex++) {
        const std::uint8_t aDifference =
            static_cast<std::uint8_t>(pBufferA[aIndex] ^ pBufferB[aIndex]);
        if (aDifference != 0U) {
            aScore.mDifferentBytes++;
            aScore.mDifferentBits += static_cast<std::size_t>(
                __builtin_popcount(static_cast<unsigned int>(aDifference)));
        }
    }

    return aScore;
}

double Percent(std::size_t pCount, std::size_t pTotal) {
    if (pTotal == 0U) {
        return 0.0;
    }

    return (static_cast<double>(pCount) * 100.0) /
           static_cast<double>(pTotal);
}

void PrintCiphertextPreview(const std::uint8_t *pCiphertext) {
    std::printf("\nEncrypted first %zu bytes:\n", kCiphertextPreviewByteCount);

    for (std::size_t aIndex=0U; aIndex<kCiphertextPreviewByteCount; aIndex++) {
        std::printf("%02X",
                    static_cast<unsigned int>(pCiphertext[aIndex]));

        const bool aLineFinished =
            ((aIndex + 1U) % kCiphertextPreviewLineByteCount) == 0U;
        std::printf("%s", aLineFinished ? "\n" : " ");
    }
}

void PrintLaneAvalancheGrid(
    const std::vector<std::vector<std::uint8_t>> &pLanes) {
    std::printf("\nMedium material-lane avalanche (different bits)\n");
    std::printf("%8s", "");
    for (std::size_t aLaneIndex=0U; aLaneIndex<kMediumLaneCount; aLaneIndex++) {
        std::printf("%11s%zu", "Lane ", aLaneIndex);
    }
    std::printf("\n");

    const std::size_t aTotalBitCount = SOCCER_BLOCK_SIZE * 8U;
    for (std::size_t aRowIndex=0U; aRowIndex<kMediumLaneCount; aRowIndex++) {
        std::printf("Lane %-3zu", aRowIndex);

        for (std::size_t aColumnIndex=0U;
             aColumnIndex<kMediumLaneCount;
             aColumnIndex++) {
            const SoccerAvalancheScore aScore =
                ScoreBuffers(pLanes[aRowIndex].data(),
                             pLanes[aColumnIndex].data(),
                             SOCCER_BLOCK_SIZE);
            std::printf("%11.4f%%",
                        Percent(aScore.mDifferentBits, aTotalBitCount));
        }
        std::printf("\n");
    }
}

void PrintStreamAvalanche(const std::uint8_t *pCiphertextA,
                          const std::uint8_t *pCiphertextB) {
    const SoccerAvalancheScore aScore =
        ScoreBuffers(pCiphertextA, pCiphertextB, SOCCER_BLOCK_SIZE);
    const std::size_t aTotalBitCount = SOCCER_BLOCK_SIZE * 8U;

    std::printf("\nPassword-change ciphertext avalanche\n");
    std::printf("Different bytes: %zu / %zu (%.6f%%)\n",
                aScore.mDifferentBytes,
                static_cast<std::size_t>(SOCCER_BLOCK_SIZE),
                Percent(aScore.mDifferentBytes, SOCCER_BLOCK_SIZE));
    std::printf("Different bits:  %zu / %zu (%.6f%%)\n",
                aScore.mDifferentBits,
                aTotalBitCount,
                Percent(aScore.mDifferentBits, aTotalBitCount));
}

bool RunReadmeSoccerExample() {
    constexpr std::uint64_t aNonce = 0xF00DFACECAFEBEEFULL;
    const std::string aMessage = "Hello, Soccer!!";
    const std::string aPasswordA = "readme-password-A";
    const std::string aPasswordB = "readme-password-B";

    std::vector<std::uint8_t> aPasswordBytesA(aPasswordA.begin(), aPasswordA.end());
    std::vector<std::uint8_t> aPasswordBytesB(aPasswordB.begin(), aPasswordB.end());
    std::vector<std::uint8_t> aPlaintext(SOCCER_BLOCK_SIZE, 0U);
    std::vector<std::uint8_t> aCiphertextA(SOCCER_BLOCK_SIZE, 0U);
    std::vector<std::uint8_t> aCiphertextB(SOCCER_BLOCK_SIZE, 0U);
    std::vector<std::uint8_t> aDecrypted(SOCCER_BLOCK_SIZE, 0U);

    std::memcpy(aPlaintext.data(), aMessage.data(), aMessage.size());

    std::printf("\nSoccer3 medium-encryption example\n");
    std::printf("Plaintext: \"%s\"\n", aMessage.c_str());
    std::printf("Password A: \"%s\"\n", aPasswordA.c_str());

    Soccer3::Zero();

    std::uint32_t aAckWordA = 0U;
    const auto aEncryptionStart = std::chrono::steady_clock::now();
    std::atomic<bool> aCancelled{false};
    if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kNormal,
                                      aPasswordBytesA.data(),
                                      aPasswordBytesA.size(),
                                      aNonce,
                                      &aAckWordA,
                                      0,
                                      &aCancelled)) {
        std::printf("Soccer3 medium encryption seed failed.\n");
        return false;
    }
    if (!Soccer3::EncryptBlock(aPlaintext.data(), aCiphertextA.data())) {
        std::printf("Soccer3 medium encryption failed.\n");
        return false;
    }
    const auto aEncryptionEnd = std::chrono::steady_clock::now();

    std::vector<std::vector<std::uint8_t>> aMaterialLanes(
        kMediumLaneCount,
        std::vector<std::uint8_t>(SOCCER_BLOCK_SIZE));
    for (std::size_t aLaneIndex=0U; aLaneIndex<kMediumLaneCount; aLaneIndex++) {
        if (Soccer3::mMaterials[aLaneIndex] == nullptr) {
            std::printf("Soccer3 material lane %zu was null.\n", aLaneIndex);
            return false;
        }
        std::memcpy(aMaterialLanes[aLaneIndex].data(),
                    Soccer3::mMaterials[aLaneIndex],
                    SOCCER_BLOCK_SIZE);
    }

    const auto aDecryptionStart = std::chrono::steady_clock::now();
    if (!Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kNormal,
                                      aPasswordBytesA.data(),
                                      aPasswordBytesA.size(),
                                      aNonce,
                                      aAckWordA,
                                      0,
                                      &aCancelled)) {
        std::printf("Soccer3 medium decryption seed failed.\n");
        return false;
    }
    if (!Soccer3::DecryptBlock(aCiphertextA.data(), aDecrypted.data())) {
        std::printf("Soccer3 medium decryption failed.\n");
        return false;
    }
    const auto aDecryptionEnd = std::chrono::steady_clock::now();

    if (std::memcmp(aPlaintext.data(), aDecrypted.data(), SOCCER_BLOCK_SIZE) != 0) {
        std::printf("Soccer3 medium round trip failed.\n");
        return false;
    }

    PrintCiphertextPreview(aCiphertextA.data());
    PrintLaneAvalancheGrid(aMaterialLanes);

    const std::string aRecoveredMessage(
        reinterpret_cast<const char *>(aDecrypted.data()),
        aMessage.size());
    std::printf("\nFinal decrypted message: \"%s\"\n",
                aRecoveredMessage.c_str());

    const double aEncryptionMilliseconds =
        std::chrono::duration<double, std::milli>(
            aEncryptionEnd - aEncryptionStart).count();
    const double aDecryptionMilliseconds =
        std::chrono::duration<double, std::milli>(
            aDecryptionEnd - aDecryptionStart).count();
    std::printf("Encryption time: %.3f ms\n", aEncryptionMilliseconds);
    std::printf("Decryption time: %.3f ms\n", aDecryptionMilliseconds);
    std::printf("Round-trip crypto time: %.3f ms\n",
                aEncryptionMilliseconds + aDecryptionMilliseconds);

    std::printf("\nPassword B: \"%s\" (one character changed)\n",
                aPasswordB.c_str());

    std::uint32_t aAckWordB = 0U;
    if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kNormal,
                                      aPasswordBytesB.data(),
                                      aPasswordBytesB.size(),
                                      aNonce,
                                      &aAckWordB,
                                      0,
                                      &aCancelled)) {
        std::printf("Soccer3 second medium encryption seed failed.\n");
        return false;
    }
    if (!Soccer3::EncryptBlock(aPlaintext.data(), aCiphertextB.data())) {
        std::printf("Soccer3 second medium encryption failed.\n");
        return false;
    }

    PrintStreamAvalanche(aCiphertextA.data(), aCiphertextB.data());
    return true;
}

} // namespace

@interface AppDelegate () <NSMenuItemValidation>

@property (strong) IBOutlet NSWindow *window;
@property (assign) BOOL cipherBenchmarkRunning;

@end

@implementation AppDelegate

- (void)beginCipherBenchmark:(NSString *)directory quitWhenDone:(BOOL)quitWhenDone {
    if (self.cipherBenchmarkRunning) return;
    self.cipherBenchmarkRunning = YES;
    const std::string outputDirectory(directory.fileSystemRepresentation);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        const bool succeeded = RunCipherBenchmarks(outputDirectory.c_str());
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cipherBenchmarkRunning = NO;
            if (quitWhenDone) std::exit(succeeded ? EXIT_SUCCESS : EXIT_FAILURE);
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = succeeded ? @"Cipher benchmark complete" : @"Cipher benchmark failed";
            alert.informativeText = succeeded
                ? [NSString stringWithFormat:@"Summary and all timing samples are saved in:\n%@", directory]
                : @"See the app console for the error. Incomplete results are not a successful benchmark.";
            [alert runModal];
        });
    });
}

- (void)runCipherBenchmark:(id)sender {
    (void)sender;
    NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:
        [@"SoccerCipherBenchmarks-" stringByAppendingString:NSUUID.UUID.UUIDString]];
    [self beginCipherBenchmark:directory quitWhenDone:NO];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    if (menuItem.action == @selector(runCipherBenchmark:)) return !self.cipherBenchmarkRunning;
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    (void)aNotification;
    
    if (IsRunningUnderXCTest()) {
        std::printf("Skipping App Delegate Test Code, On Test Target\n");
        return;
    }

    RunReadmeSoccerExample();

}

@end
