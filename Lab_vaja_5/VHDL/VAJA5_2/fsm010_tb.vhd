LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY fsm010_tb IS
END fsm010_tb;

ARCHITECTURE behavior OF fsm010_tb IS

   -- Component Declaration for the Unit Under Test (UUT)

   COMPONENT fsm010
      PORT(
         nY         : OUT std_logic;
         state_code : OUT std_logic_vector(3 downto 0);
         nX         : IN  std_logic;
         nRST       : IN  std_logic;
         nTRIGGER   : IN  std_logic
      );
   END COMPONENT;


   --Inputs
   signal nX       : std_logic := '0';
   signal nRST     : std_logic := '0';
   signal nTRIGGER : std_logic := '0';

   --Outputs
   signal nY         : std_logic;
   signal state_code : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 

   constant clk_period : time := 10 ns;

BEGIN

      -- Instantiate the Unit Under Test (UUT)
      uut : fsm010 PORT MAP (
         nY         => nY,
         state_code => state_code,
         nX         => nX,
         nRST       => nRST,
         nTRIGGER   => nTRIGGER
      );

   -- Clock process definitions
   clk_process : process
   begin
      nTRIGGER <= '0';
      wait for clk_period/2;
      nTRIGGER <= '1';
      wait for clk_period/2;
   end process;


   -- Stimulus process
   stim_proc : process
   begin
      -- hold reset state for 100 ns.
      wait for 100 ns;

      wait for clk_period; -- Definicija vhodnih signalov za prvi cikel ure. Preostale naredite sami.
      nRST <= '0';
      nX   <= '0';

      wait for clk_period;
      nRST <= '1';
      nX   <= '1';

      wait for clk_period;
      nRST <= '1';
      nX   <= '0';

      wait for clk_period;
      nRST <= '1';
      nX   <= '1';

      wait for clk_period;
      nRST <= '1';
      nX   <= '0';

      wait for clk_period;
      nRST <= '1';
      nX   <= '1';

      wait for clk_period;
      nRST <= '1';
      nX   <= '0';

      wait for clk_period;
      nRST <= '1';
      nX   <= '0';

      wait for clk_period;
      nRST <= '1';
      nX   <= '0';

      wait for clk_period;
      nRST <= '1';
      nX   <= '0';

      wait for clk_period;
      nRST <= '1';
      nX   <= '1';

      wait for clk_period;
      nRST <= '1';
      nX   <= '0';

      wait for clk_period;
      nRST <= '1';
      nX   <= '1';

      wait for clk_period;
      nRST <= '1';
      nX   <= '0';

      wait;
   end process;

END;
