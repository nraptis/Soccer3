//
//  Rig.cpp
//  MeanMachine
//
//  Created by Icarus Black on 5/4/26.
//

#include "Rig.hpp"
#include <cctype>
#include <cstdio>

Rig::Rig() {
    mData = NULL;
    mDataLength = 0;
    mBlockCount = 0;
    mLastPasswordTag = "";
}

Rig::~Rig() {
    delete [] mData;
    mData = NULL;
}

void Rig::SetBlockCount(int pBlockCount) {
    delete [] mData;
    mData = NULL;
    mDataLength = 0;
    mBlockCount = 0;
    if (pBlockCount > 0) {
        mDataLength = S_BLOCK * pBlockCount;
        mData = new std::uint8_t[mDataLength];
        memset(mData, 0, mDataLength);
        mBlockCount = pBlockCount;
    }    
}

void Rig::Run(TwistExpander *pExpander,
              std::uint8_t *pPassword,
              int pPasswordLength) {
    mLastPasswordTag = "empty";
    if ((pPassword != nullptr) && (pPasswordLength > 0)) {
        bool aAsciiOnly = true;
        for (int i = 0; i < pPasswordLength; i++) {
            const unsigned char aChar = static_cast<unsigned char>(pPassword[i]);
            if ((aChar < 32U) || (aChar > 126U)) {
                aAsciiOnly = false;
                break;
            }
        }
        
        if (aAsciiOnly) {
            mLastPasswordTag.clear();
            for (int i = 0; i < pPasswordLength; i++) {
                const unsigned char aChar = static_cast<unsigned char>(pPassword[i]);
                if (std::isalnum(aChar) || aChar == '_' || aChar == '-') {
                    mLastPasswordTag.push_back(static_cast<char>(aChar));
                } else {
                    mLastPasswordTag.push_back('_');
                }
            }
            if (mLastPasswordTag.empty()) {
                mLastPasswordTag = "empty";
            }
        } else {
            mLastPasswordTag.clear();
            char aHex[3];
            for (int i = 0; i < pPasswordLength; i++) {
                std::snprintf(aHex, sizeof(aHex), "%02x", static_cast<unsigned char>(pPassword[i]));
                mLastPasswordTag += aHex;
            }
            if (mLastPasswordTag.empty()) {
                mLastPasswordTag = "empty";
            }
        }
    }
    
    std::uint8_t aSnowLaneA[S_BLOCK];
    std::uint8_t aSnowLaneB[S_BLOCK];
    std::uint8_t aSnowLaneC[S_BLOCK];
    std::uint8_t aSnowLaneD[S_BLOCK];
    
    memset(aSnowLaneA, 0, sizeof(aSnowLaneA));
    memset(aSnowLaneB, 0, sizeof(aSnowLaneA));
    memset(aSnowLaneC, 0, sizeof(aSnowLaneA));
    memset(aSnowLaneD, 0, sizeof(aSnowLaneA));

    TwistWorkSpace aWorkSpace;
    
    std::uint64_t aIngress = 0xC57A5D1CB76274CDULL;
    std::uint64_t aCarry = 0xD884E6D87C4E5D32ULL;
    std::uint64_t aWandererA = 0x56A39022D8815D93ULL;
    std::uint64_t aWandererB = 0x78621F8668264758ULL;
    std::uint64_t aWandererC = 0x9CCC333EB717B5FDULL;
    std::uint64_t aWandererD = 0x308B1DDC64346BAAULL;
    std::uint64_t aWandererE = 0x7553EBB34F729AFDULL;
    std::uint64_t aWandererF = 0x789948C10DFC7B5DULL;
    std::uint64_t aWandererG = 0x4205DA226FC0675BULL;
    std::uint64_t aWandererH = 0x511EE95FB0224D10ULL;
    std::uint64_t aWandererI = 0xFAE48C727EFD1D19ULL;
    std::uint64_t aWandererJ = 0x51D0F4DB9C43223CULL;
    std::uint64_t aWandererK = 0x0BEE6245265CD32DULL;
    
    pExpander->Seed(&aWorkSpace,
                    0ULL,
                    pPassword,
                    static_cast<unsigned int>(pPasswordLength),
                    mData,
                    ARX_STATE_VARS);
    
    for (int aBlockIndex=1; aBlockIndex<mBlockCount; aBlockIndex++) {
        std::uint8_t *aSource = mData + (aBlockIndex - 1) * S_BLOCK;
        std::uint8_t *aDest = mData + (aBlockIndex) * S_BLOCK;
        pExpander->TwistBlock(&aWorkSpace,
                              aSource,
                              aSnowLaneA,
                              aSnowLaneB,
                              aSnowLaneC,
                              aSnowLaneD,
                              aDest,
                              false,
                              ARX_STATE_VARS);
        
    }
}

