//
//  Random.cpp
//  HomeGrownTests
//
//  Created by Lucky Squirrel on 4/3/26.
//

#include "Random.hpp"
#include <limits>

std::random_device cRandomDevice;
std::mt19937 cRandomGenerator(cRandomDevice());

void Random::Seed(int pSeed) {
    cRandomGenerator.seed(pSeed);
}

bool Random::Bool() {
    return (Get(16) > 7);
}

bool Random::Chance(std::uint8_t pProbability) {
    if (pProbability == 0U) {
        return false;
    }
    if (pProbability >= 100U) {
        return true;
    }
    return Get(100) < static_cast<int>(pProbability);
}

std::uint8_t Random::GetByte() {
    std::uniform_int_distribution<int> aDist(0, std::numeric_limits<std::uint8_t>::max());
    return aDist(cRandomGenerator);
}

std::uint32_t Random::Get32() {
    std::uniform_int_distribution<std::uint32_t> aDist(0, std::numeric_limits<std::uint32_t>::max());
    return aDist(cRandomGenerator);
}

int Random::Get() {
    std::uniform_int_distribution<int> aDist(0, std::numeric_limits<int>::max());
    return aDist(cRandomGenerator);
}

int Random::Get(int pMax) {
    if (pMax <= 0) {
        return 0;
    }
    std::uniform_int_distribution<int> aDist(0, pMax - 1);
    return aDist(cRandomGenerator);
}

int Random::Get(int pMin, int pMax) {
    if (pMin >= pMax) {
        return pMin;
    }
    std::uniform_int_distribution<int> aDist(pMin, pMax);
    return aDist(cRandomGenerator);
}


std::uint64_t Random::Get64High() {
    std::uniform_int_distribution<std::uint64_t> aDist(std::numeric_limits<std::uint64_t>::max() / 2, std::numeric_limits<std::uint64_t>::max());
    return aDist(cRandomGenerator);
}

std::uint64_t Random::Get64HighOdd() {
    return Get64High() | 1ULL;
}

std::uint64_t Random::Get64() {
    std::uniform_int_distribution<std::uint64_t> aDist(0, std::numeric_limits<std::uint64_t>::max());
    return aDist(cRandomGenerator);
}

std::uint64_t Random::Get64(std::uint64_t pMax) {
    if (pMax <= 0) {
        return 0;
    }
    std::uniform_int_distribution<std::uint64_t> aDist(0, pMax - 1);
    return aDist(cRandomGenerator);
}

std::uint64_t Random::Get64(std::uint64_t pMin, std::uint64_t pMax) {
    if (pMin >= pMax) {
        return pMin;
    }
    std::uniform_int_distribution<std::uint64_t> aDist(pMin, pMax);
    return aDist(cRandomGenerator);
}

std::uint64_t Random::Int64() {
    return Get64();
}

std::uint64_t Random::Int64(std::uint64_t pMax) {
    return Get64(pMax);
}

std::uint64_t Random::Int64(std::uint64_t pMin, std::uint64_t pMax) {
    return Get64(pMin, pMax);
}

float Random::GetFloat() {
    std::uniform_real_distribution<float> aDist(0.0f, 1.0f);
    return aDist(cRandomGenerator);
}

float Random::GetFloat(float pMax) {
    if (pMax <= 0.0f) {
        return 0.0f;
    }
    std::uniform_real_distribution<float> aDist(0.0f, pMax);
    return aDist(cRandomGenerator);
}

float Random::GetFloat(float pMin, float pMax) {
    if (pMin >= pMax) {
        return pMin;
    }
    std::uniform_real_distribution<float> aDist(pMin, pMax);
    return aDist(cRandomGenerator);
}
