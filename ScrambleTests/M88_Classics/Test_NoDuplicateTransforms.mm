//
//  Test_NoDuplicateTransforms.m
//  UnitTests
//
//  Created by Wu Tang on 6/3/26.
//

#import <XCTest/XCTest.h>

#include <array>
#include <map>
#include <string>
#include <vector>
#include <cstring>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Logging.hpp"

@interface Test_NoDuplicateTransforms : XCTestCase
@end

@implementation Test_NoDuplicateTransforms

using TransformFn = void (M88::*)();

struct TransformEntry {
    const char *mName;
    TransformFn mFunction;
};

static std::array<std::uint8_t, 64> CaptureData(const M88 &pMatrix) {
    std::array<std::uint8_t, 64> aResult;
    std::memcpy(aResult.data(), pMatrix.mData, 64);
    return aResult;
}

static std::string MatrixKey(const std::array<std::uint8_t, 64> &pData) {
    std::string aResult;
    aResult.reserve(64 * 3);

    for (std::size_t i = 0; i < pData.size(); i++) {
        aResult += std::to_string(static_cast<int>(pData[i]));
        aResult += ",";
    }

    return aResult;
}

static std::vector<TransformEntry> BuildTransformList() {
    return {
        
        { "Full_RotA_8x8", &M88::Full_RotA_8x8 },
        { "Full_RotA_EachMini_2x2", &M88::Full_RotA_EachMini_2x2 },
        { "Full_RotA_EachQuad_2x2", &M88::Full_RotA_EachQuad_2x2 },
        { "Full_RotA_EachQuad_4x4", &M88::Full_RotA_EachQuad_4x4 },

        
        { "Full_RotB_8x8", &M88::Full_RotB_8x8 },
        { "Full_RotB_EachMini_2x2", &M88::Full_RotB_EachMini_2x2 },
        { "Full_RotB_EachQuad_2x2", &M88::Full_RotB_EachQuad_2x2 },
        { "Full_RotB_EachQuad_4x4", &M88::Full_RotB_EachQuad_4x4 },

        { "Full_RotC_8x8", &M88::Full_RotC_8x8 },
        { "Full_RotC_EachMini_2x2", &M88::Full_RotC_EachMini_2x2 },
        { "Full_RotC_EachQuad_2x2", &M88::Full_RotC_EachQuad_2x2 },
        { "Full_RotC_EachQuad_4x4", &M88::Full_RotC_EachQuad_4x4 },

        
        { "Full_FlipA_8x8", &M88::Full_FlipA_8x8 },
        { "Full_FlipA_EachMini_2x2", &M88::Full_FlipA_EachMini_2x2 },
        { "Full_FlipA_EachQuad_2x2", &M88::Full_FlipA_EachQuad_2x2 },
        { "Full_FlipA_EachQuad_4x4", &M88::Full_FlipA_EachQuad_4x4 },

        
        { "Full_FlipB_8x8", &M88::Full_FlipB_8x8 },
        { "Full_FlipB_EachMini_2x2", &M88::Full_FlipB_EachMini_2x2 },
        { "Full_FlipB_EachQuad_2x2", &M88::Full_FlipB_EachQuad_2x2 },
        { "Full_FlipB_EachQuad_4x4", &M88::Full_FlipB_EachQuad_4x4 },

        { "Full_FlipC_8x8", &M88::Full_FlipC_8x8 },
        { "Full_FlipC_EachMini_2x2", &M88::Full_FlipC_EachMini_2x2 },
        { "Full_FlipC_EachQuad_2x2", &M88::Full_FlipC_EachQuad_2x2 },
        { "Full_FlipC_EachQuad_4x4", &M88::Full_FlipC_EachQuad_4x4 },

        { "Full_FlipD_8x8", &M88::Full_FlipD_8x8 },
        { "Full_FlipD_EachMini_2x2", &M88::Full_FlipD_EachMini_2x2 },
        { "Full_FlipD_EachQuad_2x2", &M88::Full_FlipD_EachQuad_2x2 },
        { "Full_FlipD_EachQuad_4x4", &M88::Full_FlipD_EachQuad_4x4 },

        { "Full_TriadA_EachMini_2x2", &M88::Full_TriadA_EachMini_2x2 },
        { "Full_TriadA_EachQuad_2x2", &M88::Full_TriadA_EachQuad_2x2 },

        { "Full_TriadB_EachMini_2x2", &M88::Full_TriadB_EachMini_2x2 },
        { "Full_TriadB_EachQuad_2x2", &M88::Full_TriadB_EachQuad_2x2 },

        { "Full_TriadC_EachMini_2x2", &M88::Full_TriadC_EachMini_2x2 },
        { "Full_TriadC_EachQuad_2x2", &M88::Full_TriadC_EachQuad_2x2 },

        { "Full_TriadD_EachMini_2x2", &M88::Full_TriadD_EachMini_2x2 },
        { "Full_TriadD_EachQuad_2x2", &M88::Full_TriadD_EachQuad_2x2 },

        { "Full_TriadE_EachMini_2x2", &M88::Full_TriadE_EachMini_2x2 },
        { "Full_TriadE_EachQuad_2x2", &M88::Full_TriadE_EachQuad_2x2 },

        { "Full_TriadF_EachMini_2x2", &M88::Full_TriadF_EachMini_2x2 },
        { "Full_TriadF_EachQuad_2x2", &M88::Full_TriadF_EachQuad_2x2 },

        { "Full_TriadG_EachMini_2x2", &M88::Full_TriadG_EachMini_2x2 },
        { "Full_TriadG_EachQuad_2x2", &M88::Full_TriadG_EachQuad_2x2 },

        { "Full_TriadH_EachMini_2x2", &M88::Full_TriadH_EachMini_2x2 },
        { "Full_TriadH_EachQuad_2x2", &M88::Full_TriadH_EachQuad_2x2 },

        { "Full_SnakeA_EachMini_2x2", &M88::Full_SnakeA_EachMini_2x2 },
        { "Full_SnakeA_EachQuad_2x2", &M88::Full_SnakeA_EachQuad_2x2 },

        { "Full_SnakeB_EachMini_2x2", &M88::Full_SnakeB_EachMini_2x2 },
        { "Full_SnakeB_EachQuad_2x2", &M88::Full_SnakeB_EachQuad_2x2 },

        { "Full_SnakeC_EachMini_2x2", &M88::Full_SnakeC_EachMini_2x2 },
        { "Full_SnakeC_EachQuad_2x2", &M88::Full_SnakeC_EachQuad_2x2 },

        { "Full_SnakeD_EachMini_2x2", &M88::Full_SnakeD_EachMini_2x2 },
        { "Full_SnakeD_EachQuad_2x2", &M88::Full_SnakeD_EachQuad_2x2 },


        { "Full_TowerA_EachQuad_4x4", &M88::Full_TowerA_EachQuad_4x4 },

        { "Full_TowerB_EachQuad_4x4", &M88::Full_TowerB_EachQuad_4x4 },

        { "Full_SwapA_EachMini_2x2", &M88::Full_SwapA_EachMini_2x2 },
        { "Full_SwapA_EachQuad_2x2", &M88::Full_SwapA_EachQuad_2x2 },

        { "Full_SwapB_EachMini_2x2", &M88::Full_SwapB_EachMini_2x2 },
        { "Full_SwapB_EachQuad_2x2", &M88::Full_SwapB_EachQuad_2x2 },

        { "Full_SwapC_EachMini_2x2", &M88::Full_SwapC_EachMini_2x2 },
        { "Full_SwapC_EachQuad_2x2", &M88::Full_SwapC_EachQuad_2x2 },

        { "Full_SwapD_EachMini_2x2", &M88::Full_SwapD_EachMini_2x2 },
        { "Full_SwapD_EachQuad_2x2", &M88::Full_SwapD_EachQuad_2x2 },

        { "Full_ShearA_8x8", &M88::Full_ShearA_8x8 },
        { "Full_ShearA_EachQuad_4x4", &M88::Full_ShearA_EachQuad_4x4 },

        { "Full_ShearB_8x8", &M88::Full_ShearB_8x8 },
        { "Full_ShearB_EachQuad_4x4", &M88::Full_ShearB_EachQuad_4x4 },

        { "Full_ShearC_8x8", &M88::Full_ShearC_8x8 },
        { "Full_ShearC_EachQuad_4x4", &M88::Full_ShearC_EachQuad_4x4 },

        { "Full_ShearD_8x8", &M88::Full_ShearD_8x8 },
        { "Full_ShearD_EachQuad_4x4", &M88::Full_ShearD_EachQuad_4x4 },

        { "Quad_RotA_2x2_A", &M88::Quad_RotA_2x2_A },
        { "Quad_RotA_2x2_B", &M88::Quad_RotA_2x2_B },
        { "Quad_RotA_2x2_C", &M88::Quad_RotA_2x2_C },
        { "Quad_RotA_2x2_D", &M88::Quad_RotA_2x2_D },
        { "Quad_RotA_4x4_A", &M88::Quad_RotA_4x4_A },
        { "Quad_RotA_4x4_B", &M88::Quad_RotA_4x4_B },
        { "Quad_RotA_4x4_C", &M88::Quad_RotA_4x4_C },
        { "Quad_RotA_4x4_D", &M88::Quad_RotA_4x4_D },
        { "Quad_RotA_EachMini_2x2_A", &M88::Quad_RotA_EachMini_2x2_A },
        { "Quad_RotA_EachMini_2x2_B", &M88::Quad_RotA_EachMini_2x2_B },
        { "Quad_RotA_EachMini_2x2_C", &M88::Quad_RotA_EachMini_2x2_C },
        { "Quad_RotA_EachMini_2x2_D", &M88::Quad_RotA_EachMini_2x2_D },

        { "Quad_RotB_2x2_A", &M88::Quad_RotB_2x2_A },
        { "Quad_RotB_2x2_B", &M88::Quad_RotB_2x2_B },
        { "Quad_RotB_2x2_C", &M88::Quad_RotB_2x2_C },
        { "Quad_RotB_2x2_D", &M88::Quad_RotB_2x2_D },
        { "Quad_RotB_4x4_A", &M88::Quad_RotB_4x4_A },
        { "Quad_RotB_4x4_B", &M88::Quad_RotB_4x4_B },
        { "Quad_RotB_4x4_C", &M88::Quad_RotB_4x4_C },
        { "Quad_RotB_4x4_D", &M88::Quad_RotB_4x4_D },
        { "Quad_RotB_EachMini_2x2_A", &M88::Quad_RotB_EachMini_2x2_A },
        { "Quad_RotB_EachMini_2x2_B", &M88::Quad_RotB_EachMini_2x2_B },
        { "Quad_RotB_EachMini_2x2_C", &M88::Quad_RotB_EachMini_2x2_C },
        { "Quad_RotB_EachMini_2x2_D", &M88::Quad_RotB_EachMini_2x2_D },

        { "Quad_RotC_2x2_A", &M88::Quad_RotC_2x2_A },
        { "Quad_RotC_2x2_B", &M88::Quad_RotC_2x2_B },
        { "Quad_RotC_2x2_C", &M88::Quad_RotC_2x2_C },
        { "Quad_RotC_2x2_D", &M88::Quad_RotC_2x2_D },
        { "Quad_RotC_4x4_A", &M88::Quad_RotC_4x4_A },
        { "Quad_RotC_4x4_B", &M88::Quad_RotC_4x4_B },
        { "Quad_RotC_4x4_C", &M88::Quad_RotC_4x4_C },
        { "Quad_RotC_4x4_D", &M88::Quad_RotC_4x4_D },
        { "Quad_RotC_EachMini_2x2_A", &M88::Quad_RotC_EachMini_2x2_A },
        { "Quad_RotC_EachMini_2x2_B", &M88::Quad_RotC_EachMini_2x2_B },
        { "Quad_RotC_EachMini_2x2_C", &M88::Quad_RotC_EachMini_2x2_C },
        { "Quad_RotC_EachMini_2x2_D", &M88::Quad_RotC_EachMini_2x2_D },

        { "Quad_FlipA_2x2_A", &M88::Quad_FlipA_2x2_A },
        { "Quad_FlipA_2x2_B", &M88::Quad_FlipA_2x2_B },
        { "Quad_FlipA_2x2_C", &M88::Quad_FlipA_2x2_C },
        { "Quad_FlipA_2x2_D", &M88::Quad_FlipA_2x2_D },
        { "Quad_FlipA_4x4_A", &M88::Quad_FlipA_4x4_A },
        { "Quad_FlipA_4x4_B", &M88::Quad_FlipA_4x4_B },
        { "Quad_FlipA_4x4_C", &M88::Quad_FlipA_4x4_C },
        { "Quad_FlipA_4x4_D", &M88::Quad_FlipA_4x4_D },
        { "Quad_FlipA_EachMini_2x2_A", &M88::Quad_FlipA_EachMini_2x2_A },
        { "Quad_FlipA_EachMini_2x2_B", &M88::Quad_FlipA_EachMini_2x2_B },
        { "Quad_FlipA_EachMini_2x2_C", &M88::Quad_FlipA_EachMini_2x2_C },
        { "Quad_FlipA_EachMini_2x2_D", &M88::Quad_FlipA_EachMini_2x2_D },

        { "Quad_FlipB_2x2_A", &M88::Quad_FlipB_2x2_A },
        { "Quad_FlipB_2x2_B", &M88::Quad_FlipB_2x2_B },
        { "Quad_FlipB_2x2_C", &M88::Quad_FlipB_2x2_C },
        { "Quad_FlipB_2x2_D", &M88::Quad_FlipB_2x2_D },
        { "Quad_FlipB_4x4_A", &M88::Quad_FlipB_4x4_A },
        { "Quad_FlipB_4x4_B", &M88::Quad_FlipB_4x4_B },
        { "Quad_FlipB_4x4_C", &M88::Quad_FlipB_4x4_C },
        { "Quad_FlipB_4x4_D", &M88::Quad_FlipB_4x4_D },
        { "Quad_FlipB_EachMini_2x2_A", &M88::Quad_FlipB_EachMini_2x2_A },
        { "Quad_FlipB_EachMini_2x2_B", &M88::Quad_FlipB_EachMini_2x2_B },
        { "Quad_FlipB_EachMini_2x2_C", &M88::Quad_FlipB_EachMini_2x2_C },
        { "Quad_FlipB_EachMini_2x2_D", &M88::Quad_FlipB_EachMini_2x2_D },

        { "Quad_FlipC_2x2_A", &M88::Quad_FlipC_2x2_A },
        { "Quad_FlipC_2x2_B", &M88::Quad_FlipC_2x2_B },
        { "Quad_FlipC_2x2_C", &M88::Quad_FlipC_2x2_C },
        { "Quad_FlipC_2x2_D", &M88::Quad_FlipC_2x2_D },
        { "Quad_FlipC_4x4_A", &M88::Quad_FlipC_4x4_A },
        { "Quad_FlipC_4x4_B", &M88::Quad_FlipC_4x4_B },
        { "Quad_FlipC_4x4_C", &M88::Quad_FlipC_4x4_C },
        { "Quad_FlipC_4x4_D", &M88::Quad_FlipC_4x4_D },
        { "Quad_FlipC_EachMini_2x2_A", &M88::Quad_FlipC_EachMini_2x2_A },
        { "Quad_FlipC_EachMini_2x2_B", &M88::Quad_FlipC_EachMini_2x2_B },
        { "Quad_FlipC_EachMini_2x2_C", &M88::Quad_FlipC_EachMini_2x2_C },
        { "Quad_FlipC_EachMini_2x2_D", &M88::Quad_FlipC_EachMini_2x2_D },

        { "Quad_FlipD_2x2_A", &M88::Quad_FlipD_2x2_A },
        { "Quad_FlipD_2x2_B", &M88::Quad_FlipD_2x2_B },
        { "Quad_FlipD_2x2_C", &M88::Quad_FlipD_2x2_C },
        { "Quad_FlipD_2x2_D", &M88::Quad_FlipD_2x2_D },
        { "Quad_FlipD_4x4_A", &M88::Quad_FlipD_4x4_A },
        { "Quad_FlipD_4x4_B", &M88::Quad_FlipD_4x4_B },
        { "Quad_FlipD_4x4_C", &M88::Quad_FlipD_4x4_C },
        { "Quad_FlipD_4x4_D", &M88::Quad_FlipD_4x4_D },
        { "Quad_FlipD_EachMini_2x2_A", &M88::Quad_FlipD_EachMini_2x2_A },
        { "Quad_FlipD_EachMini_2x2_B", &M88::Quad_FlipD_EachMini_2x2_B },
        { "Quad_FlipD_EachMini_2x2_C", &M88::Quad_FlipD_EachMini_2x2_C },
        { "Quad_FlipD_EachMini_2x2_D", &M88::Quad_FlipD_EachMini_2x2_D },

        { "Quad_TriadA_2x2_A", &M88::Quad_TriadA_2x2_A },
        { "Quad_TriadA_2x2_B", &M88::Quad_TriadA_2x2_B },
        { "Quad_TriadA_2x2_C", &M88::Quad_TriadA_2x2_C },
        { "Quad_TriadA_2x2_D", &M88::Quad_TriadA_2x2_D },
        { "Quad_TriadA_EachMini_2x2_A", &M88::Quad_TriadA_EachMini_2x2_A },
        { "Quad_TriadA_EachMini_2x2_B", &M88::Quad_TriadA_EachMini_2x2_B },
        { "Quad_TriadA_EachMini_2x2_C", &M88::Quad_TriadA_EachMini_2x2_C },
        { "Quad_TriadA_EachMini_2x2_D", &M88::Quad_TriadA_EachMini_2x2_D },

        { "Quad_TriadB_2x2_A", &M88::Quad_TriadB_2x2_A },
        { "Quad_TriadB_2x2_B", &M88::Quad_TriadB_2x2_B },
        { "Quad_TriadB_2x2_C", &M88::Quad_TriadB_2x2_C },
        { "Quad_TriadB_2x2_D", &M88::Quad_TriadB_2x2_D },
        { "Quad_TriadB_EachMini_2x2_A", &M88::Quad_TriadB_EachMini_2x2_A },
        { "Quad_TriadB_EachMini_2x2_B", &M88::Quad_TriadB_EachMini_2x2_B },
        { "Quad_TriadB_EachMini_2x2_C", &M88::Quad_TriadB_EachMini_2x2_C },
        { "Quad_TriadB_EachMini_2x2_D", &M88::Quad_TriadB_EachMini_2x2_D },

        { "Quad_TriadC_2x2_A", &M88::Quad_TriadC_2x2_A },
        { "Quad_TriadC_2x2_B", &M88::Quad_TriadC_2x2_B },
        { "Quad_TriadC_2x2_C", &M88::Quad_TriadC_2x2_C },
        { "Quad_TriadC_2x2_D", &M88::Quad_TriadC_2x2_D },
        { "Quad_TriadC_EachMini_2x2_A", &M88::Quad_TriadC_EachMini_2x2_A },
        { "Quad_TriadC_EachMini_2x2_B", &M88::Quad_TriadC_EachMini_2x2_B },
        { "Quad_TriadC_EachMini_2x2_C", &M88::Quad_TriadC_EachMini_2x2_C },
        { "Quad_TriadC_EachMini_2x2_D", &M88::Quad_TriadC_EachMini_2x2_D },

        { "Quad_TriadD_2x2_A", &M88::Quad_TriadD_2x2_A },
        { "Quad_TriadD_2x2_B", &M88::Quad_TriadD_2x2_B },
        { "Quad_TriadD_2x2_C", &M88::Quad_TriadD_2x2_C },
        { "Quad_TriadD_2x2_D", &M88::Quad_TriadD_2x2_D },
        { "Quad_TriadD_EachMini_2x2_A", &M88::Quad_TriadD_EachMini_2x2_A },
        { "Quad_TriadD_EachMini_2x2_B", &M88::Quad_TriadD_EachMini_2x2_B },
        { "Quad_TriadD_EachMini_2x2_C", &M88::Quad_TriadD_EachMini_2x2_C },
        { "Quad_TriadD_EachMini_2x2_D", &M88::Quad_TriadD_EachMini_2x2_D },

        { "Quad_TriadE_2x2_A", &M88::Quad_TriadE_2x2_A },
        { "Quad_TriadE_2x2_B", &M88::Quad_TriadE_2x2_B },
        { "Quad_TriadE_2x2_C", &M88::Quad_TriadE_2x2_C },
        { "Quad_TriadE_2x2_D", &M88::Quad_TriadE_2x2_D },
        { "Quad_TriadE_EachMini_2x2_A", &M88::Quad_TriadE_EachMini_2x2_A },
        { "Quad_TriadE_EachMini_2x2_B", &M88::Quad_TriadE_EachMini_2x2_B },
        { "Quad_TriadE_EachMini_2x2_C", &M88::Quad_TriadE_EachMini_2x2_C },
        { "Quad_TriadE_EachMini_2x2_D", &M88::Quad_TriadE_EachMini_2x2_D },

        { "Quad_TriadF_2x2_A", &M88::Quad_TriadF_2x2_A },
        { "Quad_TriadF_2x2_B", &M88::Quad_TriadF_2x2_B },
        { "Quad_TriadF_2x2_C", &M88::Quad_TriadF_2x2_C },
        { "Quad_TriadF_2x2_D", &M88::Quad_TriadF_2x2_D },
        { "Quad_TriadF_EachMini_2x2_A", &M88::Quad_TriadF_EachMini_2x2_A },
        { "Quad_TriadF_EachMini_2x2_B", &M88::Quad_TriadF_EachMini_2x2_B },
        { "Quad_TriadF_EachMini_2x2_C", &M88::Quad_TriadF_EachMini_2x2_C },
        { "Quad_TriadF_EachMini_2x2_D", &M88::Quad_TriadF_EachMini_2x2_D },

        { "Quad_TriadG_2x2_A", &M88::Quad_TriadG_2x2_A },
        { "Quad_TriadG_2x2_B", &M88::Quad_TriadG_2x2_B },
        { "Quad_TriadG_2x2_C", &M88::Quad_TriadG_2x2_C },
        { "Quad_TriadG_2x2_D", &M88::Quad_TriadG_2x2_D },
        { "Quad_TriadG_EachMini_2x2_A", &M88::Quad_TriadG_EachMini_2x2_A },
        { "Quad_TriadG_EachMini_2x2_B", &M88::Quad_TriadG_EachMini_2x2_B },
        { "Quad_TriadG_EachMini_2x2_C", &M88::Quad_TriadG_EachMini_2x2_C },
        { "Quad_TriadG_EachMini_2x2_D", &M88::Quad_TriadG_EachMini_2x2_D },

        { "Quad_TriadH_2x2_A", &M88::Quad_TriadH_2x2_A },
        { "Quad_TriadH_2x2_B", &M88::Quad_TriadH_2x2_B },
        { "Quad_TriadH_2x2_C", &M88::Quad_TriadH_2x2_C },
        { "Quad_TriadH_2x2_D", &M88::Quad_TriadH_2x2_D },
        { "Quad_TriadH_EachMini_2x2_A", &M88::Quad_TriadH_EachMini_2x2_A },
        { "Quad_TriadH_EachMini_2x2_B", &M88::Quad_TriadH_EachMini_2x2_B },
        { "Quad_TriadH_EachMini_2x2_C", &M88::Quad_TriadH_EachMini_2x2_C },
        { "Quad_TriadH_EachMini_2x2_D", &M88::Quad_TriadH_EachMini_2x2_D },

        { "Quad_SnakeA_2x2_A", &M88::Quad_SnakeA_2x2_A },
        { "Quad_SnakeA_2x2_B", &M88::Quad_SnakeA_2x2_B },
        { "Quad_SnakeA_2x2_C", &M88::Quad_SnakeA_2x2_C },
        { "Quad_SnakeA_2x2_D", &M88::Quad_SnakeA_2x2_D },
        { "Quad_SnakeA_EachMini_2x2_A", &M88::Quad_SnakeA_EachMini_2x2_A },
        { "Quad_SnakeA_EachMini_2x2_B", &M88::Quad_SnakeA_EachMini_2x2_B },
        { "Quad_SnakeA_EachMini_2x2_C", &M88::Quad_SnakeA_EachMini_2x2_C },
        { "Quad_SnakeA_EachMini_2x2_D", &M88::Quad_SnakeA_EachMini_2x2_D },

        { "Quad_SnakeB_2x2_A", &M88::Quad_SnakeB_2x2_A },
        { "Quad_SnakeB_2x2_B", &M88::Quad_SnakeB_2x2_B },
        { "Quad_SnakeB_2x2_C", &M88::Quad_SnakeB_2x2_C },
        { "Quad_SnakeB_2x2_D", &M88::Quad_SnakeB_2x2_D },
        { "Quad_SnakeB_EachMini_2x2_A", &M88::Quad_SnakeB_EachMini_2x2_A },
        { "Quad_SnakeB_EachMini_2x2_B", &M88::Quad_SnakeB_EachMini_2x2_B },
        { "Quad_SnakeB_EachMini_2x2_C", &M88::Quad_SnakeB_EachMini_2x2_C },
        { "Quad_SnakeB_EachMini_2x2_D", &M88::Quad_SnakeB_EachMini_2x2_D },

        { "Quad_SnakeC_2x2_A", &M88::Quad_SnakeC_2x2_A },
        { "Quad_SnakeC_2x2_B", &M88::Quad_SnakeC_2x2_B },
        { "Quad_SnakeC_2x2_C", &M88::Quad_SnakeC_2x2_C },
        { "Quad_SnakeC_2x2_D", &M88::Quad_SnakeC_2x2_D },
        { "Quad_SnakeC_EachMini_2x2_A", &M88::Quad_SnakeC_EachMini_2x2_A },
        { "Quad_SnakeC_EachMini_2x2_B", &M88::Quad_SnakeC_EachMini_2x2_B },
        { "Quad_SnakeC_EachMini_2x2_C", &M88::Quad_SnakeC_EachMini_2x2_C },
        { "Quad_SnakeC_EachMini_2x2_D", &M88::Quad_SnakeC_EachMini_2x2_D },

        { "Quad_SnakeD_2x2_A", &M88::Quad_SnakeD_2x2_A },
        { "Quad_SnakeD_2x2_B", &M88::Quad_SnakeD_2x2_B },
        { "Quad_SnakeD_2x2_C", &M88::Quad_SnakeD_2x2_C },
        { "Quad_SnakeD_2x2_D", &M88::Quad_SnakeD_2x2_D },
        { "Quad_SnakeD_EachMini_2x2_A", &M88::Quad_SnakeD_EachMini_2x2_A },
        { "Quad_SnakeD_EachMini_2x2_B", &M88::Quad_SnakeD_EachMini_2x2_B },
        { "Quad_SnakeD_EachMini_2x2_C", &M88::Quad_SnakeD_EachMini_2x2_C },
        { "Quad_SnakeD_EachMini_2x2_D", &M88::Quad_SnakeD_EachMini_2x2_D },


        { "Quad_TowerA_4x4_A", &M88::Quad_TowerA_4x4_A },
        { "Quad_TowerA_4x4_B", &M88::Quad_TowerA_4x4_B },
        { "Quad_TowerA_4x4_C", &M88::Quad_TowerA_4x4_C },
        { "Quad_TowerA_4x4_D", &M88::Quad_TowerA_4x4_D },

        { "Quad_TowerB_4x4_A", &M88::Quad_TowerB_4x4_A },
        { "Quad_TowerB_4x4_B", &M88::Quad_TowerB_4x4_B },
        { "Quad_TowerB_4x4_C", &M88::Quad_TowerB_4x4_C },
        { "Quad_TowerB_4x4_D", &M88::Quad_TowerB_4x4_D },


        { "Quad_SwapA_2x2_A", &M88::Quad_SwapA_2x2_A },
        { "Quad_SwapA_2x2_B", &M88::Quad_SwapA_2x2_B },
        { "Quad_SwapA_2x2_C", &M88::Quad_SwapA_2x2_C },
        { "Quad_SwapA_2x2_D", &M88::Quad_SwapA_2x2_D },
        { "Quad_SwapA_EachMini_2x2_A", &M88::Quad_SwapA_EachMini_2x2_A },
        { "Quad_SwapA_EachMini_2x2_B", &M88::Quad_SwapA_EachMini_2x2_B },
        { "Quad_SwapA_EachMini_2x2_C", &M88::Quad_SwapA_EachMini_2x2_C },
        { "Quad_SwapA_EachMini_2x2_D", &M88::Quad_SwapA_EachMini_2x2_D },

        { "Quad_SwapB_2x2_A", &M88::Quad_SwapB_2x2_A },
        { "Quad_SwapB_2x2_B", &M88::Quad_SwapB_2x2_B },
        { "Quad_SwapB_2x2_C", &M88::Quad_SwapB_2x2_C },
        { "Quad_SwapB_2x2_D", &M88::Quad_SwapB_2x2_D },
        { "Quad_SwapB_EachMini_2x2_A", &M88::Quad_SwapB_EachMini_2x2_A },
        { "Quad_SwapB_EachMini_2x2_B", &M88::Quad_SwapB_EachMini_2x2_B },
        { "Quad_SwapB_EachMini_2x2_C", &M88::Quad_SwapB_EachMini_2x2_C },
        { "Quad_SwapB_EachMini_2x2_D", &M88::Quad_SwapB_EachMini_2x2_D },

        { "Quad_SwapC_2x2_A", &M88::Quad_SwapC_2x2_A },
        { "Quad_SwapC_2x2_B", &M88::Quad_SwapC_2x2_B },
        { "Quad_SwapC_2x2_C", &M88::Quad_SwapC_2x2_C },
        { "Quad_SwapC_2x2_D", &M88::Quad_SwapC_2x2_D },
        { "Quad_SwapC_EachMini_2x2_A", &M88::Quad_SwapC_EachMini_2x2_A },
        { "Quad_SwapC_EachMini_2x2_B", &M88::Quad_SwapC_EachMini_2x2_B },
        { "Quad_SwapC_EachMini_2x2_C", &M88::Quad_SwapC_EachMini_2x2_C },
        { "Quad_SwapC_EachMini_2x2_D", &M88::Quad_SwapC_EachMini_2x2_D },

        { "Quad_SwapD_2x2_A", &M88::Quad_SwapD_2x2_A },
        { "Quad_SwapD_2x2_B", &M88::Quad_SwapD_2x2_B },
        { "Quad_SwapD_2x2_C", &M88::Quad_SwapD_2x2_C },
        { "Quad_SwapD_2x2_D", &M88::Quad_SwapD_2x2_D },
        { "Quad_SwapD_EachMini_2x2_A", &M88::Quad_SwapD_EachMini_2x2_A },
        { "Quad_SwapD_EachMini_2x2_B", &M88::Quad_SwapD_EachMini_2x2_B },
        { "Quad_SwapD_EachMini_2x2_C", &M88::Quad_SwapD_EachMini_2x2_C },
        { "Quad_SwapD_EachMini_2x2_D", &M88::Quad_SwapD_EachMini_2x2_D },
        
        { "Quad_ShearA_4x4_A", &M88::Quad_ShearA_4x4_A },
        { "Quad_ShearA_4x4_B", &M88::Quad_ShearA_4x4_B },
        { "Quad_ShearA_4x4_C", &M88::Quad_ShearA_4x4_C },
        { "Quad_ShearA_4x4_D", &M88::Quad_ShearA_4x4_D },

        { "Quad_ShearB_4x4_A", &M88::Quad_ShearB_4x4_A },
        { "Quad_ShearB_4x4_B", &M88::Quad_ShearB_4x4_B },
        { "Quad_ShearB_4x4_C", &M88::Quad_ShearB_4x4_C },
        { "Quad_ShearB_4x4_D", &M88::Quad_ShearB_4x4_D },

        { "Quad_ShearC_4x4_A", &M88::Quad_ShearC_4x4_A },
        { "Quad_ShearC_4x4_B", &M88::Quad_ShearC_4x4_B },
        { "Quad_ShearC_4x4_C", &M88::Quad_ShearC_4x4_C },
        { "Quad_ShearC_4x4_D", &M88::Quad_ShearC_4x4_D },

        { "Quad_ShearD_4x4_A", &M88::Quad_ShearD_4x4_A },
        { "Quad_ShearD_4x4_B", &M88::Quad_ShearD_4x4_B },
        { "Quad_ShearD_4x4_C", &M88::Quad_ShearD_4x4_C },
        { "Quad_ShearD_4x4_D", &M88::Quad_ShearD_4x4_D },
        
    };
}

