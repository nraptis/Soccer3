//
//  M88.hpp
//  CyberMatrix
//
//  Created by Icarus Black on on 5/29/26.
//

#ifndef M88_hpp
#define M88_hpp

#include <cstdint>
#include <cstddef>
#include <vector>
#include <string>
#include <cstring>

class M88 {
public:
    
    static std::size_t                          Slot(std::size_t pX, std::size_t pY);
    static std::size_t                          X(std::size_t pSlot);
    static std::size_t                          Y(std::size_t pSlot);
    
    static constexpr std::size_t                kOperationByteCount = 48U;
    static constexpr std::size_t                kOperationBytesUsed = 48U;
    static_assert(kOperationBytesUsed <= kOperationByteCount);

    M88();
    
    void                                        Reset();
    

    std::uint8_t                                mData[64];

    // Dispatch consumes one kOperationByteCount-sized operation record.
    
    void                                        Dispatch(std::uint8_t *pOperationData,
                                                         std::size_t pOperationIndex,
                                                         std::uint8_t *pSource,
                                                         std::size_t pSourceIndex,
                                                         std::uint8_t *pDestination,
                                                         std::uint8_t pUnrollDomainWord,
                                                         std::uint8_t pArgADomainWord,
                                                         std::uint8_t pArgBDomainWord,
                                                         std::uint8_t pArgCDomainWord,
                                                         std::uint8_t pArgDDomainWord);
    
    /*
    void                                        Dispatch(std::uint8_t *pOperationData,
                                                         std::size_t pOperationIndex,
                                                         std::uint8_t *pSource,
                                                         std::size_t pSourceIndex,
                                                         std::uint8_t *pDestination);
    */
    
    void                                        DispatchUnroll(std::uint8_t *pDestination,
                                                                std::uint8_t pByteSwapsA,
                                                                std::uint8_t pByteSwapsB,
                                                                std::uint8_t pByteSwapsC,
                                                                std::uint8_t pByteSwapsD,
                                                                
                                                                std::uint8_t pByteSwapsE,
                                                                std::uint8_t pByteSwapsF,
                                                                std::uint8_t pByteSwapsG,
                                                                std::uint8_t pByteSwapsH);


    // ============================================================
    // Byte Dispatch
    // ============================================================
    void                                        DispatchMini(std::uint8_t pByte);
    void                                        DispatchQuadA(std::uint8_t pByte);
    void                                        DispatchQuadB(std::uint8_t pByte);
    void                                        DispatchQuadC(std::uint8_t pByte);
    void                                        DispatchQuadD(std::uint8_t pByte);
    void                                        DispatchFullA(std::uint8_t pByte);
    void                                        DispatchFullB(std::uint8_t pByte);
    
    void                                        DispatchSwapsA(std::uint8_t pByteA, std::uint8_t pByteB);
    void                                        DispatchSwapsB(std::uint8_t pByte);
    
    void                                        DispatchPermute(std::uint8_t pByteSelect_QuadA_A,
                                                                 std::uint8_t pByteSelect_QuadA_B,
                                                                 std::uint8_t pByteSelect_QuadB_A,
                                                                 std::uint8_t pByteSelect_QuadB_B,
                                                                 std::uint8_t pByteSelect_QuadC_A,
                                                                 std::uint8_t pByteSelect_QuadC_B,
                                                                 std::uint8_t pByteSelect_QuadD_A,
                                                                 std::uint8_t pByteSelect_QuadD_B,
                                                                 
                                                                 std::uint8_t pByteSwapsA,
                                                                 std::uint8_t pByteSwapsB,
                                                                 std::uint8_t pByteSwapsC,
                                                                 std::uint8_t pByteSwapsD,
                                                                 std::uint8_t pByteSwapsE,
                                                                 std::uint8_t pByteSwapsF,
                                                                 std::uint8_t pByteSwapsG,
                                                                 std::uint8_t pByteSwapsH,
                                                                 
                                                                 std::uint8_t pByteAmount);
    
    std::uint8_t                                mPermute[16];
    std::uint8_t                                mPermuteTemp[16];
    std::uint8_t                                mPermuteData[16];
    
    void                                        SwapRows(std::uint8_t pRowA, std::uint8_t pRowB);
    void                                        SwapColumns(std::uint8_t pColA, std::uint8_t pColB);
    void                                        SwapMinis(std::uint8_t pBlockA, std::uint8_t pBlockB);
    

    // ============================================================
    // Full Ops (512)
    // ============================================================


    void                                        Full_RotA_8x8();
    void                                        Full_RotA_EachMini_2x2();
    void                                        Full_RotA_EachQuad_2x2();
    void                                        Full_RotA_EachQuad_4x4();


    void                                        Full_RotB_8x8();
    void                                        Full_RotB_EachMini_2x2();
    void                                        Full_RotB_EachQuad_2x2();
    void                                        Full_RotB_EachQuad_4x4();


    void                                        Full_RotC_8x8();
    void                                        Full_RotC_EachMini_2x2();
    void                                        Full_RotC_EachQuad_2x2();
    void                                        Full_RotC_EachQuad_4x4();


    void                                        Full_FlipA_8x8();
    void                                        Full_FlipA_EachMini_2x2();
    void                                        Full_FlipA_EachQuad_2x2();
    void                                        Full_FlipA_EachQuad_4x4();


    void                                        Full_FlipB_8x8();
    void                                        Full_FlipB_EachMini_2x2();
    void                                        Full_FlipB_EachQuad_2x2();
    void                                        Full_FlipB_EachQuad_4x4();


    void                                        Full_FlipC_8x8();
    void                                        Full_FlipC_EachMini_2x2();
    void                                        Full_FlipC_EachQuad_2x2();
    void                                        Full_FlipC_EachQuad_4x4();


    void                                        Full_FlipD_8x8();
    void                                        Full_FlipD_EachMini_2x2();
    void                                        Full_FlipD_EachQuad_2x2();
    void                                        Full_FlipD_EachQuad_4x4();

    void                                        Full_TriadA_EachMini_2x2();
    void                                        Full_TriadA_EachQuad_2x2();

    void                                        Full_TriadB_EachMini_2x2();
    void                                        Full_TriadB_EachQuad_2x2();

    void                                        Full_TriadC_EachMini_2x2();
    void                                        Full_TriadC_EachQuad_2x2();

    void                                        Full_TriadD_EachMini_2x2();
    void                                        Full_TriadD_EachQuad_2x2();

    void                                        Full_TriadE_EachMini_2x2();
    void                                        Full_TriadE_EachQuad_2x2();

    void                                        Full_TriadF_EachMini_2x2();
    void                                        Full_TriadF_EachQuad_2x2();

    void                                        Full_TriadG_EachMini_2x2();
    void                                        Full_TriadG_EachQuad_2x2();

    void                                        Full_TriadH_EachMini_2x2();
    void                                        Full_TriadH_EachQuad_2x2();

    void                                        Full_SnakeA_EachMini_2x2();
    void                                        Full_SnakeA_EachQuad_2x2();

    void                                        Full_SnakeB_EachMini_2x2();
    void                                        Full_SnakeB_EachQuad_2x2();

    void                                        Full_SnakeC_EachMini_2x2();
    void                                        Full_SnakeC_EachQuad_2x2();

    void                                        Full_SnakeD_EachMini_2x2();
    void                                        Full_SnakeD_EachQuad_2x2();

    void                                        Full_TowerA_EachQuad_4x4();

    void                                        Full_TowerB_EachQuad_4x4();
    void                                        Full_PinA_8x8();
    void                                        Full_PinB_8x8();

    void                                        Full_SwapA_EachMini_2x2();
    void                                        Full_SwapA_EachQuad_2x2();

    void                                        Full_SwapB_EachMini_2x2();
    void                                        Full_SwapB_EachQuad_2x2();

    void                                        Full_SwapC_EachMini_2x2();
    void                                        Full_SwapC_EachQuad_2x2();

    void                                        Full_SwapD_EachMini_2x2();
    void                                        Full_SwapD_EachQuad_2x2();

    void                                        Full_ShearA_8x8();
    void                                        Full_ShearA_EachQuad_4x4();

    void                                        Full_ShearB_8x8();
    void                                        Full_ShearB_EachQuad_4x4();

    void                                        Full_ShearC_8x8();
    void                                        Full_ShearC_EachQuad_4x4();

    void                                        Full_ShearD_8x8();
    void                                        Full_ShearD_EachQuad_4x4();
    void                                        Full_JewelA_8x8();
    void                                        Full_JewelA_4x4();
    void                                        Full_JewelA_EachQuad_4x4();
    void                                        Full_JewelB_8x8();
    void                                        Full_JewelB_4x4();
    void                                        Full_JewelB_EachQuad_4x4();
    void                                        Full_JewelC_8x8();
    void                                        Full_JewelC_4x4();
    void                                        Full_JewelC_EachQuad_4x4();
    void                                        Full_JewelD_8x8();
    void                                        Full_JewelD_4x4();
    void                                        Full_JewelD_EachQuad_4x4();
    void                                        Full_CrystalA_8x8();
    void                                        Full_CrystalA_4x4();
    void                                        Full_CrystalA_EachQuad_4x4();
    void                                        Full_CrystalC_8x8();
    void                                        Full_CrystalC_4x4();
    void                                        Full_CrystalC_EachQuad_4x4();
    void                                        Full_CrystalB_8x8();
    void                                        Full_CrystalB_4x4();
    void                                        Full_CrystalB_EachQuad_4x4();
    void                                        Full_CrystalD_8x8();
    void                                        Full_CrystalD_4x4();
    void                                        Full_CrystalD_EachQuad_4x4();
    void                                        Full_OpalA_8x8();
    void                                        Full_OpalA_4x4();
    void                                        Full_OpalA_EachQuad_4x4();
    void                                        Full_OpalC_8x8();
    void                                        Full_OpalC_4x4();
    void                                        Full_OpalC_EachQuad_4x4();
    void                                        Full_OpalB_8x8();
    void                                        Full_OpalB_4x4();
    void                                        Full_OpalB_EachQuad_4x4();
    void                                        Full_OpalD_8x8();
    void                                        Full_OpalD_4x4();
    void                                        Full_OpalD_EachQuad_4x4();
    void                                        Full_PeridotA_8x8();
    void                                        Full_PeridotA_4x4();
    void                                        Full_PeridotA_EachQuad_4x4();
    void                                        Full_PeridotB_8x8();
    void                                        Full_PeridotB_4x4();
    void                                        Full_PeridotB_EachQuad_4x4();
    void                                        Full_PeridotC_8x8();
    void                                        Full_PeridotC_4x4();
    void                                        Full_PeridotC_EachQuad_4x4();
    void                                        Full_PeridotD_8x8();
    void                                        Full_PeridotD_4x4();
    void                                        Full_PeridotD_EachQuad_4x4();

    void                                        Full_SwanA_EachQuad_4x4();

    void                                        Full_SwanB_EachQuad_4x4();

    void                                        Full_SwanC_EachQuad_4x4();

    void                                        Full_SwanD_EachQuad_4x4();

    void                                        Full_GooseA_EachQuad_4x4();

    void                                        Full_GooseB_EachQuad_4x4();

    void                                        Full_GooseC_EachQuad_4x4();

    void                                        Full_GooseD_EachQuad_4x4();
    void                                        Full_SwanA_8x8();
    void                                        Full_SwanB_8x8();
    void                                        Full_SwanC_8x8();
    void                                        Full_SwanD_8x8();
    void                                        Full_GooseA_8x8();
    void                                        Full_GooseB_8x8();
    void                                        Full_GooseC_8x8();
    void                                        Full_GooseD_8x8();

    void                                        Full_IronA_EachQuad_4x4();

    void                                        Full_IronB_EachQuad_4x4();

    void                                        Full_IronC_EachQuad_4x4();

    void                                        Full_IronD_EachQuad_4x4();

    void                                        Full_SteelA_EachQuad_4x4();

    void                                        Full_SteelB_EachQuad_4x4();

    void                                        Full_SteelC_EachQuad_4x4();

    void                                        Full_SteelD_EachQuad_4x4();

    void                                        Full_SilverA_EachQuad_4x4();

    void                                        Full_SilverB_EachQuad_4x4();

    void                                        Full_SilverC_EachQuad_4x4();

    void                                        Full_SilverD_EachQuad_4x4();

    void                                        Full_GoldA_EachQuad_4x4();

    void                                        Full_GoldB_EachQuad_4x4();

    void                                        Full_GoldC_EachQuad_4x4();

    void                                        Full_GoldD_EachQuad_4x4();

    void                                        Full_BronzeA_EachQuad_4x4();

    void                                        Full_BronzeB_EachQuad_4x4();

    void                                        Full_BronzeC_EachQuad_4x4();

    void                                        Full_BronzeD_EachQuad_4x4();

    void                                        Full_BrassA_EachQuad_4x4();

    void                                        Full_BrassB_EachQuad_4x4();

    void                                        Full_BrassC_EachQuad_4x4();

    void                                        Full_BrassD_EachQuad_4x4();

    void                                        Full_NickelA_EachQuad_4x4();

    void                                        Full_NickelB_EachQuad_4x4();

    void                                        Full_NickelC_EachQuad_4x4();

    void                                        Full_NickelD_EachQuad_4x4();

    void                                        Full_CobaltA_EachQuad_4x4();

    void                                        Full_CobaltB_EachQuad_4x4();

