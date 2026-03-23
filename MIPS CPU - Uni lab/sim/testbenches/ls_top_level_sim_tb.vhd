-- Vhdl test bench created from schematic C:\Users\Administrator\Documents\Uni\Adv. Computer structure lab\Lab #6\Home_S25\LS_TOP_LEVEL_SIM.sch - Mon May 16 02:18:07 2022
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
ENTITY LS_TOP_LEVEL_SIM_LS_TOP_LEVEL_SIM_sch_tb IS
END LS_TOP_LEVEL_SIM_LS_TOP_LEVEL_SIM_sch_tb;
ARCHITECTURE behavioral OF LS_TOP_LEVEL_SIM_LS_TOP_LEVEL_SIM_sch_tb IS 

   COMPONENT LS_TOP_LEVEL_SIM
   PORT( clk_in	:	IN	STD_LOGIC; 
          PC_step_en	:	IN	STD_LOGIC; 
          rst	:	IN	STD_LOGIC);
   END COMPONENT;

   SIGNAL clk_in	:	STD_LOGIC;
   SIGNAL PC_step_en	:	STD_LOGIC;
   SIGNAL rst	:	STD_LOGIC;

BEGIN

   UUT: LS_TOP_LEVEL_SIM PORT MAP(
		clk_in => clk_in, 
		PC_step_en => PC_step_en, 
		rst => rst
   );

-- *** Test Bench - User Defined Section ***

clk_in_process :process
   begin
		clk_in <= '1';
		wait for 50 ns;
		clk_in <= '0';
		wait for 50 ns;
   end process;

   tb : PROCESS
   BEGIN
	
		rst <= '1';	
		PC_step_en <= '0';
		wait for 100 ns;
		rst <='0';
		PC_step_en <= '1';
		
		wait for 100 ns;
		PC_step_en <= '0';
		
		wait for 1300 ns;
		PC_step_en <= '1';
		
		wait for 100 ns;
		PC_step_en <= '0';
		
		wait for 1400 ns;
		PC_step_en <= '1';
		
		wait for 100 ns;
		PC_step_en <= '0';
		
		wait for 1400 ns;
		PC_step_en <= '1';
		
		wait for 100 ns;
		PC_step_en <= '0';
		
		wait for 1400 ns;
		PC_step_en <= '1';
		
		wait for 100 ns;
		PC_step_en <= '0';
		
		wait for 1400 ns;
		PC_step_en <= '1';
		
		wait for 100 ns;
		PC_step_en <= '0';
		
		wait for 1400 ns;
		PC_step_en <= '1';
		
		wait for 100 ns;
		PC_step_en <= '0';
		
      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
