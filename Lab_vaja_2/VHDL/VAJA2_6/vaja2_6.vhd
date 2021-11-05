library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vaja2_6 is
	Port (
		LED         : out STD_LOGIC_VECTOR(6 downto 0);
		nDIGIT      : out STD_LOGIC_VECTOR(3 downto 0);
		DIP         : in  STD_LOGIC_VECTOR (7 downto 0);
		DIGIT_SHIFT : in  STD_LOGIC
	);
end vaja2_6;

architecture arch of vaja2_6 is
	signal T_SIGNAL, S_SIGNAL, D_SIGNAL, E_SIGNAL : STD_LOGIC_VECTOR (3 downto 0);
begin

	-- Glue signals
	T_SIGNAL <= "00" & DIP(7 downto 6);
	S_SIGNAL <= "00" & DIP(5 downto 4);
	D_SIGNAL <= "00" & DIP(3 downto 2);
	E_SIGNAL <= "00" & DIP(1 downto 0);

	u_leddriver : entity work.leddriver
		port map (
			LED         => LED,
			nDIGIT      => nDIGIT,
			T           => T_SIGNAL,
			S           => S_SIGNAL,
			D           => D_SIGNAL,
			E           => E_SIGNAL,
			DIGIT_SHIFT => DIGIT_SHIFT
		);

end arch;