----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:49:48 05/09/2022 
-- Design Name: 
-- Module Name:    DLX_Control - Behavioral 
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

entity DLX_Control is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  step_en : in  STD_LOGIC;
			  busy : in STD_LOGIC;
			  ir5: in STD_LOGIC;
			  bt: in STD_LOGIC;
			  opcode : in  STD_LOGIC_VECTOR (5 downto 0);
			  
			  in_init : out STD_LOGIC;
              mr : out STD_LOGIC;
              mw : out STD_LOGIC;
	
			  Ace : out STD_LOGIC;
			  Bce : out STD_LOGIC;
			  Cce : out STD_LOGIC;
			  GPRwe : out STD_LOGIC;
			  PCce : out STD_LOGIC;
			  IRce : out STD_LOGIC;
			  MARce : out STD_LOGIC;
			  MDRce : out STD_LOGIC;
			  
			  DINTSEL: out STD_LOGIC;
			  MDRSEL: out STD_LOGIC;
			  ASEL : out STD_LOGIC;
			  
			  ADD : out STD_LOGIC;
			  TEST : out STD_LOGIC;
			  SHIFT : out STD_LOGIC;
			  
			  ITYPE : out STD_LOGIC;
			  JLINK : out STD_LOGIC;
			  S1SEL0: out STD_LOGIC;
			  S1SEL1: out STD_LOGIC;
			  S2SEL0: out STD_LOGIC;
			  S2SEL1: out STD_LOGIC;
			  
			  state : inout  STD_LOGIC_VECTOR (4 downto 0));
			  
end DLX_Control;

 architecture Behavioral of DLX_Control is

	   signal NextState : std_logic_vector(4 downto 0):= "00000";
		constant INIT  : std_logic_vector(4 downto 0) := "00000"; 		 -- 0x00
		constant FETCH : std_logic_vector(4 downto 0) := "00001"; 		 -- 0x01
		constant DECODE : std_logic_vector(4 downto 0) := "00010"; 		 -- 0x02
		constant ALU : std_logic_vector(4 downto 0) := "00011"; 		 	 -- 0x03
		constant TESTI : std_logic_vector(4 downto 0) := "00100"; 		 -- 0x04
		constant ALUI : std_logic_vector(4 downto 0) := "00101";        -- 0x05
		constant SHIFT_ST : 	std_logic_vector(4 downto 0) := "00110";   -- 0x06
		constant ADDRESSCMP : std_logic_vector(4 downto 0) := "00111";  -- 0x07
		constant LOAD : std_logic_vector(4 downto 0) := "01000";        -- 0x08
		constant STORE : std_logic_vector(4 downto 0) := "01001";       -- 0x09
		constant COPYMDR2C : std_logic_vector(4 downto 0) := "01010";   -- 0x0A
		constant COPYGPR2MDR : std_logic_vector(4 downto 0) := "01011"; -- 0x0B
		constant WBR : std_logic_vector(4 downto 0) := "01100";         -- 0x0C
		constant WBI : std_logic_vector(4 downto 0) := "01101";         -- 0x0D
		constant BRANCH : std_logic_vector(4 downto 0) := "01110"; 		 -- 0x0E
		constant BTAKEN : std_logic_vector(4 downto 0) := "01111"; 		 -- 0x0F
		constant JR : std_logic_vector(4 downto 0) := "10000"; 			 -- 0x10
		constant SAVEPC : std_logic_vector(4 downto 0) := "10001"; 		 -- 0x11
		constant JALR : std_logic_vector(4 downto 0)   := "10010"; 		 -- 0x12
		constant HALT : std_logic_vector(4 downto 0) := "10011"; 		 -- 0x13

		

begin

process(clk, reset)
begin

	if reset='1' then
			state <= INIT;
	elsif rising_edge(clk) then
			state <= NextState;
	end if;
end process;


