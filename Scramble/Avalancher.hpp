//
//  Avalancher.hpp
//  MeanMachine
//
//  Created by icarus black on 6/23/26.
//

#ifndef Avalancher_hpp
#define Avalancher_hpp

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <string>
#include <vector>

#include "TwistExpander.hpp"

#define AVA_BLOCK_COUNT 32

struct AvalancherScore {
    std::size_t                     mByteCount = 0U;
    std::size_t                     mBitCount = 0U;
    std::size_t                     mDifferentBytes = 0U;
    std::size_t                     mDifferentBits = 0U;
    double                          mDifferentByteRatio = 0.0;
    double                          mDifferentBitRatio = 0.0;
    double                          mScore = 0.0;

    bool                            IsValid() const { return mByteCount > 0U; }
    void                            PrintExtended(const std::string &pName) const;
    void                            PrintQuick(const std::string &pName) const;
};

class Avalancher {
public:
    Avalancher();
    
    void                            SetExpander(TwistExpander *pExpander);
    void                            SetBlockCount(std::size_t pBlockCount);
    std::size_t                     GetBlockCount() const;
    
    AvalancherScore                 DiffAB();
    AvalancherScore                 DiffAB(const std::string &pPasswordA,
                                           const std::string &pPasswordB);
    AvalancherScore                 DiffAB(std::uint8_t *pPasswordA,
                                           int pPasswordLengthA,
                                           std::uint8_t *pPasswordB,
                                           int pPasswordLengthB);
    
    void                            RunA(std::uint8_t *pPassword,
                                         int pPasswordLength);
    void                            RunB(std::uint8_t *pPassword,
                                         int pPasswordLength);
    
    std::vector<std::uint8_t>       GetOutputA(std::uint8_t *pPassword,
                                               int pPasswordLength);
    std::vector<std::uint8_t>       GetOutputB(std::uint8_t *pPassword,
                                               int pPasswordLength);
    std::vector<std::uint8_t>       GetOutput(std::uint8_t *pPassword,
                                              int pPasswordLength);
    std::vector<std::uint8_t>       GetOutput(const std::string &pPassword);

    bool                            SavePractRandStream(std::uint8_t *pPassword,
                                                        int pPasswordLength,
                                                        const std::string &pPath);
    bool                            SavePractRandStream(const std::string &pPassword,
                                                        const std::string &pPath);
    bool                            SavePractRandStreamProjectRoot(std::uint8_t *pPassword,
                                                                   int pPasswordLength,
                                                                   const std::string &pPath);
    bool                            SavePractRandStreamProjectRoot(const std::string &pPassword,
                                                                   const std::string &pPath);

    const std::vector<std::uint8_t> &OutputA() const;
    const std::vector<std::uint8_t> &OutputB() const;

private:
    bool                            RunInto(std::uint8_t *pPassword,
                                            int pPasswordLength,
                                            std::vector<std::uint8_t> *pOutput);
    static AvalancherScore          ScoreBuffers(const std::vector<std::uint8_t> &pA,
                                                 const std::vector<std::uint8_t> &pB);
    static std::uint8_t             *PasswordBytes(const std::string &pPassword);

    TwistExpander                   *mExpander;
    std::size_t                     mBlockCount;
    std::uint8_t                    mDefaultPasswordA[1];
    std::uint8_t                    mDefaultPasswordB[1];
    std::vector<std::uint8_t>       mDestA;
    std::vector<std::uint8_t>       mDestB;
    
};

#endif /* Avalancher_hpp */
