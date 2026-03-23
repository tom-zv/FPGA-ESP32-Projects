----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:42 02/16/2015 
-- Design Name: 
-- Module Name:    AEQZ - Behavioral 
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

entity AEQZ is
    Port ( Din : in  STD_LOGIC_VECTOR (31 downto 0);
           A_eqz : out  STD_LOGIC);
end AEQZ;

architecture Behavioral of AEQZ is

begin
A_eqz <= '1' when Din = X"00000000" else '0';

end Behavioral;

