library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity step_counter is
    Port ( clk : in std_logic;
           ce : in std_logic;
           reset : in std_logic;
           cnt_o : out std_logic_vector(4 downto 0));
end step_counter;

architecture Behavioral of step_counter is

signal cnt_s: std_logic_vector(4 downto 0);
signal ce_1: std_logic;
signal ce_2: std_logic;
signal ce_3: std_logic;
begin

main: process(clk)
begin
  
      
if reset ='1'
	    then cnt_s <= "00000"; ce_1 <= '0';ce_2 <= '0';ce_3 <= '0';
	    else
	 if (clk'event and clk='1') then	 
		 ce_1 <= ce;
		 ce_2 <= ce_1;
		 ce_3 <= ce_2;
		  if ce_3 = '1' then cnt_s <= cnt_s + 1;
				    else cnt_s <= cnt_s;
	     end if;
   end if;
end if;
   end process main;

   cnt_o<=cnt_s;



end Behavioral;
