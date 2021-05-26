library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.reg_file_functions.all;
USE work.branch_ctrl_functions.all;
use ieee.math_real.all;

--    branch controller operation summary
--    PL    JB    BC    Z     N     PC
--    0     X     X     X     X     PC + 1
--    1     0     0     1     X     branch taken (Z='1')
--    1     0     0     0     X     branch not taken (Z='0')   => PC + 1
--    1     0     1     X     1     branch taken (N='1')
--    1     0     1     X     0     branch not taken (N='0')   => PC + 1
--    1     1     X     X     X     jump

entity branch_ctrl is
   generic( ctr_width : natural := 16);
   PORT (clk,                     -- clock input
      nRST,                     -- reset input  (active '0')
      N,                          -- negative bit from ALU operation
      C,                          -- carry bit from ALU operation
      V,                          -- overflow bit from ALU operation
      Z,                          -- zero bit from ALU operation
      PL,                         -- Increment (PC = PC + 1) when inactive, or load when active (PL = '1')
      JB,                         -- jump/branch when PL='1' (jump => PL = '1', load counter with predefined value)
      BC         : in  std_logic; --branch control (when '0' -> check Z bit, when '1' check N bit)
      JB_address : in  std_logic_vector(ctr_width - 1 downto 0);
      PC         : out std_logic_vector(ctr_width - 1 downto 0)
   );
end branch_ctrl;

architecture ideal of branch_ctrl is
   -- 2/1 bus multiplexer input type definitions
   type mux_vector_array_type is array (1 downto 0) of std_logic_vector(ctr_width - 1 downto 0);
   signal branch_mux_vector_array : mux_vector_array_type                                 := (others => (others => '0'));
   signal branch_mux_2d_bit_array : muxnto1_bus_type( 1 DOWNTO 0, ctr_width - 1 DOWNTO 0) := (others => (others => '0'));
   signal branch_mux_vector       : std_logic_vector(0 downto 0); -- PC mode multiplexer control signal

   signal PC_sig       : std_logic_vector(ctr_width - 1 downto 0);
   signal PC_load_addr : std_logic_vector(ctr_width - 1 downto 0); --absolute address load when JUMP operation
   signal Adder_result : std_logic_vector(ctr_width - 1 downto 0);
   signal CE           : std_logic; -- count enable
   signal nBRANCH      : std_logic; -- branching control signal (active '0')
begin

   --  ba   - always
   --  bneg - on negative                 (N='1')
   --  bpos - on positive                 (N='0')
   --  beq  - on zero                     (Z='1')
   --  bne  - on not zero                 (Z='0')
   --  bvs  - on overflow set             (V='1')
   --  bvc  - on overflow clear           (V='0')
   --  bcs  - on carry set                (C='1')
   --  bcc  - on carry clear              (C='0')
   --  bl   - on less than                ((N xor V)='1')
   --  ble  - on less than or equal       ((Z or (N xor V))='1')
   --  be   - on equal                    (Z='1')
   --  bne  - on not equal                (Z='0')
   --  bge  - on greater than or equal    ((N xor V)='0')
   --  bg   - on greater than             ((Z or (N xor V))='0')

   --    branch controller operation summary
   --    PL    JB    BC    Z     N     PC
   --    0     X     X     X     X     PC + 1
   --    1     0     0     1     X     branch taken (Z='1')
   --    1     0     0     0     X     branch not taken (Z='0')   => PC + 1
   --    1     0     1     X     1     branch taken (N='1')
   --    1     0     1     X     0     branch not taken (N='0')   => PC + 1
   --    1     1     X     X     X     jump

   nBRANCH <= '0' when (PL = '1' AND ((BC = '0' AND Z = '1') OR (BC = '1' AND N = '1') OR JB = '1')) else '1';
   CE      <= '1' when (PL = '0') OR (nBRANCH ='1') ELSE '0';
   PC      <= PC_sig;

   PC_COUNTER : entity work.counter
      generic map(
         ctr_size => ctr_width
      )
      port map(
         clk   => clk,
         nCLR  => nRST,
         nLOAD => nBRANCH,
         ENP   => CE,
         ENT   => CE,
         x     => PC_load_addr,
         Q     => PC_sig
      );

   ADDER : entity work.cla_add_n_bit
      generic map(
         n => ctr_width
      )
      port map(
         Cin => '0',
         X   => JB_address,
         Y   => PC_sig,
         S   => Adder_result
      );

   MUX : entity work.muxnto1_bus
      generic map(
         n_addr    => 1,
         bus_width => ctr_width
      )
      port map (
         s => branch_mux_vector,
         w => branch_mux_2d_bit_array,
         f => PC_load_addr
      );

   branch_mux_vector_array(0) <= Adder_result;
   branch_mux_vector_array(1) <= JB_address;
   branch_mux_vector(0)       <= JB;

   branch_mux : process (branch_mux_vector_array, branch_mux_2d_bit_array)
      variable branch_mux_vector_col : std_logic_vector (ctr_width-1 downto 0);
   begin
      for i in 0 to 1 loop
         branch_mux_vector_col := branch_mux_vector_array(i);
         for j in 0 to ctr_width-1 loop
            branch_mux_2d_bit_array(i,j) <= branch_mux_vector_col(j);
         end loop;
      end loop;
   end process;

end ideal;