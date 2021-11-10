-- NOTE: Zadevo sem raje realiziral s FSM, ker je to v tem primeru bolj smiselno.
-- Uporabil sem metodo programiranja "Two process coding style", ker to pac uporabljam vedno.
-- Ce je kaj nejasnega, me prosim kontaktirajte.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity PS2_KEYBOARD is
   generic (
      TPD_G : time := 1 ns
   );
   port (
      clk          : in  STD_LOGIC;                   --sistemska ura 50MHz
      PS2_CLK      : in  STD_LOGIC;                   --ura iz PS/2 tipkovnice
      PS2_DATA     : in  STD_LOGIC;                   --podatek iz PS/2 tipkovnice
      PS2_code_new : out STD_LOGIC;                   --zastavica da je nov podatek pripravljen na ps2_code vodilu
      PS2_code     : out STD_LOGIC_VECTOR(7 downto 0) --podatkovno vodilo PS/2 
   );
end PS2_KEYBOARD;
---------------------------------------------------------------------------------------------------
architecture rtl of PS2_KEYBOARD is

   type StateType is (
         IDLE_S,
         RCV_BITS_S,
         CHECK_PARITY_S
      );

   --! Record containing all register elements
   type RegType is record
      state        : StateType;
      ps2ClkSync   : std_logic;
      ps2ClkRED    : std_logic;
      ps2DataSync  : std_logic;
      dataShiftReg : std_logic_vector(10 downto 0);
      dataIndex    : natural;
      dataError    : std_logic;
      dataOut      : std_logic_vector(7 downto 0);
      dataOutValid : std_logic;
   end record RegType;

   --! Initial and reset values for all register elements
   constant REG_INIT_C : RegType := (
         state        => IDLE_S,
         ps2ClkSync   => '0',
         ps2ClkRED    => '0',
         ps2DataSync  => '0',
         dataShiftReg => (others => '0'),
         dataIndex    => 0,
         dataError    => '0',
         dataOut      => (others => '0'),
         dataOutValid => '0'
      );

   --! Output of registers
   signal r : RegType;

   --! p_Combinatorial input to registers
   signal rin : RegType;

---------------------------------------------------------------------------------------------------
begin

   p_Comb : process(clk, r, PS2_CLK, PS2_DATA)
      variable v : RegType := REG_INIT_C;
   begin

      v              := r; --! default assignment
      v.dataOutValid := '0';

      -- Generatate rising edge pulse on PS2 CLK
      v.ps2ClkSync := PS2_CLK;
      v.ps2ClkRED  := PS2_CLK and not(r.ps2ClkSync);

      -- Sync PS2 DATA
      v.ps2DataSync := PS2_DATA;

      --------------------------------------------------------------------------------
      -- MAIN FSM
      --------------------------------------------------------------------------------
      case (r.state) is
         when IDLE_S =>
            v.dataIndex := 0;
            if r.ps2ClkSync = '0' and r.ps2DataSync = '0' then -- Start condition
               v.state := RCV_BITS_S;
            end if;

         -----------------------------------------------------------------------
         when RCV_BITS_S =>
            if v.ps2ClkRED = '1' then
               v.dataShiftReg := r.ps2DataSync & r.dataShiftReg(r.dataShiftReg'left downto 1);
               if r.dataIndex = 10 then
                  v.state := CHECK_PARITY_S;
               else
                  v.dataIndex := r.dataIndex + 1;
               end if;

            end if;

         -----------------------------------------------------------------------
         when CHECK_PARITY_S =>

            v.dataError := (
                  not r.dataShiftReg(0) -- TODO: Tu je napacen NOT ker je MSB in LSB obrnjen
                  and r.dataShiftReg(10)
                  and (
                  r.dataShiftReg(9)
                  xor r.dataShiftReg(8)
                  xor r.dataShiftReg(7)
                  xor r.dataShiftReg(6)
                  xor r.dataShiftReg(5)
                  xor r.dataShiftReg(4)
                  xor r.dataShiftReg(3)
                  xor r.dataShiftReg(2)
                  xor r.dataShiftReg(1)
               )
            );

            if v.dataError = '1' then
               -- TODO: ERROR handling
               v.state := IDLE_S;
            else
               v.dataOut      := r.dataShiftReg(8 downto 1);
               v.dataOutValid := '1';
               v.state := IDLE_S;
            end if;

         -----------------------------------------------------------------------
         when others =>
            v := REG_INIT_C;
      end case;
      --------------------------------------------------------------------------
      -- END MAIN FSM
      --------------------------------------------------------------------------

      rin <= v; --! drive register inputs

      --! drive outputs
      PS2_code     <= r.dataOut;
      PS2_code_new <= r.dataOutValid;

   end process p_Comb;

   p_Seq : process(clk)
   begin
      if rising_edge(clk) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------
