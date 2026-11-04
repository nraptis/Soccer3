//
//  FileIO.hpp
//  Gorgon
//
//  Created by Sonic The Hedge Whore on 4/9/26.
//

#ifndef FileIO_hpp
#define FileIO_hpp

#include <cstddef>
#include <string>
#include <vector>
#include <filesystem>

class FileIO {
    
public:
    
    static bool                                 Load(std::string pPath, std::vector<std::uint8_t> &pDest);
    
    static bool                                 Save(std::string pPath, unsigned char *pData, int pLength);
    static bool                                 Save(std::string pPath, const std::vector<std::uint8_t> &pData);
    
    static std::string                          CurrentWorkingDirectory();
    static std::string                          ProjectRoot();
    
    static std::string                          Join(const std::string& pLeft, const std::string& pRight);
    
    static std::string                          CurrentWorkingDirectory(const std::string& pRight);
    static std::string                          ProjectRoot(const std::string& pRight);
    
    static std::string                          SequenceFile(const std::string& pPrefix, int pNumber, const std::string& pExtension, int pZeros);
    
    static std::vector<std::string>             GetAllFiles(const std::string &pRootPath);
    static std::vector<std::string>             GetAllFilesRecursive(const std::string &pRootPath);
    
};



#endif /* FileIO_hpp */