- (void)testNoDuplicateTransformOutputs {
    const std::vector<TransformEntry> aTransforms = BuildTransformList();

    std::map<std::string, std::string> aSeen;
    std::vector<std::string> aDuplicates;

    for (const TransformEntry &aEntry : aTransforms) {
        M88 aMatrix = VerifyFull::SpawnTestMatrixFull();

        (aMatrix.*aEntry.mFunction)();

        const std::array<std::uint8_t, 64> aData = CaptureData(aMatrix);
        const std::string aKey = MatrixKey(aData);

        auto aIt = aSeen.find(aKey);
        if (aIt != aSeen.end()) {
            const std::string aMessage =
                std::string(aEntry.mName) +
                " duplicates " +
                aIt->second;

            aDuplicates.push_back(aMessage);

            Logging::Log("Duplicate transform output", aMatrix);
            NSLog(@"Duplicate transform output: %s", aMessage.c_str());
        } else {
            aSeen[aKey] = aEntry.mName;
        }
    }

    if (!aDuplicates.empty()) {
        NSMutableString *aFailure = [NSMutableString string];

        [aFailure appendFormat:@"Found %lu duplicate transform output(s):\n",
                               static_cast<unsigned long>(aDuplicates.size())];

        for (const std::string &aDuplicate : aDuplicates) {
            [aFailure appendFormat:@"%s\n", aDuplicate.c_str()];
        }

        XCTFail(@"%@", aFailure);
    }
}

@end
