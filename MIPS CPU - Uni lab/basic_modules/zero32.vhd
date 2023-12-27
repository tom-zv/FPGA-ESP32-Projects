----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:17:30 05/22/2022 
-- Design Name: 
-- Module Name:    zero32 - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity zero32 is
    Port ( S : in  STD_LOGIC_VECTOR (31 downto 0);
           o : out  STD_LOGIC);
end zero32;

architecture Behavioral of zero32 is

signal myS: std_logic_vector (31 downto 0) := S;

begin

	process(S)
	begin
		if unsigned(S) = 0 then
			o <= '1';
		else 
			o <= '0';
		end if;
	end process;

end Behavioral;

