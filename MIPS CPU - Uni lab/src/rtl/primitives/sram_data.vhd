library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Package for SRAM pre-initialization data
package sram_data is

	-- Size of pre instantiated data
	constant data_size: integer := 13;
	
	type pre_inst_data is array(0 to data_size-1) of std_logic_vector(31 downto 0);
	constant pre_inst_mem : pre_inst_data := ( 
	-- The actual data :
	
X"2C02000C",  -- 0x00000000 	start      	 	  addi R2 R0 12
X"2C030018",  -- 0x00000001 	            	             addi R3 R0 24
X"00430826",  -- 0x00000002 	            	 	   and R1 R2 R3
X"00430825",  -- 0x00000003 	            	              or R1 R2 R3
X"00430824",  -- 0x00000004 	            	              xor R1 R2 R3
X"007F0800",  -- 0x00000005 	            	 	   slli R1 R3
X"007F0802",  -- 0x00000006 	            	 	   srli R1 R3
X"FFFF7774",  -- 0x00000007 	   err        	            halt
X"00000007",  -- 0x00000008 	adr1       	 	dc err
X"00000001",  -- 0x00000009 	adr2       	 	dc 1
X"00000001",  -- 0x0000000A 	adr3       	 	dc 1
X"00000000",  -- 0x0000000B 	adr4       	 dc 0x0
X"00000005"  -- 0x0000000C 	data1      	 	dc 0x5





			       ); 

end sram_data;

package body sram_data is

 
end sram_data;
