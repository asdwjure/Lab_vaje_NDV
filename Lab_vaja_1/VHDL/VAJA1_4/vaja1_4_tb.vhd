LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY vaja1_4_tb IS
END vaja1_4_tb;
 
ARCHITECTURE behavior OF vaja1_4_tb IS 
 
    -- Deklaracija komponente za simulacijo (Unit under test - UUT)
 
    COMPONENT vaja1_4
    PORT(
         a : IN  std_logic;
         b : IN  std_logic;
         c : IN  std_logic;
         f : OUT  std_logic
        );
    END COMPONENT;
    

   --Vhodi
   signal a : std_logic := '0';
   signal b : std_logic := '0';
   signal c : std_logic := '0';

 	--Izhodi
   signal f : std_logic;
   
   -- Če vezje ne uporablja zunanje ure, jo moramo generirati sami.    
 
   constant clk_period : time := 10 ns;		-- perioda / frekvenca urinega impulza
	signal clk : std_logic;
 
BEGIN
 
	-- Uključitev vezja v simulacijo
   uut: vaja1_4 PORT MAP (
          a => a,
          b => b,
          c => c,
          f => f
        );

   -- Definicija urinega signala
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Simulacija vezja
   stim_proc: process
   begin		
      -- Zadržimo vezje v resetu začetnih 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- Od tu naprej so ukazi simulacije
		a<='1';
		b<='0';
		c<='0';
		
		wait for clk_period*10;
		a<='0';
		b<='1';
		c<='0';
		
		wait for clk_period*10;
		a<='1';
		b<='1';
		c<='0';
		
		wait for clk_period*10;
		a<='0';
		b<='0';
		c<='1';
		
		wait for clk_period*10;
		a<='1';
		b<='0';
		c<='1';
		
		wait for clk_period*10;
		a<='0';
		b<='1';
		c<='1';
		
		wait for clk_period*10;
		a<='1';
		b<='1';
		c<='1';
      
		wait;
   end process;

END;
