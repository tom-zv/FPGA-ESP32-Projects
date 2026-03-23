--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : COMP.vhf
-- /___/   /\     Timestamp : 06/21/2022 19:13:15
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/COMP.vhf" -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/COMP.sch"
--Design Name: COMP
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity COMP is
   port ( F        : in    std_logic_vector (2 downto 0); 
          NEG      : in    std_logic; 
          S        : in    std_logic_vector (31 downto 0); 
          COMP_OUT : out   std_logic);
end COMP;

architecture BEHAVIORAL of COMP is
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


