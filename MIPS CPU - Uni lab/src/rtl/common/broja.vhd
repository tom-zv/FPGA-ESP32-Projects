library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity broja is
    Port ( clk : in std_logic;
           step : in std_logic;
           reset : in std_logic;
           in_init : out std_logic;
			  state : out std_logic_vector(3 downto 0);
           cnt : out std_logic_vector(31 downto 0));
end broja;

architecture Behavioral of broja is

constant INIT   : std_logic_vector(3 downto 0) := "1111";
constant fetch  : std_logic_vector(3 downto 0) := "1000";
constant decode : std_logic_vector(3 downto 0) := "1001";
constant gap    : std_logic_vector(3 downto 0) := "1010";

constant R0 : std_logic_vector(3 downto 0) := "0000";
constant R1 : std_logic_vector(3 downto 0) := "0001";
constant R2 : std_logic_vector(3 downto 0) := "0010";
constant R3 : std_logic_vector(3 downto 0) := "0011";
constant R4 : std_logic_vector(3 downto 0) := "0100";
constant R5 : std_logic_vector(3 downto 0) := "0101";
constant R6 : std_logic_vector(3 downto 0) := "0110";
constant R7 : std_logic_vector(3 downto 0) := "0111";

signal broja_st: std_logic_vector(3 downto 0);
signal one: std_logic;
signal more: std_logic;
signal cnt_s: std_logic_vector(7 downto 0);
  

begin

main: process(clk, reset)
BEGIN
    if (reset = '1')
	     then 
		    cnt_s <= X"00";
		    one <= '1';
		    broja_st <= init;
	 elsif (clk'EVENT AND clk = '1') 
		  	 then
			 
		 case broja_st is
			 
			 when init => 
		         if (step ='1')     then	
                   broja_st <= fetch; 			 
		             one <= not one;
			          more <= '0';
						 cnt_s <= cnt_s + 7;
			                         else
			          broja_st <= init;					 
	             end if;
			 when fetch  => broja_st <= decode;
          when decode|gap => broja_st <= R0;			 
			 when R0     =>  broja_st <= R1; more <= not more; cnt_s <= cnt_s -1;
			 when R1     =>  broja_st <= R2; cnt_s <= cnt_s - 1;
			 when R2     =>  broja_st <= R3; cnt_s <= cnt_s - 1;
			 when R3     =>  broja_st <= R4; cnt_s <= cnt_s - 1;
			 when R4     =>  broja_st <= R5; cnt_s <= cnt_s - 1;
			 when R5     =>  broja_st <= R6; cnt_s <= cnt_s - 1;
			 when R6     =>  broja_st <= R7; cnt_s <= cnt_s - 1;
			 when R7     =>  			 
			 if (one ='1') and (more = '1') then broja_st <= gap; cnt_s <= cnt_s + 15; else broja_st <= init; cnt_s <= cnt_s + 8; end if;
			 when others => null;
		  end case;

end if;		  
    	   	 	 	    
end process main;
                                                        
cnt<=cnt_s & cnt_s & cnt_s & cnt_s;
in_init <= '1' when broja_st = init else '0';
state <= broja_st;
end Behavioral;
