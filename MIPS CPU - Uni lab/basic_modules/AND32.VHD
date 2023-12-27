library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AND32 is
	Port ( A : in std_logic_vector(31 downto 0);
          B : in std_logic_vector(31 downto 0);
          O : out std_logic_vector(31 downto 0));
end AND32;

architecture Behavioral of AND32 is

begin
	O <= A and B;
end Behavioral;
