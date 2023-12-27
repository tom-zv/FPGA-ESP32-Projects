library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IO_SIMUL is
	      PORT(	clk_in			:	IN	STD_LOGIC; 
	          	RST				:	IN	STD_LOGIC; 
	          	PC_step_en		:	IN	STD_LOGIC;
					WR_OUT_N			:  IN STD_LOGIC;
					AS_N				:  IN STD_LOGIC;
					MDO				:  IN STD_LOGIC_VECTOR(31 downto 0);
					MAO				:  IN STD_LOGIC_VECTOR(31 downto 0);
					step_en			:  OUT   STD_LOGIC;					 
	          	RESET				:	OUT	STD_LOGIC;
					ACK_N				:  OUT   STD_LOGIC; 
	          	CLK				:	OUT	STD_LOGIC;
					DO					:  OUT   STD_LOGIC_VECTOR(31 downto 0));
end IO_SIMUL;

architecture Behavioral of IO_SIMUL is

	COMPONENT sram
	PORT(
		RESET : IN std_logic;
		CLK : IN std_logic;
		WE : IN std_logic;
		DI : IN std_logic_vector(31 downto 0);
		ADD : IN std_logic_vector(20 downto 0);
		AS_N : IN std_logic;          
		done : OUT std_logic;
		DO : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

signal sr_done: std_logic;
signal sr_we: std_logic;

begin

-- Create an instance of the passiv SRAM
passive_ram: sram PORT MAP(
		RESET => RST,
		CLK => clk_in,
		WE => sr_we,
		DI => mdo,
		ADD => mao(20 downto 0),
		AS_N => as_n,
		done => sr_done,
		DO => DO
	);

-- Arrange Input/Outputs according to relevance
ack_n <= not(sr_done);
sr_we <= not(WR_OUT_N);

CLK <= clk_in;
RESET <= RST;
step_en <= PC_step_en;

end Behavioral;
