--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : DLX.vhf
-- /___/   /\     Timestamp : 06/21/2022 19:13:17
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/DLX.vhf" -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/DLX.sch"
--Design Name: DLX
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--
----- CELL M2_1_HXILINX_DLX -----
  
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity M2_1_HXILINX_DLX is
  
port(
    O   : out std_logic;

    D0  : in std_logic;
    D1  : in std_logic;
    S0  : in std_logic
  );
end M2_1_HXILINX_DLX;

architecture M2_1_HXILINX_DLX_V of M2_1_HXILINX_DLX is
begin
  process (D0, D1, S0)
  begin
    case S0 is
    when '0' => O <= D0;
    when '1' => O <= D1;
    when others => NULL;
    end case;
    end process; 
end M2_1_HXILINX_DLX_V;
----- CELL ADSU16_HXILINX_DLX -----
  
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ADSU16_HXILINX_DLX is
port(
    CO   : out std_logic;
    OFL  : out std_logic;
    S    : out std_logic_vector(15 downto 0);

    A    : in std_logic_vector(15 downto 0);
    ADD  : in std_logic;
    B    : in std_logic_vector(15 downto 0);
    CI   : in std_logic
  );
end ADSU16_HXILINX_DLX;

architecture ADSU16_HXILINX_DLX_V of ADSU16_HXILINX_DLX is

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
  
end ADSU16_HXILINX_DLX_V;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity ADD_SUB32_MUSER_DLX is
   port ( A           : in    std_logic_vector (31 downto 0); 
          B           : in    std_logic_vector (31 downto 0); 
          SUB         : in    std_logic; 
          ADD_SUB_OUT : out   std_logic_vector (31 downto 0); 
          NEG         : out   std_logic);
end ADD_SUB32_MUSER_DLX;

architecture BEHAVIORAL of ADD_SUB32_MUSER_DLX is
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
   component ADSU16_HXILINX_DLX
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
   
   component M2_1_HXILINX_DLX
      port ( D0 : in    std_logic; 
             D1 : in    std_logic; 
             S0 : in    std_logic; 
             O  : out   std_logic);
   end component;
   
   attribute HU_SET of XLXI_1 : label is "XLXI_1_24";
   attribute HU_SET of XLXI_2 : label is "XLXI_2_25";
   attribute HU_SET of XLXI_3 : label is "XLXI_3_26";
   attribute HU_SET of XLXI_18 : label is "XLXI_18_27";
begin
   XLXI_1 : ADSU16_HXILINX_DLX
      port map (A(15 downto 0)=>A(31 downto 16),
                ADD=>ADD,
                B(15 downto 0)=>B(31 downto 16),
                CI=>XLXN_6,
                CO=>C1,
                OFL=>open,
                S(15 downto 0)=>UPPER_1(15 downto 0));
   
   XLXI_2 : ADSU16_HXILINX_DLX
      port map (A(15 downto 0)=>A(31 downto 16),
                ADD=>ADD,
                B(15 downto 0)=>B(31 downto 16),
                CI=>XLXN_7,
                CO=>C0,
                OFL=>open,
                S(15 downto 0)=>UPPER_0(15 downto 0));
   
   XLXI_3 : ADSU16_HXILINX_DLX
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
   
   XLXI_18 : M2_1_HXILINX_DLX
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

entity COMP_MUSER_DLX is
   port ( F        : in    std_logic_vector (2 downto 0); 
          NEG      : in    std_logic; 
          S        : in    std_logic_vector (31 downto 0); 
          COMP_OUT : out   std_logic);
end COMP_MUSER_DLX;

architecture BEHAVIORAL of COMP_MUSER_DLX is
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

entity ALU_ENV_MUSER_DLX is
   port ( A       : in    std_logic_vector (31 downto 0); 
          ADD     : in    std_logic; 
          ALUF    : in    std_logic_vector (2 downto 0); 
          B       : in    std_logic_vector (31 downto 0); 
          TEST    : in    std_logic; 
          ALU_OUT : out   std_logic_vector (31 downto 0));
end ALU_ENV_MUSER_DLX;

