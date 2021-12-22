library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.reg_file_functions.all;
use ieee.math_real.all;

entity reg_file is
   generic(
      nr_regs   : natural := 4;
      reg_width : natural := 8
   );
   PORT (
      clk,                 -- clock input
      LE   : in std_logic; -- load enable input (active '1')
      nRST : in std_logic; -- reset input (active '0')
      dest_select,         -- register number destination select input
      A_select,            -- A, B bus destination select input
      B_select : in  std_logic_vector( sizeof(nr_regs - 1) - 1 downto 0);
      D        : in  std_logic_vector(reg_width - 1 downto 0); --data input bus input
      A, B     : out std_logic_vector(reg_width - 1 downto 0)  -- A, B bus output
   );
end reg_file;

architecture NDV of reg_file is

   constant nr_regs_size  : integer                                                         := integer(ceil(log2(real(nr_regs - 1))));
   signal load_enable_sig : std_logic_vector( nr_regs - 1 DOWNTO 0)                         := (others => '0');
   SIGNAL reg_file        : muxnto1_bus_type( nr_regs - 1 DOWNTO 0, reg_width - 1 DOWNTO 0) := (others => (others => '0'));

   type reg_file_array_type is array (nr_regs - 1 downto 0) of std_logic_vector(reg_width - 1 downto 0);
   signal reg_file_array : reg_file_array_type := (others => (others => '0'));

   type reg_mode_array_type is array (nr_regs - 1 downto 0) of std_logic_vector(1 downto 0);
   signal reg_mode_sig : reg_mode_array_type := (others => (others => '0'));

begin

   -- Convert register array to register file
   p_array2file : process(reg_file_array)

      variable reg_file_col : std_logic_vector(reg_width -1 downto 0) := (others => '0');

   begin
      for i in 0 to (nr_regs -1) loop
         reg_file_col := reg_file_array(i);
         for j in 0 to (reg_width - 1) loop
            reg_file(i,j) <= reg_file_col(j);
         end loop;
      end loop;
   end process p_array2file;

   --DMUX
   u_dmuxnto1 : entity work.dmuxnto1
      generic map (
         n_addr => nr_regs_size
      )
      port map (
         s => dest_select,
         w => LE,
         f => load_enable_sig
      );

   -- A bus output mux
   u_mux_bus_A : entity work.muxnto1_bus
      generic map (
         n_addr    => nr_regs_size,
         bus_width => reg_width
      )
      port map (
         s => A_select,
         w => reg_file,
         f => A
      );

   -- B bus output mux
   u_mux_bus_B : entity work.muxnto1_bus
      generic map (
         n_addr    => nr_regs_size,
         bus_width => reg_width
      )
      port map (
         s => B_select,
         w => reg_file,
         f => B
      );

   -- shift reg connections
   registers : for i in 0 to nr_regs -1 generate
      u_shift_reg : entity work.shift_reg
         generic map (
            reg_size => reg_width
         )
         port map (
            clk   => clk,
            nCLR  => nRST,
            sr_in => '0',
            sl_in => '0',
            s     => reg_mode_sig(i),
            x     => D,
            Q     => reg_file_array(i)
         );
   end generate registers;

   -- If load enable is '1', we need to set the mode of universal register to LOAD ("11")
   p_load2mode : process(load_enable_sig)
   begin
      for i in 0 to nr_regs -1 loop
         if load_enable_sig(i) = '1' then
            reg_mode_sig(i) <= "11";
         else -- We need this else to avoid latches in this process
            reg_mode_sig(i) <= "00";
         end if;
      end loop;
   end process p_load2mode;

end NDV;