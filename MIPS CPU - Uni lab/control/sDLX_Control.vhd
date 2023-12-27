----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:02:40 05/23/2022 
-- Design Name: 
-- Module Name:    sDLX_Control - Behavioral 
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

entity sDLX_Control is
port(

	clk: in STD_LOGIC;
	reset: in STD_LOGIC;
	step_en: in STD_LOGIC;
   
   busy: in STD_LOGIC;
   
   OPCODE: in STD_LOGIC_VECTOR(5 downto 0);
   IR5: in STD_LOGIC;
   bt: in STD_LOGIC;
	

   
   mr: out STD_LOGIC;
   mw: out STD_LOGIC;

   
	ACE : out STD_LOGIC;
	BCE : out STD_LOGIC;
	CCE : out STD_LOGIC;
	IRCE : out STD_LOGIC;
	PCCE : out STD_LOGIC;
	MARCE : out STD_LOGIC;
	MDRCE : out STD_LOGIC;
	ADD : out STD_LOGIC;
	
	S1SEL: out STD_LOGIC;
	
	S2SEL: out STD_LOGIC;
	
	DINTSEL: out STD_LOGIC;
	MDRSEL: out STD_LOGIC;
	ASEL : out STD_LOGIC;
	ITYPE : out STD_LOGIC;
	GPRWE : out STD_LOGIC;
	TEST : out STD_LOGIC;
	
	SHIFT : out STD_LOGIC;
	JLINK : out STD_LOGIC;
	

	IN_INIT: out STD_LOGIC;
	DLX_state: out STD_LOGIC_VECTOR(4 downto 0)
);
end sDLX_Control;

architecture Behavioral of sDLX_Control is

signal DLX_state_s : 	std_logic_vector(4 downto 0);

constant INIT  :			std_logic_vector(4 downto 0) := "00000"; -- 0x00
constant FETCH : 			std_logic_vector(4 downto 0) := "00001"; -- 0x01
constant DECODE : 		std_logic_vector(4 downto 0) := "00010"; -- 0x02
constant ALU : 			std_logic_vector(4 downto 0) := "00011"; -- 0x03
constant SHIFT : 			std_logic_vector(4 downto 0) := "00100"; -- 0x04
constant WBR : 			std_logic_vector(4 downto 0) := "00101"; -- 0x05
constant ALUI : 			std_logic_vector(4 downto 0) := "00110"; -- 0x06
constant TESTI : 			std_logic_vector(4 downto 0) := "00111"; -- 0x07
constant WBI : 			std_logic_vector(4 downto 0) := "01000"; -- 0x08
constant ADDRESSCMP : 	std_logic_vector(4 downto 0) := "01001"; -- 0x09
constant LOAD : 			std_logic_vector(4 downto 0) := "01010"; -- 0x0A
constant COPYGPR2MDR : 	std_logic_vector(4 downto 0) := "01011"; -- 0x0B
constant COPYMDR2C : 	std_logic_vector(4 downto 0) := "01100"; -- 0x0C
constant STORE : 			std_logic_vector(4 downto 0) := "01101"; -- 0x0D
constant JR : 				std_logic_vector(4 downto 0) := "01110"; -- 0x0E
constant SAVEPC : 		std_logic_vector(4 downto 0) := "01111"; -- 0x0F
constant JALR : 			std_logic_vector(4 downto 0) := "10000"; -- 0x10
constant BRANCH : 		std_logic_vector(4 downto 0) := "10001"; -- 0x11
constant BTAKEN : 		std_logic_vector(4 downto 0) := "10010"; -- 0x12
constant HALT :			std_logic_vector(4 downto 0) := "10011"; -- 0x13



