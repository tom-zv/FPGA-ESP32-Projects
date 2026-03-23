--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : IR_env.vhf
-- /___/   /\     Timestamp : 05/16/2022 02:22:08
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #6/Home_S25/IR_env.vhf" -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #6/Home_S25/IR_env.sch"
--Design Name: IR_env
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

entity IR_env is
   port ( CE     : in    std_logic; 
          clk    : in    std_logic; 
          DI     : in    std_logic_vector (31 downto 0); 
          Aadr   : out   std_logic_vector (4 downto 0); 
          Badr   : out   std_logic_vector (4 downto 0); 
          Cadr   : out   std_logic_vector (4 downto 0); 
          IMM    : out   std_logic_vector (15 downto 0); 
          OPCODE : out   std_logic_vector (5 downto 0));
end IR_env;

architecture BEHAVIORAL of IR_env is
   signal RDO    : std_logic_vector (31 downto 0);
   component REG32CE
      port ( CLK  : in    std_logic; 
             CE   : in    std_logic; 
             DIN  : in    std_logic_vector (31 downto 0); 
             DOUT : out   std_logic_vector (31 downto 0));
   end component;
   
   component BUF5
      port ( Din  : in    std_logic_vector (4 downto 0); 
             Dout : out   std_logic_vector (4 downto 0));
   end component;
   
   component BUF16
      port ( Din  : in    std_logic_vector (15 downto 0); 
             Dout : out   std_logic_vector (15 downto 0));
   end component;
   
   component BUF6
      port ( Din  : in    std_logic_vector (5 downto 0); 
             Dout : out   std_logic_vector (5 downto 0));
   end component;
   
begin
   XLXI_1 : REG32CE
      port map (CE=>CE,
                CLK=>clk,
                DIN(31 downto 0)=>DI(31 downto 0),
                DOUT(31 downto 0)=>RDO(31 downto 0));
   
   XLXI_2 : BUF5
      port map (Din(4 downto 0)=>RDO(20 downto 16),
                Dout(4 downto 0)=>Cadr(4 downto 0));
   
   XLXI_3 : BUF5
      port map (Din(4 downto 0)=>RDO(20 downto 16),
                Dout(4 downto 0)=>Badr(4 downto 0));
   
   XLXI_8 : BUF5
      port map (Din(4 downto 0)=>RDO(25 downto 21),
                Dout(4 downto 0)=>Aadr(4 downto 0));
   
   XLXI_10 : BUF16
      port map (Din(15 downto 0)=>RDO(15 downto 0),
                Dout(15 downto 0)=>IMM(15 downto 0));
   
   XLXI_11 : BUF6
      port map (Din(5 downto 0)=>RDO(31 downto 26),
                Dout(5 downto 0)=>OPCODE(5 downto 0));
   
end BEHAVIORAL;


