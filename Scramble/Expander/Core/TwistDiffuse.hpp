//
//  TwistDiffuse.hpp
//  MeanMachine
//
//  Created by icarus black on 6/23/26.
//

#ifndef TwistDiffuse_hpp
#define TwistDiffuse_hpp

#include <cstdint>
#include <cstddef>

#include "M88.hpp"
#include "TwistWorkSpace.hpp"

class TwistDiffuse {
    
public:
    
    static void                 DiffuseWithDomainWords(std::uint8_t *pEntropyLaneA,
                                                       std::uint8_t *pEntropyLaneB,
                                                       std::uint8_t *pEntropyLaneC,
                                                       std::uint8_t *pEntropyLaneD,
                                                       std::uint8_t *pInputLaneA,
                                                       std::uint8_t *pInputLaneB,
                                                       std::uint8_t *pInputLaneC,
                                                       std::uint8_t *pInputLaneD,
                                                       std::uint8_t *pOutputLaneA,
                                                       std::uint8_t *pOutputLaneB,
                                                       std::uint8_t *pOutputLaneC,
                                                       std::uint8_t *pOutputLaneD,
                                                       std::size_t *pIndexList256A,
                                                       std::size_t *pIndexList256B,
                                                       std::size_t *pIndexList256C,
                                                       std::size_t *pIndexList256D,
                                                       M88 *pMatrix,
                                                       std::uint64_t pMatrixSelectA,
                                                       std::uint64_t pMatrixSelectB,
                                                       std::uint8_t pMatrixUnrollA,
                                                       std::uint8_t pMatrixUnrollB,
                                                       std::uint8_t pMatrixArgA,
                                                       std::uint8_t pMatrixArgB,
                                                       std::uint8_t pMatrixArgC,
                                                       std::uint8_t pMatrixArgD);
    
    static void                 KeyDiffuseWithDomainWords(std::uint8_t *pEntropyLaneA,
                                                          std::uint8_t *pEntropyLaneB,
                                                          std::uint8_t *pEntropyLaneC,
                                                          std::uint8_t *pEntropyLaneD,
                                                          std::uint8_t *pInputLaneA,
                                                          std::uint8_t *pInputLaneB,
                                                          std::uint8_t *pInputLaneC,
                                                          std::uint8_t *pInputLaneD,
                                                          std::uint8_t *pOutputLaneA,
                                                          std::uint8_t *pOutputLaneB,
                                                          std::uint8_t *pOutputLaneC,
                                                          std::uint8_t *pOutputLaneD,
                                                          std::size_t *pIndexList16A,
                                                          std::size_t *pIndexList16B,
                                                          std::size_t *pIndexList16C,
                                                          std::size_t *pIndexList16D,
                                                          M88 *pMatrix,
                                                          std::uint64_t pMatrixSelectA,
                                                          std::uint64_t pMatrixSelectB,
                                                          std::uint8_t pMatrixUnrollA,
                                                          std::uint8_t pMatrixUnrollB,
                                                          std::uint8_t pMatrixArgA,
                                                          std::uint8_t pMatrixArgB,
                                                          std::uint8_t pMatrixArgC,
                                                          std::uint8_t pMatrixArgD);

};

#endif /* TwistDiffuse_hpp */
