--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : DATA_PATH_REGS.vhf
-- /___/   /\     Timestamp : 06/21/2022 19:13:19
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/DATA_PATH_REGS.vhf" -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #7 final/Home_S25/DATA_PATH_REGS.sch"
--Design Name: DATA_PATH_REGS
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

entity GPRenv_MUSER_DATA_PATH_REGS is
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
end GPRenv_MUSER_DATA_PATH_REGS;

architecture BEHAVIORAL of GPRenv_MUSER_DATA_PATH_REGS is
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

entity DATA_PATH_REGS is
   port ( A_CE    : in    std_logic; 
          B_CE    : in    std_logic; 
          clk     : in    std_logic; 
          C_CE    : in    std_logic; 
          Dadr    : in    std_logic_vector (4 downto 0); 
          DI      : in    std_logic_vector (31 downto 0); 
          DINT    : in    std_logic_vector (31 downto 0); 
          GPR_WE  : in    std_logic; 
          IR_CE   : in    std_logic; 
          ITYPE   : in    std_logic; 
          JLINK   : in    std_logic; 
          MDR_CE  : in    std_logic; 
          MDR_SEL : in    std_logic; 
          PC_CE   : in    std_logic; 
          reset   : in    std_logic; 
          A       : out   std_logic_vector (31 downto 0); 
          AEQZ    : out   std_logic; 
          B       : out   std_logic_vector (31 downto 0); 
          D       : out   std_logic_vector (31 downto 0); 
          IR      : out   std_logic_vector (31 downto 0); 
          MDR     : out   std_logic_vector (31 downto 0); 
          OPCODE  : out   std_logic_vector (5 downto 0); 
          PC      : out   std_logic_vector (31 downto 0));
end DATA_PATH_REGS;

architecture BEHAVIORAL of DATA_PATH_REGS is
   attribute BOX_TYPE   : string ;
   signal A_reg_in : std_logic_vector (31 downto 0);
   signal B_reg_in : std_logic_vector (31 downto 0);
   signal Cadr     : std_logic_vector (4 downto 0);
   signal Cadr_0   : std_logic_vector (4 downto 0);
   signal XLXN_19  : std_logic_vector (31 downto 0);
   signal XLXN_183 : std_logic_vector (31 downto 0);
   signal IR_DUMMY : std_logic_vector (31 downto 0);
   component REG32CE
      port ( CLK  : in    std_logic; 
             CE   : in    std_logic; 
             DIN  : in    std_logic_vector (31 downto 0); 
             DOUT : out   std_logic_vector (31 downto 0));
   end component;
   
   component GPRenv_MUSER_DATA_PATH_REGS
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
   
   component MUX32bit
      port ( sel : in    std_logic; 
             A   : in    std_logic_vector (31 downto 0); 
             B   : in    std_logic_vector (31 downto 0); 
             O   : out   std_logic_vector (31 downto 0));
   end component;
   
   component REG32RST
      port ( CLK  : in    std_logic; 
             CE   : in    std_logic; 
             RST  : in    std_logic; 
             DIN  : in    std_logic_vector (31 downto 0); 
             DOUT : out   std_logic_vector (31 downto 0));
   end component;
   
   component MUX5BIT
      port ( sel : in    std_logic; 
             A0  : in    std_logic_vector (4 downto 0); 
             A1  : in    std_logic_vector (4 downto 0); 
             O   : out   std_logic_vector (4 downto 0));
   end component;
   
   component BUF6
      port ( Din  : in    std_logic_vector (5 downto 0); 
             Dout : out   std_logic_vector (5 downto 0));
   end component;
   
   component OR2
      port ( I0 : in    std_logic; 
             I1 : in    std_logic; 
             O  : out   std_logic);
   end component;
   attribute BOX_TYPE of OR2 : component is "BLACK_BOX";
   
begin
   IR(31 downto 0) <= IR_DUMMY(31 downto 0);
   XLXI_1 : REG32CE
      port map (CE=>C_CE,
                CLK=>clk,
                DIN(31 downto 0)=>DINT(31 downto 0),
                DOUT(31 downto 0)=>XLXN_19(31 downto 0));
   
   XLXI_5 : REG32CE
      port map (CE=>A_CE,
                CLK=>clk,
                DIN(31 downto 0)=>A_reg_in(31 downto 0),
                DOUT(31 downto 0)=>A(31 downto 0));
   
   XLXI_6 : REG32CE
      port map (CE=>B_CE,
                CLK=>clk,
                DIN(31 downto 0)=>B_reg_in(31 downto 0),
                DOUT(31 downto 0)=>B(31 downto 0));
   
   XLXI_18 : GPRenv_MUSER_DATA_PATH_REGS
      port map (Aadr(4 downto 0)=>IR_DUMMY(25 downto 21),
                Badr(4 downto 0)=>IR_DUMMY(20 downto 16),
                C(31 downto 0)=>XLXN_19(31 downto 0),
                Cadr(4 downto 0)=>Cadr(4 downto 0),
                clk=>clk,
                Dadr(4 downto 0)=>Dadr(4 downto 0),
                gpr_we=>GPR_WE,
                A(31 downto 0)=>A_reg_in(31 downto 0),
                A_EQZ=>AEQZ,
                B(31 downto 0)=>B_reg_in(31 downto 0),
                D(31 downto 0)=>D(31 downto 0));
   
   XLXI_20 : REG32CE
      port map (CE=>IR_CE,
                CLK=>clk,
                DIN(31 downto 0)=>DI(31 downto 0),
                DOUT(31 downto 0)=>IR_DUMMY(31 downto 0));
   
   XLXI_36 : REG32CE
      port map (CE=>MDR_CE,
                CLK=>clk,
                DIN(31 downto 0)=>XLXN_183(31 downto 0),
                DOUT(31 downto 0)=>MDR(31 downto 0));
   
   XLXI_40 : MUX32bit
      port map (A(31 downto 0)=>DINT(31 downto 0),
                B(31 downto 0)=>DI(31 downto 0),
                sel=>MDR_SEL,
                O(31 downto 0)=>XLXN_183(31 downto 0));
   
   XLXI_43 : REG32RST
      port map (CE=>PC_CE,
                CLK=>clk,
                DIN(31 downto 0)=>DINT(31 downto 0),
                RST=>reset,
                DOUT(31 downto 0)=>PC(31 downto 0));
   
   XLXI_63 : MUX5BIT
      port map (A0(4 downto 0)=>IR_DUMMY(15 downto 11),
                A1(4 downto 0)=>IR_DUMMY(20 downto 16),
                sel=>ITYPE,
                O(4 downto 0)=>Cadr_0(4 downto 0));
   
   XLXI_65 : BUF6
      port map (Din(5 downto 0)=>IR_DUMMY(31 downto 26),
                Dout(5 downto 0)=>OPCODE(5 downto 0));
   
   XLXI_67 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(1),
                O=>Cadr(1));
   
   XLXI_68 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(2),
                O=>Cadr(2));
   
   XLXI_69 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(3),
                O=>Cadr(3));
   
   XLXI_70 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(4),
                O=>Cadr(4));
   
   XLXI_71 : OR2
      port map (I0=>JLINK,
                I1=>Cadr_0(0),
                O=>Cadr(0));
   
end BEHAVIORAL;


