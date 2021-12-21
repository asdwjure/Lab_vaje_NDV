LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY muxnto1 IS
	generic( n_addr: natural := 2 );
	PORT (s	: in 	std_logic_vector(n_addr - 1 downto 0);
			w	: in 	std_logic_vector(2**n_addr - 1 downto 0);				
			f	: OUT	STD_LOGIC
			);
END muxnto1;

ARCHITECTURE ideal OF muxnto1 IS
BEGIN
	f <= w(to_integer(unsigned(s)));
END ideal; 