    void                                        Full_CobaltC_EachQuad_4x4();

    void                                        Full_CobaltD_EachQuad_4x4();

    void                                        Full_PlatinumA_EachQuad_4x4();

    void                                        Full_PlatinumB_EachQuad_4x4();

    void                                        Full_PlatinumC_EachQuad_4x4();

    void                                        Full_PlatinumD_EachQuad_4x4();

    void                                        Full_PalladiumA_EachQuad_4x4();

    void                                        Full_PalladiumB_EachQuad_4x4();

    void                                        Full_PalladiumC_EachQuad_4x4();

    void                                        Full_PalladiumD_EachQuad_4x4();

    void                                        Full_ChromiumA_EachQuad_4x4();

    void                                        Full_ChromiumB_EachQuad_4x4();

    void                                        Full_ChromiumC_EachQuad_4x4();

    void                                        Full_ChromiumD_EachQuad_4x4();

    void                                        Full_ZirconiumA_EachQuad_4x4();

    void                                        Full_ZirconiumB_EachQuad_4x4();

    void                                        Full_ZirconiumC_EachQuad_4x4();

    void                                        Full_ZirconiumD_EachQuad_4x4();
    void                                        Full_IronA_8x8();
    void                                        Full_IronB_8x8();
    void                                        Full_IronC_8x8();
    void                                        Full_IronD_8x8();
    void                                        Full_SteelA_8x8();
    void                                        Full_SteelB_8x8();
    void                                        Full_SteelC_8x8();
    void                                        Full_SteelD_8x8();
    void                                        Full_SilverA_8x8();
    void                                        Full_SilverB_8x8();
    void                                        Full_SilverC_8x8();
    void                                        Full_SilverD_8x8();
    void                                        Full_GoldA_8x8();
    void                                        Full_GoldB_8x8();
    void                                        Full_GoldC_8x8();
    void                                        Full_GoldD_8x8();
    void                                        Full_BronzeA_8x8();
    void                                        Full_BronzeB_8x8();
    void                                        Full_BronzeC_8x8();
    void                                        Full_BronzeD_8x8();
    void                                        Full_BrassA_8x8();
    void                                        Full_BrassB_8x8();
    void                                        Full_BrassC_8x8();
    void                                        Full_BrassD_8x8();
    void                                        Full_NickelA_8x8();
    void                                        Full_NickelB_8x8();
    void                                        Full_NickelC_8x8();
    void                                        Full_NickelD_8x8();
    void                                        Full_CobaltA_8x8();
    void                                        Full_CobaltB_8x8();
    void                                        Full_CobaltC_8x8();
    void                                        Full_CobaltD_8x8();
    void                                        Full_PlatinumA_8x8();
    void                                        Full_PlatinumB_8x8();
    void                                        Full_PlatinumC_8x8();
    void                                        Full_PlatinumD_8x8();
    void                                        Full_PalladiumA_8x8();
    void                                        Full_PalladiumB_8x8();
    void                                        Full_PalladiumC_8x8();
    void                                        Full_PalladiumD_8x8();
    void                                        Full_ChromiumA_8x8();
    void                                        Full_ChromiumB_8x8();
    void                                        Full_ChromiumC_8x8();
    void                                        Full_ChromiumD_8x8();
    void                                        Full_ZirconiumA_8x8();
    void                                        Full_ZirconiumB_8x8();
    void                                        Full_ZirconiumC_8x8();
    void                                        Full_ZirconiumD_8x8();

    void                                        Full_HydrogenA_EachQuad_4x4();

    void                                        Full_HydrogenB_EachQuad_4x4();

    void                                        Full_HydrogenC_EachQuad_4x4();

    void                                        Full_HydrogenD_EachQuad_4x4();

    void                                        Full_HeliumA_EachQuad_4x4();

    void                                        Full_HeliumB_EachQuad_4x4();

    void                                        Full_HeliumC_EachQuad_4x4();

    void                                        Full_HeliumD_EachQuad_4x4();

    void                                        Full_NeonA_EachQuad_4x4();

    void                                        Full_NeonB_EachQuad_4x4();

    void                                        Full_NeonC_EachQuad_4x4();

    void                                        Full_NeonD_EachQuad_4x4();

    void                                        Full_ArgonA_EachQuad_4x4();

    void                                        Full_ArgonB_EachQuad_4x4();

    void                                        Full_ArgonC_EachQuad_4x4();

    void                                        Full_ArgonD_EachQuad_4x4();

    void                                        Full_KryptonA_EachQuad_4x4();

    void                                        Full_KryptonB_EachQuad_4x4();

    void                                        Full_KryptonC_EachQuad_4x4();

    void                                        Full_KryptonD_EachQuad_4x4();

    void                                        Full_XenonA_EachQuad_4x4();

    void                                        Full_XenonB_EachQuad_4x4();

    void                                        Full_XenonC_EachQuad_4x4();

    void                                        Full_XenonD_EachQuad_4x4();
    void                                        Full_HydrogenA_8x8();
    void                                        Full_HydrogenB_8x8();
    void                                        Full_HydrogenC_8x8();
    void                                        Full_HydrogenD_8x8();
    void                                        Full_HeliumA_8x8();
    void                                        Full_HeliumB_8x8();
    void                                        Full_HeliumC_8x8();
    void                                        Full_HeliumD_8x8();
    void                                        Full_NeonA_8x8();
    void                                        Full_NeonB_8x8();
    void                                        Full_NeonC_8x8();
    void                                        Full_NeonD_8x8();
    void                                        Full_ArgonA_8x8();
    void                                        Full_ArgonB_8x8();
    void                                        Full_ArgonC_8x8();
    void                                        Full_ArgonD_8x8();
    void                                        Full_KryptonA_8x8();
    void                                        Full_KryptonB_8x8();
    void                                        Full_KryptonC_8x8();
    void                                        Full_KryptonD_8x8();
    void                                        Full_XenonA_8x8();
    void                                        Full_XenonB_8x8();
    void                                        Full_XenonC_8x8();
    void                                        Full_XenonD_8x8();
    void                                        Full_MapleA_4x4();
    void                                        Full_MapleA_EachQuad_4x4();
    void                                        Full_MapleB_4x4();
    void                                        Full_MapleB_EachQuad_4x4();
    void                                        Full_MapleC_4x4();
    void                                        Full_MapleC_EachQuad_4x4();
    void                                        Full_MapleD_4x4();
    void                                        Full_MapleD_EachQuad_4x4();
    void                                        Full_WillowA_4x4();
    void                                        Full_WillowA_EachQuad_4x4();
    void                                        Full_WillowB_4x4();
    void                                        Full_WillowB_EachQuad_4x4();
    void                                        Full_WillowC_4x4();
    void                                        Full_WillowC_EachQuad_4x4();
    void                                        Full_WillowD_4x4();
    void                                        Full_WillowD_EachQuad_4x4();
    void                                        Full_CedarA_4x4();
    void                                        Full_CedarA_EachQuad_4x4();
    void                                        Full_CedarB_4x4();
    void                                        Full_CedarB_EachQuad_4x4();
    void                                        Full_CedarC_4x4();
    void                                        Full_CedarC_EachQuad_4x4();
    void                                        Full_CedarD_4x4();
    void                                        Full_CedarD_EachQuad_4x4();
    void                                        Full_HickoryA_4x4();
    void                                        Full_HickoryA_EachQuad_4x4();
    void                                        Full_HickoryB_4x4();
    void                                        Full_HickoryB_EachQuad_4x4();
    void                                        Full_HickoryC_4x4();
    void                                        Full_HickoryC_EachQuad_4x4();
    void                                        Full_HickoryD_4x4();
    void                                        Full_HickoryD_EachQuad_4x4();
    void                                        Full_JuniperA_4x4();
    void                                        Full_JuniperA_EachQuad_4x4();
    void                                        Full_JuniperB_4x4();
    void                                        Full_JuniperB_EachQuad_4x4();
    void                                        Full_JuniperC_4x4();
    void                                        Full_JuniperC_EachQuad_4x4();
    void                                        Full_JuniperD_4x4();
    void                                        Full_JuniperD_EachQuad_4x4();
    void                                        Full_MapleA_8x8();
    void                                        Full_MapleB_8x8();
    void                                        Full_MapleC_8x8();
    void                                        Full_MapleD_8x8();
    void                                        Full_WillowA_8x8();
    void                                        Full_WillowB_8x8();
    void                                        Full_WillowC_8x8();
    void                                        Full_WillowD_8x8();
    void                                        Full_CedarA_8x8();
    void                                        Full_CedarB_8x8();
    void                                        Full_CedarC_8x8();
    void                                        Full_CedarD_8x8();
    void                                        Full_HickoryA_8x8();
    void                                        Full_HickoryB_8x8();
    void                                        Full_HickoryC_8x8();
    void                                        Full_HickoryD_8x8();
    void                                        Full_JuniperA_8x8();
    void                                        Full_JuniperB_8x8();
    void                                        Full_JuniperC_8x8();
    void                                        Full_JuniperD_8x8();

    void                                        Full_YorkA_EachQuad_4x4();

    void                                        Full_YorkB_EachQuad_4x4();

    void                                        Full_YorkC_EachQuad_4x4();

    void                                        Full_YorkD_EachQuad_4x4();

    void                                        Full_EssexA_EachQuad_4x4();

    void                                        Full_EssexB_EachQuad_4x4();

    void                                        Full_EssexC_EachQuad_4x4();

    void                                        Full_EssexD_EachQuad_4x4();
    void                                        Full_WessexA_4x4();
    void                                        Full_WessexA_EachQuad_4x4();
    void                                        Full_WessexB_4x4();
    void                                        Full_WessexB_EachQuad_4x4();
    void                                        Full_WessexC_4x4();
    void                                        Full_WessexC_EachQuad_4x4();
    void                                        Full_WessexD_4x4();
    void                                        Full_WessexD_EachQuad_4x4();

    void                                        Full_MerciaA_EachQuad_4x4();

    void                                        Full_MerciaB_EachQuad_4x4();

    void                                        Full_MerciaC_EachQuad_4x4();

    void                                        Full_MerciaD_EachQuad_4x4();

    void                                        Full_SussexA_EachQuad_4x4();

    void                                        Full_SussexB_EachQuad_4x4();

    void                                        Full_SussexC_EachQuad_4x4();

    void                                        Full_SussexD_EachQuad_4x4();

    void                                        Full_UmbriaA_EachQuad_4x4();

    void                                        Full_UmbriaB_EachQuad_4x4();

    void                                        Full_UmbriaC_EachQuad_4x4();

    void                                        Full_UmbriaD_EachQuad_4x4();
    void                                        Full_YorkA_8x8();
    void                                        Full_YorkB_8x8();
    void                                        Full_YorkC_8x8();
    void                                        Full_YorkD_8x8();
    void                                        Full_EssexA_8x8();
    void                                        Full_EssexB_8x8();
    void                                        Full_EssexC_8x8();
    void                                        Full_EssexD_8x8();
    void                                        Full_WessexA_8x8();
    void                                        Full_WessexB_8x8();
    void                                        Full_WessexC_8x8();
    void                                        Full_WessexD_8x8();
    void                                        Full_MerciaA_8x8();
    void                                        Full_MerciaB_8x8();
    void                                        Full_MerciaC_8x8();
    void                                        Full_MerciaD_8x8();
    void                                        Full_SussexA_8x8();
    void                                        Full_SussexB_8x8();
    void                                        Full_SussexC_8x8();
    void                                        Full_SussexD_8x8();
    void                                        Full_UmbriaA_8x8();
    void                                        Full_UmbriaB_8x8();
    void                                        Full_UmbriaC_8x8();
    void                                        Full_UmbriaD_8x8();

    void                                        Full_TokyoA_EachQuad_4x4();

    void                                        Full_TokyoB_EachQuad_4x4();

    void                                        Full_TokyoC_EachQuad_4x4();

    void                                        Full_TokyoD_EachQuad_4x4();

    void                                        Full_KyotoA_EachQuad_4x4();

    void                                        Full_KyotoB_EachQuad_4x4();

    void                                        Full_KyotoC_EachQuad_4x4();

    void                                        Full_KyotoD_EachQuad_4x4();

    void                                        Full_OsakaA_EachQuad_4x4();

    void                                        Full_OsakaB_EachQuad_4x4();

    void                                        Full_OsakaC_EachQuad_4x4();

    void                                        Full_OsakaD_EachQuad_4x4();

    void                                        Full_NaraA_EachQuad_4x4();

    void                                        Full_NaraB_EachQuad_4x4();

    void                                        Full_NaraC_EachQuad_4x4();

    void                                        Full_NaraD_EachQuad_4x4();

    void                                        Full_KobeA_EachQuad_4x4();

    void                                        Full_KobeB_EachQuad_4x4();

    void                                        Full_KobeC_EachQuad_4x4();

    void                                        Full_KobeD_EachQuad_4x4();

    void                                        Full_SapporoA_EachQuad_4x4();

    void                                        Full_SapporoB_EachQuad_4x4();

    void                                        Full_SapporoC_EachQuad_4x4();

    void                                        Full_SapporoD_EachQuad_4x4();

    void                                        Full_NagoyaA_EachQuad_4x4();

    void                                        Full_NagoyaB_EachQuad_4x4();

    void                                        Full_NagoyaC_EachQuad_4x4();

    void                                        Full_NagoyaD_EachQuad_4x4();

    void                                        Full_FukuokaA_EachQuad_4x4();

