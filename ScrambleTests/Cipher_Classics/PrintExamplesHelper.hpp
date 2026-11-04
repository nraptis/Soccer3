//
//  PrintExamplesHelper.hpp
//  HolyStorms
//
//  Created by icarus black on 7/2/26.
//

#ifndef PrintExamplesHelper_hpp
#define PrintExamplesHelper_hpp

#include <array>
#include <cstdint>
#include <string>
#include <vector>

class PrintExamplesHelper {
public:
    
    static constexpr std::size_t kExampleLength = 64;
    static constexpr std::size_t kBytesPerRow = 8;
    static constexpr const char *kStreamGroupSeparator = "  ";
    static constexpr const char *kBlockGroupSeparator = " | ";
    
    static std::array<std::uint8_t, kExampleLength>     BuildEightSectionExample();
    
    static std::string                                  BinaryByte(const std::uint8_t pValue);
    static std::string                                  HexByte(const std::uint8_t pValue);
    static std::string                                  HexArray(const std::uint8_t *pBuffer,
                                                                 const std::size_t pBufferLength);
    static std::string                                  HexArray(const std::vector<std::uint8_t> &pBuffer);
    
    static std::vector<std::string>                     GetRows(const std::string &pTitle,
                                                                const std::uint8_t *pSource,
                                                                const std::size_t pSourceLength,
                                                                const std::size_t pGroupSize = kBytesPerRow,
                                                                const char *pGroupSeparator = kStreamGroupSeparator);
    
    static std::vector<std::string>                     GetAvalancheRows(const std::uint8_t *pBefore,
                                                                         const std::uint8_t *pAfter,
                                                                         const std::size_t pSourceLength,
                                                                         const std::size_t pGroupSize = kBytesPerRow,
                                                                         const char *pGroupSeparator = kStreamGroupSeparator);
    
    static std::vector<std::string>                     GetBlockRows(const std::string &pTitle,
                                                                     const std::uint8_t *pSource,
                                                                     const std::size_t pSourceLength,
                                                                     const std::size_t pBlockSize);
    
    static std::vector<std::string>                     GetBlockAvalancheRows(const std::uint8_t *pBefore,
                                                                              const std::uint8_t *pAfter,
                                                                              const std::size_t pSourceLength,
                                                                              const std::size_t pBlockSize);
    
    static std::vector<std::string>                     GetExample(const std::vector<std::uint8_t> &pSource,
                                                                   const std::vector<std::uint8_t> &pExpected,
                                                                   const std::size_t pGroupSize = kBytesPerRow,
                                                                   const char *pGroupSeparator = kStreamGroupSeparator);
    
    static std::vector<std::string>                     GetBlockExample(const std::vector<std::uint8_t> &pSource,
                                                                        const std::vector<std::uint8_t> &pExpected,
                                                                        const std::size_t pBlockSize);
    
    static std::vector<std::string>                     GetBeforeAfter(const std::string &pTitle,
                                                                       const std::uint8_t *pBefore,
                                                                       const std::uint8_t *pAfter,
                                                                       const std::size_t pSourceLength,
                                                                       const std::size_t pGroupSize = kBytesPerRow,
                                                                       const char *pGroupSeparator = kStreamGroupSeparator);
    
    static std::vector<std::string>                     GetBlockBeforeAfter(const std::string &pTitle,
                                                                            const std::uint8_t *pBefore,
                                                                            const std::uint8_t *pAfter,
                                                                            const std::size_t pSourceLength,
                                                                            const std::size_t pBlockSize);
    
    static void                                         PrintRows(const std::string &pTitle,
                                                                  const std::uint8_t *pSource,
                                                                  const std::size_t pSourceLength,
                                                                  const std::size_t pGroupSize = kBytesPerRow,
                                                                  const char *pGroupSeparator = kStreamGroupSeparator);
    
    static void                                         PrintBeforeAfter(const std::string &pTitle,
                                                                         const std::uint8_t *pBefore,
                                                                         const std::uint8_t *pAfter,
                                                                         const std::size_t pSourceLength,
                                                                         const std::size_t pGroupSize = kBytesPerRow,
                                                                         const char *pGroupSeparator = kStreamGroupSeparator);
    
    static void                                         PrintBlockBeforeAfter(const std::string &pTitle,
                                                                              const std::uint8_t *pBefore,
                                                                              const std::uint8_t *pAfter,
                                                                              const std::size_t pSourceLength,
                                                                              const std::size_t pBlockSize);
    
    
};

#endif /* PrintExamplesHelper_hpp */
