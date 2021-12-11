---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file CslTwoProcessTemplate.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ud_counter is
   generic(
      ctr_size : natural := 6;
      TPD_G    : time    := 1 ns
   );
   PORT (
      clk,                                              -- signal ure
      nCLR,                                             -- signal za brisanje števca (aktiven '0')
      D_nU,                                             -- signal za smer štetja števca (narašèajoèe -> '0')
      EN  : IN  std_logic;                              -- signal za omogoèanje štetja (aktiven '1')
      RCO : out std_logic;                              -- izhodni prenos na naslednjo stopnjo (Ripple carry out)
      Q   : out std_logic_vector(ctr_size - 1 downto 0) -- izhodno štetje števca
   );
end ud_counter;
---------------------------------------------------------------------------------------------------
architecture rtl of ud_counter is

   --! Record containing all register elements
   type RegType is record
      count      : unsigned(ctr_size-1 downto 0);
      rco_signal : std_logic;
   end record RegType;

   --! Initial and reset values for all register elements
   constant REG_INIT_C : RegType := (
         count      => (others => '0'),
         rco_signal => '0'
      );

   --! Output of registers
   signal r : RegType;

   --! p_Combinatorial input to registers
   signal rin : RegType;

   constant COUNT_MAX_C : unsigned(ctr_size-1 downto 0) := (others => '1');
   constant COUNT_MIN_C : unsigned(ctr_size-1 downto 0) := (others => '0');

---------------------------------------------------------------------------------------------------
begin

   p_Comb : process(EN, D_nU, nCLR, r)
      variable v : RegType;
   begin

      v := r; --! default assignment


		-- Logic
      if EN = '1' then
         if D_nU = '0' then -- count up
            v.count := r.count + 1;
         else -- Count down
            v.count := r.count - 1;
         end if;

      end if;

      if v.count = COUNT_MAX_C and D_nU = '0' then
         v.rco_signal  :=  '1';
      elsif v.count = COUNT_MIN_C and D_nU = '1' then
         v.rco_signal  :=  '1';
      else
         v.rco_signal  :=  '0';
      end if;


      if nCLR = '0' then --! reset condition
         v := REG_INIT_C;
      end if;

      rin <= v; --! drive register inputs

      --! drive outputs
      RCO <= r.rco_signal;
      Q   <= std_logic_vector(r.count);

   end process p_Comb;

   p_Seq : process(clk)
   begin
      if rising_edge(clk) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------