    void                                        Full_FukuokaB_EachQuad_4x4();

    void                                        Full_FukuokaC_EachQuad_4x4();

    void                                        Full_FukuokaD_EachQuad_4x4();
    void                                        Full_TokyoA_8x8();
    void                                        Full_TokyoB_8x8();
    void                                        Full_TokyoC_8x8();
    void                                        Full_TokyoD_8x8();
    void                                        Full_KyotoA_8x8();
    void                                        Full_KyotoB_8x8();
    void                                        Full_KyotoC_8x8();
    void                                        Full_KyotoD_8x8();
    void                                        Full_OsakaA_8x8();
    void                                        Full_OsakaB_8x8();
    void                                        Full_OsakaC_8x8();
    void                                        Full_OsakaD_8x8();
    void                                        Full_NaraA_8x8();
    void                                        Full_NaraB_8x8();
    void                                        Full_NaraC_8x8();
    void                                        Full_NaraD_8x8();
    void                                        Full_KobeA_8x8();
    void                                        Full_KobeB_8x8();
    void                                        Full_KobeC_8x8();
    void                                        Full_KobeD_8x8();
    void                                        Full_SapporoA_8x8();
    void                                        Full_SapporoB_8x8();
    void                                        Full_SapporoC_8x8();
    void                                        Full_SapporoD_8x8();
    void                                        Full_NagoyaA_8x8();
    void                                        Full_NagoyaB_8x8();
    void                                        Full_NagoyaC_8x8();
    void                                        Full_NagoyaD_8x8();
    void                                        Full_FukuokaA_8x8();
    void                                        Full_FukuokaB_8x8();
    void                                        Full_FukuokaC_8x8();
    void                                        Full_FukuokaD_8x8();

    void                                        Full_GlendaleA_EachQuad_4x4();

    void                                        Full_GlendaleB_EachQuad_4x4();

    void                                        Full_GlendaleC_EachQuad_4x4();

    void                                        Full_GlendaleD_EachQuad_4x4();

    void                                        Full_BurbankA_EachQuad_4x4();

    void                                        Full_BurbankB_EachQuad_4x4();

    void                                        Full_BurbankC_EachQuad_4x4();

    void                                        Full_BurbankD_EachQuad_4x4();

    void                                        Full_InglewoodA_EachQuad_4x4();

    void                                        Full_InglewoodB_EachQuad_4x4();

    void                                        Full_InglewoodC_EachQuad_4x4();

    void                                        Full_InglewoodD_EachQuad_4x4();

    void                                        Full_PasadenaA_EachQuad_4x4();

    void                                        Full_PasadenaB_EachQuad_4x4();

    void                                        Full_PasadenaC_EachQuad_4x4();

    void                                        Full_PasadenaD_EachQuad_4x4();

    void                                        Full_TorranceA_EachQuad_4x4();

    void                                        Full_TorranceB_EachQuad_4x4();

    void                                        Full_TorranceC_EachQuad_4x4();

    void                                        Full_TorranceD_EachQuad_4x4();

    void                                        Full_HawthorneA_EachQuad_4x4();

    void                                        Full_HawthorneB_EachQuad_4x4();

    void                                        Full_HawthorneC_EachQuad_4x4();

    void                                        Full_HawthorneD_EachQuad_4x4();
    void                                        Full_GlendaleA_8x8();
    void                                        Full_GlendaleB_8x8();
    void                                        Full_GlendaleC_8x8();
    void                                        Full_GlendaleD_8x8();
    void                                        Full_BurbankA_8x8();
    void                                        Full_BurbankB_8x8();
    void                                        Full_BurbankC_8x8();
    void                                        Full_BurbankD_8x8();
    void                                        Full_InglewoodA_8x8();
    void                                        Full_InglewoodB_8x8();
    void                                        Full_InglewoodC_8x8();
    void                                        Full_InglewoodD_8x8();
    void                                        Full_PasadenaA_8x8();
    void                                        Full_PasadenaB_8x8();
    void                                        Full_PasadenaC_8x8();
    void                                        Full_PasadenaD_8x8();
    void                                        Full_TorranceA_8x8();
    void                                        Full_TorranceB_8x8();
    void                                        Full_TorranceC_8x8();
    void                                        Full_TorranceD_8x8();
    void                                        Full_HawthorneA_8x8();
    void                                        Full_HawthorneB_8x8();
    void                                        Full_HawthorneC_8x8();
    void                                        Full_HawthorneD_8x8();

    void                                        Full_WizardA_EachQuad_4x4();

    void                                        Full_WizardB_EachQuad_4x4();

    void                                        Full_WizardC_EachQuad_4x4();

    void                                        Full_WizardD_EachQuad_4x4();
    void                                        Full_WizardA_8x8();
    void                                        Full_WizardB_8x8();
    void                                        Full_WizardC_8x8();
    void                                        Full_WizardD_8x8();


    // ============================================================
    // Quad A Ops (259)
    // ============================================================
    void                                        Quad_RotA_2x2_A();
    void                                        Quad_RotA_4x4_A();
    void                                        Quad_RotA_EachMini_2x2_A();
    void                                        Quad_RotB_2x2_A();
    void                                        Quad_RotB_4x4_A();
    void                                        Quad_RotB_EachMini_2x2_A();
    void                                        Quad_RotC_2x2_A();
    void                                        Quad_RotC_4x4_A();
    void                                        Quad_RotC_EachMini_2x2_A();
    void                                        Quad_FlipA_2x2_A();
    void                                        Quad_FlipA_4x4_A();
    void                                        Quad_FlipA_EachMini_2x2_A();
    void                                        Quad_FlipB_2x2_A();
    void                                        Quad_FlipB_4x4_A();
    void                                        Quad_FlipB_EachMini_2x2_A();
    void                                        Quad_FlipC_2x2_A();
    void                                        Quad_FlipC_4x4_A();
    void                                        Quad_FlipC_EachMini_2x2_A();
    void                                        Quad_FlipD_2x2_A();
    void                                        Quad_FlipD_4x4_A();
    void                                        Quad_FlipD_EachMini_2x2_A();
    void                                        Quad_TriadA_2x2_A();
    void                                        Quad_TriadA_EachMini_2x2_A();
    void                                        Quad_TriadB_2x2_A();
    void                                        Quad_TriadB_EachMini_2x2_A();
    void                                        Quad_TriadC_2x2_A();
    void                                        Quad_TriadC_EachMini_2x2_A();
    void                                        Quad_TriadD_2x2_A();
    void                                        Quad_TriadD_EachMini_2x2_A();
    void                                        Quad_TriadE_2x2_A();
    void                                        Quad_TriadE_EachMini_2x2_A();
    void                                        Quad_TriadF_2x2_A();
    void                                        Quad_TriadF_EachMini_2x2_A();
    void                                        Quad_TriadG_2x2_A();
    void                                        Quad_TriadG_EachMini_2x2_A();
    void                                        Quad_TriadH_2x2_A();
    void                                        Quad_TriadH_EachMini_2x2_A();
    void                                        Quad_SnakeA_2x2_A();
    void                                        Quad_SnakeA_EachMini_2x2_A();
    void                                        Quad_SnakeB_2x2_A();
    void                                        Quad_SnakeB_EachMini_2x2_A();
    void                                        Quad_SnakeC_2x2_A();
    void                                        Quad_SnakeC_EachMini_2x2_A();
    void                                        Quad_SnakeD_2x2_A();
    void                                        Quad_SnakeD_EachMini_2x2_A();
    void                                        Quad_TowerA_4x4_A();
    void                                        Quad_TowerB_4x4_A();
    void                                        Quad_SwapA_2x2_A();
    void                                        Quad_SwapA_EachMini_2x2_A();
    void                                        Quad_SwapB_2x2_A();
    void                                        Quad_SwapB_EachMini_2x2_A();
    void                                        Quad_SwapC_2x2_A();
    void                                        Quad_SwapC_EachMini_2x2_A();
    void                                        Quad_SwapD_2x2_A();
    void                                        Quad_SwapD_EachMini_2x2_A();
    void                                        Quad_ShearA_4x4_A();
    void                                        Quad_ShearB_4x4_A();
    void                                        Quad_ShearC_4x4_A();
    void                                        Quad_ShearD_4x4_A();
    void                                        Quad_JewelA_4x4_A();
    void                                        Quad_JewelB_4x4_A();
    void                                        Quad_JewelC_4x4_A();
    void                                        Quad_JewelD_4x4_A();
    void                                        Quad_CrystalA_4x4_A();
    void                                        Quad_CrystalC_4x4_A();
    void                                        Quad_CrystalB_4x4_A();
    void                                        Quad_CrystalD_4x4_A();
    void                                        Quad_OpalA_4x4_A();
    void                                        Quad_OpalC_4x4_A();
    void                                        Quad_OpalB_4x4_A();
    void                                        Quad_OpalD_4x4_A();
    void                                        Quad_PeridotA_4x4_A();
    void                                        Quad_PeridotB_4x4_A();
    void                                        Quad_PeridotC_4x4_A();
    void                                        Quad_PeridotD_4x4_A();
    void                                        Quad_SwanA_4x4_A();
    void                                        Quad_SwanB_4x4_A();
    void                                        Quad_SwanC_4x4_A();
    void                                        Quad_SwanD_4x4_A();
    void                                        Quad_GooseA_4x4_A();
    void                                        Quad_GooseB_4x4_A();
    void                                        Quad_GooseC_4x4_A();
    void                                        Quad_GooseD_4x4_A();
    void                                        Quad_IronA_4x4_A();
    void                                        Quad_IronB_4x4_A();
    void                                        Quad_IronC_4x4_A();
    void                                        Quad_IronD_4x4_A();
    void                                        Quad_SteelA_4x4_A();
    void                                        Quad_SteelB_4x4_A();
    void                                        Quad_SteelC_4x4_A();
    void                                        Quad_SteelD_4x4_A();
    void                                        Quad_SilverA_4x4_A();
    void                                        Quad_SilverB_4x4_A();
    void                                        Quad_SilverC_4x4_A();
    void                                        Quad_SilverD_4x4_A();
    void                                        Quad_GoldA_4x4_A();
    void                                        Quad_GoldB_4x4_A();
    void                                        Quad_GoldC_4x4_A();
    void                                        Quad_GoldD_4x4_A();
    void                                        Quad_BronzeA_4x4_A();
    void                                        Quad_BronzeB_4x4_A();
    void                                        Quad_BronzeC_4x4_A();
    void                                        Quad_BronzeD_4x4_A();
    void                                        Quad_BrassA_4x4_A();
    void                                        Quad_BrassB_4x4_A();
    void                                        Quad_BrassC_4x4_A();
    void                                        Quad_BrassD_4x4_A();
    void                                        Quad_NickelA_4x4_A();
    void                                        Quad_NickelB_4x4_A();
    void                                        Quad_NickelC_4x4_A();
    void                                        Quad_NickelD_4x4_A();
    void                                        Quad_CobaltA_4x4_A();
    void                                        Quad_CobaltB_4x4_A();
    void                                        Quad_CobaltC_4x4_A();
    void                                        Quad_CobaltD_4x4_A();
    void                                        Quad_PlatinumA_4x4_A();
    void                                        Quad_PlatinumB_4x4_A();
    void                                        Quad_PlatinumC_4x4_A();
    void                                        Quad_PlatinumD_4x4_A();
    void                                        Quad_PalladiumA_4x4_A();
    void                                        Quad_PalladiumB_4x4_A();
    void                                        Quad_PalladiumC_4x4_A();
    void                                        Quad_PalladiumD_4x4_A();
    void                                        Quad_ChromiumA_4x4_A();
    void                                        Quad_ChromiumB_4x4_A();
    void                                        Quad_ChromiumC_4x4_A();
    void                                        Quad_ChromiumD_4x4_A();
    void                                        Quad_ZirconiumA_4x4_A();
    void                                        Quad_ZirconiumB_4x4_A();
    void                                        Quad_ZirconiumC_4x4_A();
    void                                        Quad_ZirconiumD_4x4_A();
    void                                        Quad_HydrogenA_4x4_A();
    void                                        Quad_HydrogenB_4x4_A();
    void                                        Quad_HydrogenC_4x4_A();
    void                                        Quad_HydrogenD_4x4_A();
    void                                        Quad_HeliumA_4x4_A();
    void                                        Quad_HeliumB_4x4_A();
    void                                        Quad_HeliumC_4x4_A();
    void                                        Quad_HeliumD_4x4_A();
    void                                        Quad_NeonA_4x4_A();
    void                                        Quad_NeonB_4x4_A();
    void                                        Quad_NeonC_4x4_A();
    void                                        Quad_NeonD_4x4_A();
    void                                        Quad_ArgonA_4x4_A();
    void                                        Quad_ArgonB_4x4_A();
    void                                        Quad_ArgonC_4x4_A();
    void                                        Quad_ArgonD_4x4_A();
    void                                        Quad_KryptonA_4x4_A();
    void                                        Quad_KryptonB_4x4_A();
    void                                        Quad_KryptonC_4x4_A();
    void                                        Quad_KryptonD_4x4_A();
    void                                        Quad_XenonA_4x4_A();
    void                                        Quad_XenonB_4x4_A();
    void                                        Quad_XenonC_4x4_A();
    void                                        Quad_XenonD_4x4_A();
    void                                        Quad_MapleA_4x4_A();
    void                                        Quad_MapleB_4x4_A();
    void                                        Quad_MapleC_4x4_A();
    void                                        Quad_MapleD_4x4_A();
    void                                        Quad_WillowA_4x4_A();
    void                                        Quad_WillowB_4x4_A();
    void                                        Quad_WillowC_4x4_A();
    void                                        Quad_WillowD_4x4_A();
    void                                        Quad_CedarA_4x4_A();
    void                                        Quad_CedarB_4x4_A();
    void                                        Quad_CedarC_4x4_A();
    void                                        Quad_CedarD_4x4_A();
    void                                        Quad_HickoryA_4x4_A();
    void                                        Quad_HickoryB_4x4_A();
    void                                        Quad_HickoryC_4x4_A();
    void                                        Quad_HickoryD_4x4_A();
    void                                        Quad_JuniperA_4x4_A();
    void                                        Quad_JuniperB_4x4_A();
    void                                        Quad_JuniperC_4x4_A();
    void                                        Quad_JuniperD_4x4_A();
    void                                        Quad_YorkA_4x4_A();
    void                                        Quad_YorkB_4x4_A();
    void                                        Quad_YorkC_4x4_A();
    void                                        Quad_YorkD_4x4_A();
    void                                        Quad_EssexA_4x4_A();
    void                                        Quad_EssexB_4x4_A();
    void                                        Quad_EssexC_4x4_A();
    void                                        Quad_EssexD_4x4_A();
    void                                        Quad_WessexA_4x4_A();
    void                                        Quad_WessexB_4x4_A();
    void                                        Quad_WessexC_4x4_A();
    void                                        Quad_WessexD_4x4_A();
    void                                        Quad_MerciaA_4x4_A();
    void                                        Quad_MerciaB_4x4_A();
    void                                        Quad_MerciaC_4x4_A();
    void                                        Quad_MerciaD_4x4_A();
    void                                        Quad_SussexA_4x4_A();
    void                                        Quad_SussexB_4x4_A();
    void                                        Quad_SussexC_4x4_A();
    void                                        Quad_SussexD_4x4_A();
    void                                        Quad_UmbriaA_4x4_A();
    void                                        Quad_UmbriaB_4x4_A();
    void                                        Quad_UmbriaC_4x4_A();
    void                                        Quad_UmbriaD_4x4_A();
    void                                        Quad_TokyoA_4x4_A();
    void                                        Quad_TokyoB_4x4_A();
    void                                        Quad_TokyoC_4x4_A();
    void                                        Quad_TokyoD_4x4_A();
    void                                        Quad_KyotoA_4x4_A();
    void                                        Quad_KyotoB_4x4_A();
    void                                        Quad_KyotoC_4x4_A();
    void                                        Quad_KyotoD_4x4_A();
    void                                        Quad_OsakaA_4x4_A();
    void                                        Quad_OsakaB_4x4_A();
    void                                        Quad_OsakaC_4x4_A();
    void                                        Quad_OsakaD_4x4_A();
    void                                        Quad_NaraA_4x4_A();
    void                                        Quad_NaraB_4x4_A();
    void                                        Quad_NaraC_4x4_A();
    void                                        Quad_NaraD_4x4_A();
    void                                        Quad_KobeA_4x4_A();
    void                                        Quad_KobeB_4x4_A();
    void                                        Quad_KobeC_4x4_A();
    void                                        Quad_KobeD_4x4_A();
    void                                        Quad_SapporoA_4x4_A();
    void                                        Quad_SapporoB_4x4_A();
    void                                        Quad_SapporoC_4x4_A();
    void                                        Quad_SapporoD_4x4_A();
    void                                        Quad_NagoyaA_4x4_A();
    void                                        Quad_NagoyaB_4x4_A();
    void                                        Quad_NagoyaC_4x4_A();
    void                                        Quad_NagoyaD_4x4_A();
    void                                        Quad_FukuokaA_4x4_A();
    void                                        Quad_FukuokaB_4x4_A();
    void                                        Quad_FukuokaC_4x4_A();
    void                                        Quad_FukuokaD_4x4_A();
    void                                        Quad_GlendaleA_4x4_A();
    void                                        Quad_GlendaleB_4x4_A();
    void                                        Quad_GlendaleC_4x4_A();
    void                                        Quad_GlendaleD_4x4_A();
    void                                        Quad_BurbankA_4x4_A();
    void                                        Quad_BurbankB_4x4_A();
    void                                        Quad_BurbankC_4x4_A();
    void                                        Quad_BurbankD_4x4_A();
    void                                        Quad_InglewoodA_4x4_A();
    void                                        Quad_InglewoodB_4x4_A();
    void                                        Quad_InglewoodC_4x4_A();
    void                                        Quad_InglewoodD_4x4_A();
    void                                        Quad_PasadenaA_4x4_A();
    void                                        Quad_PasadenaB_4x4_A();
    void                                        Quad_PasadenaC_4x4_A();
    void                                        Quad_PasadenaD_4x4_A();
    void                                        Quad_TorranceA_4x4_A();
    void                                        Quad_TorranceB_4x4_A();
    void                                        Quad_TorranceC_4x4_A();
    void                                        Quad_TorranceD_4x4_A();
    void                                        Quad_HawthorneA_4x4_A();
    void                                        Quad_HawthorneB_4x4_A();
    void                                        Quad_HawthorneC_4x4_A();
    void                                        Quad_HawthorneD_4x4_A();
    void                                        Quad_WizardA_4x4_A();
    void                                        Quad_WizardB_4x4_A();
    void                                        Quad_WizardC_4x4_A();
    void                                        Quad_WizardD_4x4_A();


