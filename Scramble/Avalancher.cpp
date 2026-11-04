//
//  Avalancher.cpp
//  MeanMachine
//
//  Created by icarus black on 6/23/26.
//

#include "Avalancher.hpp"

#include "FileIO.hpp"
#include "Rig.hpp"

#include <algorithm>
#include <bit>
#include <cmath>
#include <cstdio>
#include <limits>

namespace {

const char *LabelOrDefault(const std::string &pName) {
    return pName.empty() ? "Avalancher" : pName.c_str();
}

double Percent(const double pRatio) {
    return pRatio * 100.0;
}

} // namespace

Avalancher::Avalancher()
: mExpander(nullptr),
  mBlockCount(AVA_BLOCK_COUNT),
  mDefaultPasswordA{0U},
  mDefaultPasswordB{1U} {
}

void AvalancherScore::PrintExtended(const std::string &pName) const {
    const char *aName = LabelOrDefault(pName);
    if (!IsValid()) {
        std::printf("%s avalanche: invalid\n", aName);
        return;
    }
    
    std::printf("%s avalanche extended\n", aName);
    std::printf("  bytes: %zu\n", mByteCount);
    std::printf("  bits: %zu\n", mBitCount);
    std::printf("  different bytes: %zu / %zu (%.4f%%)\n",
                mDifferentBytes,
                mByteCount,
                Percent(mDifferentByteRatio));
    std::printf("  different bits: %zu / %zu (%.4f%%)\n",
                mDifferentBits,
                mBitCount,
                Percent(mDifferentBitRatio));
    std::printf("  score: %.6f\n", mScore);
}

void AvalancherScore::PrintQuick(const std::string &pName) const {
    const char *aName = LabelOrDefault(pName);
    if (!IsValid()) {
        std::printf("%s avalanche invalid\n", aName);
        return;
    }

    std::printf("%s avalanche bits %.4f%% score %.6f\n",
                aName,
                Percent(mDifferentBitRatio),
                mScore);
}

void Avalancher::SetExpander(TwistExpander *pExpander) {
    mExpander = pExpander;
}

void Avalancher::SetBlockCount(std::size_t pBlockCount) {
    mBlockCount = std::max<std::size_t>(1U, pBlockCount);
}

std::size_t Avalancher::GetBlockCount() const {
    return mBlockCount;
}

AvalancherScore Avalancher::DiffAB() {
    return DiffAB(mDefaultPasswordA,
                  static_cast<int>(sizeof(mDefaultPasswordA)),
                  mDefaultPasswordB,
                  static_cast<int>(sizeof(mDefaultPasswordB)));
}

AvalancherScore Avalancher::DiffAB(const std::string &pPasswordA,
                                   const std::string &pPasswordB) {
    return DiffAB(PasswordBytes(pPasswordA),
                  static_cast<int>(pPasswordA.size()),
                  PasswordBytes(pPasswordB),
                  static_cast<int>(pPasswordB.size()));
}

AvalancherScore Avalancher::DiffAB(std::uint8_t *pPasswordA,
                                   int pPasswordLengthA,
                                   std::uint8_t *pPasswordB,
                                   int pPasswordLengthB) {
    RunA(pPasswordA, pPasswordLengthA);
    RunB(pPasswordB, pPasswordLengthB);
    return ScoreBuffers(mDestA, mDestB);
}

void Avalancher::RunA(std::uint8_t *pPassword,
                      int pPasswordLength) {
    (void)RunInto(pPassword, pPasswordLength, &mDestA);
}

void Avalancher::RunB(std::uint8_t *pPassword,
                      int pPasswordLength) {
    (void)RunInto(pPassword, pPasswordLength, &mDestB);
}

std::vector<std::uint8_t> Avalancher::GetOutputA(std::uint8_t *pPassword,
                                                 int pPasswordLength) {
    RunA(pPassword, pPasswordLength);
    return mDestA;
}

std::vector<std::uint8_t> Avalancher::GetOutputB(std::uint8_t *pPassword,
                                                 int pPasswordLength) {
    RunB(pPassword, pPasswordLength);
    return mDestB;
}

std::vector<std::uint8_t> Avalancher::GetOutput(std::uint8_t *pPassword,
                                                int pPasswordLength) {
    std::vector<std::uint8_t> aOutput;
    (void)RunInto(pPassword, pPasswordLength, &aOutput);
    return aOutput;
}