begin


	main : process(clk,reset)
	begin
	if (reset='1') then
		DLX_state_s <= INIT;
	elsif ((clk'event) and (clk='1')) then
		case DLX_state_s is

			when INIT =>
				if (STEP_EN='0') then
					DLX_state_s <= INIT;
				else
					DLX_state_s <= FETCH;
				end if;

			when FETCH =>
				if (busy='0') then
					DLX_state_s <= DECODE;
				else
					DLX_state_s <= FETCH;
				end if;

			when DECODE =>
				if (OPCODE(5 downto 3)="110") then
					if (STEP_EN='0') then
						DLX_state_s <= INIT;
					else
						DLX_state_s <= FETCH;
					end if;
				elsif (OPCODE(5 downto 2)="0000") then
					if (IR5='1') then
						DLX_state_s <= ALU;
					else
						DLX_state_s <= SHIFT;
					end if;
				elsif (OPCODE(5 downto 3)="001") then
					DLX_state_s <= ALUI;
				elsif (OPCODE(5 downto 3)="011") then
					DLX_state_s <= TESTI;
				elsif (OPCODE(5 downto 4)="10") then
					DLX_state_s <= ADDRESSCMP;
				elsif (OPCODE(5 downto 3)="010") then
					if (OPCODE(0)='0') then
						DLX_state_s <= JR;
					else
						DLX_state_s <= SAVEPC;
					end if;
				elsif (OPCODE(5 downto 2)="0001") then
					DLX_state_s <= BRANCH;
				else
					DLX_state_s <= HALT;
				end if;

			when ALU =>
				DLX_state_s <= WBR;

			when SHIFT =>
				DLX_state_s <= WBR;

			when WBR =>
				if (STEP_EN='0') then
					DLX_state_s <= INIT;
				else
					DLX_state_s <= FETCH;
				end if;

			when ALUI =>
				DLX_state_s <= WBI;

			when TESTI =>
				DLX_state_s <= WBI;

			when WBI =>
				if (STEP_EN='0') then
					DLX_state_s <= INIT;
				else
					DLX_state_s <= FETCH;
				end if;

			when ADDRESSCMP =>
				if (OPCODE(3)='1') then
					DLX_state_s <= COPYGPR2MDR;
				else
					DLX_state_s <= LOAD;
				end if;

			when LOAD =>
				if (busy='1') then
					DLX_state_s <= LOAD;
				else
					DLX_state_s <= COPYMDR2C;
				end if;

			when COPYMDR2C =>
				DLX_state_s <= WBI;

			when COPYGPR2MDR =>
				DLX_state_s <= STORE;

			when STORE =>
				if (busy='1') then
					DLX_state_s <= STORE;
				elsif (STEP_EN='0') then
					DLX_state_s <= INIT;
				else
					DLX_state_s <= FETCH;
				end if;

			when JR =>
				if (STEP_EN='0') then
					DLX_state_s <= INIT;
				else
					DLX_state_s <= FETCH;
				end if;

			when SAVEPC =>
				DLX_state_s <= JALR;

			when JALR =>
				if (STEP_EN='0') then
					DLX_state_s <= INIT;
				else
				DLX_state_s <= FETCH;
				end if;

			when BRANCH =>
				if (bt='1') then
					DLX_state_s <= BTAKEN;
				elsif (STEP_EN='0') then
					DLX_state_s <= INIT;
				else
					DLX_state_s <= FETCH;
				end if;

			when BTAKEN =>
				if (STEP_EN='0') then
					DLX_state_s <= INIT;
				else
					DLX_state_s <= FETCH;
				end if;

			when HALT =>
				DLX_state_s <= HALT;
				
			when others => null;
			
		end case;
	end if;
 end process main;

DLX_state <= DLX_state_s;

mr <= '1' when ((DLX_state_s = FETCH) or (DLX_state_s = LOAD)) else '0';

mw <= '1' when (DLX_state_s = STORE) else '0';

IRCE <= '1' when ((DLX_state_s = FETCH) and (busy = '0')) else '0';

PCCE <= '1' when ((DLX_state_s = DECODE) or
						(DLX_state_s = BTAKEN) or
						(DLX_state_s = JR) or
						(DLX_state_s = JALR))
				else '0';
				
ACE <= '1' when (DLX_state_s = DECODE) else '0';

BCE <= '1' when (DLX_state_s = DECODE) else '0';

CCE <= '1' when ((DLX_state_s = ALU) or
			         (DLX_state_s = TESTI) or
						(DLX_state_s = ALUI) or
						(DLX_state_s = SHIFT) or
						(DLX_state_s = COPYMDR2C) or
						(DLX_state_s = SAVEPC))
			  else '0';
			  
MARCE <= '1' when (DLX_state_s = ADDRESSCMP) else '0';

MDRCE <= '1' when (((DLX_state_s = LOAD) and (busy = '0')) or
						(DLX_state_s = COPYGPR2MDR))
				 else '0';
				 
ADD <= '1' when ((DLX_state_s = DECODE) or
   				  (DLX_state_s = ALUI) or
					  (DLX_state_s = ADDRESSCMP) or
		   		  (DLX_state_s = BTAKEN) or
					  (DLX_state_s = JR) or
					  (DLX_state_s = SAVEPC) or
					  (DLX_state_s = JALR))
			  else '0';
			  
S1SEL0 <= '1' when ((DLX_state_s = ALU) or
						  (DLX_state_s = TESTI) or
						  (DLX_state_s = ALUI) or
						  (DLX_state_s = SHIFT) or
						  (DLX_state_s = ADDRESSCMP) or
						  (DLX_state_s = COPYMDR2C) or
						  (DLX_state_s = JR) or
						  (DLX_state_s = JALR))
				  else '0';
				  
S1SEL1 <= '1' when ((DLX_state_s = COPYMDR2C) or
						  (DLX_state_s = COPYGPR2MDR))
				  else '0';
				  
S2SEL0 <= '1' when ((DLX_state_s = DECODE) or
						  (DLX_state_s = TESTI) or
						  (DLX_state_s = ALUI) or
						  (DLX_state_s = ADDRESSCMP) or
						  (DLX_state_s = BTAKEN))
				  else '0';
				  
S2SEL1 <= '1' when ((DLX_state_s = DECODE) or
						  (DLX_state_s = COPYMDR2C) or
						  (DLX_state_s = COPYGPR2MDR) or
						  (DLX_state_s = JR) or
						  (DLX_state_s = SAVEPC) or
						  (DLX_state_s = JALR))
				  else '0';
				  
DINTSEL <= '1' when ((DLX_state_s = SHIFT) or
							(DLX_state_s = COPYMDR2C) or
							(DLX_state_s = COPYGPR2MDR))
					else '0';
					
MDRSEL <= '1' when (DLX_state_s = LOAD) else '0';
 
ASEL <= '1' when ((DLX_state_s = LOAD) or
						(DLX_state_s = STORE))
				else '0';
				 
ITYPE <= '1' when ((DLX_state_s = TESTI) or
						 (DLX_state_s = ALUI) or
						 (DLX_state_s = WBI))
				 else '0';
				 
GPRWE <= '1' when ((DLX_state_s = WBI) or
						 (DLX_state_s = WBR) or
						 (DLX_state_s = JALR))
				 else '0';
				 
TEST <= '1' when (DLX_state_s = TESTI) else '0';
 
JLINK <= '1' when (DLX_state_s = JALR) else '0';
 
SHIFT_EN <= '1' when (DLX_state_s = SHIFT) else '0';
 
IN_INIT <= '1' when ((DLX_state_s = INIT) or (DLX_state_s = HALT)) else '0';


end Behavioral;

