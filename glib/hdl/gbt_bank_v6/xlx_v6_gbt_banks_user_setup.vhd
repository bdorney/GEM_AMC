--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Xilinx Virtex 6 - GBT Banks user setup                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Xilinx Virtex 6                                                          
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Revision:              3.0                                                                      
--
-- Description:           The user can setup the different parameters of the GBT Banks by modifying
--                        this file.
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        24/06/2013   3.0       M. Barros Marin   - First .vhd package definition           
--
-- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<vendor>_<device>_gbt_bank_user_setup.vhd".     !!
-- !!     (e.g. xlx_v6_gbt_bank_user_setup.vhd)                                                 !! 
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_bank_user_setup.vhd" is the only file of the GBT Bank that   !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                                   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package gbt_banks_user_setup is
   
   --================================= GBT Banks parameters ==============================--   
   
   --=====================--
   -- Number of GBT Banks --
   --=====================--
   
   -- Comment:   * On Virtex 6 it is possible to implement up to FOUR links per GBT Bank.
   --
   --            * If more links than allowed per GBT Bank are needed, then it is 
   --              necessary to instantiate more GBT Banks.        
   
   constant NUM_GBT_BANKS                       : integer := 1;
   
   --=================--
   -- GBT Banks setup --
   --=================--
   
   -- Comment: For more information about the record "GBT_BANKS_USER_SETUP" see the file:
   --          "../gbt_bank/xilinx_v6/xlx_v6_gbt_link_package.vhd"   
   
   constant GBT_BANKS_USER_SETUP : gbt_bank_user_setup_R_A(1 to NUM_GBT_BANKS) := (
      
      -- GBT Bank 1:
      --------------     
      
      1 => (NUM_LINKS                           => 1,                   -- Comment: * 1 to 4             
            ------------------------------------
            TX_OPTIMIZATION                     => LATENCY_OPTIMIZED,            --          * (STANDARD or LATENCY_OPTIMIZED)                  
            RX_OPTIMIZATION                     => LATENCY_OPTIMIZED,            --          * (STANDARD or LATENCY_OPTIMIZED)                  
            ------------------------------------
            TX_ENCODING                         => GBT_FRAME,           --          * (GBT_FRAME or WIDE_BUS or GBT_8B10B)          
            RX_ENCODING                         => GBT_FRAME,           --          * (GBT_FRAME or WIDE_BUS or GBT_8B10B) 
            ------------------------------------                  
            STD_MGT_REFCLK_FREQ                 => FREQ_240MHz,
            ------------------------------------
            SPEEDUP_FOR_SIMULATION              => false)--,

      -- GBT Bank 2:
      -------------- 

--    2 => (NUM_LINKS                           => 4,                   -- Comment: * 1 to 4       
--          ------------------------------------
--          TX_OPTIMIZATION                     => STANDARD,            --          * (STANDARD or LATENCY_OPTIMIZED)                  
--          RX_OPTIMIZATION                     => STANDARD,            --          * (STANDARD or LATENCY_OPTIMIZED)                  
--          ------------------------------------
--          TX_ENCODING                         => GBT_FRAME,           --          * (GBT_FRAME or WIDE_BUS or GBT_8B10B)          
--          RX_ENCODING                         => WIDE_BUS,            --          * (GBT_FRAME or WIDE_BUS or GBT_8B10B)
--          ------------------------------------
--          STD_MGT_REFCLK_FREQ                 => FREQ_240MHz,
--          ------------------------------------
--          SPEEDUP_FOR_SIMULATION              => false)--,
   
   );
   
   --=====================================================================================--         
end gbt_banks_user_setup;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--