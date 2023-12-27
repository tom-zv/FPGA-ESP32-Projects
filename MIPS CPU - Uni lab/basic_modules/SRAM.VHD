library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use Work.sram_data.all;

entity sram is								
	 generic (
				-- number of words in the sram
	 			word_size: integer := 1024 ;
				-- number of bits needed to define the number of words (log2(word_size))
				word_size_bits: integer := 10
				);
    Port ( RESET : in std_logic;
           CLK : in std_logic;
           WE : in std_logic;
           DI : in std_logic_vector(31 downto 0);
			  ADD : in std_logic_vector(20 downto 0);
           AS_N : in std_logic;
           done : out std_logic;
           DO : out std_logic_vector(31 downto 0));
end sram;

architecture Behavioral of sram is

type mem_type is array (word_size-1 downto 0) of std_logic_vector(DI'range);
signal main_mem : mem_type;
signal j: integer;
signal busy: std_logic;
signal busy_d: std_logic;
signal int_done: std_logic;
signal DO_S : std_logic_vector(31 downto 0) := X"00000000";

constant ZEROS: std_logic_vector(31 downto 0) := X"00000000"; 

begin

-- SRAM Data load		
main: process(clk, reset)
begin	
	if (reset = '1') then
		-- On reset, load pre-prepared data to the appropriate words + 
		-- load 0x0 to the rest of the words
		for j in 0 to word_size-1 loop
			if (j < data_size) then
				main_mem(j) <= pre_inst_mem(j);
			else
				main_mem(j) <= ZEROS;
			end if;
		end loop;
		
	elsif ((clk'event) and (clk = '1')) then
		-- Wait 1 clk cycle
		if ((as_n = '0') and (busy_d = '1')) then
			-- Go through all words in the array
			for j in 0 to word_size-1 loop
				-- If we've found the word we need
				if (j = ADD(word_size_bits-1 downto 0)) then
					-- Write/Read the appropriate word
					if (we = '1') then
						main_mem(j) <= DI;
					else
						DO_S <= main_mem(j);
					end if;
				end if;
			end loop;
		end if;
	end if;
end process main;

-- Control the progress of the SRAM operations
progress: process(clk, reset)
begin
	if (reset = '1') then
		busy <= '0';
		busy_d <= '0';
		int_done <= '0';
	elsif ((clk'event) and (clk = '1')) then
		-- Control progress through busy (= ~as_n(t-1)) and busy_d (busy delayed) 
		if (as_n = '0') then
			busy <= '1';
			busy_d <= busy;
		else
			busy <= '0';
			busy_d <= '0';
		end if;
		
		-- After performing pending operation, raise done signal for 1 clk
		if ((as_n = '0') and (busy_d = '1')) then
			int_done <= not(int_done);
		elsif (as_n = '1') then
			int_done <= '0';
		end if;

	end if;
end process progress;

-- done output from SRAM
done <= int_done;
DO <= DO_S when int_done = '1' else X"00000000";			
end Behavioral;
