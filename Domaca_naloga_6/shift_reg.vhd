library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift_reg is
		generic( reg_size: natural := 4);
		PORT (clk, nCLR, sr_in, sl_in : IN std_logic;				
				s : in std_logic_vector(1 downto 0);
				x : in std_logic_vector(reg_size - 1 downto 0);
				Q : out std_logic_vector(reg_size - 1 downto 0)
			);
end shift_reg;

architecture ideal of shift_reg is
type dff_mux_in is array (reg_size - 1 downto 0) of std_logic_vector(3 downto 0);
signal D : dff_mux_in;

signal Q_sig : std_logic_vector(reg_size - 1 downto 0);

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
	--	Postavitev mest v pomikalnem registru je:
	--	(MSB mesto je fizièno skrajno desno, LSB mesto je fizièno skrajno levo)
	
	-- S0 S1
	-- 1  1	: Vzporedno nalaganje x => Q
	-- 1  0	: Pomikanje levo 	(v smeri od LSB do MSB)
	-- 0  1	: Pomikanje desno (v smeri od MSB do LSB)
	-- 0  0	: Držanje vsebine
	
	D(0) <= 	x(0)  & 		-- (operacija 11) - nalaganje vhoda x(LSB)				
				sl_in &  	-- (operacija 10) - pomik levo (sl vhod gre v mesto LSB)
				Q_sig(1) &	-- (operacija 01) - pomik desno (mesto 1 gre v mesto LSB)
				Q_sig(0);	-- (operacija 00) - držanje vsebine LSB
	
	L0: FOR i IN 1 TO reg_size - 2 GENERATE
			D(i) <= 
				x(i) & 			-- (operacija 11) - nalaganje vhoda x
				Q_sig(i - 1) & -- (operacija 10) - pomik levo
				Q_sig(i + 1) & -- (operacija 01) - pomik desno
				Q_sig(i);		-- (operacija 00) - držanje vsebine
		END GENERATE;		
	
	D(reg_size - 1) <=  
				x(reg_size - 1) &			-- (operacija 11) - nalaganje vhoda x		
				Q_sig(reg_size - 2) &	-- (operacija 10) - pomik levo (sl vhod gre v mesto 0)
				sr_in & 						-- (operacija 01) - pomik desno (sr vhod gre v mesto MSB)
				Q_sig(reg_size - 1);		-- (operacija 00) - držanje vsebine
	
	L1: FOR i IN 0 TO reg_size - 1 GENERATE
			U0: muxdff generic map (n_addr => 2) 
					port map ( S, D(i), clk, '1', nCLR, Q_sig(i));
		END GENERATE;

	Q <= Q_sig;

end ideal;
