--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : ALU_ENV.vhf
-- /___/   /\     Timestamp : 06/21/2022 19:13:19
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/ALU_ENV.vhf" -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/ALU_ENV.sch"
--Design Name: ALU_ENV
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--
----- CELL M2_1_HXILINX_ALU_ENV -----
  
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity M2_1_HXILINX_ALU_ENV is
  
port(
    O   : out std_logic;

    D0  : in std_logic;
    D1  : in std_logic;
    S0  : in std_logic
  );
end M2_1_HXILINX_ALU_ENV;

architecture M2_1_HXILINX_ALU_ENV_V of M2_1_HXILINX_ALU_ENV is
begin
  process (D0, D1, S0)
  begin
    case S0 is
    when '0' => O <= D0;
    when '1' => O <= D1;
    when others => NULL;
    end case;
    end process; 
end M2_1_HXILINX_ALU_ENV_V;
----- CELL ADSU16_HXILINX_ALU_ENV -----
  
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ADSU16_HXILINX_ALU_ENV is
port(
    CO   : out std_logic;
    OFL  : out std_logic;
    S    : out std_logic_vector(15 downto 0);

    A    : in std_logic_vector(15 downto 0);
    ADD  : in std_logic;
    B    : in std_logic_vector(15 downto 0);
    CI   : in std_logic
  );
end ADSU16_HXILINX_ALU_ENV;

architecture ADSU16_HXILINX_ALU_ENV_V of ADSU16_HXILINX_ALU_ENV is

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
  
end ADSU16_HXILINX_ALU_ENV_V;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity ADD_SUB32_MUSER_ALU_ENV is
   port ( A           : in    std_logic_vector (31 downto 0); 
          B           : in    std_logic_vector (31 downto 0); 
          SUB         : in    std_logic; 
          ADD_SUB_OUT : out   std_logic_vector (31 downto 0); 
          NEG         : out   std_logic);
end ADD_SUB32_MUSER_ALU_ENV;

architecture BEHAVIORAL of ADD_SUB32_MUSER_ALU_ENV is
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
   component ADSU16_HXILINX_ALU_ENV
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
   
   component M2_1_HXILINX_ALU_ENV
      port ( D0 : in    std_logic; 
             D1 : in    std_logic; 
             S0 : in    std_logic; 
             O  : out   std_logic);
   end component;
   
   attribute HU_SET of XLXI_1 : label is "XLXI_1_32";
   attribute HU_SET of XLXI_2 : label is "XLXI_2_33";
   attribute HU_SET of XLXI_3 : label is "XLXI_3_34";
   attribute HU_SET of XLXI_18 : label is "XLXI_18_35";
begin
   XLXI_1 : ADSU16_HXILINX_ALU_ENV
      port map (A(15 downto 0)=>A(31 downto 16),
                ADD=>ADD,
                B(15 downto 0)=>B(31 downto 16),
                CI=>XLXN_6,
                CO=>C1,
                OFL=>open,
                S(15 downto 0)=>UPPER_1(15 downto 0));
   
   XLXI_2 : ADSU16_HXILINX_ALU_ENV
      port map (A(15 downto 0)=>A(31 downto 16),
                ADD=>ADD,
                B(15 downto 0)=>B(31 downto 16),
                CI=>XLXN_7,
                CO=>C0,
                OFL=>open,
                S(15 downto 0)=>UPPER_0(15 downto 0));
   
   XLXI_3 : ADSU16_HXILINX_ALU_ENV
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
   
   XLXI_18 : M2_1_HXILINX_ALU_ENV
      port map (D0=>C0,
                D1=>C1,
                S0=>C16,
                O=>XLXN_56);
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity COMP_MUSER_ALU_ENV is
   port ( F        : in    std_logic_vector (2 downto 0); 
          NEG      : in    std_logic; 
          S        : in    std_logic_vector (31 downto 0); 
          COMP_OUT : out   std_logic);
end COMP_MUSER_ALU_ENV;