architecture BEHAVIORAL of ALU_ENV_MUSER_DLX is
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
   
   component COMP_MUSER_DLX
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
   
   component ADD_SUB32_MUSER_DLX
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
   
   XLXI_45 : COMP_MUSER_DLX
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
   
   XLXI_80 : ADD_SUB32_MUSER_DLX
      port map (A(31 downto 0)=>A(31 downto 0),
                B(31 downto 0)=>B(31 downto 0),
                SUB=>XLXN_191,
                ADD_SUB_OUT(31 downto 0)=>ADD_SUB_OUT(31 downto 0),
                NEG=>XLXN_199);
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity GPRenv_MUSER_DLX is
   port ( Aadr   : in    std_logic_vector (4 downto 0); 
          Badr   : in    std_logic_vector (4 downto 0); 
          C      : in    std_logic_vector (31 downto 0); 
          Cadr   : in    std_logic_vector (4 downto 0); 
          clk    : in    std_logic; 
          Dadr   : in    std_logic_vector (4 downto 0); 
          gpr_we : in    std_logic; 
          A      : out   std_logic_vector (31 downto 0); 
          A_EQZ  : out   std_logic; 
          B      : out   std_logic_vector (31 downto 0); 
          D      : out   std_logic_vector (31 downto 0));
end GPRenv_MUSER_DLX;

architecture BEHAVIORAL of GPRenv_MUSER_DLX is
   attribute BOX_TYPE   : string ;
   signal ram_we    : std_logic;
   signal sel_adr_A : std_logic_vector (4 downto 0);
   signal sel_adr_B : std_logic_vector (4 downto 0);
   signal sel_adr_D : std_logic_vector (4 downto 0);
   signal XLXN_118  : std_logic;
   signal A_DUMMY   : std_logic_vector (31 downto 0);
   component RAM32X32S
      port ( CLK : in    std_logic; 
             WE  : in    std_logic; 
             D   : in    std_logic_vector (31 downto 0); 
             ADD : in    std_logic_vector (4 downto 0); 
             DO  : out   std_logic_vector (31 downto 0));
   end component;
   
   component MUX5BIT
      port ( sel : in    std_logic; 
             A0  : in    std_logic_vector (4 downto 0); 
             A1  : in    std_logic_vector (4 downto 0); 
             O   : out   std_logic_vector (4 downto 0));
   end component;
   
   component OR5
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             I3 : in    std_logic; 
             I4 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR5 : component is "BLACK_BOX";
   
   component AND2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2 : component is "BLACK_BOX";
   
   component AEQZ
      port ( Din   : in    std_logic_vector (31 downto 0); 
             A_eqz : out   std_logic);
   end component;
   
begin
   A(31 downto 0) <= A_DUMMY(31 downto 0);
   XLXI_1 : RAM32X32S
      port map (ADD(4 downto 0)=>sel_adr_A(4 downto 0),
                CLK=>clk,
                D(31 downto 0)=>C(31 downto 0),
                WE=>ram_we,
                DO(31 downto 0)=>A_DUMMY(31 downto 0));
   
   XLXI_2 : RAM32X32S
      port map (ADD(4 downto 0)=>sel_adr_B(4 downto 0),
                CLK=>clk,
                D(31 downto 0)=>C(31 downto 0),
                WE=>ram_we,
                DO(31 downto 0)=>B(31 downto 0));
   
   XLXI_9 : MUX5BIT
      port map (A0(4 downto 0)=>Aadr(4 downto 0),
                A1(4 downto 0)=>Cadr(4 downto 0),
                sel=>gpr_we,
                O(4 downto 0)=>sel_adr_A(4 downto 0));
   
   XLXI_10 : MUX5BIT
      port map (A0(4 downto 0)=>Badr(4 downto 0),
                A1(4 downto 0)=>Cadr(4 downto 0),
                sel=>gpr_we,
                O(4 downto 0)=>sel_adr_B(4 downto 0));
   
   XLXI_13 : RAM32X32S
      port map (ADD(4 downto 0)=>sel_adr_D(4 downto 0),
                CLK=>clk,
                D(31 downto 0)=>C(31 downto 0),
                WE=>ram_we,
                DO(31 downto 0)=>D(31 downto 0));
   
   XLXI_17 : MUX5BIT
      port map (A0(4 downto 0)=>Dadr(4 downto 0),
                A1(4 downto 0)=>Cadr(4 downto 0),
                sel=>gpr_we,
                O(4 downto 0)=>sel_adr_D(4 downto 0));
   
   XLXI_18 : OR5
      port map (I0=>Cadr(4),
                I1=>Cadr(3),
                I2=>Cadr(2),
                I3=>Cadr(1),
                I4=>Cadr(0),
                O=>XLXN_118);
   
   XLXI_19 : AND2
      port map (I0=>XLXN_118,
                I1=>gpr_we,
                O=>ram_we);
   
   XLXI_20 : AEQZ
      port map (Din(31 downto 0)=>A_DUMMY(31 downto 0),
                A_eqz=>A_EQZ);
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity DATA_PATH_REGS_MUSER_DLX is
   port ( A_CE    : in    std_logic; 
          B_CE    : in    std_logic; 
          clk     : in    std_logic; 
          C_CE    : in    std_logic; 
          Dadr    : in    std_logic_vector (4 downto 0); 
          DI      : in    std_logic_vector (31 downto 0); 
          DINT    : in    std_logic_vector (31 downto 0); 
          GPR_WE  : in    std_logic; 
          IR_CE   : in    std_logic; 
          ITYPE   : in    std_logic; 
          JLINK   : in    std_logic; 
          MDR_CE  : in    std_logic; 
          MDR_SEL : in    std_logic; 
          PC_CE   : in    std_logic; 
          reset   : in    std_logic; 
          A       : out   std_logic_vector (31 downto 0); 
          AEQZ    : out   std_logic; 
          B       : out   std_logic_vector (31 downto 0); 
          D       : out   std_logic_vector (31 downto 0); 
          IR      : out   std_logic_vector (31 downto 0); 
          MDR     : out   std_logic_vector (31 downto 0); 
          OPCODE  : out   std_logic_vector (5 downto 0); 
          PC      : out   std_logic_vector (31 downto 0));
