//
//  Random.hpp
//  HomeGrownTests
//
//  Created by Lucky Squirrel on 4/3/26.
//

#ifndef RANDOM_HPP
#define RANDOM_HPP

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <random>
#include <vector>

class Random {
public:
    
    static void                         Seed(int pSeed);
    
    static std::uint8_t                 GetByte();
    static std::uint32_t                Get32();
    
    static int                          Get();
    static int                          Get(int pMax);
    static int                          Get(int pMin, int pMax);
    
    static std::uint64_t                Get64High();
    static std::uint64_t                Get64HighOdd();
    static std::uint64_t                Get64();
    static std::uint64_t                Get64(std::uint64_t pMax);
    static std::uint64_t                Get64(std::uint64_t pMin, std::uint64_t pMax);

    static std::uint64_t                Int64();
    static std::uint64_t                Int64(std::uint64_t pMax);
    static std::uint64_t                Int64(std::uint64_t pMin, std::uint64_t pMax);
    
    
    static float                        GetFloat();
    static float                        GetFloat(float pMax);
    
    static float                        GetFloat(float pMin, float pMax);
    
    static bool                         Bool();
    static bool                         Chance(std::uint8_t pProbability);
    

    template <typename T>
    static T                            Choice(const std::vector<T> &pItems) {
        if (pItems.empty()) {
            return T();
        }
        const std::size_t aIndex = static_cast<std::size_t>(Get(static_cast<int>(pItems.size())));
        return pItems[aIndex];
    }
    
    template <typename T>
    static T ChoiceIgnoring(const std::vector<T> &pItems, const std::vector<T> &pIgnore) {
        std::vector<T> aChoices;
        for (const auto &aItem: pItems) {
            bool aIgnore = false;
            for (const auto &aIgnoredItem: pIgnore) {
                if (aItem == aIgnoredItem) {
                    aIgnore = true;
                    break;
                }
            }
            
            if (aIgnore == false) {
                aChoices.push_back(aItem);
            }
        }
        
        if (aChoices.empty()) {
            return T();
        }
        
        const std::size_t aIndex = static_cast<std::size_t>(Get(static_cast<int>(aChoices.size())));
        return aChoices[aIndex];
    }

    template <typename T>
    static void                         Shuffle(std::vector<T> *pItems) {
        if ((pItems == nullptr) || (pItems->size() < 2U)) {
            return;
        }
        for (std::size_t i = 1U; i < pItems->size(); ++i) {
            const std::size_t aSwapIndex = static_cast<std::size_t>(Get(static_cast<int>(i + 1U)));
            std::swap((*pItems)[i], (*pItems)[aSwapIndex]);
        }
    }
    
    template <typename T>
    static void                         Shuffle(T *pItems, int pLength) {
        if ((pItems == nullptr) || (pLength < 2U)) {
            return;
        }
        for (std::size_t i = 1U; i < pLength; ++i) {
            const std::size_t aSwapIndex = static_cast<std::size_t>(Get(static_cast<int>(i + 1U)));
            std::swap(pItems[i], pItems[aSwapIndex]);
        }
    }
    
    static std::vector<int> RandomIndicesInRange(int pCount, int pRangeMax) {
        
        std::vector<int> aResult;
        if (pRangeMax <= 0 || pCount <= 0) {
            return aResult;
        }
        
        pCount = std::min(pCount, pRangeMax);
        
        std::vector<int> aPool(pRangeMax);
        for (int i = 0; i < pRangeMax; i++) {
            aPool[i] = i;
        }
        
        // Partial Fisher–Yates: only first pCount positions
        for (int i = 0; i < pCount; i++) {
            int j = i + Random::Get(pRangeMax - i); // random in [i, pRangeMax)
            std::swap(aPool[i], aPool[j]);
        }
        
        return std::vector<int>(aPool.begin(), aPool.begin() + pCount);
    }
    
};

#endif /* Random_hpp */
