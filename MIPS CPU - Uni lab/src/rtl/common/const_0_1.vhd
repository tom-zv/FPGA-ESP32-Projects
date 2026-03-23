----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:40 05/16/2022 
-- Design Name: 
-- Module Name:    const_0_1 - Behavioral 
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

entity const_0_1 is
		Port ( const0 : out  STD_LOGIC_VECTOR (31 downto 0);
             const1 : out  STD_LOGIC_VECTOR (31 downto 0));
end const_0_1;

architecture Behavioral of const_0_1 is

begin

const0 <= X"00000000";
const1 <= X"00000001";

end Behavioral;