end DATA_PATH_REGS_MUSER_DLX;

architecture BEHAVIORAL of DATA_PATH_REGS_MUSER_DLX is
   attribute BOX_TYPE   : string ;
   signal A_reg_in : std_logic_vector (31 downto 0);
   signal B_reg_in : std_logic_vector (31 downto 0);
   signal Cadr     : std_logic_vector (4 downto 0);
   signal Cadr_0   : std_logic_vector (4 downto 0);
   signal XLXN_19  : std_logic_vector (31 downto 0);
   signal XLXN_183 : std_logic_vector (31 downto 0);
   signal IR_DUMMY : std_logic_vector (31 downto 0);
   component REG32CE
      port ( CLK  : in    std_logic; 
             CE   : in    std_logic; 
             DIN  : in    std_logic_vector (31 downto 0); 
             DOUT : out   std_logic_vector (31 downto 0));
   end component;
   
   component GPRenv_MUSER_DLX
      port ( C      : in    std_logic_vector (31 downto 0); 
             gpr_we : in    std_logic; 
             clk    : in    std_logic; 
             Aadr   : in    std_logic_vector (4 downto 0); 
             Badr   : in    std_logic_vector (4 downto 0); 
             Cadr   : in    std_logic_vector (4 downto 0); 
             Dadr   : in    std_logic_vector (4 downto 0); 
             A      : out   std_logic_vector (31 downto 0); 
             B      : out   std_logic_vector (31 downto 0); 
             A_EQZ  : out   std_logic; 
             D      : out   std_logic_vector (31 downto 0));
   end component;
   
   component MUX32bit
      port ( sel : in    std_logic; 
             A   : in    std_logic_vector (31 downto 0); 
             B   : in    std_logic_vector (31 downto 0); 
             O   : out   std_logic_vector (31 downto 0));
   end component;
   
   component REG32RST
      port ( CLK  : in    std_logic; 
             CE   : in    std_logic; 
             RST  : in    std_logic; 
             DIN  : in    std_logic_vector (31 downto 0); 
             DOUT : out   std_logic_vector (31 downto 0));
   end component;
   
   component MUX5BIT
      port ( sel : in    std_logic; 
             A0  : in    std_logic_vector (4 downto 0); 
             A1  : in    std_logic_vector (4 downto 0); 
             O   : out   std_logic_vector (4 downto 0));
   end component;
   
   component BUF6
      port ( Din  : in    std_logic_vector (5 downto 0); 
             Dout : out   std_logic_vector (5 downto 0));
   end component;
   
   component OR2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR2 : component is "BLACK_BOX";
   
