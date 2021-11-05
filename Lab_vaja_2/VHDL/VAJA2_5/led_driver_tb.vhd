library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

 
ENTITY led_driver_tb IS
END led_driver_tb;
 
ARCHITECTURE behavior OF led_driver_tb IS 
 
    -- Deklaracija spremenljivk za vezje, ki ga simuliramo (Unit Under Test - UUT)
 
    COMPONENT leddriver
    PORT(
         LED : OUT  std_logic_vector(6 downto 0);
         nDIGIT : OUT  std_logic_vector(3 downto 0);
         T : IN  std_logic_vector(3 downto 0);
         S : IN  std_logic_vector(3 downto 0);
         D : IN  std_logic_vector(3 downto 0);
         E : IN  std_logic_vector(3 downto 0);
         DIGIT_SHIFT : IN  std_logic
        );
    END COMPONENT;
    

   --vhodi
   signal T : std_logic_vector(3 downto 0) := (others => '0');
   signal S : std_logic_vector(3 downto 0) := (others => '0');
   signal D : std_logic_vector(3 downto 0) := (others => '0');
   signal E : std_logic_vector(3 downto 0) := (others => '0');
   signal DIGIT_SHIFT : std_logic := '0';

 	--izhodi
   signal LED : std_logic_vector(6 downto 0);
   signal nDIGIT : std_logic_vector(3 downto 0);
   
	-- Ker ure nimamo definirane, moramo spremeniti <clolck> v novo spremenljivko in jo definirati kot signal 
 
   constant clk_period : time := 10 ns;
	signal clk : std_logic;
 
BEGIN
 
   uut: leddriver PORT MAP (
          LED => LED,
          nDIGIT => nDIGIT,
          T => T,
          S => S,
          D => D,
          E => E,
          DIGIT_SHIFT => DIGIT_SHIFT
        );

   -- Definicija urinega impulza
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Simulacijski procesni stavek
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- simulacijski stavki 
			T <= "0001";
			S <= "1001";
			D <= "0111";
			E <= "1000";

			DIGIT_SHIFT <= '0';
						
			wait for clk_period*10;
			DIGIT_SHIFT <= '1';
			
			wait for clk_period*10;
			DIGIT_SHIFT <= '0';
			
			wait for clk_period*10;
			DIGIT_SHIFT <= '1';
			
			wait for clk_period*10;
			DIGIT_SHIFT <= '0';
			
			wait for clk_period*10;
			DIGIT_SHIFT <= '1';
			
			wait for clk_period*10;
			DIGIT_SHIFT <= '0';
			
			wait for clk_period*10;
			DIGIT_SHIFT <= '1';
			
			wait for clk_period*10;
			DIGIT_SHIFT <= '0';
			
			wait for clk_period*10;
			DIGIT_SHIFT <= '1';


      wait;
   end process;

END;
