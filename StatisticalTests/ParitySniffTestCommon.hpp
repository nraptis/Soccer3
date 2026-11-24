#pragma once

#include "../Scramble/Public/Soccer3.hpp"

#include <cstddef>
#include <cstdint>
#include <string>

// Profiles change workload only; kEncryptionStrength controls all three.
// Each trial uses a replayable password/nonce and the full 1 MiB API.
// Input bits are clustered/scattered; trials alternate fixed/fresh backgrounds.
// Bit-flip probes locate candidate ciphertext bits without inspecting the plan.
// Training samples choose ciphertext XOR features and their prediction polarity.
// Frozen predictors are screened on NEW plaintexts, never on training samples.
// Fresh confirmation distinguishes repeated findings; unconfirmed screens stay alerts.
// All 255 nonempty whole-block row parities complement the sampled-bit search.
// Bounds cover all profiles/trials/targets; random labels provide a null control.
// This is a bounded search, with progress and replay details for human review.
class ParitySniffTest {
public:
    // Change this ONE setting to run every profile at another cipher strength.
    inline static constexpr EncryptionStrength kEncryptionStrength = EncryptionStrength::kWeak;
    inline static constexpr std::uint64_t kCampaignSeed = 0U; // 0: random once/process; otherwise replay this seed.
    inline static constexpr double kFamilyAlpha = 1.0e-6;
    inline static constexpr double kProgressSeconds = 2.0;
    inline static constexpr std::size_t kDiscoveryLogEveryBits = 4U;
    inline static constexpr std::size_t kSearchLogEveryFeatures = 256U;
    inline static constexpr std::size_t kTopFindingsToPrint = 6U;
    inline static constexpr bool kPrintAllFindings = false; // Counts always include every finding.
    inline static constexpr std::size_t kPasswordBytes = 32U;
    inline static constexpr std::uint64_t kProtocolVersion = 0U;
    inline static constexpr bool kAlternateBackgrounds = true;
    inline static constexpr bool kCheckWholeBlockParities = true;
    inline static constexpr bool kRunPositiveControl = true;
    inline static constexpr bool kRunBiasedPositiveControl = true;
    inline static constexpr std::size_t kControlBytes = 512U;
    inline static constexpr std::size_t kControlByteRotation = 37U;
    inline static constexpr unsigned kControlBitRotation = 3U;
    inline static constexpr std::uint8_t kControlXorMask = 0xA5U;
    inline static constexpr double kBiasedControlMinAccuracy = 0.70;
    inline static constexpr double kBiasedControlMaxAccuracy = 0.80;

    struct Config {
        const char *mName;
        std::size_t mTrials;                  // Fresh encryption plans/passwords/nonces.
        std::size_t mPlaintextBits;           // 8..64, with every physical bit row represented.
        std::size_t mProbeRepeats;            // Different backgrounds for public bit-flip probes.
        std::size_t mProbeCipherBits;         // Changed ciphertext bits retained per input/probe.
        std::size_t mUniformCipherBits;       // Additional ciphertext bit coordinates.
        std::size_t mPairsPerInput;           // Pair features drawn from each probe group.
        std::size_t mRandomParities;          // Extra sparse ciphertext XOR candidates.
        unsigned mMaxParityBits;             // 2..8 input/output bits per sparse parity.
        std::size_t mInputParityChecks;       // Additional multi-bit plaintext targets.
        std::size_t mTrainingSamples;         // Must be a multiple of 64; only these select models.
        std::size_t mScreenSamples;
        std::size_t mConfirmationSamples;     // Used only if screen/control flags are found.
        std::size_t mProgressEveryQueries;
    };

    inline static constexpr Config kWeak{
        .mName = "Weak/light", .mTrials = 2U, .mPlaintextBits = 16U,
        .mProbeRepeats = 1U, .mProbeCipherBits = 8U, .mUniformCipherBits = 128U,
        .mPairsPerInput = 32U, .mRandomParities = 256U, .mMaxParityBits = 2U,
        .mInputParityChecks = 16U, .mTrainingSamples = 512U,
        .mScreenSamples = 1024U, .mConfirmationSamples = 4096U,
        .mProgressEveryQueries = 64U};

    inline static constexpr Config kNormal{
        .mName = "Normal", .mTrials = 6U, .mPlaintextBits = 32U,
        .mProbeRepeats = 2U, .mProbeCipherBits = 12U, .mUniformCipherBits = 256U,
        .mPairsPerInput = 96U, .mRandomParities = 1024U, .mMaxParityBits = 3U,
        .mInputParityChecks = 32U, .mTrainingSamples = 2048U,
        .mScreenSamples = 4096U, .mConfirmationSamples = 16384U,
        .mProgressEveryQueries = 256U};

    inline static constexpr Config kRigorous{
        .mName = "Rigorous", .mTrials = 16U, .mPlaintextBits = 64U,
        .mProbeRepeats = 3U, .mProbeCipherBits = 16U, .mUniformCipherBits = 512U,
        .mPairsPerInput = 192U, .mRandomParities = 4096U, .mMaxParityBits = 4U,
        .mInputParityChecks = 64U, .mTrainingSamples = 16384U,
        .mScreenSamples = 32768U, .mConfirmationSamples = 65536U,
        .mProgressEveryQueries = 512U};

    // Small known affine oracle: verifies discovery, XOR matching and polarity
    // through the same runner before inspecting the real encryption API.
    inline static constexpr Config kPositiveControl{
        .mName = "affine control", .mTrials = 1U, .mPlaintextBits = 8U,
        .mProbeRepeats = 1U, .mProbeCipherBits = 1U, .mUniformCipherBits = 0U,
        .mPairsPerInput = 0U, .mRandomParities = 256U, .mMaxParityBits = 2U,
        .mInputParityChecks = 4U, .mTrainingSamples = 512U,
        .mScreenSamples = 256U, .mConfirmationSamples = 256U,
        .mProgressEveryQueries = 64U};

    inline static constexpr Config kBiasedControl{
        .mName = "75% nonlinear control", .mTrials = 1U, .mPlaintextBits = 8U,
        .mProbeRepeats = 1U, .mProbeCipherBits = 1U, .mUniformCipherBits = 0U,
        .mPairsPerInput = 0U, .mRandomParities = 256U, .mMaxParityBits = 2U,
        .mInputParityChecks = 4U, .mTrainingSamples = 512U,
        .mScreenSamples = 2048U, .mConfirmationSamples = 4096U,
        .mProgressEveryQueries = 256U};

    struct Result {
        bool mCompleted = false;
        std::size_t mTrialsCompleted = 0U;
        std::size_t mScreenFindings = 0U;
        std::size_t mConfirmedFindings = 0U;
        std::size_t mControlAlerts = 0U;
        std::uint64_t mCampaignSeed = 0U;
        std::string mError;
    };

    // Serial process-wide Soccer state; prints/flushes progress throughout.
    static Result Run(const Config &pConfig);
};