architecture BEHAVIORAL of COMP_MUSER_ALU_ENV is
   attribute BOX_TYPE   : string ;
   signal O        : std_logic;
   signal XLXN_9   : std_logic;
   signal XLXN_23  : std_logic;
   signal XLXN_24  : std_logic;
   signal XLXN_25  : std_logic;
   signal XLXN_28  : std_logic;
   signal XLXN_29  : std_logic;
   component AND2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2 : component is "BLACK_BOX";
   
   component INV
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of INV : component is "BLACK_BOX";
   
   component zero32
      port ( S : in    std_logic_vector (31 downto 0); 
             o : out   std_logic);
   end component;
   
   component OR2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR2 : component is "BLACK_BOX";
   
   component AND2B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2B1 : component is "BLACK_BOX";
   
begin
   XLXI_1 : AND2
      port map (I0=>O,
                I1=>F(1),
                O=>XLXN_24);
   
   XLXI_2 : AND2
      port map (I0=>NEG,
                I1=>F(2),
                O=>XLXN_25);
   
   XLXI_3 : AND2
      port map (I0=>XLXN_9,
                I1=>F(0),
                O=>XLXN_23);
   
   XLXI_4 : INV
      port map (I=>NEG,
                O=>XLXN_9);
   
   XLXI_5 : zero32
      port map (S(31 downto 0)=>S(31 downto 0),
                o=>O);
   
   XLXI_11 : OR2
      port map (I0=>XLXN_25,
                I1=>XLXN_24,
                O=>XLXN_29);
   
   XLXI_12 : AND2B1
      port map (I0=>O,
                I1=>XLXN_23,
                O=>XLXN_28);
   
   XLXI_13 : OR2
      port map (I0=>XLXN_29,
                I1=>XLXN_28,
                O=>COMP_OUT);
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity ALU_ENV is
   port ( A       : in    std_logic_vector (31 downto 0); 
          ADD     : in    std_logic; 
          ALUF    : in    std_logic_vector (2 downto 0); 
          B       : in    std_logic_vector (31 downto 0); 
          TEST    : in    std_logic; 
          ALU_OUT : out   std_logic_vector (31 downto 0));
end ALU_ENV;

architecture BEHAVIORAL of ALU_ENV is
   attribute BOX_TYPE   : string ;
   signal ADD_SUB_OUT  : std_logic_vector (31 downto 0);
   signal AnB          : std_logic_vector (31 downto 0);
   signal COMP_PAD     : std_logic_vector (31 downto 0);
   signal COND_SUM_ADD : std_logic_vector (31 downto 0);
   signal F            : std_logic_vector (2 downto 0);
   signal frcAdd       : std_logic_vector (2 downto 0);
   signal XLXN_68      : std_logic_vector (31 downto 0);
   signal XLXN_129     : std_logic_vector (31 downto 0);
   signal XLXN_178     : std_logic_vector (31 downto 0);
   signal XLXN_179     : std_logic_vector (31 downto 0);
   signal XLXN_191     : std_logic;
   signal XLXN_199     : std_logic;
   signal XLXN_213     : std_logic;
   signal XLXN_274     : std_logic;
   signal XLXN_275     : std_logic;
   component MUX32bit
      port ( sel : in    std_logic; 
             A   : in    std_logic_vector (31 downto 0); 
             B   : in    std_logic_vector (31 downto 0); 
             O   : out   std_logic_vector (31 downto 0));
   end component;
   
   component XOR32
      port ( A     : in    std_logic_vector (31 downto 0); 
             B     : in    std_logic_vector (31 downto 0); 
             AxorB : out   std_logic_vector (31 downto 0));
   end component;
   
   component OR32
      port ( A : in    std_logic_vector (31 downto 0); 
             B : in    std_logic_vector (31 downto 0); 
             O : out   std_logic_vector (31 downto 0));
   end component;
   
   component COMP_MUSER_ALU_ENV
      port ( S        : in    std_logic_vector (31 downto 0); 
             NEG      : in    std_logic; 
             F        : in    std_logic_vector (2 downto 0); 
             COMP_OUT : out   std_logic);
   end component;
   
   component ZeroPad
      port ( S     : in    std_logic; 
             S_pad : out   std_logic_vector (31 downto 0));
   end component;
   
   component MUX3BIT
      port ( sel : in    std_logic; 
             A0  : in    std_logic_vector (2 downto 0); 
             A1  : in    std_logic_vector (2 downto 0); 
             O   : out   std_logic_vector (2 downto 0));
   end component;
   
   component GND
      port ( G : out   std_logic);
   end component;
   attribute BOX_TYPE of GND : component is "BLACK_BOX";
   
   component VCC
      port ( P : out   std_logic);
   end component;
   attribute BOX_TYPE of VCC : component is "BLACK_BOX";
   
   component BUF
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of BUF : component is "BLACK_BOX";
   
   component AND32
      port ( A : in    std_logic_vector (31 downto 0); 
             B : in    std_logic_vector (31 downto 0); 
             O : out   std_logic_vector (31 downto 0));
   end component;
   
   component OR2B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR2B1 : component is "BLACK_BOX";
   
   component ADD_SUB32_MUSER_ALU_ENV
      port ( A           : in    std_logic_vector (31 downto 0); 
             B           : in    std_logic_vector (31 downto 0); 
             SUB         : in    std_logic; 
             ADD_SUB_OUT : out   std_logic_vector (31 downto 0); 
             NEG         : out   std_logic);
   end component;
   
