library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX32bit is
    Port ( A : in std_logic_vector(31 downto 0);
           B : in std_logic_vector(31 downto 0);
           sel : in std_logic;
           O : out std_logic_vector(31 downto 0));
end MUX32bit;

architecture Behavioral of MUX32bit is

begin

O <= A when (sel = '0') else B;

end Behavioral;
