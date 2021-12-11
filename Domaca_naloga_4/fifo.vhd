LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
   generic( fifo_width : natural := 4; -- dolžina vhodnega podatka
      fifo_size : natural := 8);       -- število hranjenih podatkov
   PORT (
      clk,                                                      -- signal ure (spremembe na sprednjo fronto)
      nCLR,                                                     -- signal za asinhrono brisanje (vsebina FIFO gre na 0)
      nEnable,                                                  --  signal za omogoèanje FIFO ('0'-> omogoèen vpis, '1' -> ohranja stanje)
      LOAD     : IN  std_logic;                                 -- signal za omogoèanje nalaganja ('1'-> fifo_in se vpiše)
      fifo_in  : in  std_logic_vector(fifo_width - 1 downto 0); -- vhodni podatek
      fifo_out : out std_logic_vector(fifo_width - 1 downto 0)  -- izhodni podatek
   );
end fifo;

architecture NDV of fifo is
   type shift_reg_array_type is array (fifo_width - 1 downto 0) of std_logic_vector(fifo_size - 1 downto 0);
   signal Q : shift_reg_array_type := (others => (others => '0'));

   signal s : std_logic_vector(1 downto 0);

begin

   S <= "10" when nEnable='0' and LOAD='1' else "00";

   smeti : for i in 0 to fifo_width-1 generate
      shift_reg_1 : entity work.shift_reg
         generic map (
            reg_size => fifo_size
         )
         port map (
            clk   => clk,
            nCLR  => nCLR,
            sr_in => '0',
            sl_in => fifo_in(i),
            s     => s,
            x     => (others => '0'),
            Q     => Q(i)
         );

      fifo_out(i) <= Q(i)(fifo_size - 1);

   end generate smeti;


end NDV;