begin
   IR(31 downto 0) <= IR_DUMMY(31 downto 0);
   XLXI_1 : REG32CE
      port map (CE=>C_CE,
                CLK=>clk,
                DIN(31 downto 0)=>DINT(31 downto 0),
                DOUT(31 downto 0)=>XLXN_19(31 downto 0));
   
   XLXI_5 : REG32CE
      port map (CE=>A_CE,
                CLK=>clk,
                DIN(31 downto 0)=>A_reg_in(31 downto 0),
                DOUT(31 downto 0)=>A(31 downto 0));
   
   XLXI_6 : REG32CE
      port map (CE=>B_CE,
                CLK=>clk,
                DIN(31 downto 0)=>B_reg_in(31 downto 0),
                DOUT(31 downto 0)=>B(31 downto 0));
   
   XLXI_18 : GPRenv_MUSER_DLX
      port map (Aadr(4 downto 0)=>IR_DUMMY(25 downto 21),
                Badr(4 downto 0)=>IR_DUMMY(20 downto 16),
                C(31 downto 0)=>XLXN_19(31 downto 0),
                Cadr(4 downto 0)=>Cadr(4 downto 0),
                clk=>clk,
                Dadr(4 downto 0)=>Dadr(4 downto 0),
                gpr_we=>GPR_WE,
                A(31 downto 0)=>A_reg_in(31 downto 0),
                A_EQZ=>AEQZ,
                B(31 downto 0)=>B_reg_in(31 downto 0),
                D(31 downto 0)=>D(31 downto 0));
   
   XLXI_20 : REG32CE
      port map (CE=>IR_CE,
                CLK=>clk,
                DIN(31 downto 0)=>DI(31 downto 0),
                DOUT(31 downto 0)=>IR_DUMMY(31 downto 0));
   
   XLXI_36 : REG32CE
      port map (CE=>MDR_CE,
                CLK=>clk,
                DIN(31 downto 0)=>XLXN_183(31 downto 0),
                DOUT(31 downto 0)=>MDR(31 downto 0));
   
   XLXI_40 : MUX32bit
      port map (A(31 downto 0)=>DINT(31 downto 0),
                B(31 downto 0)=>DI(31 downto 0),
                sel=>MDR_SEL,
                O(31 downto 0)=>XLXN_183(31 downto 0));
   
   XLXI_43 : REG32RST
      port map (CE=>PC_CE,
                CLK=>clk,
                DIN(31 downto 0)=>DINT(31 downto 0),
                RST=>reset,
                DOUT(31 downto 0)=>PC(31 downto 0));
   
   XLXI_63 : MUX5BIT
      port map (A0(4 downto 0)=>IR_DUMMY(15 downto 11),
                A1(4 downto 0)=>IR_DUMMY(20 downto 16),
                sel=>ITYPE,
                O(4 downto 0)=>Cadr_0(4 downto 0));
   
   XLXI_65 : BUF6
      port map (Din(5 downto 0)=>IR_DUMMY(31 downto 26),
                Dout(5 downto 0)=>OPCODE(5 downto 0));
   
   XLXI_67 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(1),
                O=>Cadr(1));
   
   XLXI_68 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(2),
                O=>Cadr(2));
   
   XLXI_69 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(3),
                O=>Cadr(3));
   
   XLXI_70 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(4),
                O=>Cadr(4));
   
   XLXI_71 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(0),
                O=>Cadr(0));
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity DLX_DATA_PATH_MUSER_DLX is
   port ( ADD     : in    std_logic; 
          ASEL    : in    std_logic; 
          A_CE    : in    std_logic; 
          B_CE    : in    std_logic; 
          clk     : in    std_logic; 
          C_CE    : in    std_logic; 
          Dadr    : in    std_logic_vector (4 downto 0); 
          DI      : in    std_logic_vector (31 downto 0); 
          DINTSEL : in    std_logic; 
          GPR_WE  : in    std_logic; 
          IR_CE   : in    std_logic; 
          ITYPE   : in    std_logic; 
          JLINK   : in    std_logic; 
          MAR_CE  : in    std_logic; 
          MDR_CE  : in    std_logic; 
          MDR_SEL : in    std_logic; 
          PC_CE   : in    std_logic; 
          reset   : in    std_logic; 
          SHIFT   : in    std_logic; 
          S1SEL   : in    std_logic_vector (1 downto 0); 
          S2SEL   : in    std_logic_vector (1 downto 0); 
          TEST    : in    std_logic; 
          AO      : out   std_logic_vector (31 downto 0); 
          bt      : out   std_logic; 
          DO      : out   std_logic_vector (31 downto 0); 
          Dreg    : out   std_logic_vector (31 downto 0); 
          ir5     : out   std_logic; 
          OPCODE  : out   std_logic_vector (5 downto 0));
