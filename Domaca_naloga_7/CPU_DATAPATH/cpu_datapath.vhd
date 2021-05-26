library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.reg_file_functions.all;
USE work.cpu_datapath_functions.all;
use ieee.math_real.all;

entity cpu_datapath is
   generic(
      nr_regs   : natural := 4;
      reg_width : natural := 8
   );
   PORT (
      clk,                 -- clock input
      RW   : in std_logic; -- register write input (active '1')
      nRST : in std_logic; -- reset input (active '0')
      DA,                  -- destination register number select input
      AA,                  -- A, B bus register number select input
      BA : in std_logic_vector( sizeof(nr_regs - 1) - 1 downto 0);
      MB : in std_logic;                                           -- constant/operand bus B bus multiplexer control signal
      MD : in std_logic;                                           -- external data/alu result multiplexer control signal
                                                                   -- ALU operation summary:
                                                                   -- M F          operation
                                                                   -- 0 0 0 0 S = X plus Y
                                                                   -- 0 0 0 1 S = X minus Y
                                                                   -- 0 0 1 0 S = X plus 1
                                                                   -- 0 0 1 1 S = X minus 1
                                                                   -- 0 1 0 0 S = X plus X
                                                                   -- 0 1 0 1 S = minus 1 (dvojiški komplement)
                                                                   -- 1 0 0 0 S = X and Y   
                                                                   -- 1 0 0 1 S = X nand Y
                                                                   -- 1 0 1 0 S = X or Y
                                                                   -- 1 0 1 1 S = X nor Y
                                                                   -- 1 1 0 0 S = X xor Y
                                                                   -- 1 1 0 1 S = X xnor Y
                                                                   -- 1 1 1 0 S = X
                                                                   -- 1 1 1 1 S = Y
      ALU_mode     : in  std_logic;                                --mode of alu operation (M in upper table)
      ALU_function : in  std_logic_vector(2 downto 0);             -- function of ALU (F in upper table)
      ALU_N_bit    : out std_logic;                                -- Negative bit of alu operation
      ALU_C_bit    : out std_logic;                                -- Carry bit of alu operation
      ALU_V_bit    : out std_logic;                                -- Overflow bit of alu operation
      ALU_Z_bit    : out std_logic;                                -- Zero bit of alu operation
      Const_in     : in  std_logic_vector(reg_width - 1 downto 0); --constant input bus
      Data_in      : in  std_logic_vector(reg_width - 1 downto 0); --data input bus input
      Address_out  : out std_logic_vector(reg_width - 1 downto 0); --address bus output
      Data_out     : out std_logic_vector(reg_width - 1 downto 0)  --data bus output
   );
end cpu_datapath;

architecture ideal of cpu_datapath is
   -- 2/1 bus multiplexer input type definitions
   type mux_vector_array_type is array (1 downto 0) of std_logic_vector(reg_width - 1 downto 0);
   signal b_mux_vector_array : mux_vector_array_type := (others => (others => '0'));
   signal d_mux_vector_array : mux_vector_array_type := (others => (others => '0'));

   signal b_mux_2d_bit_array : muxnto1_bus_type( 1 DOWNTO 0, reg_width - 1 DOWNTO 0) := (others => (others => '0'));
   signal d_mux_2d_bit_array : muxnto1_bus_type( 1 DOWNTO 0, reg_width - 1 DOWNTO 0) := (others => (others => '0'));

   signal A_data, B_data, B_muxed, D_data : std_logic_vector(reg_width - 1 downto 0);
   signal ALU_result                      : std_logic_vector(reg_width - 1 downto 0);

   signal MB_vector : std_logic_vector(0 downto 0); -- MB constant/operand bus B bus multiplexer control signal
   signal MD_vector : std_logic_vector(0 downto 0); -- external data/alu result multiplexer control signal

begin

   regfile : entity work.reg_file
      generic map(
         nr_regs   => nr_regs,
         reg_width => reg_width
      )
      port map (
         clk         => clk,
         LE          => RW,
         nRST        => nRST,
         dest_select => DA,
         A_select    => AA,
         B_select    => BA,
         D           => D_data,
         A           => A_data,
         B           => B_data
      );
   MUXB : entity work.muxnto1_bus
      generic map(
         n_addr    => 1,
         bus_width => reg_width
      )
      port map (
         s => MB_vector,
         w => b_mux_2d_bit_array,
         f => B_muxed
      );
   MUXD : entity work.muxnto1_bus
      generic map(
         n_addr    => 1,
         bus_width => reg_width
      )
      port map (
         s => MD_vector,
         w => d_mux_2d_bit_array,
         f => D_data
      );

   Address_out           <= A_data;
   Data_out              <= B_muxed;
   b_mux_vector_array(0) <= B_data;
   b_mux_vector_array(1) <= Const_in;
   d_mux_vector_array(0) <= ALU_result;
   d_mux_vector_array(1) <= Data_in;

   ALU : entity work.ndn_alu
      generic map(
         n => reg_width
      )
      port map(
         M        => ALU_mode,
         F        => ALU_function,
         X        => A_data,
         Y        => B_muxed,
         S        => ALU_result,
         Negative => ALU_N_bit,
         Cout     => ALU_C_bit,
         Overflow => ALU_V_bit,
         Zero     => ALU_Z_bit
      );

   b_mux : process (b_mux_vector_array, b_mux_2d_bit_array)
      variable b_mux_col : std_logic_vector (reg_width-1 downto 0);
   begin
      for i in 0 to 1 loop
         b_mux_col := b_mux_vector_array(i);
         for j in 0 to reg_width-1 loop
            b_mux_2d_bit_array(i, j) <= b_mux_col(j);
         end loop;
      end loop;
   end process;

   d_mux : process (d_mux_vector_array, d_mux_2d_bit_array)
      variable d_mux_col : std_logic_vector (reg_width-1 downto 0);
   begin
      for i in 0 to 1 loop
         d_mux_col := d_mux_vector_array(i);
         for j in 0 to reg_width-1 loop
            d_mux_2d_bit_array(i, j) <= d_mux_col(j);
         end loop;
      end loop;
   end process;

   MB_vector(0) <= MB;
   MD_vector(0) <= MD;

end ideal;