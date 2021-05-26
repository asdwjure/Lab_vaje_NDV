-- *********************************************************************** 
-- **** STUDENT: ideal 
-- ***********************************************************************
-- KOMENTARJI K OCENI NALOGE
-- Matej Mozek: Predloga vaje 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter is
		generic( ctr_size: natural := 4);
		PORT (	clk, 						-- signal ure
				nCLR, 						-- signal za brisanje števca (aktiven '0')
				nLOAD, 						-- signal za nalaganje števca (aktiven '0')
				ENP, ENT : IN std_logic;	-- signala za omogoèanje štetja (aktiven '1')
				RCO : out std_logic;		-- izhodni prenos na naslednjo stopnjo (rco)
				x : in std_logic_vector(ctr_size - 1 downto 0);	-- vhod za vzporedno nalaganje
				Q : out std_logic_vector(ctr_size - 1 downto 0)	-- izhodno štetje 
			);
end counter;

architecture ideal of counter is
constant n_addr : integer := 1;
type		dff_mux_in is array (ctr_size - 1 downto 0) of std_logic_vector(2**n_addr - 1 downto 0);
signal	D : dff_mux_in;

signal	s : std_logic_vector(n_addr - 1 downto 0) := (others => '0');	--signal za izbirni vhod ULM
signal	RCO_sig : std_logic_vector(ctr_size downto 0); 	--vmesni RCO signali stopenj štetja
signal	Q_sig : std_logic_vector(ctr_size - 1 downto 0);	-- signal števnega izhoda

COMPONENT muxdff IS
	generic( n_addr: natural := 2 );
	PORT (	S : in	std_logic_vector(n_addr-1 downto 0);
				D : in 	std_logic_vector(2**n_addr-1 downto 0);				
				clk, nPRESET, nCLEAR : IN std_logic;
				Q : out std_logic
			);
END COMPONENT;

for all:muxdff use entity work.muxdff(ideal);

begin
		
	RCO_sig(0) <= Enp and Ent;	-- vhodni RCO signal je kar vhod za omogoèanje štetja
	
	L0: FOR i IN 0 TO ctr_size - 1 GENERATE
			
			D(i) <= (Q_sig(i) xor  RCO_sig(i))	& 	-- (ULM MUX vhod 1) - števni vhod xor RCO_sig stopnje
													x(i);		-- (ULM MUX vhod 0) - nalaganje vhoda x(i)
										
			RCO_sig(i + 1) <= Q_sig(i) and RCO_sig(i);	-- prenos na višji bit števca (rco)
			
		END GENERATE;
	
	RCO <= RCO_sig(ctr_size);	--izhodni prenos za naslednje stopnje
	
	s(0) <= nLOAD; -- izbirni vhod za ULM - pretvorba signala std_logic v enobitni std_logic_vector
	
	L1: FOR i IN 0 TO ctr_size - 1 GENERATE
			Ui: muxdff generic map (n_addr => 1) 
					port map ( s, D(i), clk, '1', nCLR, Q_sig(i));	-- povezovanje ULM
		END GENERATE;
	
	Q <= Q_sig;	-- povezovanje izhodnega štetja

end ideal;
