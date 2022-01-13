library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.cordic_pkg.all;

ENTITY barrel_shifter_sra IS
   GENERIC(
      width : integer := 32;
      size  : integer := 32
   );
   PORT(
      input  : IN  std_logic_vector (WIDTH-1 DOWNTO 0);
      output : OUT std_logic_vector (WIDTH-1 DOWNTO 0);
      n      : IN  std_logic_vector (sizeof(size - 1) - 1 DOWNTO 0)
   );
END barrel_shifter_sra;

architecture ndv of barrel_shifter_sra is
   type barrel_shifter_type is array (0 to size - 1) of std_logic_vector (width - 1 downto 0);
   signal barrel_shifter : barrel_shifter_type := ( others => (others => '0') );
begin

   -- 1D polje 'barrel shifter'
   process(input)
   begin
      for i in 0 to (size-1) loop -- tvori vse mozne pomike
         barrel_shifter(i) <= std_logic_vector(resize(signed(input(WIDTH - 1 downto i)), output'length));
      end loop;
   end process;

   -- element polja, ki se pojavi na izhodu
   output <= barrel_shifter(to_integer(unsigned(n))); -- bus multiplexer

end ndv;