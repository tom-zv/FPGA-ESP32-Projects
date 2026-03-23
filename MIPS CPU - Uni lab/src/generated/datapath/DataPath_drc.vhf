--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : DataPath_drc.vhf
-- /___/   /\     Timestamp : 05/16/2022 02:01:01
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: E:\Programs\14.7\ISE_DS\ISE\bin\nt64\unwrapped\sch2hdl.exe -intstyle ise -family spartan6 -flat -suppress -vhdl DataPath_drc.vhf -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #6/Home_S25/DataPath.sch"
--Design Name: DataPath
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity GPRenv_MUSER_DataPath is
   port ( Aadr   : in    std_logic_vector (4 downto 0); 
          Badr   : in    std_logic_vector (4 downto 0); 
          C      : in    std_logic_vector (31 downto 0); 
          Cadr   : in    std_logic_vector (4 downto 0); 
          clk    : in    std_logic; 
          Dadr   : in    std_logic_vector (4 downto 0); 
          gpr_we : in    std_logic; 
          A      : out   std_logic_vector (31 downto 0); 
          A_EQZ  : out   std_logic; 
          B      : out   std_logic_vector (31 downto 0); 
          D      : out   std_logic_vector (31 downto 0));
end GPRenv_MUSER_DataPath;

architecture BEHAVIORAL of GPRenv_MUSER_DataPath is
   attribute BOX_TYPE   : string ;
   signal ram_we    : std_logic;
   signal sel_adr_A : std_logic_vector (4 downto 0);
   signal sel_adr_B : std_logic_vector (4 downto 0);
   signal sel_adr_D : std_logic_vector (4 downto 0);
   signal XLXN_118  : std_logic;
   signal A_DUMMY   : std_logic_vector (31 downto 0);
   component RAM32X32S
      port ( CLK : in    std_logic; 
             WE  : in    std_logic; 
             D   : in    std_logic_vector (31 downto 0); 
             ADD : in    std_logic_vector (4 downto 0); 
             DO  : out   std_logic_vector (31 downto 0));
   end component;
   
   component MUX5BIT
      port ( sel : in    std_logic; 
             A0  : in    std_logic_vector (4 downto 0); 
             A1  : in    std_logic_vector (4 downto 0); 
             O   : out   std_logic_vector (4 downto 0));
   end component;
   
   component OR5
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             I2 : in    std_logic; 
             I3 : in    std_logic; 
             I4 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR5 : component is "BLACK_BOX";
   
   component AND2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of AND2 : component is "BLACK_BOX";
   
   component AEQZ
      port ( Din   : in    std_logic_vector (31 downto 0); 
             A_eqz : out   std_logic);
   end component;
   
begin
   A(31 downto 0) <= A_DUMMY(31 downto 0);
   XLXI_1 : RAM32X32S
      port map (ADD(4 downto 0)=>sel_adr_A(4 downto 0),
                CLK=>clk,
                D(31 downto 0)=>C(31 downto 0),
                WE=>ram_we,
                DO(31 downto 0)=>A_DUMMY(31 downto 0));
   
   XLXI_2 : RAM32X32S
      port map (ADD(4 downto 0)=>sel_adr_B(4 downto 0),
                CLK=>clk,
                D(31 downto 0)=>C(31 downto 0),
                WE=>ram_we,
                DO(31 downto 0)=>B(31 downto 0));
   
   XLXI_9 : MUX5BIT
      port map (A0(4 downto 0)=>Aadr(4 downto 0),
                A1(4 downto 0)=>Cadr(4 downto 0),
                sel=>gpr_we,
                O(4 downto 0)=>sel_adr_A(4 downto 0));
   
   XLXI_10 : MUX5BIT
      port map (A0(4 downto 0)=>Badr(4 downto 0),
                A1(4 downto 0)=>Cadr(4 downto 0),
                sel=>gpr_we,
                O(4 downto 0)=>sel_adr_B(4 downto 0));
   
   XLXI_13 : RAM32X32S
      port map (ADD(4 downto 0)=>sel_adr_D(4 downto 0),
                CLK=>clk,
                D(31 downto 0)=>C(31 downto 0),
                WE=>ram_we,
                DO(31 downto 0)=>D(31 downto 0));
   
   XLXI_17 : MUX5BIT
      port map (A0(4 downto 0)=>Dadr(4 downto 0),
                A1(4 downto 0)=>Cadr(4 downto 0),
                sel=>gpr_we,
                O(4 downto 0)=>sel_adr_D(4 downto 0));
   
   XLXI_18 : OR5
      port map (I0=>Cadr(4),
                I1=>Cadr(3),
                I2=>Cadr(2),
                I3=>Cadr(1),
                I4=>Cadr(0),
                O=>XLXN_118);
   
   XLXI_19 : AND2
      port map (I0=>XLXN_118,
                I1=>gpr_we,
                O=>ram_we);
   
   XLXI_20 : AEQZ
      port map (Din(31 downto 0)=>A_DUMMY(31 downto 0),
                A_eqz=>A_EQZ);
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity IR_env_MUSER_DataPath is
   port ( CE     : in    std_logic; 
          clk    : in    std_logic; 
          DI     : in    std_logic_vector (31 downto 0); 
          Aadr   : out   std_logic_vector (4 downto 0); 
          Badr   : out   std_logic_vector (4 downto 0); 
          Cadr   : out   std_logic_vector (4 downto 0); 
          IMM    : out   std_logic_vector (15 downto 0); 
          OPCODE : out   std_logic_vector (5 downto 0));
