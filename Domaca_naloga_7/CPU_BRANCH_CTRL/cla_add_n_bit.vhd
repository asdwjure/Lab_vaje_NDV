-- *********************************************************************** 
-- **** STUDENT: ideal 
-- *********************************************************************** 
-- KOMENTARJI K OCENI NALOGE
-- Matej Mozek: Predloga vaje
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY cla_add_n_bit IS
	generic(n: natural := 8);
	PORT (	Cin	:	in 	std_logic ;
				X, Y	:	in 	std_logic_vector(n-1 downto 0);
				S		:	out	std_logic_vector(n-1 downto 0);
				Gout, 
				Pout, 
				Cout	:	out	std_logic);
END cla_add_n_bit;

ARCHITECTURE ideal OF cla_add_n_bit IS

COMPONENT cla_gp IS
	PORT (	Cin, x, y : IN STD_LOGIC;
				S, Cout, g, p : OUT STD_LOGIC );
END COMPONENT;

for all:cla_gp use entity work.cla_gp(ideal);

--vektor vmesnih prenosov in funkcij tvorjenja in širjenja
SIGNAL C, G, P	: STD_LOGIC_VECTOR(n DOWNTO 0);

BEGIN
	C(0) <= Cin;

	cla_stages: FOR i IN 0 TO n-1 GENERATE
		cla_stage: cla_gp PORT MAP ( C(i), X(i), Y(i), S(i), C(i+1), G(i+1), P(i+1) );
	END GENERATE;
	
	Cout <= C(n);	--izhodni prenos
	Gout <= G(n);	--izhodna funkcija tvorjenja (generate)
	Pout <= P(n);	--izhodna funkcija širjenja (propagate)
	
END ideal; 
