library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity leddriver is
	Port (
		LED         : out STD_LOGIC_VECTOR(6 downto 0);
		nDIGIT      : out STD_LOGIC_VECTOR(3 downto 0);
		T, S, D, E  : in  STD_LOGIC_VECTOR (3 downto 0);
		DIGIT_SHIFT : in  STD_LOGIC
	);
end leddriver;

architecture arch of leddriver is

	signal data_signal : std_logic_vector(nDIGIT'range);
	signal nDigit_signal : std_logic_vector(nDIGIT'range);

begin

	u_led4digit : entity work.led4digit
		port map (
			CLK    => DIGIT_SHIFT,
			nDIGIT => nDigit_signal,
			LED    => LED,
			DATA   => data_signal
		);	
	nDIGIT <= nDigit_signal;

	u_DIGIT_SELECTOR : entity work.DIGIT_SELECTOR
		port map (
			SELECTED_DIGIT => data_signal,
			T              => T,
			S              => S,
			D              => D,
			E              => E,
			nDIGIT         => nDigit_signal
		);	

end arch;