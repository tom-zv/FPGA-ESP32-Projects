----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:34:08 04/04/2022 
-- Design Name: 
-- Module Name:    CNT32 - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CNT32 is
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           cnt_o : out  STD_LOGIC_VECTOR (31 downto 0));
end CNT32;

architecture Behavioral of CNT32 is
	signal cnt_s: std_logic_vector(31 downto 0) := X"00000000";
	
begin

main: process(clk)
begin
  if (clk'event and clk='1') then
      
	 if reset ='1'
	    then cnt_s <= X"00000000";
	    elsif ce = '1' then cnt_s <= cnt_s + 1;
				    else cnt_s <= cnt_s;
	 end if;
   end if;
   end process main;

   cnt_o<=cnt_s;



end Behavioral;

