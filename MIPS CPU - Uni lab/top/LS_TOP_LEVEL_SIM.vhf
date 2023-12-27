--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : LS_TOP_LEVEL_SIM.vhf
-- /___/   /\     Timestamp : 05/16/2022 02:22:08
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #6/Home_S25/LS_TOP_LEVEL_SIM.vhf" -w "C:/Users/Administrator/Documents/Uni/Adv. Computer structure lab/Lab #6/Home_S25/LS_TOP_LEVEL_SIM.sch"
--Design Name: LS_TOP_LEVEL_SIM
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

entity GPRenv_MUSER_LS_TOP_LEVEL_SIM is
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
end GPRenv_MUSER_LS_TOP_LEVEL_SIM;

architecture BEHAVIORAL of GPRenv_MUSER_LS_TOP_LEVEL_SIM is
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

entity IR_env_MUSER_LS_TOP_LEVEL_SIM is
   port ( CE     : in    std_logic; 
          clk    : in    std_logic; 
          DI     : in    std_logic_vector (31 downto 0); 
          Aadr   : out   std_logic_vector (4 downto 0); 
          Badr   : out   std_logic_vector (4 downto 0); 
          Cadr   : out   std_logic_vector (4 downto 0); 
          IMM    : out   std_logic_vector (15 downto 0); 
          OPCODE : out   std_logic_vector (5 downto 0));
end IR_env_MUSER_LS_TOP_LEVEL_SIM;

architecture BEHAVIORAL of IR_env_MUSER_LS_TOP_LEVEL_SIM is
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

entity DataPath_MUSER_LS_TOP_LEVEL_SIM is
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
end DataPath_MUSER_LS_TOP_LEVEL_SIM;

architecture BEHAVIORAL of DataPath_MUSER_LS_TOP_LEVEL_SIM is
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
   component GPRenv_MUSER_LS_TOP_LEVEL_SIM
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
   
   component IR_env_MUSER_LS_TOP_LEVEL_SIM
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
   XLXI_1 : GPRenv_MUSER_LS_TOP_LEVEL_SIM
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
   
   XLXI_2 : IR_env_MUSER_LS_TOP_LEVEL_SIM
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



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity LS_machine_MUSER_LS_TOP_LEVEL_SIM is
   port ( ack_n     : in    std_logic; 
          clk       : in    std_logic; 
          Dadr      : in    std_logic_vector (4 downto 0); 
          DI        : in    std_logic_vector (31 downto 0); 
          reset     : in    std_logic; 
          step_en   : in    std_logic; 
          addr_sel  : out   std_logic; 
          AO        : out   std_logic_vector (31 downto 0); 
          as_n      : out   std_logic; 
          busy      : out   std_logic; 
          b_ce      : out   std_logic; 
          c_ce      : out   std_logic; 
          DLX_state : out   std_logic_vector (2 downto 0); 
          DO        : out   std_logic_vector (31 downto 0); 
          gpr_we    : out   std_logic; 
          in_init   : out   std_logic; 
          ir_ce     : out   std_logic; 
          MAC_state : out   std_logic_vector (1 downto 0); 
          mr        : out   std_logic; 
          mw        : out   std_logic; 
          opcode    : out   std_logic_vector (5 downto 0); 
          PC        : out   std_logic_vector (15 downto 0); 
          pc_ce     : out   std_logic; 
          stop_n    : out   std_logic; 
          wr_n      : out   std_logic);
end LS_machine_MUSER_LS_TOP_LEVEL_SIM;

