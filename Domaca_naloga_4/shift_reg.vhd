LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg is
   generic( reg_size : natural := 4); --velikost registra
   PORT (
      clk,                                                 -- signal ure (prozen na sprednjo fronto)
      nCLR,                                                -- signal za asinhrono brisanje (vsebina registra gre na 0)
      sr_in,                                               -- zaporedni vhod za pomikanje desno (takrat gre sr_in->MSB)
      sl_in : IN  std_logic;                               -- zaporedni vhod pri pomikanju levo (takrat gre sl_in->LSB)
      s     : in  std_logic_vector(1 downto 0);            -- izbira operacije pomikalnega registra
      x     : in  std_logic_vector(reg_size - 1 downto 0); -- vhod za vzporedno nalaganje
      Q     : out std_logic_vector(reg_size - 1 downto 0)  -- vzporedni izhod registra
   );
end shift_reg;

architecture NDV of shift_reg is

   type dff_mux_in is array (reg_size - 1 downto 0) of std_logic_vector(3 downto 0);
   signal D : dff_mux_in := (others => (others => '0'));

   signal Q_sig : std_logic_vector(reg_size-1 downto 0);

BEGIN


   D(0)          <= x(0) & sl_in & Q_sig(1) & Q_sig(0);
   D(reg_size-1) <= x(reg_size-1) & Q_sig(reg_size-2) & sr_in & Q_sig(reg_size-1);

   Signal_generador : for i in 1 to reg_size-2 generate
      D(i) <= x(i) & Q_sig(i-1) & Q_sig(i+1) & Q_sig(i);
   end generate Signal_generador;


   ULM_generador : for i in 0 to reg_size-1 generate
      u_muxdff : entity work.muxdff
         generic map (
            n_addr => 2
         )
         port map (
            S      => S,
            D      => D(i),
            clk    => clk,
            nCLEAR => nCLR,
            Q      => Q_sig(i)
         );
   end generate ULM_generador;

   Q <= Q_sig;

end NDV;

