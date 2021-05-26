library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE work.reg_file_functions.all;
USE work.cpu_datapath_functions.all;
USE work.cpu_functions.all;
use ieee.math_real.all;

-- opcode summary:
-- MB NOT(RW) MD ALU_M  ALU_F
-- 0  0        0  0     000   A plus B
-- 0  0        0  0     001   A minus B
-- 0  0        0  0     010   A plus 1
-- 0  0        0  0     011   A minus 1
-- 0  0        0  0     100   A plus A
-- 0  0        0  0     101   minus 1 (2' complement)
-- 0  0        0  1     000   A and B  
-- 0  0        0  1     001   A nand B
-- 0  0        0  1     010   A or B
-- 0  0        0  1     011   A nor B
-- 0  0        0  1     100   A xor B
-- 0  0        0  1     101   A xnor B
-- 0  0        0  1     110   TEST A
-- 0  0        0  1     111   NOT IMPLEMENTED
-- 1  0        0  1     111   LDI (load immediate)
-- 1  0        0  0     000   ADI (add immediate)
-- 1  0        0  0     001   SBI (subtract immediate)
-- 0  0        1  1     110   LOAD A
-- 0  0        0  1     110   MOVE A   (MOVE R(DR)<-R(SA))
-- 0  0        0  1     111   MOVE B   (MOVE R(DR)<-R(SB))
-- 0  1        0  1     111   STORE B
--             JB          BC 
-- 1  1        0  1     11 0  BRZ R(SA)
-- 1  1        0  0     00 1  BRN R(SA)
-- 1  1        1  0     00 0  JMP

entity cpu is
   generic(
      nr_regs     : natural := 8;
      reg_width   : natural := 16;
      ram_nr_addr : natural := 4;
      rom_nr_addr : natural := 4
   );
   PORT (
      clk,                                                           -- clock input
      nRST           : in  std_logic;                                -- reset input   (active '0')
      IOBUS_WnR      : out std_logic;                                -- io bus write input  (active '1')
      IOBUS_Data_in  : in  std_logic_vector(reg_width - 1 downto 0); -- io bus data input
      IOBUS_Address  : out std_logic_vector(reg_width - 1 downto 0); -- io address bus 
      IOBUS_Data_out : out std_logic_vector(reg_width - 1 downto 0); -- io bus data output
      ProgMem_Addr   : out std_logic_vector(reg_width - 1 downto 0); -- program memory address
      IR             : in  std_logic_vector(reg_width - 1 downto 0)  -- program memory data input 
   );
end cpu;

architecture ideal of cpu is

   signal MW : std_logic; -- ram write input (active '1')

   signal PL         : std_logic; -- Increment (PC = PC + 1) when inactive, or load when active (PL = '1')
   signal JB         : std_logic; -- jump/branch when PL='1' (jump => PL = '1', load counter with predefined value)
   signal JB_address : std_logic_vector(reg_width - 1 downto 0);
   signal BC         : std_logic; -- branch control (when '0' -> check Z bit, when '1' check N bit)

   signal RW : std_logic; -- register write input  (active '1')
   signal DA,             -- destination register number select input
   AA,                    -- A, B bus register number select input
   BA : std_logic_vector( sizeof(nr_regs - 1) - 1 downto 0);
   signal MB : std_logic; -- constant/operand bus B bus multiplexer control signal
   signal MD : std_logic; -- external data/alu result multiplexer control signal

   signal ALU_mode     : std_logic;                    --mode of alu operation (M in upper table)
   signal ALU_function : std_logic_vector(2 downto 0); -- function of ALU (F in upper table)
   signal ALU_N_bit    : std_logic;                    -- Negative bit of alu operation
   signal ALU_C_bit    : std_logic;                    -- Carry bit of alu operation
   signal ALU_V_bit    : std_logic;                    -- Overflow bit of alu operation
   signal ALU_Z_bit    : std_logic;                    -- Zero bit of alu operation

   signal Const_in : std_logic_vector(reg_width - 1 downto 0); -- constant input bus
   signal PC       : std_logic_vector(reg_width - 1 downto 0);
   signal A_bus    : std_logic_vector(reg_width - 1 downto 0); -- A bus from CPU
   
begin

   JB_address   <= STD_LOGIC_VECTOR(resize(signed(ir(8 downto 6) & ir(2 downto 0)), JB_address'length));
   Const_in     <= STD_LOGIC_VECTOR(resize(unsigned(ir(2 downto 0)), Const_in'length));
   ProgMem_Addr <= PC;
   IOBUS_WnR    <= MW;
   DA           <= IR(8 downto 6);
   AA           <= IR(5 downto 3);
   BA           <= IR(2 downto 0);
   MB           <= IR(15);
   ALU_mode     <= ir(12);
   ALU_function <= IR(11 downto 10) & (IR(9) and (not PL));
   MD           <= IR(13);
   RW           <= NOT IR(14);
   MW           <= IR(14) AND (NOT IR(15));
   PL           <= IR(14) AND IR(15);
   JB           <= IR(13);
   BC           <= IR(9);

   cpu_datapath_map : entity work.cpu_datapath
      generic map (
         nr_regs => nr_regs, reg_width => reg_width
      )
      port map (
         clk          => clk,
         RW           => RW,
         nRST         => nRST,
         DA           => DA,
         AA           => AA,
         BA           => BA,
         MB           => MB,
         MD           => MD,
         ALU_mode     => ALU_mode,
         ALU_function => ALU_function,
         ALU_N_bit    => ALU_N_bit,
         ALU_C_bit    => ALU_C_bit,
         ALU_V_bit    => ALU_V_bit,
         ALU_Z_bit    => ALU_Z_bit,
         Const_in     => Const_in,
         Data_in      => IOBUS_Data_in,
         Address_out  => IOBUS_Address,
         Data_out     => IOBUS_Data_out
      );

   branch_ctr_map : entity work.branch_ctrl
      generic map (
         ctr_width => reg_width
      )
      port map (
         clk        => clk,
         nRST       => nRST,
         N          => ALU_N_bit,
         C          => ALU_C_bit,
         V          => ALU_V_bit,
         Z          => ALU_Z_bit,
         PL         => PL,
         JB         => JB,
         BC         => BC,
         JB_address => JB_address,
         PC         => PC
      );

end ideal;