----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:48:06 04/04/2022 
-- Design Name: 
-- Module Name:    read_state_machine - Behavioral 
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

entity read_state_machine is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           step_en : in  STD_LOGIC;
           ack_n : in  STD_LOGIC;
			  in_init : out STD_LOGIC:= '1';
			  AS_N : out STD_LOGIC:= '1';
			  stop_n : out STD_LOGIC:= '1';
			  ce : out STD_LOGIC;
			  State : inout std_logic_vector(1 downto 0):= "00");
end read_state_machine;

architecture Behavioral of read_state_machine is
		
	   
		signal NextState : std_logic_vector(1 downto 0):= "00";
		constant s0 : std_logic_vector(1 downto 0) := "00";
	   constant s1 : std_logic_vector(1 downto 0) := "01";
	   constant s2 : std_logic_vector(1 downto 0) := "10";
		constant s3 : std_logic_vector(1 downto 0) := "11";
		signal stop_delay : std_logic := '0';

begin

process(clk, reset)
begin
	if rising_edge(clk) then
		if reset='1' then 
			 State <= s0;
		else 
			State <= NextState;
		end if ;
	end if;
end process;


process(State,step_en,ack_n, clk)
begin

	NextState <= State;
	case State is
		
		when s0 =>     -- wait
			in_init <= '1';
			as_n <= '1';
			stop_n <= '1';
			ce <= '0';
			
			if step_en='0' then 
				NextState <= s0;
			else
				NextState <= s1;
			end if;
				

		when s1 =>    -- fetch
			in_init <='0';
			as_n <= '0';

			NextState <= s2;
				
				
		when s2 =>    -- wait4ack
				
			if ack_n ='1' then 
			
				NextState <= s2;
				
				if stop_delay='0' then
					stop_delay <= '1';
				else 
					stop_n <='0';
				end if;
				
			else
				stop_n <= '1';
				stop_delay <= '0';
				NextState <= s3;
			end if;
				
				
				
		when s3 =>    -- load
			NextState <= s0;
			AS_N <='1';
			ce <= '1';
				
				
		when others => 
			
				
		end case;
	
end process;

end Behavioral;