end DLX_DATA_PATH_MUSER_DLX;

architecture BEHAVIORAL of DLX_DATA_PATH_MUSER_DLX is
   attribute BOX_TYPE   : string ;
   signal A            : std_logic_vector (31 downto 0);
   signal AEQZ         : std_logic;
   signal ALUF         : std_logic_vector (2 downto 0);
   signal ALU_OUT      : std_logic_vector (31 downto 0);
   signal B            : std_logic_vector (31 downto 0);
   signal const0       : std_logic_vector (31 downto 0);
   signal const1       : std_logic_vector (31 downto 0);
   signal DINT         : std_logic_vector (31 downto 0);
   signal fAO          : std_logic_vector (31 downto 0);
   signal IMM_ext      : std_logic_vector (31 downto 0);
   signal IR           : std_logic_vector (31 downto 0);
   signal MAR_OUT      : std_logic_vector (31 downto 0);
   signal PC           : std_logic_vector (31 downto 0);
   signal SHIFT_OUT    : std_logic_vector (31 downto 0);
   signal S1           : std_logic_vector (31 downto 0);
   signal S2           : std_logic_vector (31 downto 0);
   signal DO_DUMMY     : std_logic_vector (31 downto 0);
   signal OPCODE_DUMMY : std_logic_vector (5 downto 0);
   component MUX4_32bit
      port ( A0  : in    std_logic_vector (31 downto 0); 
             A1  : in    std_logic_vector (31 downto 0); 
             A2  : in    std_logic_vector (31 downto 0); 
             A3  : in    std_logic_vector (31 downto 0); 
             sel : in    std_logic_vector (1 downto 0); 
             O   : out   std_logic_vector (31 downto 0));
   end component;
   
   component DATA_PATH_REGS_MUSER_DLX
      port ( clk     : in    std_logic; 
             DI      : in    std_logic_vector (31 downto 0); 
             DINT    : in    std_logic_vector (31 downto 0); 
             A_CE    : in    std_logic; 
             B_CE    : in    std_logic; 
             C_CE    : in    std_logic; 
             PC_CE   : in    std_logic; 
             IR_CE   : in    std_logic; 
             MDR_CE  : in    std_logic; 
             MDR_SEL : in    std_logic; 
             Dadr    : in    std_logic_vector (4 downto 0); 
             reset   : in    std_logic; 
             GPR_WE  : in    std_logic; 
             ITYPE   : in    std_logic; 
             A       : out   std_logic_vector (31 downto 0); 
             B       : out   std_logic_vector (31 downto 0); 
             PC      : out   std_logic_vector (31 downto 0); 
             IR      : out   std_logic_vector (31 downto 0); 
             MDR     : out   std_logic_vector (31 downto 0); 
             D       : out   std_logic_vector (31 downto 0); 
             AEQZ    : out   std_logic; 
             OPCODE  : out   std_logic_vector (5 downto 0); 
             JLINK   : in    std_logic);
   end component;
   
   component Sxt_16_32
      port ( S16    : in    std_logic_vector (15 downto 0); 
             S32ext : out   std_logic_vector (31 downto 0));
   end component;
   
   component const_0_1
      port ( const0 : out   std_logic_vector (31 downto 0); 
             const1 : out   std_logic_vector (31 downto 0));
   end component;
   
   component SHIFT_ENV
      port ( clk   : in    std_logic; 
             shift : in    std_logic; 
             right : in    std_logic; 
             S     : in    std_logic_vector (31 downto 0); 
             SO    : out   std_logic_vector (31 downto 0));
   end component;
   
   component MUX3BIT
      port ( sel : in    std_logic; 
             A0  : in    std_logic_vector (2 downto 0); 
             A1  : in    std_logic_vector (2 downto 0); 
             O   : out   std_logic_vector (2 downto 0));
   end component;
   
   component MUX32bit
      port ( sel : in    std_logic; 
             A   : in    std_logic_vector (31 downto 0); 
             B   : in    std_logic_vector (31 downto 0); 
             O   : out   std_logic_vector (31 downto 0));
   end component;
   
   component REG32CE
      port ( CLK  : in    std_logic; 
             CE   : in    std_logic; 
             DIN  : in    std_logic_vector (31 downto 0); 
             DOUT : out   std_logic_vector (31 downto 0));
   end component;
   
   component MMU
      port ( AO     : in    std_logic_vector (23 downto 0); 
             MMU_AO : out   std_logic_vector (31 downto 0));
   end component;
   
   component XOR2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of XOR2 : component is "BLACK_BOX";
   
   component BUF
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of BUF : component is "BLACK_BOX";
   
   component ALU_ENV_MUSER_DLX
      port ( ADD     : in    std_logic; 
             ALUF    : in    std_logic_vector (2 downto 0); 
             TEST    : in    std_logic; 
             A       : in    std_logic_vector (31 downto 0); 
             B       : in    std_logic_vector (31 downto 0); 
             ALU_OUT : out   std_logic_vector (31 downto 0));
   end component;
   
