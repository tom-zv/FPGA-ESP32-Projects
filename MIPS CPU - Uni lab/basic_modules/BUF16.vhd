----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:05 02/16/2015 
-- Design Name: 
-- Module Name:    BUF16 - Behavioral 
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

entity BUF16 is
    Port ( Din : in  STD_LOGIC_VECTOR (15 downto 0);
           Dout : out  STD_LOGIC_VECTOR (15 downto 0));
end BUF16;

architecture Behavioral of BUF16 is

begin

Dout <= Din;
end Behavioral;

