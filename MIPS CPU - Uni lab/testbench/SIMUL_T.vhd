--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:43:08 07/13/2015
-- Design Name:   
-- Module Name:   E:/a_dlx_S25/student2/IOSimul_S25/SIMUL_T.vhd
-- Project Name:  IOSimul_S25
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IO_SIMUL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SIMUL_T IS
END SIMUL_T;
 
ARCHITECTURE behavior OF SIMUL_T IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IO_SIMUL
    PORT(
         clk_in : IN  std_logic;
         RST : IN  std_logic;
         PC_step_en : IN  std_logic;
         WR_OUT_N : IN  std_logic;
         AS_N : IN  std_logic;
         MDO : IN  std_logic_vector(31 downto 0);
         MAO : IN  std_logic_vector(31 downto 0);
         step_en : OUT  std_logic;
         RESET : OUT  std_logic;
         ACK_N : OUT  std_logic;
         CLK : OUT  std_logic;
         DO : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_in : std_logic := '0';
   signal RST : std_logic := '0';
   signal PC_step_en : std_logic := '0';
   signal WR_OUT_N : std_logic := '0';
   signal AS_N : std_logic := '0';
   signal MDO : std_logic_vector(31 downto 0) := (others => '0');
   signal MAO : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal step_en : std_logic;
   signal RESET : std_logic;
   signal ACK_N : std_logic;
   signal CLK : std_logic;
   signal DO : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_in_period : time := 200 ns;
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IO_SIMUL PORT MAP (
          clk_in => clk_in,
          RST => RST,
          PC_step_en => PC_step_en,
          WR_OUT_N => WR_OUT_N,
          AS_N => AS_N,
          MDO => MDO,
          MAO => MAO,
          step_en => step_en,
          RESET => RESET,
          ACK_N => ACK_N,
          CLK => CLK,
          DO => DO
        );

   -- Clock process definitions
   clk_in_process :process
   begin
		clk_in <= '1';
		wait for clk_in_period/2;
		clk_in <= '0';
		wait for clk_in_period/2;
   end process;
 
   
 

   -- Stimulus process
   stim_proc: process
   begin
      RST <= '1';	
		PC_STEP_EN <= '1';
		AS_N <= '1';
		WR_OUT_N <= '1';
		MAO <= X"00000000";
      wait for 402 ns;	
      RST <= '0';
		wait for 200 ns;
		AS_N <= '0';
		wait for 800 ns;
		AS_N<= '1';
      wait;

      -- insert stimulus here 

      wait;
   end process;

END;
