--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:03:28 12/09/2019
-- Design Name:   
-- Module Name:   C:/Users/matejkra/OneDrive - Univerza v Ljubljani/Ucenje/RDS/Xilinx datoteke/Vaja5_4/UART_TX_test.vhd
-- Project Name:  Vaja5_4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART_TX
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UART_TX_test IS
END UART_TX_test;
 
ARCHITECTURE behavior OF UART_TX_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART_TX
    PORT(
         DATA : IN  std_logic_vector(7 downto 0);
         nRST : IN  std_logic;
         TX_CLK : IN  std_logic;
         nSEND : IN  std_logic;
         TX : OUT  std_logic;
         nDONE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal nRST : std_logic := '0';
   signal TX_CLK : std_logic := '0';
   signal nSEND : std_logic := '0';

 	--Outputs
   signal TX : std_logic;
   signal nDONE : std_logic;

   -- Clock period definitions
   constant TX_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART_TX PORT MAP (
          DATA => DATA,
          nRST => nRST,
          TX_CLK => TX_CLK,
          nSEND => nSEND,
          TX => TX,
          nDONE => nDONE
        );

   -- Clock process definitions
   TX_CLK_process :process
   begin
		TX_CLK <= '0';
		wait for TX_CLK_period/2;
		TX_CLK <= '1';
		wait for TX_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		nRST <= '0';
		nSEND <= '1';

      wait for TX_CLK_period*10;
      nRST <= '1'; 
		DATA <= X"61";
		nSEND <= '0';
		
		wait for TX_CLK_period*1;
		nSEND <= '1';
		
		wait for TX_CLK_period*10;

      wait;
   end process;

END;
