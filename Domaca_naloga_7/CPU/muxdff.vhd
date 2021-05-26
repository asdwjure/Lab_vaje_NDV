-- *********************************************************************** 
-- **** STUDENT: ideal 
-- ***********************************************************************
-- KOMENTARJI K OCENI NALOGE
-- Matej Mozek: Predloga vaje 
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY muxdff IS
	generic( n_addr: natural := 2 );
	PORT (	S : in std_logic_vector(n_addr - 1 downto 0);
				D : in 	std_logic_vector(2**n_addr - 1 downto 0);				
				clk, nPRESET, nCLEAR : IN std_logic;
				Q : out std_logic
			);
END muxdff;

ARCHITECTURE ideal OF muxdff IS
	signal muxout : std_logic;

	COMPONENT muxnto1 IS
		generic( n_addr: natural := 2 );
		PORT (	s : in std_logic_vector(n_addr - 1 downto 0);
					w : in 	std_logic_vector(2**n_addr - 1 downto 0);				
					f : OUT STD_LOGIC
				);
	END COMPONENT;

	COMPONENT dff IS
	PORT ( D, clk, nPRESET, nCLEAR : IN STD_LOGIC;
			 Q : OUT std_logic);
	END COMPONENT;

	for all:dff use entity work.dff(ideal);
	for all:muxnto1 use entity work.muxnto1(ideal);

BEGIN
	U0: muxnto1 generic map (n_addr => n_addr) port map ( S, D, muxout);
	U1: dff port map ( muxout, clk, nPRESET, nCLEAR, Q);
END ideal;