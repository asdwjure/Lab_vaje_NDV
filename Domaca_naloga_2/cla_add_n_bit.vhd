LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY cla_add_n_bit IS
   generic(
      n : natural := 8
   );
   PORT (
      Cin              : in  std_logic;
      X, Y             : in  std_logic_vector(n-1 downto 0);
      S                : out std_logic_vector(n-1 downto 0);
      Gout, Pout, Cout : out std_logic
   );
END cla_add_n_bit;

ARCHITECTURE NDV OF cla_add_n_bit IS

   signal C, G, P : std_logic_vector(n-1 downto 0);
   signal S_sig   : std_logic_vector(n-1 downto 0);

BEGIN

   stages : for i in 0 to n-1 generate

      stage_0 : if i = 0 generate
         cla_gp_0 : entity work.cla_gp
            port map (
               Cin  => Cin,
               x    => x(i),
               y    => y(i),
               S    => S_sig(0),
               Cout => C(i),
               g    => g(i),
               p    => p(i)
            );
      end generate stage_0;

      stage_n : if i > 0 generate
         cla_gp_n : entity work.cla_gp
            port map (
               Cin  => C(i-1),
               x    => x(i),
               y    => y(i),
               S    => S_sig(i),
               Cout => C(i),
               g    => g(i),
               p    => p(i)
            );
      end generate stage_n;

   end generate stages;

   S <= S_sig;
   Pout <= p(n-1);
   Gout <= g(n-1);
   Cout <= C(n-1);

END NDV; 