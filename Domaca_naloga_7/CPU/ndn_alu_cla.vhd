-- *********************************************************************** 
-- **** STUDENT: ideal 
-- *********************************************************************** 
-- KOMENTARJI K OCENI NALOGE
-- Matej Mozek: Predloga vaje
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ndn_alu is
	generic( n: natural := 8 );
	port(	M			:	in 	std_logic;	
			--naèin delovanja ('0' => aritmetièni, '1' => logièni)			
			F			: 	in 	std_logic_vector(2 downto 0);	
			-- funkcijski vhod za operacije
			X, Y		:	in 	std_logic_vector(n-1 downto 0);
			S			:	out std_logic_vector(n-1 downto 0);
			Negative, 
			Cout, 
			Overflow, 
			Zero,
			Gout, 
			Pout		:	out	std_logic );
end ndn_alu;

architecture ideal of ndn_alu is
constant zeroes 		: std_logic_vector(n-1 downto 0) := (others => '0');
constant one			: std_logic_vector(n-1 downto 0) := (0=>'1', others=>'0');
signal Sum_sig,Y_sig	: std_logic_vector(n-1 downto 0);
signal nAddSub			: std_logic;
-- operacija seštevanja (nAddSub => '0') ali odštevanja (nAddSub => '1')
signal alu_operation : std_logic_vector(3 downto 0);

signal X_is_zero, Y_is_zero, Sum_is_zero : std_logic;

component cla_add_n_bit IS
	generic(n: natural := 8);
	PORT (	Cin	:	in 	std_logic ;
				X, Y	:	in 	std_logic_vector(n-1 downto 0);
				S		:	out	std_logic_vector(n-1 downto 0);
				Gout, 
				Pout, 
				Cout	:	out	std_logic);
END component;

for all:cla_add_n_bit use entity work.cla_add_n_bit(ideal);

begin

	alu_operation <= M & F;			-- združimo naèin delovanja ALU in tip operacije
	nAddSub <= alu_operation(0);	-- LSB mesto bo doloèalo tip aritmetiène operacije
	
	-- Izbiralnik vhoda Y za razliène operacije:
	with alu_operation select
		Y_sig <=	Y				when x"0", 	--seštevanje
					not(Y) 		when x"1",	--odštevanje (eniški komplement)
					one			when x"2",	--prištevanje konstante 1
					not (one)	when x"3",	--odštevanje konstante 1
					X				when x"4",	--prištevanje X + X
					Y				when others;
			
	U1: cla_add_n_bit  generic map (n => n)  port map ( nAddSub, X, Y_sig, Sum_sig, Gout, Pout, Cout );
	--povezovanje sestevalnika
	
	with alu_operation select
		Negative <= '1'				when x"5",		-- postavi N bit v konstanti -1 na izhodu
						X(n-1) 			when x"E",
						Y(n-1) 			when x"F",
						Sum_sig(n-1)	when others;	-- bit predznaka

	-- bit preliva se postavi v primerih (odvisno od operacije):
	--	Operacija:		X(n-1)					Y(n-1)			S(n-1)
	--	Add (X+Y)		0 (pozitiven)			0 (pozitiven)	1 (negativen)
	--	Add (X+Y)		1 (negativen)			1 (negativen)	0 (pozitiven)
	--	Sub (X-Y)		0 (pozitiven)			1 (negativen)	1 (negativen)
	--	Sub (X-Y)		1 (negativen)			0 (pozitiven)	0 (pozitiven)
	
	Overflow <= (not nAddSub	and not X(n-1) 	and not Y(n-1) and 		Sum_sig(n-1) ) or 
				(not nAddSub	and 	X(n-1)	and     Y(n-1) and not	Sum_sig(n-1) ) or
				(	  nAddSub	and not	X(n-1)	and     Y(n-1) and 		Sum_sig(n-1) ) or
				(	  nAddSub	and 	X(n-1)	and not Y(n-1) and not	Sum_sig(n-1) ); 

	Sum_is_zero <= '1' when (Sum_sig = zeroes) else '0';
	X_is_zero <= '1' when (X = zeroes) else '0';
	Y_is_zero <= '1' when (Y = zeroes) else '0';
	
	with alu_operation select
		Zero <= 	'0'			when x"5",
					X_is_zero 	when x"E",
					Y_is_zero 	when x"F",
					Sum_is_zero	when others;	-- bit enako nic
		
	-- Izhodni izbiralnik ALU realizira operacije:
	-- M F	     	 operacija
	-- 0 0 0 0 S = X plus Y
	-- 0 0 0 1 S = X minus Y
	-- 0 0 1 0 S = X plus 1
	-- 0 0 1 1 S = X minus 1
	-- 0 1 0 0 S = X plus X
	-- 0 1 0 1 S = minus 1 (dvojiški komplement)
	-- 1 0 0 0 S = X and Y	
	-- 1 0 0 1 S = X nand Y
	-- 1 0 1 0 S = X or Y
	-- 1 0 1 1 S = X nor Y
	-- 1 1 0 0 S = X xor Y
	-- 1 1 0 1 S = X xnor Y
	-- 1 1 1 0 S = X
	-- 1 1 1 1 S = Y
	
	with alu_operation select
		S <= 	Sum_sig			when x"0" | x"1" | x"2" | x"3" | x"4",
				not (zeroes)	when x"5",
				X and Y			when x"8",
				X nand Y			when x"9",
				X or Y			when x"A",
				X nor Y			when x"B",
				X xor Y			when x"C",
				X xnor Y			when x"D",
				X 					when x"E",
				Y					when x"F",
				zeroes 			when others;
	
end ideal;
