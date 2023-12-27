library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX4_32bit is
    Port ( A0 : in std_logic_vector(31 downto 0);
           A1 : in std_logic_vector(31 downto 0);
           A2 : in std_logic_vector(31 downto 0);
           A3 : in std_logic_vector(31 downto 0);
           sel : in std_logic_vector(1 downto 0);
           O : out std_logic_vector(31 downto 0));
end MUX4_32bit;

architecture Behavioral of MUX4_32bit is

begin

O <= 	A0 when (sel = "00") else
		A1 when (sel = "01") else
		A2 when (sel = "10") else
		A3;

end Behavioral;
