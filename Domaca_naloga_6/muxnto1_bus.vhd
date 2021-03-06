LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE work.reg_file_functions.all;

ENTITY muxnto1_bus IS
   generic(
      n_addr    : INTEGER := 2;
      bus_width : INTEGER := 8
   );
   PORT (
      s : IN  std_logic_vector( n_addr - 1 downto 0);
      w : IN  muxnto1_bus_type( 2**n_addr - 1 DOWNTO 0, bus_width - 1 DOWNTO 0);
      f : OUT std_logic_vector( bus_width - 1 downto 0)
   );
END muxnto1_bus;

ARCHITECTURE NDV OF muxnto1_bus IS
   type mux_addr_type is array (bus_width - 1 downto 0) of std_logic_vector(2**n_addr - 1 downto 0);
   signal mux_addr : mux_addr_type := (others => (others => '0'));
BEGIN

   -- std_logic array to std_logic_vector conversion
   p_bit2vector : process(w)

      variable mux_addr_col : std_logic_vector(2**n_addr -1 downto 0) := (others => '0');

   begin
      for i in 0 to (bus_width - 1) loop   -- Row
         for j in 0 to (2**n_addr -1) loop -- Column
            mux_addr_col(j) := w(j,i);
         end loop;

         mux_addr(i) <= mux_addr_col; -- connect variable to column of std_logic_vector
      end loop;
   end process p_bit2vector;

   -- Connecting to single bit muxes
   mux_gen : for i in 0 to (bus_width - 1) generate

      u_muxnto1 : entity work.muxnto1
         generic map (
            n_addr => n_addr
         )
         port map (
            s => s,
            w => mux_addr(i),
            f => f(i)
         );

   end generate mux_gen;

END NDV;