    // ============================================================
    // Quad B Ops (259)
    // ============================================================
    void                                        Quad_RotA_2x2_B();
    void                                        Quad_RotA_4x4_B();
    void                                        Quad_RotA_EachMini_2x2_B();
    void                                        Quad_RotB_2x2_B();
    void                                        Quad_RotB_4x4_B();
    void                                        Quad_RotB_EachMini_2x2_B();
    void                                        Quad_RotC_2x2_B();
    void                                        Quad_RotC_4x4_B();
    void                                        Quad_RotC_EachMini_2x2_B();
    void                                        Quad_FlipA_2x2_B();
    void                                        Quad_FlipA_4x4_B();
    void                                        Quad_FlipA_EachMini_2x2_B();
    void                                        Quad_FlipB_2x2_B();
    void                                        Quad_FlipB_4x4_B();
    void                                        Quad_FlipB_EachMini_2x2_B();
    void                                        Quad_FlipC_2x2_B();
    void                                        Quad_FlipC_4x4_B();
    void                                        Quad_FlipC_EachMini_2x2_B();
    void                                        Quad_FlipD_2x2_B();
    void                                        Quad_FlipD_4x4_B();
    void                                        Quad_FlipD_EachMini_2x2_B();
    void                                        Quad_TriadA_2x2_B();
    void                                        Quad_TriadA_EachMini_2x2_B();
    void                                        Quad_TriadB_2x2_B();
    void                                        Quad_TriadB_EachMini_2x2_B();
    void                                        Quad_TriadC_2x2_B();
    void                                        Quad_TriadC_EachMini_2x2_B();
    void                                        Quad_TriadD_2x2_B();
    void                                        Quad_TriadD_EachMini_2x2_B();
    void                                        Quad_TriadE_2x2_B();
    void                                        Quad_TriadE_EachMini_2x2_B();
    void                                        Quad_TriadF_2x2_B();
    void                                        Quad_TriadF_EachMini_2x2_B();
    void                                        Quad_TriadG_2x2_B();
    void                                        Quad_TriadG_EachMini_2x2_B();
    void                                        Quad_TriadH_2x2_B();
    void                                        Quad_TriadH_EachMini_2x2_B();
    void                                        Quad_SnakeA_2x2_B();
    void                                        Quad_SnakeA_EachMini_2x2_B();
    void                                        Quad_SnakeB_2x2_B();
    void                                        Quad_SnakeB_EachMini_2x2_B();
    void                                        Quad_SnakeC_2x2_B();
    void                                        Quad_SnakeC_EachMini_2x2_B();
    void                                        Quad_SnakeD_2x2_B();
    void                                        Quad_SnakeD_EachMini_2x2_B();
    void                                        Quad_TowerA_4x4_B();
    void                                        Quad_TowerB_4x4_B();
    void                                        Quad_SwapA_2x2_B();
    void                                        Quad_SwapA_EachMini_2x2_B();
    void                                        Quad_SwapB_2x2_B();
    void                                        Quad_SwapB_EachMini_2x2_B();
    void                                        Quad_SwapC_2x2_B();
    void                                        Quad_SwapC_EachMini_2x2_B();
    void                                        Quad_SwapD_2x2_B();
    void                                        Quad_SwapD_EachMini_2x2_B();
    void                                        Quad_ShearA_4x4_B();
    void                                        Quad_ShearB_4x4_B();
    void                                        Quad_ShearC_4x4_B();
    void                                        Quad_ShearD_4x4_B();
    void                                        Quad_JewelA_4x4_B();
    void                                        Quad_JewelB_4x4_B();
    void                                        Quad_JewelC_4x4_B();
    void                                        Quad_JewelD_4x4_B();
    void                                        Quad_CrystalA_4x4_B();
    void                                        Quad_CrystalC_4x4_B();
    void                                        Quad_CrystalB_4x4_B();
    void                                        Quad_CrystalD_4x4_B();
    void                                        Quad_OpalA_4x4_B();
    void                                        Quad_OpalC_4x4_B();
    void                                        Quad_OpalB_4x4_B();
    void                                        Quad_OpalD_4x4_B();
    void                                        Quad_PeridotA_4x4_B();
    void                                        Quad_PeridotB_4x4_B();
    void                                        Quad_PeridotC_4x4_B();
    void                                        Quad_PeridotD_4x4_B();
    void                                        Quad_SwanA_4x4_B();
    void                                        Quad_SwanB_4x4_B();
    void                                        Quad_SwanC_4x4_B();
    void                                        Quad_SwanD_4x4_B();
    void                                        Quad_GooseA_4x4_B();
    void                                        Quad_GooseB_4x4_B();
    void                                        Quad_GooseC_4x4_B();
    void                                        Quad_GooseD_4x4_B();
    void                                        Quad_IronA_4x4_B();
    void                                        Quad_IronB_4x4_B();
    void                                        Quad_IronC_4x4_B();
    void                                        Quad_IronD_4x4_B();
    void                                        Quad_SteelA_4x4_B();
    void                                        Quad_SteelB_4x4_B();
    void                                        Quad_SteelC_4x4_B();
    void                                        Quad_SteelD_4x4_B();
    void                                        Quad_SilverA_4x4_B();
    void                                        Quad_SilverB_4x4_B();
    void                                        Quad_SilverC_4x4_B();
    void                                        Quad_SilverD_4x4_B();
    void                                        Quad_GoldA_4x4_B();
    void                                        Quad_GoldB_4x4_B();
    void                                        Quad_GoldC_4x4_B();
    void                                        Quad_GoldD_4x4_B();
    void                                        Quad_BronzeA_4x4_B();
    void                                        Quad_BronzeB_4x4_B();
    void                                        Quad_BronzeC_4x4_B();
    void                                        Quad_BronzeD_4x4_B();
    void                                        Quad_BrassA_4x4_B();
    void                                        Quad_BrassB_4x4_B();
    void                                        Quad_BrassC_4x4_B();
    void                                        Quad_BrassD_4x4_B();
    void                                        Quad_NickelA_4x4_B();
    void                                        Quad_NickelB_4x4_B();
    void                                        Quad_NickelC_4x4_B();
    void                                        Quad_NickelD_4x4_B();
    void                                        Quad_CobaltA_4x4_B();
    void                                        Quad_CobaltB_4x4_B();
    void                                        Quad_CobaltC_4x4_B();
    void                                        Quad_CobaltD_4x4_B();
    void                                        Quad_PlatinumA_4x4_B();
    void                                        Quad_PlatinumB_4x4_B();
    void                                        Quad_PlatinumC_4x4_B();
    void                                        Quad_PlatinumD_4x4_B();
    void                                        Quad_PalladiumA_4x4_B();
    void                                        Quad_PalladiumB_4x4_B();
    void                                        Quad_PalladiumC_4x4_B();
    void                                        Quad_PalladiumD_4x4_B();
    void                                        Quad_ChromiumA_4x4_B();
    void                                        Quad_ChromiumB_4x4_B();
    void                                        Quad_ChromiumC_4x4_B();
    void                                        Quad_ChromiumD_4x4_B();
    void                                        Quad_ZirconiumA_4x4_B();
    void                                        Quad_ZirconiumB_4x4_B();
    void                                        Quad_ZirconiumC_4x4_B();
    void                                        Quad_ZirconiumD_4x4_B();
    void                                        Quad_HydrogenA_4x4_B();
    void                                        Quad_HydrogenB_4x4_B();
    void                                        Quad_HydrogenC_4x4_B();
    void                                        Quad_HydrogenD_4x4_B();
    void                                        Quad_HeliumA_4x4_B();
    void                                        Quad_HeliumB_4x4_B();
    void                                        Quad_HeliumC_4x4_B();
    void                                        Quad_HeliumD_4x4_B();
    void                                        Quad_NeonA_4x4_B();
    void                                        Quad_NeonB_4x4_B();
    void                                        Quad_NeonC_4x4_B();
    void                                        Quad_NeonD_4x4_B();
    void                                        Quad_ArgonA_4x4_B();
    void                                        Quad_ArgonB_4x4_B();
    void                                        Quad_ArgonC_4x4_B();
    void                                        Quad_ArgonD_4x4_B();
    void                                        Quad_KryptonA_4x4_B();
    void                                        Quad_KryptonB_4x4_B();
    void                                        Quad_KryptonC_4x4_B();
    void                                        Quad_KryptonD_4x4_B();
    void                                        Quad_XenonA_4x4_B();
    void                                        Quad_XenonB_4x4_B();
    void                                        Quad_XenonC_4x4_B();
    void                                        Quad_XenonD_4x4_B();
    void                                        Quad_MapleA_4x4_B();
    void                                        Quad_MapleB_4x4_B();
    void                                        Quad_MapleC_4x4_B();
    void                                        Quad_MapleD_4x4_B();
    void                                        Quad_WillowA_4x4_B();
    void                                        Quad_WillowB_4x4_B();
    void                                        Quad_WillowC_4x4_B();
    void                                        Quad_WillowD_4x4_B();
    void                                        Quad_CedarA_4x4_B();
    void                                        Quad_CedarB_4x4_B();
    void                                        Quad_CedarC_4x4_B();
    void                                        Quad_CedarD_4x4_B();
    void                                        Quad_HickoryA_4x4_B();
    void                                        Quad_HickoryB_4x4_B();
    void                                        Quad_HickoryC_4x4_B();
    void                                        Quad_HickoryD_4x4_B();
    void                                        Quad_JuniperA_4x4_B();
    void                                        Quad_JuniperB_4x4_B();
    void                                        Quad_JuniperC_4x4_B();
    void                                        Quad_JuniperD_4x4_B();
    void                                        Quad_YorkA_4x4_B();
    void                                        Quad_YorkB_4x4_B();
    void                                        Quad_YorkC_4x4_B();
    void                                        Quad_YorkD_4x4_B();
    void                                        Quad_EssexA_4x4_B();
    void                                        Quad_EssexB_4x4_B();
    void                                        Quad_EssexC_4x4_B();
    void                                        Quad_EssexD_4x4_B();
    void                                        Quad_WessexA_4x4_B();
    void                                        Quad_WessexB_4x4_B();
    void                                        Quad_WessexC_4x4_B();
    void                                        Quad_WessexD_4x4_B();
    void                                        Quad_MerciaA_4x4_B();
    void                                        Quad_MerciaB_4x4_B();
    void                                        Quad_MerciaC_4x4_B();
    void                                        Quad_MerciaD_4x4_B();
    void                                        Quad_SussexA_4x4_B();
    void                                        Quad_SussexB_4x4_B();
    void                                        Quad_SussexC_4x4_B();
    void                                        Quad_SussexD_4x4_B();
    void                                        Quad_UmbriaA_4x4_B();
    void                                        Quad_UmbriaB_4x4_B();
    void                                        Quad_UmbriaC_4x4_B();
    void                                        Quad_UmbriaD_4x4_B();
    void                                        Quad_TokyoA_4x4_B();
    void                                        Quad_TokyoB_4x4_B();
    void                                        Quad_TokyoC_4x4_B();
    void                                        Quad_TokyoD_4x4_B();
    void                                        Quad_KyotoA_4x4_B();
    void                                        Quad_KyotoB_4x4_B();
    void                                        Quad_KyotoC_4x4_B();
    void                                        Quad_KyotoD_4x4_B();
    void                                        Quad_OsakaA_4x4_B();
    void                                        Quad_OsakaB_4x4_B();
    void                                        Quad_OsakaC_4x4_B();
    void                                        Quad_OsakaD_4x4_B();
    void                                        Quad_NaraA_4x4_B();
    void                                        Quad_NaraB_4x4_B();
    void                                        Quad_NaraC_4x4_B();
    void                                        Quad_NaraD_4x4_B();
    void                                        Quad_KobeA_4x4_B();
    void                                        Quad_KobeB_4x4_B();
    void                                        Quad_KobeC_4x4_B();
    void                                        Quad_KobeD_4x4_B();
    void                                        Quad_SapporoA_4x4_B();
    void                                        Quad_SapporoB_4x4_B();
    void                                        Quad_SapporoC_4x4_B();
    void                                        Quad_SapporoD_4x4_B();
    void                                        Quad_NagoyaA_4x4_B();
    void                                        Quad_NagoyaB_4x4_B();
    void                                        Quad_NagoyaC_4x4_B();
    void                                        Quad_NagoyaD_4x4_B();
    void                                        Quad_FukuokaA_4x4_B();
    void                                        Quad_FukuokaB_4x4_B();
    void                                        Quad_FukuokaC_4x4_B();
    void                                        Quad_FukuokaD_4x4_B();
    void                                        Quad_GlendaleA_4x4_B();
    void                                        Quad_GlendaleB_4x4_B();
    void                                        Quad_GlendaleC_4x4_B();
    void                                        Quad_GlendaleD_4x4_B();
    void                                        Quad_BurbankA_4x4_B();
    void                                        Quad_BurbankB_4x4_B();
    void                                        Quad_BurbankC_4x4_B();
    void                                        Quad_BurbankD_4x4_B();
    void                                        Quad_InglewoodA_4x4_B();
    void                                        Quad_InglewoodB_4x4_B();
    void                                        Quad_InglewoodC_4x4_B();
    void                                        Quad_InglewoodD_4x4_B();
    void                                        Quad_PasadenaA_4x4_B();
    void                                        Quad_PasadenaB_4x4_B();
    void                                        Quad_PasadenaC_4x4_B();
    void                                        Quad_PasadenaD_4x4_B();
    void                                        Quad_TorranceA_4x4_B();
    void                                        Quad_TorranceB_4x4_B();
    void                                        Quad_TorranceC_4x4_B();
    void                                        Quad_TorranceD_4x4_B();
    void                                        Quad_HawthorneA_4x4_B();
    void                                        Quad_HawthorneB_4x4_B();
    void                                        Quad_HawthorneC_4x4_B();
    void                                        Quad_HawthorneD_4x4_B();
    void                                        Quad_WizardA_4x4_B();
    void                                        Quad_WizardB_4x4_B();
    void                                        Quad_WizardC_4x4_B();
    void                                        Quad_WizardD_4x4_B();


