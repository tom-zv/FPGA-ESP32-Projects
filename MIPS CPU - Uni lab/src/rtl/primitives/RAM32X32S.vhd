library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM32X32S is
    Port ( CLK : in std_logic;
           WE : in std_logic;
           D : in std_logic_vector(31 downto 0);
           ADD : in std_logic_vector(4 downto 0);
           DO : out std_logic_vector(31 downto 0));
end RAM32X32S;

architecture Behavioral of RAM32X32S is
   type ram_t is array (0 to 31) of std_logic_vector(31 downto 0);
   signal ram : ram_t := (others => (others => '0'));
begin

   process (CLK)
   begin
      if rising_edge(CLK) then
         if WE = '1' then
            ram(to_integer(unsigned(ADD))) <= D;
         end if;
      end if;
   end process;

   DO <= ram(to_integer(unsigned(ADD)));

end Behavioral;