end IR_env_MUSER_DataPath;

architecture BEHAVIORAL of IR_env_MUSER_DataPath is
   signal RDO    : std_logic_vector (31 downto 0);
   component REG32CE
      port ( CLK  : in    std_logic; 
             CE   : in    std_logic; 
             DIN  : in    std_logic_vector (31 downto 0); 
             DOUT : out   std_logic_vector (31 downto 0));
   end component;
   
   component BUF5
      port ( Din  : in    std_logic_vector (4 downto 0); 
             Dout : out   std_logic_vector (4 downto 0));
   end component;
   
   component BUF16
      port ( Din  : in    std_logic_vector (15 downto 0); 
             Dout : out   std_logic_vector (15 downto 0));
   end component;
   
   component BUF6
      port ( Din  : in    std_logic_vector (5 downto 0); 
             Dout : out   std_logic_vector (5 downto 0));
   end component;
   
begin
   XLXI_1 : REG32CE
      port map (CE=>CE,
                CLK=>clk,
                DIN(31 downto 0)=>DI(31 downto 0),
                DOUT(31 downto 0)=>RDO(31 downto 0));
   
   XLXI_2 : BUF5
      port map (Din(4 downto 0)=>RDO(20 downto 16),
                Dout(4 downto 0)=>Cadr(4 downto 0));
   
   XLXI_3 : BUF5
      port map (Din(4 downto 0)=>RDO(20 downto 16),
                Dout(4 downto 0)=>Badr(4 downto 0));
   
   XLXI_8 : BUF5
      port map (Din(4 downto 0)=>RDO(25 downto 21),
                Dout(4 downto 0)=>Aadr(4 downto 0));
   
   XLXI_10 : BUF16
      port map (Din(15 downto 0)=>RDO(15 downto 0),
                Dout(15 downto 0)=>IMM(15 downto 0));
   
   XLXI_11 : BUF6
      port map (Din(5 downto 0)=>RDO(31 downto 26),
                Dout(5 downto 0)=>OPCODE(5 downto 0));
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity DataPath is
   port ( addr_sel : in    std_logic; 
          B_CE     : in    std_logic; 
          clk      : in    std_logic; 
          C_CE     : in    std_logic; 
          Dadr     : in    std_logic_vector (4 downto 0); 
          DI       : in    std_logic_vector (31 downto 0); 
          GPR_we   : in    std_logic; 
          IR_CE    : in    std_logic; 
          PC_CE    : in    std_logic; 
          reset    : in    std_logic; 
          AO       : out   std_logic_vector (31 downto 0); 
          DO       : out   std_logic_vector (31 downto 0); 
          OPCODE   : out   std_logic_vector (5 downto 0); 
          PC       : out   std_logic_vector (15 downto 0));
end DataPath;