begin
   DO(31 downto 0) <= DO_DUMMY(31 downto 0);
   OPCODE(5 downto 0) <= OPCODE_DUMMY(5 downto 0);
   XLXI_13 : MUX4_32bit
      port map (A0(31 downto 0)=>PC(31 downto 0),
                A1(31 downto 0)=>A(31 downto 0),
                A2(31 downto 0)=>B(31 downto 0),
                A3(31 downto 0)=>DO_DUMMY(31 downto 0),
                sel(1 downto 0)=>S1SEL(1 downto 0),
                O(31 downto 0)=>S1(31 downto 0));
   
   XLXI_14 : MUX4_32bit
      port map (A0(31 downto 0)=>B(31 downto 0),
                A1(31 downto 0)=>IMM_ext(31 downto 0),
                A2(31 downto 0)=>const0(31 downto 0),
                A3(31 downto 0)=>const1(31 downto 0),
                sel(1 downto 0)=>S2SEL(1 downto 0),
                O(31 downto 0)=>S2(31 downto 0));
   
   XLXI_21 : DATA_PATH_REGS_MUSER_DLX
      port map (A_CE=>A_CE,
                B_CE=>B_CE,
                clk=>clk,
                C_CE=>C_CE,
                Dadr(4 downto 0)=>Dadr(4 downto 0),
                DI(31 downto 0)=>DI(31 downto 0),
                DINT(31 downto 0)=>DINT(31 downto 0),
                GPR_WE=>GPR_WE,
                IR_CE=>IR_CE,
                ITYPE=>ITYPE,
                JLINK=>JLINK,
                MDR_CE=>MDR_CE,
                MDR_SEL=>MDR_SEL,
                PC_CE=>PC_CE,
                reset=>reset,
                A(31 downto 0)=>A(31 downto 0),
                AEQZ=>AEQZ,
                B(31 downto 0)=>B(31 downto 0),
                D(31 downto 0)=>Dreg(31 downto 0),
                IR(31 downto 0)=>IR(31 downto 0),
                MDR(31 downto 0)=>DO_DUMMY(31 downto 0),
                OPCODE(5 downto 0)=>OPCODE_DUMMY(5 downto 0),
                PC(31 downto 0)=>PC(31 downto 0));
   
   XLXI_22 : Sxt_16_32
      port map (S16(15 downto 0)=>IR(15 downto 0),
                S32ext(31 downto 0)=>IMM_ext(31 downto 0));
   
   XLXI_23 : const_0_1
      port map (const0(31 downto 0)=>const0(31 downto 0),
                const1(31 downto 0)=>const1(31 downto 0));
   
   XLXI_25 : SHIFT_ENV
      port map (clk=>clk,
                right=>IR(1),
                S(31 downto 0)=>S1(31 downto 0),
                shift=>SHIFT,
                SO(31 downto 0)=>SHIFT_OUT(31 downto 0));
   
   XLXI_28 : MUX3BIT
      port map (A0(2 downto 0)=>IR(2 downto 0),
                A1(2 downto 0)=>IR(28 downto 26),
                sel=>ITYPE,
                O(2 downto 0)=>ALUF(2 downto 0));
   
   XLXI_29 : MUX32bit
      port map (A(31 downto 0)=>ALU_OUT(31 downto 0),
                B(31 downto 0)=>SHIFT_OUT(31 downto 0),
                sel=>DINTSEL,
                O(31 downto 0)=>DINT(31 downto 0));
   
   XLXI_33 : REG32CE
      port map (CE=>MAR_CE,
                CLK=>clk,
                DIN(31 downto 0)=>DINT(31 downto 0),
                DOUT(31 downto 0)=>MAR_OUT(31 downto 0));
   
   XLXI_58 : MUX32bit
      port map (A(31 downto 0)=>PC(31 downto 0),
                B(31 downto 0)=>MAR_OUT(31 downto 0),
                sel=>ASEL,
                O(31 downto 0)=>fAO(31 downto 0));
   
   XLXI_63 : MMU
      port map (AO(23 downto 0)=>fAO(23 downto 0),
                MMU_AO(31 downto 0)=>AO(31 downto 0));
   
   XLXI_64 : XOR2
      port map (I0=>AEQZ,
                I1=>OPCODE_DUMMY(0),
                O=>bt);
   
   XLXI_68 : BUF
      port map (I=>IR(5),
                O=>ir5);
   
   XLXI_69 : ALU_ENV_MUSER_DLX
      port map (A(31 downto 0)=>S1(31 downto 0),
                ADD=>ADD,
                ALUF(2 downto 0)=>ALUF(2 downto 0),
                B(31 downto 0)=>S2(31 downto 0),
                TEST=>TEST,
                ALU_OUT(31 downto 0)=>ALU_OUT(31 downto 0));
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity DLX is
   port ( ack_n   : in    std_logic; 
          clk     : in    std_logic; 
          DI      : in    std_logic_vector (31 downto 0); 
          reset   : in    std_logic; 
          step_en : in    std_logic; 
          AO      : out   std_logic_vector (31 downto 0); 
          as_n    : out   std_logic; 
          DO      : out   std_logic_vector (31 downto 0); 
          wr_n    : out   std_logic);
