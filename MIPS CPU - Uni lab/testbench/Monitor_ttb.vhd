-- Vhdl test bench created from schematic E:\adlx\B4\Home_S25\Monitor.sch - Mon Mar 28 14:57:43 2022
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
ENTITY Monitor_Monitor_sch_tb IS
END Monitor_Monitor_sch_tb;
ARCHITECTURE behavioral OF Monitor_Monitor_sch_tb IS 

   COMPONENT Monitor
   PORT( clk	:	IN	STD_LOGIC; 
          step_en	:	IN	STD_LOGIC; 
          in_init	:	IN	STD_LOGIC; 
          stop_n	:	IN	STD_LOGIC; 
          CARD_SEL	:	IN	STD_LOGIC; 
          WR_N	:	IN	STD_LOGIC; 
          AI	:	IN	STD_LOGIC_VECTOR (9 DOWNTO 0); 
          Sample	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          A	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          B	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          REG_ADR	:	OUT	STD_LOGIC_VECTOR (4 DOWNTO 0); 
          SDO	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
          SACK_N	:	OUT	STD_LOGIC);
   END COMPONENT;

   SIGNAL clk	:	STD_LOGIC;
   SIGNAL step_en	:	STD_LOGIC;
   SIGNAL in_init	:	STD_LOGIC;
   SIGNAL stop_n	:	STD_LOGIC;
   SIGNAL CARD_SEL	:	STD_LOGIC;
   SIGNAL WR_N	:	STD_LOGIC;
   SIGNAL AI	:	STD_LOGIC_VECTOR (9 DOWNTO 0);
   SIGNAL Sample	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL A	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL B	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL REG_ADR	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
   SIGNAL SDO	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL SACK_N	:	STD_LOGIC;

BEGIN

   UUT: Monitor PORT MAP(
		clk => clk, 
		step_en => step_en, 
		in_init => in_init, 
		stop_n => stop_n, 
		CARD_SEL => CARD_SEL, 
		WR_N => WR_N, 
		AI => AI, 
		Sample => Sample, 
		A => A, 
		B => B, 
		REG_ADR => REG_ADR, 
		SDO => SDO, 
		SACK_N => SACK_N
   );

-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