architecture BEHAVIORAL of DataPath is
   signal Aadr     : std_logic_vector (4 downto 0);
   signal Badr     : std_logic_vector (4 downto 0);
   signal Cadr     : std_logic_vector (4 downto 0);
   signal IMM      : std_logic_vector (15 downto 0);
   signal XLXN_10  : std_logic_vector (31 downto 0);
   signal XLXN_19  : std_logic_vector (31 downto 0);
   signal XLXN_20  : std_logic_vector (31 downto 0);
   signal XLXN_21  : std_logic;
   signal XLXN_22  : std_logic_vector (31 downto 0);
   signal XLXN_139 : std_logic_vector (15 downto 0);
   signal PC_DUMMY : std_logic_vector (15 downto 0);
   component GPRenv_MUSER_DataPath
      port ( C      : in    std_logic_vector (31 downto 0); 
             gpr_we : in    std_logic; 
             clk    : in    std_logic; 
             Aadr   : in    std_logic_vector (4 downto 0); 
             Badr   : in    std_logic_vector (4 downto 0); 
             Cadr   : in    std_logic_vector (4 downto 0); 
             Dadr   : in    std_logic_vector (4 downto 0); 
             A      : out   std_logic_vector (31 downto 0); 
             B      : out   std_logic_vector (31 downto 0); 
             A_EQZ  : out   std_logic; 
             D      : out   std_logic_vector (31 downto 0));
   end component;
   
   component IR_env_MUSER_DataPath
      port ( DI     : in    std_logic_vector (31 downto 0); 
             clk    : in    std_logic; 
             CE     : in    std_logic; 
             Cadr   : out   std_logic_vector (4 downto 0); 
             Badr   : out   std_logic_vector (4 downto 0); 
             Aadr   : out   std_logic_vector (4 downto 0); 
             IMM    : out   std_logic_vector (15 downto 0); 
             OPCODE : out   std_logic_vector (5 downto 0));
   end component;
   
   component REG32CE
      port ( CLK  : in    std_logic; 
             CE   : in    std_logic; 
             DIN  : in    std_logic_vector (31 downto 0); 
             DOUT : out   std_logic_vector (31 downto 0));
   end component;
   
   component CNT16
      port ( clk   : in    std_logic; 
             ce    : in    std_logic; 
             reset : in    std_logic; 
             cnt_o : out   std_logic_vector (15 downto 0));
   end component;
   
   component MMU
      port ( AO     : in    std_logic_vector (15 downto 0); 
             MMU_AO : out   std_logic_vector (31 downto 0));
   end component;
   
   component MUX16bit
      port ( sel : in    std_logic; 
             A   : in    std_logic_vector (15 downto 0); 
             B   : in    std_logic_vector (15 downto 0); 
             O   : out   std_logic_vector (15 downto 0));
   end component;
   
begin
   PC(15 downto 0) <= PC_DUMMY(15 downto 0);
   XLXI_1 : GPRenv_MUSER_DataPath
      port map (Aadr(4 downto 0)=>Aadr(4 downto 0),
                Badr(4 downto 0)=>Badr(4 downto 0),
                C(31 downto 0)=>XLXN_10(31 downto 0),
                Cadr(4 downto 0)=>Cadr(4 downto 0),
                clk=>clk,
                Dadr(4 downto 0)=>Dadr(4 downto 0),
                gpr_we=>GPR_we,
                A(31 downto 0)=>XLXN_20(31 downto 0),
                A_EQZ=>XLXN_21,
                B(31 downto 0)=>XLXN_19(31 downto 0),
                D(31 downto 0)=>XLXN_22(31 downto 0));
   
   XLXI_2 : IR_env_MUSER_DataPath
      port map (CE=>IR_CE,
                clk=>clk,
                DI(31 downto 0)=>DI(31 downto 0),
                Aadr(4 downto 0)=>Aadr(4 downto 0),
                Badr(4 downto 0)=>Badr(4 downto 0),
                Cadr(4 downto 0)=>Cadr(4 downto 0),
                IMM(15 downto 0)=>IMM(15 downto 0),
                OPCODE(5 downto 0)=>OPCODE(5 downto 0));
   
   XLXI_5 : REG32CE
      port map (CE=>C_CE,
                CLK=>clk,
                DIN(31 downto 0)=>DI(31 downto 0),
                DOUT(31 downto 0)=>XLXN_10(31 downto 0));
   
   XLXI_6 : REG32CE
      port map (CE=>B_CE,
                CLK=>clk,
                DIN(31 downto 0)=>XLXN_19(31 downto 0),
                DOUT(31 downto 0)=>DO(31 downto 0));
   
   XLXI_8 : CNT16
      port map (ce=>PC_CE,
                clk=>clk,
                reset=>reset,
                cnt_o(15 downto 0)=>PC_DUMMY(15 downto 0));
   
   XLXI_9 : MMU
      port map (AO(15 downto 0)=>XLXN_139(15 downto 0),
                MMU_AO(31 downto 0)=>AO(31 downto 0));
   
   XLXI_10 : MUX16bit
      port map (A(15 downto 0)=>IMM(15 downto 0),
                B(15 downto 0)=>PC_DUMMY(15 downto 0),
                sel=>addr_sel,
                O(15 downto 0)=>XLXN_139(15 downto 0));
   
end BEHAVIORAL;


