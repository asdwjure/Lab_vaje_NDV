LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.cordic_pkg.all;

ENTITY up_counter IS
	GENERIC(
		MODULO : integer := 24
	);
	PORT(	clk, nRST, count_enable	: IN std_logic;
			count		: OUT std_logic_vector( sizeof(MODULO - 1) - 1 DOWNTO 0);
			rco 		: OUT	std_logic
	);
END up_counter;

ARCHITECTURE rtl OF up_counter IS
SIGNAL Q : unsigned( sizeof(MODULO - 1) - 1 DOWNTO 0 ) := (others => '0');
BEGIN
	process (clk, nRST, count_enable, Q)	
	begin
		if (rising_edge(clk)) then   
			if ( nRST = '0' ) then 
				Q <= (others => '0');	-- reset to zero
			elsif ( count_enable = '1' ) then 
				Q <= Q + 1;					-- increment
			end if;
		end if;
	end process;
	
	count <= std_logic_vector(Q);
	rco <= '1' when Q = (MODULO - 1) else '0';
	
END rtl;
