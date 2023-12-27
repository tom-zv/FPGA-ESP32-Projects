--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : ADD_SUB32.vhf
-- /___/   /\     Timestamp : 06/21/2022 19:13:15
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/ADD_SUB32.vhf" -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/ADD_SUB32.sch"
--Design Name: ADD_SUB32
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--
----- CELL M2_1_HXILINX_ADD_SUB32 -----
  
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity M2_1_HXILINX_ADD_SUB32 is
  
port(
    O   : out std_logic;

    D0  : in std_logic;
    D1  : in std_logic;
    S0  : in std_logic
  );
end M2_1_HXILINX_ADD_SUB32;

architecture M2_1_HXILINX_ADD_SUB32_V of M2_1_HXILINX_ADD_SUB32 is
begin
  process (D0, D1, S0)
  begin
    case S0 is
    when '0' => O <= D0;
    when '1' => O <= D1;
    when others => NULL;
    end case;
    end process; 
end M2_1_HXILINX_ADD_SUB32_V;
----- CELL ADSU16_HXILINX_ADD_SUB32 -----
  
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ADSU16_HXILINX_ADD_SUB32 is
port(
    CO   : out std_logic;
    OFL  : out std_logic;
    S    : out std_logic_vector(15 downto 0);

    A    : in std_logic_vector(15 downto 0);
    ADD  : in std_logic;
    B    : in std_logic_vector(15 downto 0);
    CI   : in std_logic
  );
end ADSU16_HXILINX_ADD_SUB32;

architecture ADSU16_HXILINX_ADD_SUB32_V of ADSU16_HXILINX_ADD_SUB32 is

begin
  adsu_p : process (A, ADD, B, CI)
    variable adsu_tmp : std_logic_vector(16 downto 0);
  begin
    if(ADD = '1') then
     adsu_tmp := conv_std_logic_vector((conv_integer(A) + conv_integer(B) + conv_integer(CI)),17);
    else
     adsu_tmp := conv_std_logic_vector((conv_integer(A) - conv_integer(not CI) - conv_integer(B)),17);
  end if;
      
  S   <= adsu_tmp(15 downto 0);
   
  if (ADD='1') then
    CO <= adsu_tmp(16);
    OFL <=  ( A(15) and B(15) and (not adsu_tmp(15)) ) or ( (not A(15)) and (not B(15)) and adsu_tmp(15) );  
  else
    CO <= not adsu_tmp(16);
    OFL <=  ( A(15) and (not B(15)) and (not adsu_tmp(15)) ) or ( (not A(15)) and B(15) and adsu_tmp(15) );  
  end if;
 
  end process;
  
end ADSU16_HXILINX_ADD_SUB32_V;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity ADD_SUB32 is
   port ( A           : in    std_logic_vector (31 downto 0); 
          B           : in    std_logic_vector (31 downto 0); 
          SUB         : in    std_logic; 
          ADD_SUB_OUT : out   std_logic_vector (31 downto 0); 
          NEG         : out   std_logic);
end ADD_SUB32;

architecture BEHAVIORAL of ADD_SUB32 is
   attribute HU_SET     : string ;
   attribute BOX_TYPE   : string ;
   signal ADD         : std_logic;
   signal C0          : std_logic;
   signal C1          : std_logic;
   signal C16         : std_logic;
   signal UPPER_0     : std_logic_vector (15 downto 0);
   signal UPPER_1     : std_logic_vector (15 downto 0);
   signal XLXN_6      : std_logic;
   signal XLXN_7      : std_logic;
   signal XLXN_49     : std_logic;
   signal XLXN_56     : std_logic;
   component ADSU16_HXILINX_ADD_SUB32
      port ( A   : in    std_logic_vector (15 downto 0); 
             ADD : in    std_logic; 
             B   : in    std_logic_vector (15 downto 0); 
             CI  : in    std_logic; 
             CO  : out   std_logic; 
             OFL : out   std_logic; 
             S   : out   std_logic_vector (15 downto 0));
   end component;
   
   component GND
      port ( G : out   std_logic);
   end component;
   attribute BOX_TYPE of GND : component is "BLACK_BOX";
   
   component VCC
      port ( P : out   std_logic);
   end component;
   attribute BOX_TYPE of VCC : component is "BLACK_BOX";
   
   component INV
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of INV : component is "BLACK_BOX";
   
   component MUX16bit
      port ( sel : in    std_logic; 
             A   : in    std_logic_vector (15 downto 0); 
             B   : in    std_logic_vector (15 downto 0); 
             O   : out   std_logic_vector (15 downto 0));
   end component;
   
   component XOR2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of XOR2 : component is "BLACK_BOX";
   
   component XOR3
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of XOR3 : component is "BLACK_BOX";
   
   component M2_1_HXILINX_ADD_SUB32
      port ( D0 : in    std_logic; 
             D1 : in    std_logic; 
             S0 : in    std_logic; 
             O  : out   std_logic);
   end component;
   
   attribute HU_SET of XLXI_1 : label is "XLXI_1_16";
   attribute HU_SET of XLXI_2 : label is "XLXI_2_17";
   attribute HU_SET of XLXI_3 : label is "XLXI_3_18";
   attribute HU_SET of XLXI_18 : label is "XLXI_18_19";
begin
   XLXI_1 : ADSU16_HXILINX_ADD_SUB32
      port map (A(15 downto 0)=>A(31 downto 16),
                ADD=>ADD,
                B(15 downto 0)=>B(31 downto 16),
                CI=>XLXN_6,
                CO=>C1,
                OFL=>open,
                S(15 downto 0)=>UPPER_1(15 downto 0));
   
   XLXI_2 : ADSU16_HXILINX_ADD_SUB32
      port map (A(15 downto 0)=>A(31 downto 16),
                ADD=>ADD,
                B(15 downto 0)=>B(31 downto 16),
                CI=>XLXN_7,
                CO=>C0,
                OFL=>open,
                S(15 downto 0)=>UPPER_0(15 downto 0));
   
   XLXI_3 : ADSU16_HXILINX_ADD_SUB32
      port map (A(15 downto 0)=>A(15 downto 0),
                ADD=>ADD,
                B(15 downto 0)=>B(15 downto 0),
                CI=>SUB,
                CO=>C16,
                OFL=>open,
                S(15 downto 0)=>ADD_SUB_OUT(15 downto 0));
   
   XLXI_4 : GND
      port map (G=>XLXN_7);
   
   XLXI_5 : VCC
      port map (P=>XLXN_6);
   
   XLXI_6 : INV
      port map (I=>SUB,
                O=>ADD);
   
   XLXI_12 : MUX16bit
      port map (A(15 downto 0)=>UPPER_0(15 downto 0),
                B(15 downto 0)=>UPPER_1(15 downto 0),
                sel=>C16,
                O(15 downto 0)=>ADD_SUB_OUT(31 downto 16));
   
   XLXI_13 : XOR2
      port map (I0=>SUB,
                I1=>B(31),
                O=>XLXN_49);
   
   XLXI_14 : XOR3
      port map (I0=>XLXN_49,
                I1=>A(31),
                I2=>XLXN_56,
                O=>NEG);
   
   XLXI_18 : M2_1_HXILINX_ADD_SUB32
      port map (D0=>C0,
                D1=>C1,
                S0=>C16,
                O=>XLXN_56);
   
end BEHAVIORAL;


