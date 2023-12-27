----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:56:47 05/23/2022 
-- Design Name: 
-- Module Name:    SHIFT_ENV - Behavioral 
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

entity SHIFT_ENV is
    Port ( clk : in  STD_LOGIC;
           shift : in  STD_LOGIC;
           right : in  STD_LOGIC;
           S : in  STD_LOGIC_VECTOR (31 downto 0);
           SO : out  STD_LOGIC_VECTOR (31 downto 0));
end SHIFT_ENV;

architecture Behavioral of SHIFT_ENV is

begin

	SO(31 downto 0) <= '0' & S(31 downto 1) when (right = '1' and shift = '1')
	else S(30 downto 0) & '0' when (right = '0' and shift = '1')
	else S(31 downto 0);


end Behavioral;

