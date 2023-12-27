----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:11:45 05/16/2022 
-- Design Name: 
-- Module Name:    Sxt_16_32 - Behavioral 
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

entity Sxt_16_32 is
    Port ( S16 : in  STD_LOGIC_VECTOR (15 downto 0);
           S32ext : out  STD_LOGIC_VECTOR (31 downto 0));
end Sxt_16_32;

architecture Behavioral of Sxt_16_32 is

begin
	 S32ext(15 downto 0) <= S16(15 downto 0);
    S32ext(31 downto 16) <= (others=>S16(15));

end Behavioral;

