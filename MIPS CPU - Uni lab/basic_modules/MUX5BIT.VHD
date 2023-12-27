library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux5bit is
    Port ( A0 : in std_logic_vector(4 downto 0);
           A1 : in std_logic_vector(4 downto 0);
           sel : in std_logic;
           O : out std_logic_vector(4 downto 0));
end mux5bit;

architecture Behavioral of mux5bit is

begin

O <= A0 when (sel = '0') else A1;

end Behavioral;
