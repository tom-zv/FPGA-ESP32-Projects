----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:49:11 05/09/2022 
-- Design Name: 
-- Module Name:    MAC - Behavioral 
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

entity MAC is
    Port ( clk : in  STD_LOGIC;
		     rst : in STD_LOGIC;
			  mr : in  STD_LOGIC;
           mw : in  STD_LOGIC;
			  ack_n : in  STD_LOGIC;
           as_n : out  STD_LOGIC;
           wr_n : out  STD_LOGIC;
			  busy : out STD_LOGIC;
			  stop_n : out  STD_LOGIC;
			  State : inout std_logic_vector(1 downto 0):= "00");
end MAC;

architecture Behavioral of MAC is

		signal req : STD_LOGIC := '0';
		signal NextState : std_logic_vector(1 downto 0):= "00";
		constant WAIT4REQ : std_logic_vector(1 downto 0) := "00";
	   constant WAIT4ACK : std_logic_vector(1 downto 0) := "01";
	   constant stNEXT : std_logic_vector(1 downto 0) := "10";

begin

process(clk)
begin
	if rst='1' then
		State <= WAIT4REQ;
	elsif rising_edge(clk) then
		State <= NextState;
	end if;
end process;


process(State, clk)
begin

	NextState <= State;
	case State is
		
		when WAIT4REQ =>     -- wait4req
		
			if ((mw='1') or (mr='1')) then 
				NextState <= WAIT4ACK;
			else
				NextState <= WAIT4REQ;
			end if;
				

		when WAIT4ACK =>    -- wait4ack
		
			if ack_n='1' then 
					NextState <= WAIT4ACK;
				else
					NextState <= stNEXT;
				end if;
				
		when stNEXT =>    -- Next
		
			req <= '0';
			NextState <= WAIT4REQ;

		when others => 
			
				
		end case;
	
end process;

busy <= '1' when ((mw='1') or (mr='1')) and (ack_n='1') else '0';
as_n <= '0' when (State = WAIT4ACK) else '1';
wr_n <= not mw;
stop_n <= '0' when ((State = WAIT4ACK) and (ack_n='1')) else '1';


end Behavioral;