end DLX;

architecture BEHAVIORAL of DLX is
   signal ADD       : std_logic;
   signal ASEL      : std_logic;
   signal A_ce      : std_logic;
   signal bt        : std_logic;
   signal busy      : std_logic;
   signal B_ce      : std_logic;
   signal C_ce      : std_logic;
   signal DINT_sel  : std_logic;
   signal DLX_state : std_logic_vector (4 downto 0);
   signal GPR_we    : std_logic;
   signal in_init   : std_logic;
   signal IR_ce     : std_logic;
   signal ir5       : std_logic;
   signal ITYPE     : std_logic;
   signal JLINK     : std_logic;
   signal MAC_state : std_logic_vector (1 downto 0);
   signal MAR_ce    : std_logic;
   signal MDR_ce    : std_logic;
   signal MDR_sel   : std_logic;
   signal mr        : std_logic;
   signal mw        : std_logic;
   signal OPCODE    : std_logic_vector (5 downto 0);
   signal PC_ce     : std_logic;
   signal SHIFT     : std_logic;
   signal stop_n    : std_logic;
   signal S1SEL     : std_logic_vector (1 downto 0);
   signal S2SEL     : std_logic_vector (1 downto 0);
   signal TEST      : std_logic;
   signal XLXN_185  : std_logic_vector (4 downto 0);
   signal XLXN_191  : std_logic_vector (31 downto 0);
   component DLX_Control
      port ( clk     : in    std_logic; 
             reset   : in    std_logic; 
             step_en : in    std_logic; 
             busy    : in    std_logic; 
             ir5     : in    std_logic; 
             bt      : in    std_logic; 
             opcode  : in    std_logic_vector (5 downto 0); 
             state   : inout std_logic_vector (4 downto 0); 
             in_init : out   std_logic; 
             mr      : out   std_logic; 
             mw      : out   std_logic; 
             Ace     : out   std_logic; 
             Bce     : out   std_logic; 
             Cce     : out   std_logic; 
             GPRwe   : out   std_logic; 
             PCce    : out   std_logic; 
             IRce    : out   std_logic; 
             MARce   : out   std_logic; 
             MDRce   : out   std_logic; 
             DINTSEL : out   std_logic; 
             MDRSEL  : out   std_logic; 
             ASEL    : out   std_logic; 
             ADD     : out   std_logic; 
             TEST    : out   std_logic; 
             SHIFT   : out   std_logic; 
             ITYPE   : out   std_logic; 
             JLINK   : out   std_logic; 
             S1SEL0  : out   std_logic; 
             S1SEL1  : out   std_logic; 
             S2SEL0  : out   std_logic; 
             S2SEL1  : out   std_logic);
   end component;
   
   component MAC
      port ( clk    : in    std_logic; 
             rst    : in    std_logic; 
             mr     : in    std_logic; 
             mw     : in    std_logic; 
             ack_n  : in    std_logic; 
             State  : inout std_logic_vector (1 downto 0); 
             as_n   : out   std_logic; 
             wr_n   : out   std_logic; 
             busy   : out   std_logic; 
             stop_n : out   std_logic);
   end component;
   
   component DLX_DATA_PATH_MUSER_DLX
      port ( GPR_WE  : in    std_logic; 
             ITYPE   : in    std_logic; 
             IR_CE   : in    std_logic; 
             MDR_CE  : in    std_logic; 
             C_CE    : in    std_logic; 
             PC_CE   : in    std_logic; 
             A_CE    : in    std_logic; 
             B_CE    : in    std_logic; 
             S1SEL   : in    std_logic_vector (1 downto 0); 
             S2SEL   : in    std_logic_vector (1 downto 0); 
             MDR_SEL : in    std_logic; 
             reset   : in    std_logic; 
             DI      : in    std_logic_vector (31 downto 0); 
             clk     : in    std_logic; 
             Dadr    : in    std_logic_vector (4 downto 0); 
             TEST    : in    std_logic; 
             SHIFT   : in    std_logic; 
             DINTSEL : in    std_logic; 
             ADD     : in    std_logic; 
             MAR_CE  : in    std_logic; 
             ASEL    : in    std_logic; 
             JLINK   : in    std_logic; 
             DO      : out   std_logic_vector (31 downto 0); 
             AO      : out   std_logic_vector (31 downto 0); 
             OPCODE  : out   std_logic_vector (5 downto 0); 
             Dreg    : out   std_logic_vector (31 downto 0); 
             bt      : out   std_logic; 
             ir5     : out   std_logic);
   end component;
   
