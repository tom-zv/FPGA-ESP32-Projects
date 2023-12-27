-- Vhdl test bench created from schematic C:\Users\Administrator\Documents\Uni\Adv. Computer structure lab\Lab #7\Home_S25\IO_simulation.sch - Thu May 26 17:05:58 2022
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
ENTITY IO_simulation_IO_simulation_sch_tb IS
END IO_simulation_IO_simulation_sch_tb;
ARCHITECTURE behavioral OF IO_simulation_IO_simulation_sch_tb IS 

   COMPONENT IO_simulation
   PORT( clk	:	IN	STD_LOGIC; 
         reset	:	IN	STD_LOGIC; 
         step_en	:	IN	STD_LOGIC);
   END COMPONENT;

   SIGNAL clk	:	STD_LOGIC;
   SIGNAL reset	:	STD_LOGIC;
   SIGNAL step_en	:	STD_LOGIC;

BEGIN

   UUT: IO_simulation PORT MAP(
		clk => clk, 
		reset => reset, 
		step_en => step_en
   );

-- *** Test Bench - User Defined Section ***


	clk_process :process
   begin
		clk <= '1';
		wait for 50 ns;
		clk <= '0';
		wait for 50 ns;
   end process;



   tb : PROCESS
   BEGIN
	
		reset <= '1';	
		step_en <= '0';
		wait for 100 ns;
		reset <='0';
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
		
		wait for 800 ns;
		step_en <= '1';
		
		wait for 100 ns;
		step_en <= '0';
      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
