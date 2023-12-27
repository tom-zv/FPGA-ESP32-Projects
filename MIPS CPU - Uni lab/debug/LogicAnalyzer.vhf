--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : LogicAnalyzer.vhf
-- /___/   /\     Timestamp : 03/28/2022 15:50:50
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl E:/adlx/B4/Home_S25/LogicAnalyzer.vhf -w E:/adlx/B4/Home_S25/LogicAnalyzer.sch
--Design Name: LogicAnalyzer
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--
----- CELL FD8CE_HXILINX_LogicAnalyzer -----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FD8CE_HXILINX_LogicAnalyzer is
port (
    Q   : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    C   : in STD_LOGIC;
    CE  : in STD_LOGIC;
    CLR : in STD_LOGIC;
    D   : in STD_LOGIC_VECTOR(7 downto 0)
    );
end FD8CE_HXILINX_LogicAnalyzer;

architecture Behavioral of FD8CE_HXILINX_LogicAnalyzer is

begin

process(C, CLR)
begin
  if (CLR='1') then
    Q <= (others => '0');
  elsif (C'event and C = '1') then
    if (CE='1') then 
      Q <= D;
    end if;
  end if;
end process;


end Behavioral;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity LogicAnalyzer is
   port ( AI      : in    std_logic_vector (4 downto 0); 
          clk     : in    std_logic; 
          in_init : in    std_logic; 
          Sample  : in    std_logic_vector (31 downto 0); 
          step_en : in    std_logic; 
          stop_n  : in    std_logic; 
          LA_RAM  : out   std_logic_vector (31 downto 0); 
          status  : out   std_logic_vector (7 downto 0));
end LogicAnalyzer;

architecture BEHAVIORAL of LogicAnalyzer is
   attribute HU_SET     : string ;
   attribute BOX_TYPE   : string ;
   signal CNT     : std_logic_vector (7 downto 0);
   signal LA_RUN  : std_logic;
   signal LA_WE   : std_logic;
   signal STS_CE  : std_logic;
   signal XLXN_12 : std_logic;
   signal XLXN_17 : std_logic_vector (4 downto 0);
   signal XLXN_78 : std_logic;
   signal XLXN_79 : std_logic;
   signal XLXN_94 : std_logic;
   signal XLXN_96 : std_logic;
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
   
   component CNT5
      port ( clk   : in    std_logic; 
             ce    : in    std_logic; 
             reset : in    std_logic; 
             cnt_o : out   std_logic_vector (4 downto 0));
   end component;
   
   component FD8CE_HXILINX_LogicAnalyzer
      port ( C   : in    std_logic; 
             CE  : in    std_logic; 
             CLR : in    std_logic; 
             D   : in    std_logic_vector (7 downto 0); 
             Q   : out   std_logic_vector (7 downto 0));
   end component;
   
   component OR2B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR2B1 : component is "BLACK_BOX";
   
   component FD
      generic( INIT : bit :=  '0');
      port ( C : in    std_logic; 
             D : in    std_logic; 
             Q : out   std_logic);
   end component;
   attribute BOX_TYPE of FD : component is "BLACK_BOX";
   
   component OR2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR2 : component is "BLACK_BOX";
   
   component AND2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2 : component is "BLACK_BOX";
   
   component AND3B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND3B1 : component is "BLACK_BOX";
   
   component AND2B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2B1 : component is "BLACK_BOX";
   
   component GND
      port ( G : out   std_logic);
   end component;
   attribute BOX_TYPE of GND : component is "BLACK_BOX";
   
   attribute HU_SET of XLXI_4 : label is "XLXI_4_0";
begin
   XLXI_1 : RAM32X32S
      port map (ADD(4 downto 0)=>XLXN_17(4 downto 0),
                CLK=>clk,
                D(31 downto 0)=>Sample(31 downto 0),
                WE=>LA_WE,
                DO(31 downto 0)=>LA_RAM(31 downto 0));
   
   XLXI_2 : MUX5BIT
      port map (A0(4 downto 0)=>AI(4 downto 0),
                A1(4 downto 0)=>CNT(4 downto 0),
                sel=>LA_RUN,
                O(4 downto 0)=>XLXN_17(4 downto 0));
   
   XLXI_3 : CNT5
      port map (ce=>LA_WE,
                clk=>clk,
                reset=>STS_CE,
                cnt_o(4 downto 0)=>CNT(4 downto 0));
   
   XLXI_4 : FD8CE_HXILINX_LogicAnalyzer
      port map (C=>clk,
                CE=>STS_CE,
                CLR=>XLXN_12,
                D(7 downto 0)=>CNT(7 downto 0),
                Q(7 downto 0)=>status(7 downto 0));
   
   XLXI_16 : OR2B1
      port map (I0=>in_init,
                I1=>step_en,
                O=>XLXN_78);
   
   XLXI_17 : FD
      port map (C=>clk,
                D=>XLXN_78,
                Q=>XLXN_79);
   
   XLXI_18 : OR2
      port map (I0=>XLXN_79,
                I1=>step_en,
                O=>LA_RUN);
   
   XLXI_19 : AND2
      port map (I0=>stop_n,
                I1=>LA_RUN,
                O=>LA_WE);
   
   XLXI_20 : AND3B1
      port map (I0=>step_en,
                I1=>LA_RUN,
                I2=>in_init,
                O=>XLXN_96);
   
   XLXI_21 : FD
      port map (C=>clk,
                D=>XLXN_94,
                Q=>STS_CE);
   
   XLXI_26 : AND2B1
      port map (I0=>STS_CE,
                I1=>XLXN_96,
                O=>XLXN_94);
   
   XLXI_28 : GND
      port map (G=>XLXN_12);
   
   XLXI_29 : GND
      port map (G=>CNT(5));
   
   XLXI_30 : GND
      port map (G=>CNT(6));
   
   XLXI_31 : GND
      port map (G=>CNT(7));
   
end BEHAVIORAL;


