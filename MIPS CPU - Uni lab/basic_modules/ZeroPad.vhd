----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:39:21 05/23/2022 
-- Design Name: 
-- Module Name:    ZeroPad - Behavioral 
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

entity ZeroPad is
    Port ( S : in  STD_LOGIC;
           S_pad : out  STD_LOGIC_VECTOR (31 downto 0));
end ZeroPad;

architecture Behavioral of ZeroPad is

begin
	
	S_pad(0) <= s;
	S_pad(31 downto 1)<= "0000000000000000000000000000000";
	

end Behavioral;