std::vector<std::uint8_t> Avalancher::GetOutput(const std::string &pPassword) {
    return GetOutput(PasswordBytes(pPassword),
                     static_cast<int>(pPassword.size()));
}

bool Avalancher::SavePractRandStream(std::uint8_t *pPassword,
                                     int pPasswordLength,
                                     const std::string &pPath) {
    const std::vector<std::uint8_t> aOutput = GetOutput(pPassword, pPasswordLength);
    if (aOutput.empty() ||
        (aOutput.size() > static_cast<std::size_t>(std::numeric_limits<int>::max()))) {
        return false;
    }

    return FileIO::Save(pPath, aOutput);
}

bool Avalancher::SavePractRandStream(const std::string &pPassword,
                                     const std::string &pPath) {
    return SavePractRandStream(PasswordBytes(pPassword),
                               static_cast<int>(pPassword.size()),
                               pPath);
}

bool Avalancher::SavePractRandStreamProjectRoot(std::uint8_t *pPassword,
                                                int pPasswordLength,
                                                const std::string &pPath) {
    return SavePractRandStream(pPassword, pPasswordLength, FileIO::ProjectRoot(pPath));
}

bool Avalancher::SavePractRandStreamProjectRoot(const std::string &pPassword,
                                                const std::string &pPath) {
    return SavePractRandStreamProjectRoot(PasswordBytes(pPassword),
                                          static_cast<int>(pPassword.size()),
                                          pPath);
}

const std::vector<std::uint8_t> &Avalancher::OutputA() const {
    return mDestA;
}

const std::vector<std::uint8_t> &Avalancher::OutputB() const {
    return mDestB;
}

bool Avalancher::RunInto(std::uint8_t *pPassword,
                         int pPasswordLength,
                         std::vector<std::uint8_t> *pOutput) {
    if (pOutput == nullptr) {
        return false;
    }

    pOutput->clear();
    if (mExpander == nullptr) {
        return false;
    }

    if (mBlockCount > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        return false;
    }

    const int aPasswordLength = std::max(0, pPasswordLength);
    Rig aRig;
    aRig.SetBlockCount(static_cast<int>(mBlockCount));
    aRig.Run(mExpander,
             (aPasswordLength > 0) ? pPassword : nullptr,
             aPasswordLength);
    if ((aRig.mData == nullptr) || (aRig.mDataLength == 0U)) {
        return false;
    }

    pOutput->assign(aRig.mData, aRig.mData + aRig.mDataLength);
    return true;
}

AvalancherScore Avalancher::ScoreBuffers(const std::vector<std::uint8_t> &pA,
                                         const std::vector<std::uint8_t> &pB) {
    AvalancherScore aScore;
    if (pA.empty() || (pA.size() != pB.size())) {
        return aScore;
    }

    aScore.mByteCount = pA.size();
    aScore.mBitCount = pA.size() * 8U;
    for (std::size_t aIndex = 0U; aIndex < pA.size(); aIndex += 1U) {
        const std::uint8_t aDiff = static_cast<std::uint8_t>(pA[aIndex] ^ pB[aIndex]);
        if (aDiff != 0U) {
            aScore.mDifferentBytes += 1U;
            aScore.mDifferentBits += static_cast<std::size_t>(std::popcount(static_cast<unsigned int>(aDiff)));
        }
    }

    aScore.mDifferentByteRatio = static_cast<double>(aScore.mDifferentBytes) /
        static_cast<double>(aScore.mByteCount);
    aScore.mDifferentBitRatio = static_cast<double>(aScore.mDifferentBits) /
        static_cast<double>(aScore.mBitCount);
    const double aDistanceFromIdeal = std::abs(aScore.mDifferentBitRatio - 0.5);
    aScore.mScore = std::max(0.0, 1.0 - (aDistanceFromIdeal * 2.0));
    return aScore;
}

std::uint8_t *Avalancher::PasswordBytes(const std::string &pPassword) {
    if (pPassword.empty()) {
        return nullptr;
    }

    const std::uint8_t *aBytes = reinterpret_cast<const std::uint8_t *>(pPassword.data());
    return const_cast<std::uint8_t *>(aBytes);
}
