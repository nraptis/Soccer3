//
//  PrintExamplesHelper.cpp
//  HolyStorms
//
//  Created by icarus black on 7/2/26.
//

#include "PrintExamplesHelper.hpp"

#include <algorithm>
#include <cstdio>

namespace {

std::size_t CountSetBits(std::uint8_t pValue) {
    std::size_t aResult = 0u;
    while (pValue != 0u) {
        aResult += pValue & 1u;
        pValue >>= 1u;
    }
    return aResult;
}

std::size_t CountChangedBits(const std::uint8_t *pBefore,
                             const std::uint8_t *pAfter,
                             const std::size_t pSourceLength) {
    if (pBefore == nullptr || pAfter == nullptr) {
        return 0u;
    }
    
    std::size_t aResult = 0u;
    for (std::size_t aIndex = 0; aIndex < pSourceLength; ++aIndex) {
        aResult += CountSetBits(static_cast<std::uint8_t>(pBefore[aIndex] ^ pAfter[aIndex]));
    }
    return aResult;
}

std::string AvalanchePercentLine(const std::uint8_t *pBefore,
                                 const std::uint8_t *pAfter,
                                 const std::size_t pSourceLength) {
    const std::size_t aChangedBits = CountChangedBits(pBefore, pAfter, pSourceLength);
    const std::size_t aTotalBits = pSourceLength * 8u;
    const double aPercent = aTotalBits == 0u
                                ? 0.0
                                : (static_cast<double>(aChangedBits) * 100.0) /
                                      static_cast<double>(aTotalBits);
    
    char aBuffer[64];
    std::snprintf(aBuffer, sizeof(aBuffer), "Avalanche: %.2f%%", aPercent);
    return aBuffer;
}

}  // namespace

