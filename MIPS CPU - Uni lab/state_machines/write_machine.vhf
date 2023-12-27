--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : write_machine.vhf
-- /___/   /\     Timestamp : 04/27/2022 15:29:51
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #5/Projects/Home_S25/write_machine.vhf" -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #5/Projects/Home_S25/write_machine.sch"
--Design Name: write_machine
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

entity write_machine is
   port ( ack_n   : in    std_logic; 
          clk     : in    std_logic; 
          reset   : in    std_logic; 
          step_en : in    std_logic; 
          AO      : out   std_logic_vector (31 downto 0); 
          AS_N    : out   std_logic; 
          in_init : out   std_logic; 
          stop_n  : out   std_logic; 
          WDO     : out   std_logic_vector (31 downto 0));
end write_machine;

architecture BEHAVIORAL of write_machine is
   signal ce      : std_logic;
   component const_data
      port ( const : out   std_logic_vector (31 downto 0));
   end component;
   
   component CNT32
      port ( clk   : in    std_logic; 
             ce    : in    std_logic; 
             reset : in    std_logic; 
             cnt_o : out   std_logic_vector (31 downto 0));
   end component;
   
   component write_state_machine
      port ( clk     : in    std_logic; 
             reset   : in    std_logic; 
             step_en : in    std_logic; 
             ack_n   : in    std_logic; 
             in_init : out   std_logic; 
             AS_N    : out   std_logic; 
             stop_n  : out   std_logic; 
             ce      : out   std_logic);
   end component;
   
begin
   XLXI_1 : const_data
      port map (const(31 downto 0)=>WDO(31 downto 0));
   
   XLXI_3 : CNT32
      port map (ce=>ce,
                clk=>clk,
                reset=>reset,
                cnt_o(31 downto 0)=>AO(31 downto 0));
   
   XLXI_5 : write_state_machine
      port map (ack_n=>ack_n,
                clk=>clk,
                reset=>reset,
                step_en=>step_en,
                AS_N=>AS_N,
                ce=>ce,
                in_init=>in_init,
                stop_n=>stop_n);
   
end BEHAVIORAL;


