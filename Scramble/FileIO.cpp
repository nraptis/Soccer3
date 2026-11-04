//
//  FileIO.cpp
//  Gorgon
//
//  Created by Sonic The Hedge Whore on 4/9/26.
//

#include "FileIO.hpp"
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <filesystem>
#include <stdexcept>
#include <format>
#include <vector>
#include <mach-o/dyld.h>

namespace {

std::filesystem::path ExecutablePath() {
    std::uint32_t aBufferSize = 0;
    _NSGetExecutablePath(nullptr, &aBufferSize);
    if (aBufferSize == 0) {
        return {};
    }

    std::vector<char> aBuffer(aBufferSize, '\0');
    if (_NSGetExecutablePath(aBuffer.data(), &aBufferSize) != 0) {
        return {};
    }

    std::error_code aError;
    const std::filesystem::path aPath = std::filesystem::weakly_canonical(aBuffer.data(), aError);
    if (aError) {
        return std::filesystem::path(aBuffer.data()).lexically_normal();
    }
    return aPath;
}

std::filesystem::path CompileTimeProjectRoot() {
    const std::filesystem::path aSourcePath(__FILE__);
    return aSourcePath.parent_path().parent_path().lexically_normal();
}

bool LooksLikeProjectRoot(const std::filesystem::path &pPath) {
    std::error_code aError;
    return std::filesystem::exists(pPath / "Scramble.xcodeproj", aError) ||
           std::filesystem::exists(pPath / "MeanMachine.xcodeproj", aError);
}

std::filesystem::path FindProjectRoot(const std::filesystem::path &pStart) {
    if (pStart.empty()) {
        return {};
    }

    std::filesystem::path aPath = pStart;
    std::error_code aError;
    if (!std::filesystem::is_directory(aPath, aError)) {
        aPath = aPath.parent_path();
    }

    while (!aPath.empty()) {
        if (LooksLikeProjectRoot(aPath)) {
            return aPath.lexically_normal();
        }
        if (!aPath.has_parent_path() || aPath.parent_path() == aPath) {
            break;
        }
        aPath = aPath.parent_path();
    }

    return {};
}

} // namespace



bool FileIO::Load(std::string pPath, std::vector<std::uint8_t> &pDest) {
    FILE *aFile = std::fopen(pPath.c_str(), "rb");
    if (aFile == nullptr) {
        pDest.clear();
        return false;
    }

    if (std::fseek(aFile, 0, SEEK_END) != 0) {
        std::fclose(aFile);
        pDest.clear();
        return false;
    }

    long aLength = std::ftell(aFile);
    if (aLength <= 0) {
        std::fclose(aFile);
        pDest.clear();
        return false;
    }

    if (std::fseek(aFile, 0, SEEK_SET) != 0) {
        std::fclose(aFile);
        pDest.clear();
        return false;
    }

    // resize vector to file size
    pDest.resize(static_cast<std::size_t>(aLength));

    std::size_t aReadCount = std::fread(
        pDest.data(),
        1,
        static_cast<std::size_t>(aLength),
        aFile
    );

    std::fclose(aFile);

    if (aReadCount != static_cast<std::size_t>(aLength)) {
        pDest.resize(aReadCount); // shrink to actual read
        return false;
    }

    return true;
}

bool FileIO::Save(std::string pPath, unsigned char *pData, int pLength) {
    const std::filesystem::path aTargetPath(pPath);
    const std::filesystem::path aParentPath = aTargetPath.parent_path();
    if (!aParentPath.empty()) {
        std::error_code aCreateError;
        std::filesystem::create_directories(aParentPath, aCreateError);
        if (aCreateError) {
            std::string aErrorMessage = "failed to create directory for write: " + aParentPath.generic_string();
            printf("%s\n", aErrorMessage.c_str());
            return false;
        }
    }
    
    FILE *aFile = std::fopen(pPath.c_str(), "wb");
    if (aFile == NULL) {
        std::string aErrorMessage = "failed to open file for writeA: " + pPath;
        printf("%s\n", aErrorMessage.c_str());
        return false;
    }
    
    if (pData != NULL && pLength > 0) {
        const std::size_t aWriteCount = std::fwrite(pData, 1, static_cast<std::size_t>(pLength), aFile);
        if (aWriteCount != static_cast<std::size_t>(pLength)) {
            std::fclose(aFile);
            std::string aErrorMessage = "failed to write all bytes to file B: " + pPath;
            printf("%s\n", aErrorMessage.c_str());
            return false;
        }
    }
    
    std::fclose(aFile);
    return true;
}

bool FileIO::Save(std::string pPath, const std::vector<std::uint8_t> &pData) {
    bool aResult = Save(pPath, (std::uint8_t *)pData.data(), (int)pData.size());
    return aResult;
}

std::string FileIO::CurrentWorkingDirectory() {
    std::error_code aError;
    const std::filesystem::path aPath = std::filesystem::current_path(aError);
    if (aError) {
        return ".";
    }
    return aPath.lexically_normal().generic_string();
}