architecture BEHAVIORAL of LS_machine_MUSER_LS_TOP_LEVEL_SIM is
   signal busy_DUMMY      : std_logic;
   signal b_ce_DUMMY      : std_logic;
   signal DLX_state_DUMMY : std_logic_vector (2 downto 0);
   signal gpr_we_DUMMY    : std_logic;
   signal mr_DUMMY        : std_logic;
   signal MAC_state_DUMMY : std_logic_vector (1 downto 0);
   signal mw_DUMMY        : std_logic;
   signal c_ce_DUMMY      : std_logic;
   signal pc_ce_DUMMY     : std_logic;
   signal addr_sel_DUMMY  : std_logic;
   signal opcode_DUMMY    : std_logic_vector (5 downto 0);
   signal ir_ce_DUMMY     : std_logic;
   component DLX_Control
      port ( clk      : in    std_logic; 
             reset    : in    std_logic; 
             step_en  : in    std_logic; 
             busy     : in    std_logic; 
             opcode   : in    std_logic_vector (5 downto 0); 
             in_init  : out   std_logic; 
             mr       : out   std_logic; 
             mw       : out   std_logic; 
             B_ce     : out   std_logic; 
             C_ce     : out   std_logic; 
             GPR_we   : out   std_logic; 
             PC_ce    : out   std_logic; 
             IR_ce    : out   std_logic; 
             addr_sel : out   std_logic; 
             state    : inout std_logic_vector (2 downto 0));
   end component;
   
   component MAC
      port ( clk    : in    std_logic; 
             rst    : in    std_logic; 
             mr     : in    std_logic; 
             mw     : in    std_logic; 
             ack_n  : in    std_logic; 
             State  : inout std_logic_vector (1 downto 0); 
             as_n   : out   std_logic; 
             wr_n   : out   std_logic; 
             busy   : out   std_logic; 
             stop_n : out   std_logic);
   end component;
   
   component DataPath_MUSER_LS_TOP_LEVEL_SIM
      port ( clk      : in    std_logic; 
             DI       : in    std_logic_vector (31 downto 0); 
             reset    : in    std_logic; 
             PC_CE    : in    std_logic; 
             IR_CE    : in    std_logic; 
             C_CE     : in    std_logic; 
             B_CE     : in    std_logic; 
             addr_sel : in    std_logic; 
             GPR_we   : in    std_logic; 
             Dadr     : in    std_logic_vector (4 downto 0); 
             OPCODE   : out   std_logic_vector (5 downto 0); 
             DO       : out   std_logic_vector (31 downto 0); 
             AO       : out   std_logic_vector (31 downto 0); 
             PC       : out   std_logic_vector (15 downto 0));
   end component;
   
begin
   addr_sel <= addr_sel_DUMMY;
   busy <= busy_DUMMY;
   b_ce <= b_ce_DUMMY;
   c_ce <= c_ce_DUMMY;
   DLX_state(2 downto 0) <= DLX_state_DUMMY(2 downto 0);
   gpr_we <= gpr_we_DUMMY;
   ir_ce <= ir_ce_DUMMY;
   MAC_state(1 downto 0) <= MAC_state_DUMMY(1 downto 0);
   mr <= mr_DUMMY;
   mw <= mw_DUMMY;
   opcode(5 downto 0) <= opcode_DUMMY(5 downto 0);
   pc_ce <= pc_ce_DUMMY;
   XLXI_1 : DLX_Control
      port map (busy=>busy_DUMMY,
                clk=>clk,
                opcode(5 downto 0)=>opcode_DUMMY(5 downto 0),
                reset=>reset,
                step_en=>step_en,
                addr_sel=>addr_sel_DUMMY,
                B_ce=>b_ce_DUMMY,
                C_ce=>c_ce_DUMMY,
                GPR_we=>gpr_we_DUMMY,
                in_init=>in_init,
                IR_ce=>ir_ce_DUMMY,
                mr=>mr_DUMMY,
                mw=>mw_DUMMY,
                PC_ce=>pc_ce_DUMMY,
                state(2 downto 0)=>DLX_state_DUMMY(2 downto 0));
   
   XLXI_2 : MAC
      port map (ack_n=>ack_n,
                clk=>clk,
                mr=>mr_DUMMY,
                mw=>mw_DUMMY,
                rst=>reset,
                as_n=>as_n,
                busy=>busy_DUMMY,
                stop_n=>stop_n,
                wr_n=>wr_n,
                State(1 downto 0)=>MAC_state_DUMMY(1 downto 0));
   
   XLXI_5 : DataPath_MUSER_LS_TOP_LEVEL_SIM
      port map (addr_sel=>addr_sel_DUMMY,
                B_CE=>b_ce_DUMMY,
                clk=>clk,
                C_CE=>c_ce_DUMMY,
                Dadr(4 downto 0)=>Dadr(4 downto 0),
                DI(31 downto 0)=>DI(31 downto 0),
                GPR_we=>gpr_we_DUMMY,
                IR_CE=>ir_ce_DUMMY,
                PC_CE=>pc_ce_DUMMY,
                reset=>reset,
                AO(31 downto 0)=>AO(31 downto 0),
                DO(31 downto 0)=>DO(31 downto 0),
                OPCODE(5 downto 0)=>opcode_DUMMY(5 downto 0),
                PC(15 downto 0)=>PC(15 downto 0));
   
end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity LS_TOP_LEVEL_SIM is
   port ( clk_in     : in    std_logic; 
          PC_step_en : in    std_logic; 
          rst        : in    std_logic);
end LS_TOP_LEVEL_SIM;

