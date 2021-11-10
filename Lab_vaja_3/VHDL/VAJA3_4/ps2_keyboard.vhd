
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity PS2_KEYBOARD is
   port(
      clk          : in  STD_LOGIC;                   --sistemska ura 50MHz
      PS2_CLK      : in  STD_LOGIC;                   --ura iz PS/2 tipkovnice
      PS2_DATA     : in  STD_LOGIC;                   --podatek iz PS/2 tipkovnice
      PS2_code_new : out STD_LOGIC;                   --zastavica da je nov podatek pripravljen na ps2_code vodilu
      PS2_code     : out STD_LOGIC_VECTOR(7 downto 0) --podatkovno vodilo PS/2 
   );
end PS2_KEYBOARD;

architecture arch of PS2_KEYBOARD is

   -- Signals
   signal ps2DataSync : std_logic;
   signal ps2ClkSync  : std_logic;

   signal shiftRegData : std_logic_vector(10 downto 0) := "00000000000";
   signal dataError    : std_logic;

   signal counterRco : std_logic;
   signal dataValid : std_logic;



begin

   -----------------------------------------------------------------------------
   -- Modules
   -----------------------------------------------------------------------------
   u_Dflipflop_data : entity work.Dflipflop
      port map (
         nRST => '1',
         clk  => clk,
         D    => PS2_DATA,
         Q    => ps2DataSync
      );

   u_Dflipflop_clk : entity work.Dflipflop
      port map (
         nRST => '1',
         clk  => clk,
         D    => PS2_CLK,
         Q    => ps2ClkSync
      );

   u_module_m_counter : entity work.module_m_counter
      generic map (
         M => 3000
      )
      port map (
         nRST => ps2ClkSync,
         clk  => clk,
         CTR  => open,
         RCO  => counterRco
      );

   u_shiftReg : entity work.shiftReg
      generic map (
         PAR_BITS => 11
      )
      port map (
         CLK          => ps2ClkSync,
         SERIAL_IN    => ps2DataSync,
         PARALLEL_OUT => shiftRegData
      );

   --u_Dflipflop_dataOut : entity work.Dflipflop
   --   port map (
   --      nRST => '1',
   --      clk  => dataValid,
   --      D    => shiftRegData(8 downto 1),
   --      Q    => PS2_code
   --   );

   --u_Dflipflop_dataValid : entity work.Dflipflop
   --   port map (
   --      nRST => '1',
   --      clk  => clk,
   --      D    => dataValid,
   --      Q    => PS2_code_new
   --   );


   p_Seq : process( clk, dataValid )
   begin
      if rising_edge(clk) then
         PS2_code_new <= dataValid;
      end if;

      if rising_edge(dataValid) then
         PS2_code <= shiftRegData(8 downto 1);
      end if;
   end process p_Seq;



   dataError <= not (
         not shiftRegData(0)
         and shiftRegData(10)
         and (
         shiftRegData(9)
         xor shiftRegData(8)
         xor shiftRegData(7)
         xor shiftRegData(6)
         xor shiftRegData(5)
         xor shiftRegData(4)
         xor shiftRegData(3)
         xor shiftRegData(2)
         xor shiftRegData(1)
      )
   );

   dataValid <= dataError and counterRco;

end arch;
