-- Vhdl test bench created from schematic C:\Users\Administrator\Documents\Uni\Adv. Computer structure lab\ISE Projects\Home_S25\simple_slave.sch - Sun Mar 13 17:13:08 2022
--
-- Notes: 
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Xilinx recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "Source->Add"
-- menu in Project Navigator to import the testbench. Then
-- edit the user defined section below, adding code to generate the 
-- stimulus for your design.
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY UNISIM;
USE UNISIM.Vcomponents.ALL;
ENTITY simple_slave_simple_slave_sch_tb IS
END simple_slave_simple_slave_sch_tb;
ARCHITECTURE behavioral OF simple_slave_simple_slave_sch_tb IS 

   COMPONENT simple_slave
   PORT(  A	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          B	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          C	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          D	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          reg_adr	:	OUT	STD_LOGIC_VECTOR (4 DOWNTO 0); 
          clk	:	IN	STD_LOGIC; 
          Card_sel	:	IN	STD_LOGIC; 
          WR_N	:	IN	STD_LOGIC; 
          SDO	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          SACK_N	:	OUT	STD_LOGIC; 
          AI	:	IN	STD_LOGIC_VECTOR (9 DOWNTO 0));
   END COMPONENT;

   SIGNAL A	:	STD_LOGIC_VECTOR (31 DOWNTO 0):= X"00000001";
   SIGNAL B	:	STD_LOGIC_VECTOR (31 DOWNTO 0):= X"00000002";
   SIGNAL C	:	STD_LOGIC_VECTOR (31 DOWNTO 0):= X"00000003";
   SIGNAL D	:	STD_LOGIC_VECTOR (31 DOWNTO 0):= X"00000004";
   SIGNAL reg_adr	:	STD_LOGIC_VECTOR (4 DOWNTO 0):= "00001";
   SIGNAL clk	:	STD_LOGIC;
   SIGNAL Card_sel	:	STD_LOGIC:= '1';
   SIGNAL WR_N	:	STD_LOGIC:= '1';
   SIGNAL SDO	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL SACK_N	:	STD_LOGIC;
   SIGNAL AI	:	STD_LOGIC_VECTOR (9 DOWNTO 0):= "0000000000";

BEGIN

   UUT: simple_slave PORT MAP(
		A => A, 
		B => B, 
		C => C, 
		D => D, 
		reg_adr => reg_adr, 
		clk => clk, 
		Card_sel => Card_sel, 
		WR_N => WR_N, 
		SDO => SDO, 
		SACK_N => SACK_N, 
		AI => AI
   );

-- *** Test Bench - User Defined Section ***
	CLK_process :process
		begin
			CLK <= '1';
			wait for 100 ns;
			CLK <= '0';
			wait for 100 ns;
   end process;
   tb : PROCESS
   BEGIN
	wait for 400 ns;
	AI <= "0000100000";
	wait for 200 ns;
	AI <= "0001100000";
	card_sel <= '0';
	wait for 200 ns;
	card_sel <= '1';
	
      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
