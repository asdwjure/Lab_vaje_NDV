---------------------------------------------------------------------------------------------------
--! @brief  Vajo sem naredil po svoje, z uporabo t.i. "Two process coding style". Zadevo sem
-- simuliral in naceloma deluje enako kot naj bi tista v navodilih. Ce so kaksna vprasanja,
-- me prosim kontaktirajte.
--! @details 
--!
--! @author 64180134
--!
--! @file CslTwoProcessTemplate.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity lifo is
   generic(
      TPD_G      : time    := 1 ns;
      lifo_width : natural := 4;  -- velikost podatka sklada
      lifo_size  : natural := 8); -- velikost sklada
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
---------------------------------------------------------------------------------------------------
architecture rtl of lifo is

   type lifoType is array (lifo_size - 1 downto 0) of std_logic_vector(lifo_width - 1 downto 0);

   --! Record containing all register elements
   type RegType is record
      count     : unsigned(lifo_size-1 downto 0);
      lifo_reg  : lifoType;
      full_sig  : std_logic;
      empty_sig : std_logic;
   end record RegType;

   --! Initial and reset values for all register elements
   constant REG_INIT_C : RegType := (
         count     => (others => '0'),
         lifo_reg  => (others => (others => '0')),
         full_sig  => '0',
         empty_sig => '0'
      );

   --! Output of registers
   signal r : RegType;

   --! p_Combinatorial input to registers
   signal rin : RegType;

   signal data_sig : std_logic_vector(data'range) := (others => '0');

   constant ZERO_C : std_logic_vector(lifo_width-1 downto 0) := (others => '0');

---------------------------------------------------------------------------------------------------
begin

   p_Comb : process(nEnable, PUSH, POP, data, data_sig, r)
      variable v : RegType;
   begin

      v := r; --! default assignment


      -- Logic

      --------------------------------------------------------------------------
      -- Check LIFO full or empty
      if r.count >= to_unsigned(lifo_size, v.count'length) then
         v.full_sig := '1';
      else
         v.full_sig := '0';
      end if;

      if r.count = 0 then
         v.empty_sig := '1';
      else
         v.empty_sig := '0';
      end if;
      --------------------------------------------------------------------------------

      --------------------------------------------------------------------------
      -- LIFO logic
      if nEnable = '0' then

         if PUSH = '1' and v.full_sig = '0' then
            v.lifo_reg := r.lifo_reg(r.lifo_reg'left-1 downto 0) & data; -- shift left
            v.count    := r.count + 1;
         elsif POP = '1' and v.empty_sig = '0' then
            v.lifo_reg := ZERO_C & r.lifo_reg(r.lifo_reg'left downto 1); -- shift left
            v.count    := r.count - 1;
         end if;

      end if;
      --------------------------------------------------------------------------

      if nCLR = '0' then --! reset condition
         v := REG_INIT_C;
      end if;

      rin <= v; --! drive register inputs

      --! drive outputs
      FULL  <= v.full_sig;
      EMPTY <= v.empty_sig;

   end process p_Comb;

   -----------------------------------------------------------------------------
   p_Seq : process(clk)
   begin
      if rising_edge(clk) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;


   --------------------------------------------------------------------------
   -- Data I/O management
   data_sig <= r.lifo_reg(0);
   data     <= data_sig when POP='1' else (others => 'Z');
   --------------------------------------------------------------------------

end rtl;
---------------------------------------------------------------------------------------------------