architecture BEHAVIORAL of LS_TOP_LEVEL_SIM is
   signal ack_n      : std_logic;
   signal addr_sel   : std_logic;
   signal AO         : std_logic_vector (31 downto 0);
   signal as_n       : std_logic;
   signal busy       : std_logic;
   signal b_ce       : std_logic;
   signal clk        : std_logic;
   signal c_ce       : std_logic;
   signal DI         : std_logic_vector (31 downto 0);
   signal DLX_STATE  : std_logic_vector (2 downto 0);
   signal DO         : std_logic_vector (31 downto 0);
   signal gpr_we     : std_logic;
   signal in_init    : std_logic;
   signal ir_ce      : std_logic;
   signal MAC_STATE  : std_logic_vector (1 downto 0);
   signal mr         : std_logic;
   signal mw         : std_logic;
   signal OPCODE     : std_logic_vector (5 downto 0);
   signal PC         : std_logic_vector (15 downto 0);
   signal pc_ce      : std_logic;
   signal reset      : std_logic;
   signal step_en    : std_logic;
   signal stop_n     : std_logic;
   signal wr_n       : std_logic;
   signal XLXN_32    : std_logic_vector (4 downto 0);
   component LS_machine_MUSER_LS_TOP_LEVEL_SIM
      port ( clk       : in    std_logic; 
             reset     : in    std_logic; 
             step_en   : in    std_logic; 
             ack_n     : in    std_logic; 
             DI        : in    std_logic_vector (31 downto 0); 
             Dadr      : in    std_logic_vector (4 downto 0); 
             b_ce      : out   std_logic; 
             as_n      : out   std_logic; 
             wr_n      : out   std_logic; 
             in_init   : out   std_logic; 
             AO        : out   std_logic_vector (31 downto 0); 
             DO        : out   std_logic_vector (31 downto 0); 
             ir_ce     : out   std_logic; 
             pc_ce     : out   std_logic; 
             gpr_we    : out   std_logic; 
             busy      : out   std_logic; 
             mr        : out   std_logic; 
             mw        : out   std_logic; 
             addr_sel  : out   std_logic; 
             stop_n    : out   std_logic; 
             opcode    : out   std_logic_vector (5 downto 0); 
             DLX_state : out   std_logic_vector (2 downto 0); 
             MAC_state : out   std_logic_vector (1 downto 0); 
             PC        : out   std_logic_vector (15 downto 0); 
             c_ce      : out   std_logic);
   end component;
   
   component IO_SIMUL
      port ( clk_in     : in    std_logic; 
             RST        : in    std_logic; 
             PC_step_en : in    std_logic; 
             WR_OUT_N   : in    std_logic; 
             AS_N       : in    std_logic; 
             MDO        : in    std_logic_vector (31 downto 0); 
             MAO        : in    std_logic_vector (31 downto 0); 
             step_en    : out   std_logic; 
             RESET      : out   std_logic; 
             ACK_N      : out   std_logic; 
             CLK        : out   std_logic; 
             DO         : out   std_logic_vector (31 downto 0));
   end component;
   
begin
   XLXI_1 : LS_machine_MUSER_LS_TOP_LEVEL_SIM
      port map (ack_n=>ack_n,
                clk=>clk,
                Dadr(4 downto 0)=>XLXN_32(4 downto 0),
                DI(31 downto 0)=>DI(31 downto 0),
                reset=>reset,
                step_en=>step_en,
                addr_sel=>addr_sel,
                AO(31 downto 0)=>AO(31 downto 0),
                as_n=>as_n,
                busy=>busy,
                b_ce=>b_ce,
                c_ce=>c_ce,
                DLX_state(2 downto 0)=>DLX_STATE(2 downto 0),
                DO(31 downto 0)=>DO(31 downto 0),
                gpr_we=>gpr_we,
                in_init=>in_init,
                ir_ce=>ir_ce,
                MAC_state(1 downto 0)=>MAC_STATE(1 downto 0),
                mr=>mr,
                mw=>mw,
                opcode(5 downto 0)=>OPCODE(5 downto 0),
                PC(15 downto 0)=>PC(15 downto 0),
                pc_ce=>pc_ce,
                stop_n=>stop_n,
                wr_n=>wr_n);
   
   XLXI_2 : IO_SIMUL
      port map (AS_N=>as_n,
                clk_in=>clk_in,
                MAO(31 downto 0)=>AO(31 downto 0),
                MDO(31 downto 0)=>DO(31 downto 0),
                PC_step_en=>PC_step_en,
                RST=>rst,
                WR_OUT_N=>wr_n,
                ACK_N=>ack_n,
                CLK=>clk,
                DO(31 downto 0)=>DI(31 downto 0),
                RESET=>reset,
                step_en=>step_en);
   
end BEHAVIORAL;


