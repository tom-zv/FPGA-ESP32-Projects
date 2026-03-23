--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : simple_slave_drc.vhf
-- /___/   /\     Timestamp : 03/13/2022 17:11:32
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: E:\Programs\14.7\ISE_DS\ISE\bin\nt64\unwrapped\sch2hdl.exe -intstyle ise -family spartan6 -flat -suppress -vhdl simple_slave_drc.vhf -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/ISE Projects/Home_S25/simple_slave.sch"
--Design Name: simple_slave
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

entity simple_slave is
   port ( A        : in    std_logic_vector (31 downto 0); 
          AI       : in    std_logic_vector (9 downto 0); 
          B        : in    std_logic_vector (31 downto 0); 
          C        : in    std_logic_vector (31 downto 0); 
          Card_sel : in    std_logic; 
          clk      : in    std_logic; 
          D        : in    std_logic_vector (31 downto 0); 
          WR_N     : in    std_logic; 
          reg_adr  : out   std_logic_vector (4 downto 0); 
          SACK_N   : out   std_logic; 
          SDO      : out   std_logic_vector (31 downto 0));
end simple_slave;

architecture BEHAVIORAL of simple_slave is
   attribute BOX_TYPE   : string ;
   signal XLXN_61  : std_logic;
   signal XLXN_83  : std_logic;
   signal XLXN_87  : std_logic;
   signal XLXN_92  : std_logic;
   component MUX4_32bit
      port ( A0  : in    std_logic_vector (31 downto 0); 
             A1  : in    std_logic_vector (31 downto 0); 
             A2  : in    std_logic_vector (31 downto 0); 
             A3  : in    std_logic_vector (31 downto 0); 
             sel : in    std_logic_vector (1 downto 0); 
             O   : out   std_logic_vector (31 downto 0));
   end component;
   
   component BUF5
      port ( Din  : in    std_logic_vector (4 downto 0); 
             Dout : out   std_logic_vector (4 downto 0));
   end component;
   
   component AND3
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND3 : component is "BLACK_BOX";
   
   component FD
      generic( INIT : bit :=  '0');
      port ( C : in    std_logic; 
             D : in    std_logic; 
             Q : out   std_logic);
   end component;
   attribute BOX_TYPE of FD : component is "BLACK_BOX";
   
   component NAND2B1
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of NAND2B1 : component is "BLACK_BOX";
   
   component AND3B3
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND3B3 : component is "BLACK_BOX";
   
begin
   XLXI_1 : MUX4_32bit
      port map (A0(31 downto 0)=>A(31 downto 0),
                A1(31 downto 0)=>B(31 downto 0),
                A2(31 downto 0)=>C(31 downto 0),
                A3(31 downto 0)=>D(31 downto 0),
                sel(1 downto 0)=>AI(6 downto 5),
                O(31 downto 0)=>SDO(31 downto 0));
   
   XLXI_2 : BUF5
      port map (Din(4 downto 0)=>AI(4 downto 0),
                Dout(4 downto 0)=>reg_adr(4 downto 0));
   
   XLXI_7 : AND3
      port map (I0=>WR_N,
                I1=>Card_sel,
                I2=>XLXN_61,
                O=>XLXN_92);
   
   XLXI_10 : FD
      port map (C=>clk,
                D=>XLXN_92,
                Q=>XLXN_83);
   
   XLXI_12 : FD
      port map (C=>clk,
                D=>XLXN_83,
                Q=>XLXN_87);
   
   XLXI_18 : NAND2B1
      port map (I0=>XLXN_87,
                I1=>XLXN_83,
                O=>SACK_N);
   
   XLXI_20 : AND3B3
      port map (I0=>AI(7),
                I1=>AI(8),
                I2=>AI(9),
                O=>XLXN_61);
   
end BEHAVIORAL;


