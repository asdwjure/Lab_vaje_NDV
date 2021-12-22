LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY dmuxnto1 IS
   generic(
      n_addr : natural := 2
   );
   PORT (
      s : in  std_logic_vector(n_addr - 1 downto 0);
      w : in  STD_LOGIC;
      f : OUT std_logic_vector(2**n_addr - 1 downto 0)
   );
END dmuxnto1;

ARCHITECTURE NDV OF dmuxnto1 IS

   signal addr  : integer                                  := 0;
   signal f_sig : std_logic_vector(2**n_addr - 1 downto 0) := (others => '0');

BEGIN

   addr  <= to_integer(unsigned(s));
   f_sig <= std_logic_vector(to_unsigned(2**addr, 2**n_addr));

   f <= f_sig when w = '1' else (others => '0');

END NDV;