std::array<std::uint8_t, PrintExamplesHelper::kExampleLength> PrintExamplesHelper::BuildEightSectionExample() {
    std::array<std::uint8_t, kExampleLength> aSource = {};
    
    const std::uint8_t aRows[8][8] = {
        {0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01},
        {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
        {0x81, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42, 0x81},
        {0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55},
        {0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F},
        {0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF},
        {0x01, 0x03, 0x07, 0x0F, 0x1F, 0x3F, 0x7F, 0xFF},
        {0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77},
    };
    
    for (std::size_t aRow = 0; aRow < kBytesPerRow; ++aRow) {
        for (std::size_t aColumn = 0; aColumn < kBytesPerRow; ++aColumn) {
            aSource[(aRow * kBytesPerRow) + aColumn] = aRows[aRow][aColumn];
        }
    }
    
    return aSource;
}

std::string PrintExamplesHelper::BinaryByte(const std::uint8_t pValue) {
    std::string aResult;
    aResult.reserve(8);
    
    for (int aBit = 7; aBit >= 0; --aBit) {
        aResult.push_back((pValue & (1u << aBit)) != 0 ? '1' : '0');
    }
    
    return aResult;
}

std::string PrintExamplesHelper::HexByte(const std::uint8_t pValue) {
    const char *aDigits = "0123456789ABCDEF";
    std::string aResult = "0x00";
    aResult[2] = aDigits[(pValue >> 4) & 0x0F];
    aResult[3] = aDigits[pValue & 0x0F];
    return aResult;
}

std::string PrintExamplesHelper::HexArray(const std::uint8_t *pBuffer,
                                          const std::size_t pBufferLength) {
    std::string aResult = "[";
    
    for (std::size_t aIndex = 0; aIndex < pBufferLength; ++aIndex) {
        if (aIndex != 0u) {
            aResult += ", ";
        }
        aResult += HexByte(pBuffer == nullptr ? 0u : pBuffer[aIndex]);
    }
    
    aResult += "]";
    return aResult;
}

std::string PrintExamplesHelper::HexArray(const std::vector<std::uint8_t> &pBuffer) {
    return HexArray(pBuffer.data(), pBuffer.size());
}

std::vector<std::string> PrintExamplesHelper::GetRows(const std::string &pTitle,
                                                      const std::uint8_t *pSource,
                                                      const std::size_t pSourceLength,
                                                      const std::size_t pGroupSize,
                                                      const char *pGroupSeparator) {
    std::vector<std::string> aLines;
    aLines.push_back(pTitle + ":");
    
    if (pSource == nullptr) {
        return aLines;
    }
    
    const char *aSeparator = pGroupSeparator == nullptr ? "" : pGroupSeparator;
    
    for (std::size_t aRow = 0; aRow < 8; ++aRow) {
        const int aBit = 7 - static_cast<int>(aRow);
        std::string aLine = "bit" + std::to_string(aRow) + " ";
        
        for (std::size_t aIndex = 0; aIndex < pSourceLength; ++aIndex) {
            const bool aIsSet = (pSource[aIndex] & (1u << aBit)) != 0;
            aLine.push_back(aIsSet ? '1' : '0');
            
            if (pGroupSize != 0u &&
                ((aIndex + 1) % pGroupSize) == 0 &&
                (aIndex + 1) < pSourceLength) {
                aLine += aSeparator;
            }
        }
        
        aLines.push_back(aLine);
    }
    
    return aLines;
}

std::vector<std::string> PrintExamplesHelper::GetBlockRows(const std::string &pTitle,
                                                           const std::uint8_t *pSource,
                                                           const std::size_t pSourceLength,
                                                           const std::size_t pBlockSize) {
    return GetRows(pTitle,
                   pSource,
                   pSourceLength,
                   pBlockSize,
                   kBlockGroupSeparator);
}

std::vector<std::string> PrintExamplesHelper::GetAvalancheRows(const std::uint8_t *pBefore,
                                                               const std::uint8_t *pAfter,
                                                               const std::size_t pSourceLength,
                                                               const std::size_t pGroupSize,
                                                               const char *pGroupSeparator) {
    std::vector<std::string> aLines;
    aLines.push_back("Avalanche:");
    
    if (pBefore == nullptr || pAfter == nullptr) {
        aLines.push_back(AvalanchePercentLine(pBefore, pAfter, pSourceLength));
        return aLines;
    }
    
    const char *aSeparator = pGroupSeparator == nullptr ? "" : pGroupSeparator;
    
    for (std::size_t aRow = 0; aRow < 8; ++aRow) {
        const int aBit = 7 - static_cast<int>(aRow);
        std::string aLine = "bit" + std::to_string(aRow) + " ";
        
        for (std::size_t aIndex = 0; aIndex < pSourceLength; ++aIndex) {
            const bool aChanged =
                ((pBefore[aIndex] ^ pAfter[aIndex]) & (1u << aBit)) != 0;
            aLine.push_back(aChanged ? 'X' : '.');
            
            if (pGroupSize != 0u &&
                ((aIndex + 1) % pGroupSize) == 0 &&
                (aIndex + 1) < pSourceLength) {
                aLine += aSeparator;
            }
        }
        
        aLines.push_back(aLine);
    }
    
    aLines.push_back(AvalanchePercentLine(pBefore, pAfter, pSourceLength));
    return aLines;
}

std::vector<std::string> PrintExamplesHelper::GetBlockAvalancheRows(const std::uint8_t *pBefore,
                                                                    const std::uint8_t *pAfter,
                                                                    const std::size_t pSourceLength,
                                                                    const std::size_t pBlockSize) {
    return GetAvalancheRows(pBefore,
                            pAfter,
                            pSourceLength,
                            pBlockSize,
                            kBlockGroupSeparator);
}

std::vector<std::string> PrintExamplesHelper::GetExample(const std::vector<std::uint8_t> &pSource,
                                                         const std::vector<std::uint8_t> &pExpected,
                                                         const std::size_t pGroupSize,
                                                         const char *pGroupSeparator) {
    std::vector<std::string> aLines = GetRows("Before Cipher",
                                              pSource.data(),
                                              pSource.size(),
                                              pGroupSize,
                                              pGroupSeparator);
    aLines.push_back("");
    
    std::vector<std::string> aAfterLines = GetRows("After Cipher",
                                                   pExpected.data(),
                                                   pExpected.size(),
                                                   pGroupSize,
                                                   pGroupSeparator);
    aLines.insert(aLines.end(), aAfterLines.begin(), aAfterLines.end());
    aLines.push_back("");
    
    const std::size_t aAvalancheLength =
        std::min(pSource.size(), pExpected.size());
    std::vector<std::string> aAvalancheLines = GetAvalancheRows(pSource.data(),
                                                                pExpected.data(),
                                                                aAvalancheLength,
                                                                pGroupSize,
                                                                pGroupSeparator);
    aLines.insert(aLines.end(), aAvalancheLines.begin(), aAvalancheLines.end());
    
    return aLines;
}

std::vector<std::string> PrintExamplesHelper::GetBlockExample(const std::vector<std::uint8_t> &pSource,
                                                              const std::vector<std::uint8_t> &pExpected,
                                                              const std::size_t pBlockSize) {
    return GetExample(pSource,
                      pExpected,
                      pBlockSize,
                      kBlockGroupSeparator);
}

std::vector<std::string> PrintExamplesHelper::GetBeforeAfter(const std::string &pTitle,
                                                            const std::uint8_t *pBefore,
                                                            const std::uint8_t *pAfter,
                                                            const std::size_t pSourceLength,
                                                            const std::size_t pGroupSize,
                                                            const char *pGroupSeparator) {
    std::vector<std::string> aLines;
    aLines.push_back("----- " + pTitle + " -----");
    aLines.push_back("");
    
    std::vector<std::string> aBeforeLines = GetRows("Before Cipher",
                                                    pBefore,
                                                    pSourceLength,
                                                    pGroupSize,
                                                    pGroupSeparator);
    aLines.insert(aLines.end(), aBeforeLines.begin(), aBeforeLines.end());
    aLines.push_back("");
    
    std::vector<std::string> aAfterLines = GetRows("After Cipher",
                                                   pAfter,
                                                   pSourceLength,
                                                   pGroupSize,
                                                   pGroupSeparator);
    aLines.insert(aLines.end(), aAfterLines.begin(), aAfterLines.end());
    aLines.push_back("");
    
    std::vector<std::string> aAvalancheLines = GetAvalancheRows(pBefore,
                                                                pAfter,
                                                                pSourceLength,
                                                                pGroupSize,
                                                                pGroupSeparator);
    aLines.insert(aLines.end(), aAvalancheLines.begin(), aAvalancheLines.end());
    
    return aLines;
}

std::vector<std::string> PrintExamplesHelper::GetBlockBeforeAfter(const std::string &pTitle,
                                                                  const std::uint8_t *pBefore,
                                                                  const std::uint8_t *pAfter,
                                                                  const std::size_t pSourceLength,
                                                                  const std::size_t pBlockSize) {
    return GetBeforeAfter(pTitle,
                          pBefore,
                          pAfter,
                          pSourceLength,
                          pBlockSize,
                          kBlockGroupSeparator);
}

void PrintExamplesHelper::PrintRows(const std::string &pTitle,
                                    const std::uint8_t *pSource,
                                    const std::size_t pSourceLength,
                                    const std::size_t pGroupSize,
                                    const char *pGroupSeparator) {
    const std::vector<std::string> aLines = GetRows(pTitle,
                                                    pSource,
                                                    pSourceLength,
                                                    pGroupSize,
                                                    pGroupSeparator);
    for (const std::string &aLine : aLines) {
        std::printf("%s\n", aLine.c_str());
    }
}

void PrintExamplesHelper::PrintBeforeAfter(const std::string &pTitle,
                                           const std::uint8_t *pBefore,
                                           const std::uint8_t *pAfter,
                                           const std::size_t pSourceLength,
                                           const std::size_t pGroupSize,
                                           const char *pGroupSeparator) {
    std::printf("\n");
    
    const std::vector<std::string> aLines = GetBeforeAfter(pTitle,
                                                           pBefore,
                                                           pAfter,
                                                           pSourceLength,
                                                           pGroupSize,
                                                           pGroupSeparator);
    for (const std::string &aLine : aLines) {
        std::printf("%s\n", aLine.c_str());
    }
    
    std::printf("\n");
}

void PrintExamplesHelper::PrintBlockBeforeAfter(const std::string &pTitle,
                                                const std::uint8_t *pBefore,
                                                const std::uint8_t *pAfter,
                                                const std::size_t pSourceLength,
                                                const std::size_t pBlockSize) {
    std::printf("\n");
    
    const std::vector<std::string> aLines = GetBlockBeforeAfter(pTitle,
                                                                pBefore,
                                                                pAfter,
                                                                pSourceLength,
                                                                pBlockSize);
    for (const std::string &aLine : aLines) {
        std::printf("%s\n", aLine.c_str());
    }
    
    std::printf("\n");
}
