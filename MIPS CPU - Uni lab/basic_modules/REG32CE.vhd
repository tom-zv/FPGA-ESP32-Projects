----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:23:33 07/12/2015 
-- Design Name: 
-- Module Name:    REG32CE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REG32CE is
    Port ( CLK : in  STD_LOGIC;
           CE : in  STD_LOGIC;
           DIN : in  STD_LOGIC_VECTOR (31 downto 0);
           DOUT : out  STD_LOGIC_VECTOR (31 downto 0) := X"00000000" );
end REG32CE;

architecture Behavioral of REG32CE is

begin

main: process(CLK,CE)
begin
  if (clk'event and clk='1') then
      if ce = '1'            then DOUT <= DIN;
		                       
	   end if;
   end if;
 end process main;

end Behavioral;

