----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:43:58 05/09/2022 
-- Design Name: 
-- Module Name:    MMU - Behavioral 
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

entity MMU is
    Port ( AO : in  STD_LOGIC_VECTOR (23 downto 0);
           MMU_AO : out  STD_LOGIC_VECTOR (31 downto 0));
end MMU;

architecture Behavioral of MMU is
	

begin



MMU_AO(23 downto 0) <= AO(23 downto 0);
MMU_AO(31 downto 24) <= X"00";

end Behavioral;

