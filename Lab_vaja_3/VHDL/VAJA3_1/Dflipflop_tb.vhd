LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Dflipflop_tb IS
END Dflipflop_tb;
 
ARCHITECTURE behavior OF Dflipflop_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Dflipflop
    PORT(
         nRST : IN  std_logic;
         clk : IN  std_logic;
         D : IN  std_logic;
         Q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal nRST : std_logic := '0';
   signal clk : std_logic := '0';
   signal D : std_logic := '0';

  --Outputs
   signal Q : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
   uut: Dflipflop PORT MAP (
          nRST => nRST,
          clk => clk,
          D => D,
          Q => Q
        );

   -- Clock process definitions
   clk_process :process
   begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin    

      wait for clk_period*5;  
    nRST <= '0';
    D <= '1';
    
    wait for clk_period*10;
    nRST <= '1';
    
    wait for clk_period*2;
    D <= '0';
    
    wait for clk_period*2;
    D <= '1';       

      wait;
   end process;

END;