    // ============================================================
    // Quad C Ops (259)
    // ============================================================
    void                                        Quad_RotA_2x2_C();
    void                                        Quad_RotA_4x4_C();
    void                                        Quad_RotA_EachMini_2x2_C();
    void                                        Quad_RotB_2x2_C();
    void                                        Quad_RotB_4x4_C();
    void                                        Quad_RotB_EachMini_2x2_C();
    void                                        Quad_RotC_2x2_C();
    void                                        Quad_RotC_4x4_C();
    void                                        Quad_RotC_EachMini_2x2_C();
    void                                        Quad_FlipA_2x2_C();
    void                                        Quad_FlipA_4x4_C();
    void                                        Quad_FlipA_EachMini_2x2_C();
    void                                        Quad_FlipB_2x2_C();
    void                                        Quad_FlipB_4x4_C();
    void                                        Quad_FlipB_EachMini_2x2_C();
    void                                        Quad_FlipC_2x2_C();
    void                                        Quad_FlipC_4x4_C();
    void                                        Quad_FlipC_EachMini_2x2_C();
    void                                        Quad_FlipD_2x2_C();
    void                                        Quad_FlipD_4x4_C();
    void                                        Quad_FlipD_EachMini_2x2_C();
    void                                        Quad_TriadA_2x2_C();
    void                                        Quad_TriadA_EachMini_2x2_C();
    void                                        Quad_TriadB_2x2_C();
    void                                        Quad_TriadB_EachMini_2x2_C();
    void                                        Quad_TriadC_2x2_C();
    void                                        Quad_TriadC_EachMini_2x2_C();
    void                                        Quad_TriadD_2x2_C();
    void                                        Quad_TriadD_EachMini_2x2_C();
    void                                        Quad_TriadE_2x2_C();
    void                                        Quad_TriadE_EachMini_2x2_C();
    void                                        Quad_TriadF_2x2_C();
    void                                        Quad_TriadF_EachMini_2x2_C();
    void                                        Quad_TriadG_2x2_C();
    void                                        Quad_TriadG_EachMini_2x2_C();
    void                                        Quad_TriadH_2x2_C();
    void                                        Quad_TriadH_EachMini_2x2_C();
    void                                        Quad_SnakeA_2x2_C();
    void                                        Quad_SnakeA_EachMini_2x2_C();
    void                                        Quad_SnakeB_2x2_C();
    void                                        Quad_SnakeB_EachMini_2x2_C();
    void                                        Quad_SnakeC_2x2_C();
    void                                        Quad_SnakeC_EachMini_2x2_C();
    void                                        Quad_SnakeD_2x2_C();
    void                                        Quad_SnakeD_EachMini_2x2_C();
    void                                        Quad_TowerA_4x4_C();
    void                                        Quad_TowerB_4x4_C();
    void                                        Quad_SwapA_2x2_C();
    void                                        Quad_SwapA_EachMini_2x2_C();
    void                                        Quad_SwapB_2x2_C();
    void                                        Quad_SwapB_EachMini_2x2_C();
    void                                        Quad_SwapC_2x2_C();
    void                                        Quad_SwapC_EachMini_2x2_C();
    void                                        Quad_SwapD_2x2_C();
    void                                        Quad_SwapD_EachMini_2x2_C();
    void                                        Quad_ShearA_4x4_C();
    void                                        Quad_ShearB_4x4_C();
    void                                        Quad_ShearC_4x4_C();
    void                                        Quad_ShearD_4x4_C();
    void                                        Quad_JewelA_4x4_C();
    void                                        Quad_JewelB_4x4_C();
    void                                        Quad_JewelC_4x4_C();
    void                                        Quad_JewelD_4x4_C();
    void                                        Quad_CrystalA_4x4_C();
    void                                        Quad_CrystalC_4x4_C();
    void                                        Quad_CrystalB_4x4_C();
    void                                        Quad_CrystalD_4x4_C();
    void                                        Quad_OpalA_4x4_C();
    void                                        Quad_OpalC_4x4_C();
    void                                        Quad_OpalB_4x4_C();
    void                                        Quad_OpalD_4x4_C();
    void                                        Quad_PeridotA_4x4_C();
    void                                        Quad_PeridotB_4x4_C();
    void                                        Quad_PeridotC_4x4_C();
    void                                        Quad_PeridotD_4x4_C();
    void                                        Quad_SwanA_4x4_C();
    void                                        Quad_SwanB_4x4_C();
    void                                        Quad_SwanC_4x4_C();
    void                                        Quad_SwanD_4x4_C();
    void                                        Quad_GooseA_4x4_C();
    void                                        Quad_GooseB_4x4_C();
    void                                        Quad_GooseC_4x4_C();
    void                                        Quad_GooseD_4x4_C();
    void                                        Quad_IronA_4x4_C();
    void                                        Quad_IronB_4x4_C();
    void                                        Quad_IronC_4x4_C();
    void                                        Quad_IronD_4x4_C();
    void                                        Quad_SteelA_4x4_C();
    void                                        Quad_SteelB_4x4_C();
    void                                        Quad_SteelC_4x4_C();
    void                                        Quad_SteelD_4x4_C();
    void                                        Quad_SilverA_4x4_C();
    void                                        Quad_SilverB_4x4_C();
    void                                        Quad_SilverC_4x4_C();
    void                                        Quad_SilverD_4x4_C();
    void                                        Quad_GoldA_4x4_C();
    void                                        Quad_GoldB_4x4_C();
    void                                        Quad_GoldC_4x4_C();
    void                                        Quad_GoldD_4x4_C();
    void                                        Quad_BronzeA_4x4_C();
    void                                        Quad_BronzeB_4x4_C();
    void                                        Quad_BronzeC_4x4_C();
    void                                        Quad_BronzeD_4x4_C();
    void                                        Quad_BrassA_4x4_C();
    void                                        Quad_BrassB_4x4_C();
    void                                        Quad_BrassC_4x4_C();
    void                                        Quad_BrassD_4x4_C();
    void                                        Quad_NickelA_4x4_C();
    void                                        Quad_NickelB_4x4_C();
    void                                        Quad_NickelC_4x4_C();
    void                                        Quad_NickelD_4x4_C();
    void                                        Quad_CobaltA_4x4_C();
    void                                        Quad_CobaltB_4x4_C();
    void                                        Quad_CobaltC_4x4_C();
    void                                        Quad_CobaltD_4x4_C();
    void                                        Quad_PlatinumA_4x4_C();
    void                                        Quad_PlatinumB_4x4_C();
    void                                        Quad_PlatinumC_4x4_C();
    void                                        Quad_PlatinumD_4x4_C();
    void                                        Quad_PalladiumA_4x4_C();
    void                                        Quad_PalladiumB_4x4_C();
    void                                        Quad_PalladiumC_4x4_C();
    void                                        Quad_PalladiumD_4x4_C();
    void                                        Quad_ChromiumA_4x4_C();
    void                                        Quad_ChromiumB_4x4_C();
    void                                        Quad_ChromiumC_4x4_C();
    void                                        Quad_ChromiumD_4x4_C();
    void                                        Quad_ZirconiumA_4x4_C();
    void                                        Quad_ZirconiumB_4x4_C();
    void                                        Quad_ZirconiumC_4x4_C();
    void                                        Quad_ZirconiumD_4x4_C();
    void                                        Quad_HydrogenA_4x4_C();
    void                                        Quad_HydrogenB_4x4_C();
    void                                        Quad_HydrogenC_4x4_C();
    void                                        Quad_HydrogenD_4x4_C();
    void                                        Quad_HeliumA_4x4_C();
    void                                        Quad_HeliumB_4x4_C();
    void                                        Quad_HeliumC_4x4_C();
    void                                        Quad_HeliumD_4x4_C();
    void                                        Quad_NeonA_4x4_C();
    void                                        Quad_NeonB_4x4_C();
    void                                        Quad_NeonC_4x4_C();
    void                                        Quad_NeonD_4x4_C();
    void                                        Quad_ArgonA_4x4_C();
    void                                        Quad_ArgonB_4x4_C();
    void                                        Quad_ArgonC_4x4_C();
    void                                        Quad_ArgonD_4x4_C();
    void                                        Quad_KryptonA_4x4_C();
    void                                        Quad_KryptonB_4x4_C();
    void                                        Quad_KryptonC_4x4_C();
    void                                        Quad_KryptonD_4x4_C();
    void                                        Quad_XenonA_4x4_C();
    void                                        Quad_XenonB_4x4_C();
    void                                        Quad_XenonC_4x4_C();
    void                                        Quad_XenonD_4x4_C();
    void                                        Quad_MapleA_4x4_C();
    void                                        Quad_MapleB_4x4_C();
    void                                        Quad_MapleC_4x4_C();
    void                                        Quad_MapleD_4x4_C();
    void                                        Quad_WillowA_4x4_C();
    void                                        Quad_WillowB_4x4_C();
    void                                        Quad_WillowC_4x4_C();
    void                                        Quad_WillowD_4x4_C();
    void                                        Quad_CedarA_4x4_C();
    void                                        Quad_CedarB_4x4_C();
    void                                        Quad_CedarC_4x4_C();
    void                                        Quad_CedarD_4x4_C();
    void                                        Quad_HickoryA_4x4_C();
    void                                        Quad_HickoryB_4x4_C();
    void                                        Quad_HickoryC_4x4_C();
    void                                        Quad_HickoryD_4x4_C();
    void                                        Quad_JuniperA_4x4_C();
    void                                        Quad_JuniperB_4x4_C();
    void                                        Quad_JuniperC_4x4_C();
    void                                        Quad_JuniperD_4x4_C();
    void                                        Quad_YorkA_4x4_C();
    void                                        Quad_YorkB_4x4_C();
    void                                        Quad_YorkC_4x4_C();
    void                                        Quad_YorkD_4x4_C();
    void                                        Quad_EssexA_4x4_C();
    void                                        Quad_EssexB_4x4_C();
    void                                        Quad_EssexC_4x4_C();
    void                                        Quad_EssexD_4x4_C();
    void                                        Quad_WessexA_4x4_C();
    void                                        Quad_WessexB_4x4_C();
    void                                        Quad_WessexC_4x4_C();
    void                                        Quad_WessexD_4x4_C();
    void                                        Quad_MerciaA_4x4_C();
    void                                        Quad_MerciaB_4x4_C();
    void                                        Quad_MerciaC_4x4_C();
    void                                        Quad_MerciaD_4x4_C();
    void                                        Quad_SussexA_4x4_C();
    void                                        Quad_SussexB_4x4_C();
    void                                        Quad_SussexC_4x4_C();
    void                                        Quad_SussexD_4x4_C();
    void                                        Quad_UmbriaA_4x4_C();
    void                                        Quad_UmbriaB_4x4_C();
    void                                        Quad_UmbriaC_4x4_C();
    void                                        Quad_UmbriaD_4x4_C();
    void                                        Quad_TokyoA_4x4_C();
    void                                        Quad_TokyoB_4x4_C();
    void                                        Quad_TokyoC_4x4_C();
    void                                        Quad_TokyoD_4x4_C();
    void                                        Quad_KyotoA_4x4_C();
    void                                        Quad_KyotoB_4x4_C();
    void                                        Quad_KyotoC_4x4_C();
    void                                        Quad_KyotoD_4x4_C();
    void                                        Quad_OsakaA_4x4_C();
    void                                        Quad_OsakaB_4x4_C();
    void                                        Quad_OsakaC_4x4_C();
    void                                        Quad_OsakaD_4x4_C();
    void                                        Quad_NaraA_4x4_C();
    void                                        Quad_NaraB_4x4_C();
    void                                        Quad_NaraC_4x4_C();
    void                                        Quad_NaraD_4x4_C();
    void                                        Quad_KobeA_4x4_C();
    void                                        Quad_KobeB_4x4_C();
    void                                        Quad_KobeC_4x4_C();
    void                                        Quad_KobeD_4x4_C();
    void                                        Quad_SapporoA_4x4_C();
    void                                        Quad_SapporoB_4x4_C();
    void                                        Quad_SapporoC_4x4_C();
    void                                        Quad_SapporoD_4x4_C();
    void                                        Quad_NagoyaA_4x4_C();
    void                                        Quad_NagoyaB_4x4_C();
    void                                        Quad_NagoyaC_4x4_C();
    void                                        Quad_NagoyaD_4x4_C();
    void                                        Quad_FukuokaA_4x4_C();
    void                                        Quad_FukuokaB_4x4_C();
    void                                        Quad_FukuokaC_4x4_C();
    void                                        Quad_FukuokaD_4x4_C();
    void                                        Quad_GlendaleA_4x4_C();
    void                                        Quad_GlendaleB_4x4_C();
    void                                        Quad_GlendaleC_4x4_C();
    void                                        Quad_GlendaleD_4x4_C();
    void                                        Quad_BurbankA_4x4_C();
    void                                        Quad_BurbankB_4x4_C();
    void                                        Quad_BurbankC_4x4_C();
    void                                        Quad_BurbankD_4x4_C();
    void                                        Quad_InglewoodA_4x4_C();
    void                                        Quad_InglewoodB_4x4_C();
    void                                        Quad_InglewoodC_4x4_C();
    void                                        Quad_InglewoodD_4x4_C();
    void                                        Quad_PasadenaA_4x4_C();
    void                                        Quad_PasadenaB_4x4_C();
    void                                        Quad_PasadenaC_4x4_C();
    void                                        Quad_PasadenaD_4x4_C();
    void                                        Quad_TorranceA_4x4_C();
    void                                        Quad_TorranceB_4x4_C();
    void                                        Quad_TorranceC_4x4_C();
    void                                        Quad_TorranceD_4x4_C();
    void                                        Quad_HawthorneA_4x4_C();
    void                                        Quad_HawthorneB_4x4_C();
    void                                        Quad_HawthorneC_4x4_C();
    void                                        Quad_HawthorneD_4x4_C();
    void                                        Quad_WizardA_4x4_C();
    void                                        Quad_WizardB_4x4_C();
    void                                        Quad_WizardC_4x4_C();
    void                                        Quad_WizardD_4x4_C();