begin
   XLXI_1 : DLX_Control
      port map (bt=>bt,
                busy=>busy,
                clk=>clk,
                ir5=>ir5,
                opcode(5 downto 0)=>OPCODE(5 downto 0),
                reset=>reset,
                step_en=>step_en,
                Ace=>A_ce,
                ADD=>ADD,
                ASEL=>ASEL,
                Bce=>B_ce,
                Cce=>C_ce,
                DINTSEL=>DINT_sel,
                GPRwe=>GPR_we,
                in_init=>in_init,
                IRce=>IR_ce,
                ITYPE=>ITYPE,
                JLINK=>JLINK,
                MARce=>MAR_ce,
                MDRce=>MDR_ce,
                MDRSEL=>MDR_sel,
                mr=>mr,
                mw=>mw,
                PCce=>PC_ce,
                SHIFT=>SHIFT,
                S1SEL0=>S1SEL(0),
                S1SEL1=>S1SEL(1),
                S2SEL0=>S2SEL(0),
                S2SEL1=>S2SEL(1),
                TEST=>TEST,
                state(4 downto 0)=>DLX_state(4 downto 0));
   
   XLXI_4 : MAC
      port map (ack_n=>ack_n,
                clk=>clk,
                mr=>mr,
                mw=>mw,
                rst=>reset,
                as_n=>as_n,
                busy=>busy,
                stop_n=>stop_n,
                wr_n=>wr_n,
                State(1 downto 0)=>MAC_state(1 downto 0));
   
   XLXI_5 : DLX_DATA_PATH_MUSER_DLX
      port map (ADD=>ADD,
                ASEL=>ASEL,
                A_CE=>A_ce,
                B_CE=>B_ce,
                clk=>clk,
                C_CE=>C_ce,
                Dadr(4 downto 0)=>XLXN_185(4 downto 0),
                DI(31 downto 0)=>DI(31 downto 0),
                DINTSEL=>DINT_sel,
                GPR_WE=>GPR_we,
                IR_CE=>IR_ce,
                ITYPE=>ITYPE,
                JLINK=>JLINK,
                MAR_CE=>MAR_ce,
                MDR_CE=>MDR_ce,
                MDR_SEL=>MDR_sel,
                PC_CE=>PC_ce,
                reset=>reset,
                SHIFT=>SHIFT,
                S1SEL(1 downto 0)=>S1SEL(1 downto 0),
                S2SEL(1 downto 0)=>S2SEL(1 downto 0),
                TEST=>TEST,
                AO(31 downto 0)=>AO(31 downto 0),
                bt=>bt,
                DO(31 downto 0)=>DO(31 downto 0),
                Dreg(31 downto 0)=>XLXN_191(31 downto 0),
                ir5=>ir5,
                OPCODE(5 downto 0)=>OPCODE(5 downto 0));
   
end BEHAVIORAL;


