-- *********************************************************************** 
-- **** STUDENT: ideal 
-- ***********************************************************************
-- KOMENTARJI K OCENI NALOGE
-- Matej Mozek: Predloga vaje
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE work.reg_file_functions.all;

ENTITY muxnto1_bus IS

	generic( n_addr		:	INTEGER := 2;
				bus_width	:	INTEGER := 8 );
	PORT (	s 				:	IN 	std_logic_vector( n_addr - 1 downto 0);
				w 				:	IN		muxnto1_bus_type( 2**n_addr - 1 DOWNTO 0, bus_width - 1 DOWNTO 0);				
				f 				:	OUT	std_logic_vector( bus_width - 1 downto 0)
			);
END muxnto1_bus;

ARCHITECTURE ideal OF muxnto1_bus IS

COMPONENT muxnto1 IS
	generic( n_addr: natural := 2 );
	PORT (	s : in 	std_logic_vector(n_addr - 1 downto 0);
				w : in 	std_logic_vector(2**n_addr - 1 downto 0);				
				f : OUT	STD_LOGIC
			);
END COMPONENT;

type mux_addr_type is array (bus_width - 1 downto 0) of std_logic_vector(2**n_addr - 1 downto 0);
signal mux_addr : mux_addr_type := (others =>(others => '0'));

BEGIN

bus_mux_process: PROCESS( w )
variable mux_addr_col : std_logic_vector(2**n_addr - 1 downto 0);
BEGIN
	FOR j IN 0 TO bus_width - 1 LOOP
			FOR i IN 0 TO 2**n_addr - 1 LOOP
					mux_addr_col(i) := w(i, j);
			END LOOP;			
			mux_addr(j) <= mux_addr_col;
	END LOOP;
END PROCESS;

muxloop: FOR k IN 0 TO bus_width - 1 GENERATE
	Ui: muxnto1 generic map (	n_addr => n_addr)
					port map (	s => s,
									w => mux_addr(k),
									f => f(k)
					);
END GENERATE;

END ideal;