std::string FileIO::ProjectRoot() {

    const char *aProjectDir = std::getenv("PROJECT_DIR");
    if (aProjectDir != NULL && aProjectDir[0] != '\0') {
        const std::filesystem::path aRoot = FindProjectRoot(aProjectDir);
        if (!aRoot.empty()) {
            return aRoot.generic_string();
        }
    }

    const char *aPWD = std::getenv("PWD");
    if (aPWD != NULL && aPWD[0] != '\0') {
        const std::filesystem::path aRoot = FindProjectRoot(aPWD);
        if (!aRoot.empty()) {
            return aRoot.generic_string();
        }
    }

    const std::filesystem::path aCwdRoot = FindProjectRoot(CurrentWorkingDirectory());
    if (!aCwdRoot.empty()) {
        return aCwdRoot.generic_string();
    }

    const std::filesystem::path aExecRoot = FindProjectRoot(ExecutablePath());
    if (!aExecRoot.empty()) {
        return aExecRoot.generic_string();
    }

    const std::filesystem::path aSourceRoot = FindProjectRoot(CompileTimeProjectRoot());
    if (!aSourceRoot.empty()) {
        return aSourceRoot.generic_string();
    }

    return CurrentWorkingDirectory();
}

std::string FileIO::CurrentWorkingDirectory(const std::string& pRight) {
    std::string aCurrentWorkingDirectory = CurrentWorkingDirectory();
    std::string aResult = Join(aCurrentWorkingDirectory, pRight);
    return aResult;
}

std::string FileIO::ProjectRoot(const std::string& pRight) {
    return Join(ProjectRoot(), pRight);
}

std::string FileIO::Join(const std::string& pLeft, const std::string& pRight) {
    if (pLeft.empty()) {
        return pRight;
    }
    if (pRight.empty()) {
        return pLeft;
    }
    
    std::filesystem::path aRightPath(pRight);
    if (aRightPath.is_absolute()) {
        aRightPath = aRightPath.relative_path();
    }
    
    return (std::filesystem::path(pLeft) / aRightPath)
        .lexically_normal()
        .generic_string();
}

std::string FileIO::SequenceFile(const std::string& pPrefix, int pNumber, const std::string& pExtension, int pZeros) {
    std::string aNumberString = std::format("{:0{}}", pNumber, pZeros);
    std::string aResult = pPrefix + aNumberString + pExtension;
    return aResult;
}

std::vector<std::string> FileIO::GetAllFiles(const std::string &pRootPath) {
    std::vector<std::string> aEntries;
    const std::filesystem::path aRoot(pRootPath);
    std::error_code aRootError;
    if (!std::filesystem::is_directory(aRoot, aRootError) || aRootError) {
        return aEntries;
    }
    
    std::error_code aIteratorError;
    std::filesystem::directory_iterator aIterator(aRoot,
                                                  std::filesystem::directory_options::skip_permission_denied,
                                                  aIteratorError);
    std::filesystem::directory_iterator aEnd;
    while (!aIteratorError && aIterator != aEnd) {
        const std::filesystem::directory_entry aEntry = *aIterator;
        std::error_code aTypeError;
        if (!aEntry.is_regular_file(aTypeError) || aTypeError) {
            aIterator.increment(aIteratorError);
            continue;
        }
        aEntries.push_back(aEntry.path().lexically_normal().generic_string());
        aIterator.increment(aIteratorError);
    }
    
    std::sort(aEntries.begin(), aEntries.end(),
        [](const std::string &a, const std::string &b) {
            const std::filesystem::path pa(a);
            const std::filesystem::path pb(b);

            const std::string sa = pa.stem().string();
            const std::string sb = pb.stem().string();

            if (sa == sb) {
                // tie-breaker: full path (keeps ordering stable)
                return a < b;
            }
            return sa < sb;
        });
    
    return aEntries;
}

std::vector<std::string> FileIO::GetAllFilesRecursive(const std::string &pRootPath) {
    std::vector<std::string> aEntries;
    const std::filesystem::path aRoot(pRootPath);
    std::error_code aRootError;
    if (!std::filesystem::is_directory(aRoot, aRootError) || aRootError) {
        return aEntries;
    }
    
    std::error_code aIteratorError;
    std::filesystem::recursive_directory_iterator aIterator(aRoot,
                                                            std::filesystem::directory_options::skip_permission_denied,
                                                            aIteratorError);
    std::filesystem::recursive_directory_iterator aEnd;
    while (!aIteratorError && aIterator != aEnd) {
        const std::filesystem::directory_entry aEntry = *aIterator;
        std::error_code aEntryError;
        if (!aEntry.is_regular_file(aEntryError) || aEntryError) {
            aIterator.increment(aIteratorError);
            continue;
        }
        
        std::error_code aRelativeError;
        const std::filesystem::path aRelativePath =
        std::filesystem::relative(aEntry.path(), aRoot, aRelativeError);
        if (aRelativeError) {
            aIterator.increment(aIteratorError);
            continue;
        }
        aEntries.push_back(aEntry.path().lexically_normal().generic_string());
        aIterator.increment(aIteratorError);
    }
    
    std::sort(aEntries.begin(), aEntries.end(),
        [](const std::string &a, const std::string &b) {
            const std::filesystem::path pa(a);
            const std::filesystem::path pb(b);

            const std::string sa = pa.stem().string();
            const std::string sb = pb.stem().string();

            if (sa == sb) {
                // tie-breaker: full path (keeps ordering stable)
                return a < b;
            }
            return sa < sb;
        });
    
    return aEntries;
}