bool Rig::SaveByteStream(const std::string &pFolder) const {
    if ((mData == nullptr) || (mDataLength <= 0)) { return false; }
    const std::string aPath = FileIO::Join(pFolder, "byte_stream.bin");
    return FileIO::Save(aPath, mData, static_cast<int>(mDataLength));
}

bool Rig::SaveByteStreamProjectRoot(const std::string &pFolder) const {
    if ((mData == nullptr) || (mDataLength <= 0)) { return false; }
    const std::string aPath = FileIO::ProjectRoot(FileIO::Join(pFolder, "byte_stream.bin"));
    return FileIO::Save(aPath, mData, static_cast<int>(mDataLength));
}

bool Rig::SaveByteStreamLastAsciiPassword(const std::string &pFolder) const {
    if ((mData == nullptr) || (mDataLength <= 0)) { return false; }
    const std::string aFileName = "byte_stream_" + (mLastPasswordTag.empty() ? std::string("empty") : mLastPasswordTag) + ".bin";
    const std::string aPath = FileIO::Join(pFolder, aFileName);
    return FileIO::Save(aPath, mData, static_cast<int>(mDataLength));
}

bool Rig::SaveByteStreamProjectRootLastAsciiPassword(const std::string &pFolder) const {
    if ((mData == nullptr) || (mDataLength <= 0)) { return false; }
    const std::string aFileName = "byte_stream_" + (mLastPasswordTag.empty() ? std::string("empty") : mLastPasswordTag) + ".bin";
    const std::string aPath = FileIO::ProjectRoot(FileIO::Join(pFolder, aFileName));
    return FileIO::Save(aPath, mData, static_cast<int>(mDataLength));
}

bool Rig::SaveByteStream(const std::string &pFolder,
                         const std::string &pBaseFile,
                         int pFileNumber) const {
    if ((mData == nullptr) || (mDataLength <= 0) || pBaseFile.empty()) { return false; }
    std::string aBase = pBaseFile;
    if ((aBase.size() > 4) && (aBase.substr(aBase.size() - 4) == ".bin")) {
        aBase = aBase.substr(0, aBase.size() - 4);
    }
    const std::string aFileName = FileIO::SequenceFile(aBase + "_", pFileNumber, ".bin", 6);
    const std::string aPath = FileIO::Join(pFolder, aFileName);
    return FileIO::Save(aPath, mData, static_cast<int>(mDataLength));
}

bool Rig::SaveByteStreamProjectRoot(const std::string &pFolder,
                                    const std::string &pBaseFile,
                                    int pFileNumber) const {
    if ((mData == nullptr) || (mDataLength <= 0) || pBaseFile.empty()) { return false; }
    std::string aBase = pBaseFile;
    if ((aBase.size() > 4) && (aBase.substr(aBase.size() - 4) == ".bin")) {
        aBase = aBase.substr(0, aBase.size() - 4);
    }
    const std::string aFileName = FileIO::SequenceFile(aBase + "_", pFileNumber, ".bin", 6);
    const std::string aPath = FileIO::ProjectRoot(FileIO::Join(pFolder, aFileName));
    return FileIO::Save(aPath, mData, static_cast<int>(mDataLength));
}
