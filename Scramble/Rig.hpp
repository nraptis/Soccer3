//
//  Rig.hpp
//  MeanMachine
//
//  Created by Icarus Black on 5/4/26.
//

#ifndef Rig_hpp
#define Rig_hpp

#include "FileIO.hpp"
#include "TwistExpander.hpp"
#include "TwistFunctional.hpp"


class Rig {
    
public:
    
    Rig();
    ~Rig();
    
    void                            SetBlockCount(int pBlockCount);
    
    void                            Run(TwistExpander *pExpander,
                                        std::uint8_t *pPassword,
                                        int pPasswordLength);

    bool                            SaveByteStream(const std::string &pFolder = "") const;
    bool                            SaveByteStreamProjectRoot(const std::string &pFolder = "") const;

    bool                            SaveByteStreamLastAsciiPassword(const std::string &pFolder = "") const;
    bool                            SaveByteStreamProjectRootLastAsciiPassword(const std::string &pFolder = "") const;

    bool                            SaveByteStream(const std::string &pFolder,
                                                   const std::string &pBaseFile,
                                                   int pFileNumber) const;
    bool                            SaveByteStreamProjectRoot(const std::string &pFolder,
                                                              const std::string &pBaseFile,
                                                              int pFileNumber) const;
    
    std::uint8_t                    *mData;
    std::size_t                     mDataLength;
    std::size_t                     mBlockCount;
    std::string                     mLastPasswordTag;
    
    
};

#endif /* Rig_hpp */