    // ============================================================
    // Quad D Ops (259)
    // ============================================================
    void                                        Quad_RotA_2x2_D();
    void                                        Quad_RotA_4x4_D();
    void                                        Quad_RotA_EachMini_2x2_D();
    void                                        Quad_RotB_2x2_D();
    void                                        Quad_RotB_4x4_D();
    void                                        Quad_RotB_EachMini_2x2_D();
    void                                        Quad_RotC_2x2_D();
    void                                        Quad_RotC_4x4_D();
    void                                        Quad_RotC_EachMini_2x2_D();
    void                                        Quad_FlipA_2x2_D();
    void                                        Quad_FlipA_4x4_D();
    void                                        Quad_FlipA_EachMini_2x2_D();
    void                                        Quad_FlipB_2x2_D();
    void                                        Quad_FlipB_4x4_D();
    void                                        Quad_FlipB_EachMini_2x2_D();
    void                                        Quad_FlipC_2x2_D();
    void                                        Quad_FlipC_4x4_D();
    void                                        Quad_FlipC_EachMini_2x2_D();
    void                                        Quad_FlipD_2x2_D();
    void                                        Quad_FlipD_4x4_D();
    void                                        Quad_FlipD_EachMini_2x2_D();
    void                                        Quad_TriadA_2x2_D();
    void                                        Quad_TriadA_EachMini_2x2_D();
    void                                        Quad_TriadB_2x2_D();
    void                                        Quad_TriadB_EachMini_2x2_D();
    void                                        Quad_TriadC_2x2_D();
    void                                        Quad_TriadC_EachMini_2x2_D();
    void                                        Quad_TriadD_2x2_D();
    void                                        Quad_TriadD_EachMini_2x2_D();
    void                                        Quad_TriadE_2x2_D();
    void                                        Quad_TriadE_EachMini_2x2_D();
    void                                        Quad_TriadF_2x2_D();
    void                                        Quad_TriadF_EachMini_2x2_D();
    void                                        Quad_TriadG_2x2_D();
    void                                        Quad_TriadG_EachMini_2x2_D();
    void                                        Quad_TriadH_2x2_D();
    void                                        Quad_TriadH_EachMini_2x2_D();
    void                                        Quad_SnakeA_2x2_D();
    void                                        Quad_SnakeA_EachMini_2x2_D();
    void                                        Quad_SnakeB_2x2_D();
    void                                        Quad_SnakeB_EachMini_2x2_D();
    void                                        Quad_SnakeC_2x2_D();
    void                                        Quad_SnakeC_EachMini_2x2_D();
    void                                        Quad_SnakeD_2x2_D();
    void                                        Quad_SnakeD_EachMini_2x2_D();
    void                                        Quad_TowerA_4x4_D();
    void                                        Quad_TowerB_4x4_D();
    void                                        Quad_SwapA_2x2_D();
    void                                        Quad_SwapA_EachMini_2x2_D();
    void                                        Quad_SwapB_2x2_D();
    void                                        Quad_SwapB_EachMini_2x2_D();
    void                                        Quad_SwapC_2x2_D();
    void                                        Quad_SwapC_EachMini_2x2_D();
    void                                        Quad_SwapD_2x2_D();
    void                                        Quad_SwapD_EachMini_2x2_D();
    void                                        Quad_ShearA_4x4_D();
    void                                        Quad_ShearB_4x4_D();
    void                                        Quad_ShearC_4x4_D();
    void                                        Quad_ShearD_4x4_D();
    void                                        Quad_JewelA_4x4_D();
    void                                        Quad_JewelB_4x4_D();
    void                                        Quad_JewelC_4x4_D();
    void                                        Quad_JewelD_4x4_D();
    void                                        Quad_CrystalA_4x4_D();
    void                                        Quad_CrystalC_4x4_D();
    void                                        Quad_CrystalB_4x4_D();
    void                                        Quad_CrystalD_4x4_D();
    void                                        Quad_OpalA_4x4_D();
    void                                        Quad_OpalC_4x4_D();
    void                                        Quad_OpalB_4x4_D();
    void                                        Quad_OpalD_4x4_D();
    void                                        Quad_PeridotA_4x4_D();
    void                                        Quad_PeridotB_4x4_D();
    void                                        Quad_PeridotC_4x4_D();
    void                                        Quad_PeridotD_4x4_D();
    void                                        Quad_SwanA_4x4_D();
    void                                        Quad_SwanB_4x4_D();
    void                                        Quad_SwanC_4x4_D();
    void                                        Quad_SwanD_4x4_D();
    void                                        Quad_GooseA_4x4_D();
    void                                        Quad_GooseB_4x4_D();
    void                                        Quad_GooseC_4x4_D();
    void                                        Quad_GooseD_4x4_D();
    void                                        Quad_IronA_4x4_D();
    void                                        Quad_IronB_4x4_D();
    void                                        Quad_IronC_4x4_D();
    void                                        Quad_IronD_4x4_D();
    void                                        Quad_SteelA_4x4_D();
    void                                        Quad_SteelB_4x4_D();
    void                                        Quad_SteelC_4x4_D();
    void                                        Quad_SteelD_4x4_D();
    void                                        Quad_SilverA_4x4_D();
    void                                        Quad_SilverB_4x4_D();
    void                                        Quad_SilverC_4x4_D();
    void                                        Quad_SilverD_4x4_D();
    void                                        Quad_GoldA_4x4_D();
    void                                        Quad_GoldB_4x4_D();
    void                                        Quad_GoldC_4x4_D();
    void                                        Quad_GoldD_4x4_D();
    void                                        Quad_BronzeA_4x4_D();
    void                                        Quad_BronzeB_4x4_D();
    void                                        Quad_BronzeC_4x4_D();
    void                                        Quad_BronzeD_4x4_D();
    void                                        Quad_BrassA_4x4_D();
    void                                        Quad_BrassB_4x4_D();
    void                                        Quad_BrassC_4x4_D();
    void                                        Quad_BrassD_4x4_D();
    void                                        Quad_NickelA_4x4_D();
    void                                        Quad_NickelB_4x4_D();
    void                                        Quad_NickelC_4x4_D();
    void                                        Quad_NickelD_4x4_D();
    void                                        Quad_CobaltA_4x4_D();
    void                                        Quad_CobaltB_4x4_D();
    void                                        Quad_CobaltC_4x4_D();
    void                                        Quad_CobaltD_4x4_D();
    void                                        Quad_PlatinumA_4x4_D();
    void                                        Quad_PlatinumB_4x4_D();
    void                                        Quad_PlatinumC_4x4_D();
    void                                        Quad_PlatinumD_4x4_D();
    void                                        Quad_PalladiumA_4x4_D();
    void                                        Quad_PalladiumB_4x4_D();
    void                                        Quad_PalladiumC_4x4_D();
    void                                        Quad_PalladiumD_4x4_D();
    void                                        Quad_ChromiumA_4x4_D();
    void                                        Quad_ChromiumB_4x4_D();
    void                                        Quad_ChromiumC_4x4_D();
    void                                        Quad_ChromiumD_4x4_D();
    void                                        Quad_ZirconiumA_4x4_D();
    void                                        Quad_ZirconiumB_4x4_D();
    void                                        Quad_ZirconiumC_4x4_D();
    void                                        Quad_ZirconiumD_4x4_D();
    void                                        Quad_HydrogenA_4x4_D();
    void                                        Quad_HydrogenB_4x4_D();
    void                                        Quad_HydrogenC_4x4_D();
    void                                        Quad_HydrogenD_4x4_D();
    void                                        Quad_HeliumA_4x4_D();
    void                                        Quad_HeliumB_4x4_D();
    void                                        Quad_HeliumC_4x4_D();
    void                                        Quad_HeliumD_4x4_D();
    void                                        Quad_NeonA_4x4_D();
    void                                        Quad_NeonB_4x4_D();
    void                                        Quad_NeonC_4x4_D();
    void                                        Quad_NeonD_4x4_D();
    void                                        Quad_ArgonA_4x4_D();
    void                                        Quad_ArgonB_4x4_D();
    void                                        Quad_ArgonC_4x4_D();
    void                                        Quad_ArgonD_4x4_D();
    void                                        Quad_KryptonA_4x4_D();
    void                                        Quad_KryptonB_4x4_D();
    void                                        Quad_KryptonC_4x4_D();
    void                                        Quad_KryptonD_4x4_D();
    void                                        Quad_XenonA_4x4_D();
    void                                        Quad_XenonB_4x4_D();
    void                                        Quad_XenonC_4x4_D();
    void                                        Quad_XenonD_4x4_D();
    void                                        Quad_MapleA_4x4_D();
    void                                        Quad_MapleB_4x4_D();
    void                                        Quad_MapleC_4x4_D();
    void                                        Quad_MapleD_4x4_D();
    void                                        Quad_WillowA_4x4_D();
    void                                        Quad_WillowB_4x4_D();
    void                                        Quad_WillowC_4x4_D();
    void                                        Quad_WillowD_4x4_D();
    void                                        Quad_CedarA_4x4_D();
    void                                        Quad_CedarB_4x4_D();
    void                                        Quad_CedarC_4x4_D();
    void                                        Quad_CedarD_4x4_D();
    void                                        Quad_HickoryA_4x4_D();
    void                                        Quad_HickoryB_4x4_D();
    void                                        Quad_HickoryC_4x4_D();
    void                                        Quad_HickoryD_4x4_D();
    void                                        Quad_JuniperA_4x4_D();
    void                                        Quad_JuniperB_4x4_D();
    void                                        Quad_JuniperC_4x4_D();
    void                                        Quad_JuniperD_4x4_D();
    void                                        Quad_YorkA_4x4_D();
    void                                        Quad_YorkB_4x4_D();
    void                                        Quad_YorkC_4x4_D();
    void                                        Quad_YorkD_4x4_D();
    void                                        Quad_EssexA_4x4_D();
    void                                        Quad_EssexB_4x4_D();
    void                                        Quad_EssexC_4x4_D();
    void                                        Quad_EssexD_4x4_D();
    void                                        Quad_WessexA_4x4_D();
    void                                        Quad_WessexB_4x4_D();
    void                                        Quad_WessexC_4x4_D();
    void                                        Quad_WessexD_4x4_D();
    void                                        Quad_MerciaA_4x4_D();
    void                                        Quad_MerciaB_4x4_D();
    void                                        Quad_MerciaC_4x4_D();
    void                                        Quad_MerciaD_4x4_D();
    void                                        Quad_SussexA_4x4_D();
    void                                        Quad_SussexB_4x4_D();
    void                                        Quad_SussexC_4x4_D();
    void                                        Quad_SussexD_4x4_D();
    void                                        Quad_UmbriaA_4x4_D();
    void                                        Quad_UmbriaB_4x4_D();
    void                                        Quad_UmbriaC_4x4_D();
    void                                        Quad_UmbriaD_4x4_D();
    void                                        Quad_TokyoA_4x4_D();
    void                                        Quad_TokyoB_4x4_D();
    void                                        Quad_TokyoC_4x4_D();
    void                                        Quad_TokyoD_4x4_D();
    void                                        Quad_KyotoA_4x4_D();
    void                                        Quad_KyotoB_4x4_D();
    void                                        Quad_KyotoC_4x4_D();
    void                                        Quad_KyotoD_4x4_D();
    void                                        Quad_OsakaA_4x4_D();
    void                                        Quad_OsakaB_4x4_D();
    void                                        Quad_OsakaC_4x4_D();
    void                                        Quad_OsakaD_4x4_D();
    void                                        Quad_NaraA_4x4_D();
    void                                        Quad_NaraB_4x4_D();
    void                                        Quad_NaraC_4x4_D();
    void                                        Quad_NaraD_4x4_D();
    void                                        Quad_KobeA_4x4_D();
    void                                        Quad_KobeB_4x4_D();
    void                                        Quad_KobeC_4x4_D();
    void                                        Quad_KobeD_4x4_D();
    void                                        Quad_SapporoA_4x4_D();
    void                                        Quad_SapporoB_4x4_D();
    void                                        Quad_SapporoC_4x4_D();
    void                                        Quad_SapporoD_4x4_D();
    void                                        Quad_NagoyaA_4x4_D();
    void                                        Quad_NagoyaB_4x4_D();
    void                                        Quad_NagoyaC_4x4_D();
    void                                        Quad_NagoyaD_4x4_D();
    void                                        Quad_FukuokaA_4x4_D();
    void                                        Quad_FukuokaB_4x4_D();
    void                                        Quad_FukuokaC_4x4_D();
    void                                        Quad_FukuokaD_4x4_D();
    void                                        Quad_GlendaleA_4x4_D();
    void                                        Quad_GlendaleB_4x4_D();
    void                                        Quad_GlendaleC_4x4_D();
    void                                        Quad_GlendaleD_4x4_D();
    void                                        Quad_BurbankA_4x4_D();
    void                                        Quad_BurbankB_4x4_D();
    void                                        Quad_BurbankC_4x4_D();
    void                                        Quad_BurbankD_4x4_D();
    void                                        Quad_InglewoodA_4x4_D();
    void                                        Quad_InglewoodB_4x4_D();
    void                                        Quad_InglewoodC_4x4_D();
    void                                        Quad_InglewoodD_4x4_D();
    void                                        Quad_PasadenaA_4x4_D();
    void                                        Quad_PasadenaB_4x4_D();
    void                                        Quad_PasadenaC_4x4_D();
    void                                        Quad_PasadenaD_4x4_D();
    void                                        Quad_TorranceA_4x4_D();
    void                                        Quad_TorranceB_4x4_D();
    void                                        Quad_TorranceC_4x4_D();
    void                                        Quad_TorranceD_4x4_D();
    void                                        Quad_HawthorneA_4x4_D();
    void                                        Quad_HawthorneB_4x4_D();
    void                                        Quad_HawthorneC_4x4_D();
    void                                        Quad_HawthorneD_4x4_D();
    void                                        Quad_WizardA_4x4_D();
    void                                        Quad_WizardB_4x4_D();
    void                                        Quad_WizardC_4x4_D();
    void                                        Quad_WizardD_4x4_D();


