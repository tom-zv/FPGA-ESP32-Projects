-- VHDL model created from C:\Xilinx\spartan2\data\drawing\ram32x8s.sch - Thu Oct 07 17:42:22 2004


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on

entity RAM32X8S_MXILINX_slave_monitor is
   port ( A0   : in    std_logic; 
          A1   : in    std_logic; 
          A2   : in    std_logic; 
          A3   : in    std_logic; 
          A4   : in    std_logic; 
          D    : in    std_logic_vector (7 downto 0); 
          WCLK : in    std_logic; 
          WE   : in    std_logic; 
          O    : out   std_logic_vector (7 downto 0));
end RAM32X8S_MXILINX_slave_monitor;

architecture BEHAVIORAL of RAM32X8S_MXILINX_slave_monitor is
   attribute INIT       : STRING ;
   attribute BOX_TYPE   : STRING ;
   component RAM32X1S
      -- synopsys translate_off
      generic( INIT : bit_vector :=  x"00000000");
      -- synopsys translate_on
      port ( A0   : in    std_logic; 
             A1   : in    std_logic; 
             A2   : in    std_logic; 
             A3   : in    std_logic; 
             A4   : in    std_logic; 
             D    : in    std_logic; 
             WCLK : in    std_logic; 
             WE   : in    std_logic; 
             O    : out   std_logic);
   end component;
   attribute INIT of RAM32X1S : COMPONENT is "00000000";
   attribute BOX_TYPE of RAM32X1S : COMPONENT is "BLACK_BOX";
   
begin
   O0 : RAM32X1S
      port map (A0=>A0, A1=>A1, A2=>A2, A3=>A3, A4=>A4, D=>D(0), WCLK=>WCLK,
            WE=>WE, O=>O(0));
   
   O1 : RAM32X1S
      port map (A0=>A0, A1=>A1, A2=>A2, A3=>A3, A4=>A4, D=>D(1), WCLK=>WCLK,
            WE=>WE, O=>O(1));
   
   O2 : RAM32X1S
      port map (A0=>A0, A1=>A1, A2=>A2, A3=>A3, A4=>A4, D=>D(2), WCLK=>WCLK,
            WE=>WE, O=>O(2));
   
   O3 : RAM32X1S
      port map (A0=>A0, A1=>A1, A2=>A2, A3=>A3, A4=>A4, D=>D(3), WCLK=>WCLK,
            WE=>WE, O=>O(3));
   
   O4 : RAM32X1S
      port map (A0=>A0, A1=>A1, A2=>A2, A3=>A3, A4=>A4, D=>D(4), WCLK=>WCLK,
            WE=>WE, O=>O(4));
   
   O5 : RAM32X1S
      port map (A0=>A0, A1=>A1, A2=>A2, A3=>A3, A4=>A4, D=>D(5), WCLK=>WCLK,
            WE=>WE, O=>O(5));
   
   O6 : RAM32X1S
      port map (A0=>A0, A1=>A1, A2=>A2, A3=>A3, A4=>A4, D=>D(6), WCLK=>WCLK,
            WE=>WE, O=>O(6));
   
   O7 : RAM32X1S
      port map (A0=>A0, A1=>A1, A2=>A2, A3=>A3, A4=>A4, D=>D(7), WCLK=>WCLK,
            WE=>WE, O=>O(7));
   
end BEHAVIORAL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM32X32S is
    Port ( CLK : in std_logic;
           WE : in std_logic;
           D : in std_logic_vector(31 downto 0);
           ADD : in std_logic_vector(4 downto 0);
           DO : out std_logic_vector(31 downto 0));
end RAM32X32S;

architecture Behavioral of RAM32X32S is

   component RAM32X8S_MXILINX_slave_monitor
      port ( A0   : in    std_logic; 
             A1   : in    std_logic; 
             A2   : in    std_logic; 
             A3   : in    std_logic; 
             A4   : in    std_logic; 
             D    : in    std_logic_vector (7 downto 0); 
             WCLK : in    std_logic; 
             WE   : in    std_logic; 
             O    : out   std_logic_vector (7 downto 0));
   end component;

begin

ram00 : RAM32X8S_MXILINX_slave_monitor port map (	
						ADD(0),
						ADD(1),
						ADD(2),
						ADD(3),
						ADD(4),
						D(7 downto 0),
						CLK,
						WE,
						DO(7 downto 0));

ram01 : RAM32X8S_MXILINX_slave_monitor port map (	
						ADD(0),
						ADD(1),
						ADD(2),
						ADD(3),
						ADD(4),
						D(15 downto 8),
						CLK,
						WE,
						DO(15 downto 8));

ram10 : RAM32X8S_MXILINX_slave_monitor port map (	
						ADD(0),
						ADD(1),
						ADD(2),
						ADD(3),
						ADD(4),
						D(23 downto 16),
						CLK,
						WE,
						DO(23 downto 16));

ram11 : RAM32X8S_MXILINX_slave_monitor port map (	
						ADD(0),
						ADD(1),
						ADD(2),
						ADD(3),
						ADD(4),
						D(31 downto 24),
						CLK,
						WE,
						DO(31 downto 24));


end Behavioral;