process(State, clk)
begin

	NextState <= state;
	case state is
		
		when INIT =>     -- INIT
		
			if step_en='0' then
				NextState <= INIT;
			else
				NextState <= FETCH;
			end if;				

		when FETCH =>    -- fetch

			if busy='1' then 
					NextState <= FETCH;
			else
					NextState <= DECODE;
			end if;
				
		when DECODE =>    -- decode
				
			if (OPCODE(5 downto 3)="110") then  -- no-Op
				if (STEP_EN='0') then
					NextState <= INIT;
				else
					NextState <= FETCH;
				end if;
				
			elsif (OPCODE(5 downto 2)="0000") then  -- I type
					if (ir5='1') then
						NextState <= ALU;
					else
						NextState <= SHIFT_ST;
					end if;
					
			elsif (OPCODE(5 downto 3)="001") then --addi
				NextState <= ALUI;
				
			elsif (OPCODE(5 downto 3)="011") then -- test set
				NextState <= TESTI;
				
			elsif (OPCODE(5 downto 4)="10") then -- lw/sw
				NextState <= ADDRESSCMP;
				
			elsif (OPCODE(5 downto 3)="010") then -- jr/jalr
				if (OPCODE(0)='0') then
					NextState <= JR;
				else
					NextState <= SAVEPC;
				end if;	
					
			elsif (OPCODE(5 downto 2)="0001") then
				NextState <= BRANCH;
				
			else
				NextState <= HALT;
		end if;
				
		when ALU =>
			NextState <= WBR;

		when SHIFT_ST =>
			NextState <= WBR;

		when WBR =>
			if (step_en='0') then
				NextState <= INIT;
			else
				NextState <= FETCH;
			end if;		
		
		when ALUI =>
				NextState <= WBI;

			when TESTI =>
				NextState <= WBI;

		when WBI =>
			if (STEP_EN='0') then
				NextState <= INIT;
			else
				NextState <= FETCH;
			end if;
			
		when ADDRESSCMP =>
			if (OPCODE(3)='1') then
				NextState <= COPYGPR2MDR;
			else
				NextState <= LOAD;
			end if;

		when LOAD =>
			if (busy='1') then
				NextState <= LOAD;
			else
				NextState <= COPYMDR2C;
			end if;

		when COPYMDR2C =>
			NextState <= WBI;

		when COPYGPR2MDR =>
			NextState <= STORE;
			
		when STORE =>
		
			if busy='1' then
				NextState <= STORE;
			elsif (STEP_EN='0') then
				NextState <= INIT;
			else
				NextState <= FETCH;
			end if;
			
	
	   when JR =>
			if (STEP_EN='0') then
				NextState <= INIT;
			else
				NextState <= FETCH;
			end if;
			
		when SAVEPC =>
				NextState <= JALR;
				
		when JALR =>
			if (STEP_EN='0') then
				NextState <= INIT;
			else
				NextState <= FETCH;
			end if;

		when BRANCH =>
			if (bt='1') then
				NextState <= BTAKEN;
			elsif (STEP_EN='0') then
				NextState <= INIT;
			else
				NextState <= FETCH;
			end if;

		when BTAKEN =>
			if (STEP_EN='0') then
				NextState <= INIT;
			else
				NextState <= FETCH;
			end if;
	
		
		when HALT =>
			NextState <= HALT;	  
	
		when others => 
			
				
		end case;
	
end process;

in_init <= '1' when (state=INIT) or (state=HALT) else '0';

mr <= '1' when (state = FETCH) or (state = LOAD) else '0';

mw <= '1' when (state = STORE) else '0';

Ace <= '1' when (state = DECODE) else '0';

Bce <= '1' when (state = DECODE) else '0';

Cce <= '1' when (( state = ALU)   or
			         (state = TESTI) or
						(state = ALUI)  or
						(state = SHIFT_ST) or
						(state = COPYMDR2C) or
						(state = SAVEPC))
			  else '0';
			  
GPRwe <= '1' when ((state = WBI) or
						 (state = WBR) or
						 (state = JALR))
				 else '0';
				 
PCce <= '1' when ((state = DECODE) or
						 (state = BTAKEN) or
						 (state = JR) or
						 (state = JALR))
				 else '0';
				 
IRce <= '1' when (state = FETCH) else '0';
				 
MARce <= '1' when (state = ADDRESSCMP) else '0';
				 
MDRce<= '1' when ((state = LOAD and (busy = '0')) or
						 (state = COPYGPR2MDR))    
				 else '0';
			  
ASEL <= '1' when ((state = LOAD) or
						(state = STORE))
				else '0';
				
DINTSEL <= '1' when ((state = SHIFT_ST) or
							(state = COPYMDR2C) or
							(state = COPYGPR2MDR))
					else '0';
					
MDRSEL  <= '1' when (state = LOAD) else '0';
 
			  
ADD <= '1' when ((state = DECODE) or
   				  (state = ALUI) or
					  (state = ADDRESSCMP) or
		   		  (state = BTAKEN) or
					  (state = JR) or
					  (state = SAVEPC) or
					  (state= JALR))
			  else '0';
			  
TEST <= '1' when (state = TESTI) else '0';

SHIFT <= '1' when (state = SHIFT_ST) else '0';
			  
ITYPE <= '1' when ((state = TESTI) or
						 (state = ALUI) or
						 (state = WBI))
				 else '0';
JLINK <= '1' when (state = JALR) else '0';

S1SEL0 <= '1' when ((state = ALU) or
						  (state = TESTI) or
						  (state = ALUI) or
						  (state = SHIFT_ST) or
						  (state = ADDRESSCMP) or
						  (state = COPYMDR2C) or
						  (state = JR) or
						  (state = JALR))
				  else '0';
				  
S1SEL1 <= '1' when ((state = COPYMDR2C) or
						  (state = COPYGPR2MDR))
				  else '0';
				  
S2SEL0 <= '1' when ((state = DECODE) or
						  (state = TESTI) or
						  (state = ALUI) or
						  (state = ADDRESSCMP) or
						  (state = BTAKEN))
				  else '0';
				  
S2SEL1 <= '1' when ((state = DECODE) or
						  (state = COPYMDR2C) or
						  (state = COPYGPR2MDR) or
						  (state = JR) or
						  (state = SAVEPC) or
						  (state = JALR))
				  else '0';





end Behavioral;