    // ============================================================
    // Mini Ops (368)
    // ============================================================
    void                                        Mini_RotA_2x2_A();
    void                                        Mini_RotA_2x2_B();
    void                                        Mini_RotA_2x2_C();
    void                                        Mini_RotA_2x2_D();
    void                                        Mini_RotA_2x2_E();
    void                                        Mini_RotA_2x2_F();
    void                                        Mini_RotA_2x2_G();
    void                                        Mini_RotA_2x2_H();
    void                                        Mini_RotA_2x2_I();
    void                                        Mini_RotA_2x2_J();
    void                                        Mini_RotA_2x2_K();
    void                                        Mini_RotA_2x2_L();
    void                                        Mini_RotA_2x2_M();
    void                                        Mini_RotA_2x2_N();
    void                                        Mini_RotA_2x2_O();
    void                                        Mini_RotA_2x2_P();
    void                                        Mini_RotB_2x2_A();
    void                                        Mini_RotB_2x2_B();
    void                                        Mini_RotB_2x2_C();
    void                                        Mini_RotB_2x2_D();
    void                                        Mini_RotB_2x2_E();
    void                                        Mini_RotB_2x2_F();
    void                                        Mini_RotB_2x2_G();
    void                                        Mini_RotB_2x2_H();
    void                                        Mini_RotB_2x2_I();
    void                                        Mini_RotB_2x2_J();
    void                                        Mini_RotB_2x2_K();
    void                                        Mini_RotB_2x2_L();
    void                                        Mini_RotB_2x2_M();
    void                                        Mini_RotB_2x2_N();
    void                                        Mini_RotB_2x2_O();
    void                                        Mini_RotB_2x2_P();
    void                                        Mini_RotC_2x2_A();
    void                                        Mini_RotC_2x2_B();
    void                                        Mini_RotC_2x2_C();
    void                                        Mini_RotC_2x2_D();
    void                                        Mini_RotC_2x2_E();
    void                                        Mini_RotC_2x2_F();
    void                                        Mini_RotC_2x2_G();
    void                                        Mini_RotC_2x2_H();
    void                                        Mini_RotC_2x2_I();
    void                                        Mini_RotC_2x2_J();
    void                                        Mini_RotC_2x2_K();
    void                                        Mini_RotC_2x2_L();
    void                                        Mini_RotC_2x2_M();
    void                                        Mini_RotC_2x2_N();
    void                                        Mini_RotC_2x2_O();
    void                                        Mini_RotC_2x2_P();
    void                                        Mini_FlipA_2x2_A();
    void                                        Mini_FlipA_2x2_B();
    void                                        Mini_FlipA_2x2_C();
    void                                        Mini_FlipA_2x2_D();
    void                                        Mini_FlipA_2x2_E();
    void                                        Mini_FlipA_2x2_F();
    void                                        Mini_FlipA_2x2_G();
    void                                        Mini_FlipA_2x2_H();
    void                                        Mini_FlipA_2x2_I();
    void                                        Mini_FlipA_2x2_J();
    void                                        Mini_FlipA_2x2_K();
    void                                        Mini_FlipA_2x2_L();
    void                                        Mini_FlipA_2x2_M();
    void                                        Mini_FlipA_2x2_N();
    void                                        Mini_FlipA_2x2_O();
    void                                        Mini_FlipA_2x2_P();
    void                                        Mini_FlipB_2x2_A();
    void                                        Mini_FlipB_2x2_B();
    void                                        Mini_FlipB_2x2_C();
    void                                        Mini_FlipB_2x2_D();
    void                                        Mini_FlipB_2x2_E();
    void                                        Mini_FlipB_2x2_F();
    void                                        Mini_FlipB_2x2_G();
    void                                        Mini_FlipB_2x2_H();
    void                                        Mini_FlipB_2x2_I();
    void                                        Mini_FlipB_2x2_J();
    void                                        Mini_FlipB_2x2_K();
    void                                        Mini_FlipB_2x2_L();
    void                                        Mini_FlipB_2x2_M();
    void                                        Mini_FlipB_2x2_N();
    void                                        Mini_FlipB_2x2_O();
    void                                        Mini_FlipB_2x2_P();
    void                                        Mini_FlipC_2x2_A();
    void                                        Mini_FlipC_2x2_B();
    void                                        Mini_FlipC_2x2_C();
    void                                        Mini_FlipC_2x2_D();
    void                                        Mini_FlipC_2x2_E();
    void                                        Mini_FlipC_2x2_F();
    void                                        Mini_FlipC_2x2_G();
    void                                        Mini_FlipC_2x2_H();
    void                                        Mini_FlipC_2x2_I();
    void                                        Mini_FlipC_2x2_J();
    void                                        Mini_FlipC_2x2_K();
    void                                        Mini_FlipC_2x2_L();
    void                                        Mini_FlipC_2x2_M();
    void                                        Mini_FlipC_2x2_N();
    void                                        Mini_FlipC_2x2_O();
    void                                        Mini_FlipC_2x2_P();
    void                                        Mini_FlipD_2x2_A();
    void                                        Mini_FlipD_2x2_B();
    void                                        Mini_FlipD_2x2_C();
    void                                        Mini_FlipD_2x2_D();
    void                                        Mini_FlipD_2x2_E();
    void                                        Mini_FlipD_2x2_F();
    void                                        Mini_FlipD_2x2_G();
    void                                        Mini_FlipD_2x2_H();
    void                                        Mini_FlipD_2x2_I();
    void                                        Mini_FlipD_2x2_J();
    void                                        Mini_FlipD_2x2_K();
    void                                        Mini_FlipD_2x2_L();
    void                                        Mini_FlipD_2x2_M();
    void                                        Mini_FlipD_2x2_N();
    void                                        Mini_FlipD_2x2_O();
    void                                        Mini_FlipD_2x2_P();
    void                                        Mini_TriadA_2x2_A();
    void                                        Mini_TriadA_2x2_B();
    void                                        Mini_TriadA_2x2_C();
    void                                        Mini_TriadA_2x2_D();
    void                                        Mini_TriadA_2x2_E();
    void                                        Mini_TriadA_2x2_F();
    void                                        Mini_TriadA_2x2_G();
    void                                        Mini_TriadA_2x2_H();
    void                                        Mini_TriadA_2x2_I();
    void                                        Mini_TriadA_2x2_J();
    void                                        Mini_TriadA_2x2_K();
    void                                        Mini_TriadA_2x2_L();
    void                                        Mini_TriadA_2x2_M();
    void                                        Mini_TriadA_2x2_N();
    void                                        Mini_TriadA_2x2_O();
    void                                        Mini_TriadA_2x2_P();
    void                                        Mini_TriadB_2x2_A();
    void                                        Mini_TriadB_2x2_B();
    void                                        Mini_TriadB_2x2_C();
    void                                        Mini_TriadB_2x2_D();
    void                                        Mini_TriadB_2x2_E();
    void                                        Mini_TriadB_2x2_F();
    void                                        Mini_TriadB_2x2_G();
    void                                        Mini_TriadB_2x2_H();
    void                                        Mini_TriadB_2x2_I();
    void                                        Mini_TriadB_2x2_J();
    void                                        Mini_TriadB_2x2_K();
    void                                        Mini_TriadB_2x2_L();
    void                                        Mini_TriadB_2x2_M();
    void                                        Mini_TriadB_2x2_N();
    void                                        Mini_TriadB_2x2_O();
    void                                        Mini_TriadB_2x2_P();
    void                                        Mini_TriadC_2x2_A();
    void                                        Mini_TriadC_2x2_B();
    void                                        Mini_TriadC_2x2_C();
    void                                        Mini_TriadC_2x2_D();
    void                                        Mini_TriadC_2x2_E();
    void                                        Mini_TriadC_2x2_F();
    void                                        Mini_TriadC_2x2_G();
    void                                        Mini_TriadC_2x2_H();
    void                                        Mini_TriadC_2x2_I();
    void                                        Mini_TriadC_2x2_J();
    void                                        Mini_TriadC_2x2_K();
    void                                        Mini_TriadC_2x2_L();
    void                                        Mini_TriadC_2x2_M();
    void                                        Mini_TriadC_2x2_N();
    void                                        Mini_TriadC_2x2_O();
    void                                        Mini_TriadC_2x2_P();
    void                                        Mini_TriadD_2x2_A();
    void                                        Mini_TriadD_2x2_B();
    void                                        Mini_TriadD_2x2_C();
    void                                        Mini_TriadD_2x2_D();
    void                                        Mini_TriadD_2x2_E();
    void                                        Mini_TriadD_2x2_F();
    void                                        Mini_TriadD_2x2_G();
    void                                        Mini_TriadD_2x2_H();
    void                                        Mini_TriadD_2x2_I();
    void                                        Mini_TriadD_2x2_J();
    void                                        Mini_TriadD_2x2_K();
    void                                        Mini_TriadD_2x2_L();
    void                                        Mini_TriadD_2x2_M();
    void                                        Mini_TriadD_2x2_N();
    void                                        Mini_TriadD_2x2_O();
    void                                        Mini_TriadD_2x2_P();
    void                                        Mini_TriadE_2x2_A();
    void                                        Mini_TriadE_2x2_B();
    void                                        Mini_TriadE_2x2_C();
    void                                        Mini_TriadE_2x2_D();
    void                                        Mini_TriadE_2x2_E();
    void                                        Mini_TriadE_2x2_F();
    void                                        Mini_TriadE_2x2_G();
    void                                        Mini_TriadE_2x2_H();
    void                                        Mini_TriadE_2x2_I();
    void                                        Mini_TriadE_2x2_J();
    void                                        Mini_TriadE_2x2_K();
    void                                        Mini_TriadE_2x2_L();
    void                                        Mini_TriadE_2x2_M();
    void                                        Mini_TriadE_2x2_N();
    void                                        Mini_TriadE_2x2_O();
    void                                        Mini_TriadE_2x2_P();
    void                                        Mini_TriadF_2x2_A();
    void                                        Mini_TriadF_2x2_B();
    void                                        Mini_TriadF_2x2_C();
    void                                        Mini_TriadF_2x2_D();
    void                                        Mini_TriadF_2x2_E();
    void                                        Mini_TriadF_2x2_F();
    void                                        Mini_TriadF_2x2_G();
    void                                        Mini_TriadF_2x2_H();
    void                                        Mini_TriadF_2x2_I();
    void                                        Mini_TriadF_2x2_J();
    void                                        Mini_TriadF_2x2_K();
    void                                        Mini_TriadF_2x2_L();
    void                                        Mini_TriadF_2x2_M();
    void                                        Mini_TriadF_2x2_N();
    void                                        Mini_TriadF_2x2_O();
    void                                        Mini_TriadF_2x2_P();
    void                                        Mini_TriadG_2x2_A();
    void                                        Mini_TriadG_2x2_B();
    void                                        Mini_TriadG_2x2_C();
    void                                        Mini_TriadG_2x2_D();
    void                                        Mini_TriadG_2x2_E();
    void                                        Mini_TriadG_2x2_F();
    void                                        Mini_TriadG_2x2_G();
    void                                        Mini_TriadG_2x2_H();
    void                                        Mini_TriadG_2x2_I();
    void                                        Mini_TriadG_2x2_J();
    void                                        Mini_TriadG_2x2_K();
    void                                        Mini_TriadG_2x2_L();
    void                                        Mini_TriadG_2x2_M();
    void                                        Mini_TriadG_2x2_N();
    void                                        Mini_TriadG_2x2_O();
    void                                        Mini_TriadG_2x2_P();
    void                                        Mini_TriadH_2x2_A();
    void                                        Mini_TriadH_2x2_B();
    void                                        Mini_TriadH_2x2_C();
    void                                        Mini_TriadH_2x2_D();
    void                                        Mini_TriadH_2x2_E();
    void                                        Mini_TriadH_2x2_F();
    void                                        Mini_TriadH_2x2_G();
    void                                        Mini_TriadH_2x2_H();
    void                                        Mini_TriadH_2x2_I();
    void                                        Mini_TriadH_2x2_J();
    void                                        Mini_TriadH_2x2_K();
    void                                        Mini_TriadH_2x2_L();
    void                                        Mini_TriadH_2x2_M();
    void                                        Mini_TriadH_2x2_N();
    void                                        Mini_TriadH_2x2_O();
    void                                        Mini_TriadH_2x2_P();
    void                                        Mini_SnakeA_2x2_A();
    void                                        Mini_SnakeA_2x2_B();
    void                                        Mini_SnakeA_2x2_C();
    void                                        Mini_SnakeA_2x2_D();
    void                                        Mini_SnakeA_2x2_E();
    void                                        Mini_SnakeA_2x2_F();
    void                                        Mini_SnakeA_2x2_G();
    void                                        Mini_SnakeA_2x2_H();
    void                                        Mini_SnakeA_2x2_I();
    void                                        Mini_SnakeA_2x2_J();
    void                                        Mini_SnakeA_2x2_K();
    void                                        Mini_SnakeA_2x2_L();
    void                                        Mini_SnakeA_2x2_M();
    void                                        Mini_SnakeA_2x2_N();
    void                                        Mini_SnakeA_2x2_O();
    void                                        Mini_SnakeA_2x2_P();
    void                                        Mini_SnakeB_2x2_A();
    void                                        Mini_SnakeB_2x2_B();
    void                                        Mini_SnakeB_2x2_C();
    void                                        Mini_SnakeB_2x2_D();
    void                                        Mini_SnakeB_2x2_E();
    void                                        Mini_SnakeB_2x2_F();
    void                                        Mini_SnakeB_2x2_G();
    void                                        Mini_SnakeB_2x2_H();
    void                                        Mini_SnakeB_2x2_I();
    void                                        Mini_SnakeB_2x2_J();
    void                                        Mini_SnakeB_2x2_K();
    void                                        Mini_SnakeB_2x2_L();
    void                                        Mini_SnakeB_2x2_M();
    void                                        Mini_SnakeB_2x2_N();
    void                                        Mini_SnakeB_2x2_O();
    void                                        Mini_SnakeB_2x2_P();
    void                                        Mini_SnakeC_2x2_A();
    void                                        Mini_SnakeC_2x2_B();
    void                                        Mini_SnakeC_2x2_C();
    void                                        Mini_SnakeC_2x2_D();
    void                                        Mini_SnakeC_2x2_E();
    void                                        Mini_SnakeC_2x2_F();
    void                                        Mini_SnakeC_2x2_G();
    void                                        Mini_SnakeC_2x2_H();
    void                                        Mini_SnakeC_2x2_I();
    void                                        Mini_SnakeC_2x2_J();
    void                                        Mini_SnakeC_2x2_K();
    void                                        Mini_SnakeC_2x2_L();
    void                                        Mini_SnakeC_2x2_M();
    void                                        Mini_SnakeC_2x2_N();
    void                                        Mini_SnakeC_2x2_O();
    void                                        Mini_SnakeC_2x2_P();
    void                                        Mini_SnakeD_2x2_A();
    void                                        Mini_SnakeD_2x2_B();
    void                                        Mini_SnakeD_2x2_C();
    void                                        Mini_SnakeD_2x2_D();
    void                                        Mini_SnakeD_2x2_E();
    void                                        Mini_SnakeD_2x2_F();
    void                                        Mini_SnakeD_2x2_G();
    void                                        Mini_SnakeD_2x2_H();
    void                                        Mini_SnakeD_2x2_I();
    void                                        Mini_SnakeD_2x2_J();
    void                                        Mini_SnakeD_2x2_K();
    void                                        Mini_SnakeD_2x2_L();
    void                                        Mini_SnakeD_2x2_M();
    void                                        Mini_SnakeD_2x2_N();
    void                                        Mini_SnakeD_2x2_O();
    void                                        Mini_SnakeD_2x2_P();
    void                                        Mini_SwapA_2x2_A();
    void                                        Mini_SwapA_2x2_B();
    void                                        Mini_SwapA_2x2_C();
    void                                        Mini_SwapA_2x2_D();
    void                                        Mini_SwapA_2x2_E();
    void                                        Mini_SwapA_2x2_F();
    void                                        Mini_SwapA_2x2_G();
    void                                        Mini_SwapA_2x2_H();
    void                                        Mini_SwapA_2x2_I();
    void                                        Mini_SwapA_2x2_J();
    void                                        Mini_SwapA_2x2_K();
    void                                        Mini_SwapA_2x2_L();
    void                                        Mini_SwapA_2x2_M();
    void                                        Mini_SwapA_2x2_N();
    void                                        Mini_SwapA_2x2_O();
    void                                        Mini_SwapA_2x2_P();
    void                                        Mini_SwapB_2x2_A();
    void                                        Mini_SwapB_2x2_B();
    void                                        Mini_SwapB_2x2_C();
    void                                        Mini_SwapB_2x2_D();
    void                                        Mini_SwapB_2x2_E();
    void                                        Mini_SwapB_2x2_F();
    void                                        Mini_SwapB_2x2_G();
    void                                        Mini_SwapB_2x2_H();
    void                                        Mini_SwapB_2x2_I();
    void                                        Mini_SwapB_2x2_J();
    void                                        Mini_SwapB_2x2_K();
    void                                        Mini_SwapB_2x2_L();
    void                                        Mini_SwapB_2x2_M();
    void                                        Mini_SwapB_2x2_N();
    void                                        Mini_SwapB_2x2_O();
    void                                        Mini_SwapB_2x2_P();
    void                                        Mini_SwapC_2x2_A();
    void                                        Mini_SwapC_2x2_B();
    void                                        Mini_SwapC_2x2_C();
    void                                        Mini_SwapC_2x2_D();
    void                                        Mini_SwapC_2x2_E();
    void                                        Mini_SwapC_2x2_F();
    void                                        Mini_SwapC_2x2_G();
    void                                        Mini_SwapC_2x2_H();
    void                                        Mini_SwapC_2x2_I();
    void                                        Mini_SwapC_2x2_J();
    void                                        Mini_SwapC_2x2_K();
    void                                        Mini_SwapC_2x2_L();
    void                                        Mini_SwapC_2x2_M();
    void                                        Mini_SwapC_2x2_N();
    void                                        Mini_SwapC_2x2_O();
    void                                        Mini_SwapC_2x2_P();
    void                                        Mini_SwapD_2x2_A();
    void                                        Mini_SwapD_2x2_B();
    void                                        Mini_SwapD_2x2_C();
    void                                        Mini_SwapD_2x2_D();
    void                                        Mini_SwapD_2x2_E();
    void                                        Mini_SwapD_2x2_F();
    void                                        Mini_SwapD_2x2_G();
    void                                        Mini_SwapD_2x2_H();
    void                                        Mini_SwapD_2x2_I();
    void                                        Mini_SwapD_2x2_J();
    void                                        Mini_SwapD_2x2_K();
    void                                        Mini_SwapD_2x2_L();
    void                                        Mini_SwapD_2x2_M();
    void                                        Mini_SwapD_2x2_N();
    void                                        Mini_SwapD_2x2_O();
    void                                        Mini_SwapD_2x2_P();
    
};

#endif /* M88_hpp */