begin
   XLXI_7 : MUX32bit
      port map (A(31 downto 0)=>COND_SUM_ADD(31 downto 0),
                B(31 downto 0)=>COMP_PAD(31 downto 0),
                sel=>TEST,
                O(31 downto 0)=>ALU_OUT(31 downto 0));
   
   XLXI_8 : MUX32bit
      port map (A(31 downto 0)=>ADD_SUB_OUT(31 downto 0),
                B(31 downto 0)=>XLXN_129(31 downto 0),
                sel=>F(2),
                O(31 downto 0)=>COND_SUM_ADD(31 downto 0));
   
   XLXI_20 : MUX32bit
      port map (A(31 downto 0)=>XLXN_178(31 downto 0),
                B(31 downto 0)=>XLXN_179(31 downto 0),
                sel=>F(0),
                O(31 downto 0)=>XLXN_68(31 downto 0));
   
   XLXI_22 : MUX32bit
      port map (A(31 downto 0)=>XLXN_68(31 downto 0),
                B(31 downto 0)=>AnB(31 downto 0),
                sel=>F(1),
                O(31 downto 0)=>XLXN_129(31 downto 0));
   
   XLXI_23 : XOR32
      port map (A(31 downto 0)=>A(31 downto 0),
                B(31 downto 0)=>B(31 downto 0),
                AxorB(31 downto 0)=>XLXN_178(31 downto 0));
   
   XLXI_24 : OR32
      port map (A(31 downto 0)=>A(31 downto 0),
                B(31 downto 0)=>B(31 downto 0),
                O(31 downto 0)=>XLXN_179(31 downto 0));
   
   XLXI_45 : COMP_MUSER_ALU_ENV
      port map (F(2 downto 0)=>F(2 downto 0),
                NEG=>XLXN_199,
                S(31 downto 0)=>ADD_SUB_OUT(31 downto 0),
                COMP_OUT=>XLXN_213);
   
   XLXI_46 : ZeroPad
      port map (S=>XLXN_213,
                S_pad(31 downto 0)=>COMP_PAD(31 downto 0));
   
   XLXI_68 : MUX3BIT
      port map (A0(2 downto 0)=>ALUF(2 downto 0),
                A1(2 downto 0)=>frcAdd(2 downto 0),
                sel=>ADD,
                O(2 downto 0)=>F(2 downto 0));
   
   XLXI_69 : GND
      port map (G=>XLXN_274);
   
   XLXI_71 : VCC
      port map (P=>XLXN_275);
   
   XLXI_75 : BUF
      port map (I=>XLXN_275,
                O=>frcAdd(0));
   
   XLXI_76 : BUF
      port map (I=>XLXN_275,
                O=>frcAdd(1));
   
   XLXI_77 : BUF
      port map (I=>XLXN_274,
                O=>frcAdd(2));
   
   XLXI_78 : AND32
      port map (A(31 downto 0)=>A(31 downto 0),
                B(31 downto 0)=>B(31 downto 0),
                O(31 downto 0)=>AnB(31 downto 0));
   
   XLXI_79 : OR2B1
      port map (I0=>F(0),
                I1=>TEST,
                O=>XLXN_191);
   
   XLXI_80 : ADD_SUB32_MUSER_ALU_ENV
      port map (A(31 downto 0)=>A(31 downto 0),
                B(31 downto 0)=>B(31 downto 0),
                SUB=>XLXN_191,
                ADD_SUB_OUT(31 downto 0)=>ADD_SUB_OUT(31 downto 0),
                NEG=>XLXN_199);
   
end BEHAVIORAL;


