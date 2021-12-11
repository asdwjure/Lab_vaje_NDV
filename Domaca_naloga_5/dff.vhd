LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dff IS
PORT ( D, clk, nPRESET, nCLEAR : IN STD_LOGIC;
		 Q : OUT STD_LOGIC);
END dff;

ARCHITECTURE ideal OF dff IS
BEGIN
PROCESS ( clk, nPRESET, nCLEAR, D )
	BEGIN
		IF (nPRESET = '0') THEN
			Q <= '1';	--asinhrono postavljanje izhoda (preset)
		ELSIF (nCLEAR = '0') THEN
			Q <= '0';	--asinhrono brisanje izhoda (clear)
		ELSIF rising_edge(clk) THEN
			Q <= D after 1 ns; -- simulate 1ns time delay
		END IF;	
	END PROCESS;
END ideal; 
