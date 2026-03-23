----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:35:26 05/09/2022 
-- Design Name: 
-- Module Name:    IRenv - Behavioral 
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

entity IRenv is
    Port ( D_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Aadr : out  STD_LOGIC_VECTOR (4 downto 0);
           Badr : out  STD_LOGIC_VECTOR (4 downto 0);
           Cadr : out  STD_LOGIC_VECTOR (4 downto 0);
           imm : out  STD_LOGIC_VECTOR (15 downto 0));
end IRenv;

architecture Behavioral of IRenv is

begin

Aadr <= D_in(10 downto 6);
Badr <= D_in(15 downto 11);
Cadr <= D_in(15 downto 11);
imm <= D_in(31 downto 16);

end Behavioral;

