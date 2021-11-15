library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_cla is
   generic(
      n : natural := 8
   );
   port(
      M                                          : in  std_logic;                    --nacin delovanja ('0' => aritmetièni, '1' => logicni)        
      F                                          : in  std_logic_vector(2 downto 0); -- funkcijski vhod za operacije
      X, Y                                       : in  std_logic_vector(n-1 downto 0);
      S                                          : out std_logic_vector(n-1 downto 0);
      Negative, Cout, Overflow, Zero, Gout, Pout : out std_logic
   );
end alu_cla;

architecture NDV of alu_cla is

   signal aluOperationSig : std_logic_vector(3 downto 0) := "0000";
   signal claYSig         : std_logic_vector(n-1 downto 0);
   signal addSubSig       : std_logic; -- '0' for adding, '1' for substraction
   signal claCOutSig      : std_logic;
   signal claPoutSig      : std_logic;
   signal claGoutSig      : std_logic;
   signal claSSig         : std_logic_vector(n-1 downto 0);
   signal n_sig           : std_logic;

   signal s_sig : std_logic_vector(n-1 downto 0);
   -- signal x_sig : std_logic_vector(n-1 downto 0);

   constant ZERO_C : std_logic_vector(n-1 downto 0) := (others => '0');
   constant ONE_C  : std_logic_vector(n-1 downto 0) := (0      => '1', others => '0');

begin

   u_cla_add_n_bit : entity work.cla_add_n_bit
      generic map (
         n => n
      )
      port map (
         Cin  => addSubSig,
         X    => X,
         Y    => claYSig,
         S    => claSSig,
         Gout => claGoutSig,
         Pout => claPoutSig,
         Cout => claCOutSig
      );


   -----------------------------------------------------------------------------
   -- Status flags
   Cout <= claCOutSig;
   Zero <= '1' when s_sig = ZERO_C else '0';

   n_sig    <= s_sig(s_sig'left);
   Negative <= n_sig;

   Overflow <= ( not(X(n-1)) and not(claYSig(n-1)) and claSSig(n-1) ) or ( X(n-1) and claYSig(n-1) and not(claSSig(n-1)) );

   -----------------------------------------------------------------------------
   -- Operation mode selection
   aluOperationSig <= M & F;
   addSubSig       <= aluOperationSig(0);

   -- Select y signal to the CLA with regard to arithmetic mode selected
   with aluOperationSig select
   claYSig <=
      Y          when "0000", -- X+Y
      not(Y)     when "0001", -- X-Y
      ONE_C      when "0010", -- X+1
      not(ONE_C) when "0011", -- X-1
      X          when "0100", -- X+X
      Y          when others;

   -- Select between arithmetic and logic mode
   with aluOperationSig select
   s_sig <=
      -- Arithmetic mode
      claSSig         when "0000", -- X+Y
      claSSig         when "0001", -- X-Y
      claSSig         when "0010", -- X+1
      claSSig         when "0011", -- X-1
      claSSig         when "0100", -- X+X
      (others => '1') when "0101", -- minus 1 (two's complement)

      -- Logic mode
      X and Y         when "1000",
      X nand Y        when "1001",
      X or Y          when "1010",
      X nor Y         when "1011",
      X xor Y         when "1100",
      X xnor Y        when "1101",
      X               when "1110",
      Y               when "1111",
      (others => '0') when others;

   -----------------------------------------------------------------------------
   -- Drive outputs
   S    <= s_sig;
   Pout <= claPoutSig;
   Gout <= claGoutSig;

end NDV;
