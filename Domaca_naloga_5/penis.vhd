library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.ALL;
use ieee.numeric_std.all;

entity lifo is
   generic( lifo_width : natural := 4; -- velikost podatka sklada
      lifo_size : natural := 8);       -- velikost sklada
   PORT (
      clk,                                                    -- signal ure
      nCLR,                                                   -- signal asinhronega brisanja vsebine sklada (aktiven '0')
      nEnable,                                                -- signal omogoèanja sklada (aktiven '0', sicer drži vsebino)
      PUSH,                                                   -- operacija vpisa na sklad (aktiven '1')
      POP  : IN    std_logic;                                 -- operacija branja s sklada (aktiven '1')
      data : inout std_logic_vector(lifo_width - 1 downto 0); --tristanjski izhod sklada
      FULL,                                                   -- izhod, ki postane '1', ko je sklad poln
      EMPTY : OUT std_logic                                   -- izhod, ki postane '0', ko je sklad prazen
   );
end lifo;

architecture ndv of lifo is

   type shift_reg_array_type is array (lifo_width - 1 downto 0) of std_logic_vector(lifo_size - 1 downto 0);
   signal Q : shift_reg_array_type := (others => (others => '0'));

   signal s : std_logic_vector(1 downto 0);

   signal data_sig : std_logic_vector(data'range);

   constant ud_ctr_size : integer := integer(ceil(log2(real(lifo_size + 1))));
   signal ud_ctr_mode   : std_logic_vector(1 downto 0);
   signal ctr_sig       : std_logic_vector(ud_ctr_size-1 downto 0);

   signal full_sig  : std_logic;
   signal empty_sig : std_logic;

begin

   S <= "10" when nEnable='0' and PUSH='1' and full_sig='0' else
      "01" when nEnable='0' and POP='1' and empty_sig='0' else
      "00";

   smeti : for i in 0 to lifo_width-1 generate
      u_shift_reg : entity work.shift_reg
         generic map (
            reg_size => lifo_size
         )
         port map (
            clk   => clk,
            nCLR  => nCLR,
            sr_in => '0',
            sl_in => data(i),
            s     => s,
            x     => (others => '0'),
            Q     => Q(i)
         );
   end generate smeti;

   krneki : for i in 0 to lifo_width-1 generate
      dff_1 : entity work.dff
         port map (
            D       => Q(i)(0),
            clk     => clk,
            nPRESET => '1',
            nCLEAR  => nCLR,
            Q       => data_sig(i)
         );
   end generate krneki;

   data <= data_sig when S="01" else (others => 'Z');


   ud_ctr_mode <= "00" when S="00" else
      "10" when S="10" else
      "11" when S="01";

   u_ud_counter : entity work.ud_counter
      generic map (
         ctr_size => ud_ctr_size
      )
      port map (
         clk  => clk,
         nCLR => nCLR,
         D_nU => ud_ctr_mode(0),
         EN   => ud_ctr_mode(1),
         RCO  => open,
         Q    => ctr_sig
      );

   empty_sig <= '1' when ctr_sig = 0 else '0';
   full_sig  <= '1' when ctr_sig = std_logic_vector(to_unsigned(lifo_size, ctr_sig'length)) else '0';

   EMPTY <= empty_sig;
   FULL  <= full_sig;

end ndv;