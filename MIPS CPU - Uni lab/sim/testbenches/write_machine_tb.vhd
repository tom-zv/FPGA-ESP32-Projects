-- Vhdl test bench created from schematic E:\adlx\B4\Home_S25\write_machine.sch - Mon Apr 04 15:32:34 2022
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
ENTITY write_machine_write_machine_sch_tb IS
END write_machine_write_machine_sch_tb;
ARCHITECTURE behavioral OF write_machine_write_machine_sch_tb IS 

   COMPONENT write_machine
   PORT( step_en	:	IN	STD_LOGIC; 
          ack_n	:	IN	STD_LOGIC; 
          reset	:	IN	STD_LOGIC; 
          clk	:	IN	STD_LOGIC; 
          WDO	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          AO	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          stop_n	:	OUT	STD_LOGIC; 
          AS_N	:	OUT	STD_LOGIC; 
          in_init	:	OUT	STD_LOGIC);
   END COMPONENT;

   SIGNAL step_en	:	STD_LOGIC := '0';
   SIGNAL ack_n	:	STD_LOGIC := '1';
   SIGNAL reset	:	STD_LOGIC := '0';
   SIGNAL clk	:	STD_LOGIC;
   SIGNAL WDO	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL AO	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL stop_n	:	STD_LOGIC;
   SIGNAL AS_N	:	STD_LOGIC;
   SIGNAL in_init	:	STD_LOGIC;

BEGIN

   UUT: write_machine PORT MAP(
		step_en => step_en, 
		ack_n => ack_n, 
		reset => reset, 
		clk => clk, 
		WDO => WDO, 
		AO => AO, 
		stop_n => stop_n, 
		AS_N => AS_N, 
		in_init => in_init
   );

-- *** Test Bench - User Defined Section ***

CLK_process :process
		begin
			CLK <= '0';
			wait for 100 ns;
			CLK <= '1';
			wait for 100 ns;
end process;
	
	
tb : PROCESS
   BEGIN
	
	wait for 300 ns;
	step_en <= '1';
	wait for 200 ns;
	step_en <= '0';
	
	wait for 1000 ns;
	ack_n <= '0';
	wait for 200 ns;
	ack_n <= '1';
	


      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
