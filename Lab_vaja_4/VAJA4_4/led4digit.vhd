library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led4digit is
	Port (
		CLK    : in  STD_LOGIC;
		nDIGIT : out STD_LOGIC_VECTOR (3 downto 0);
		LED    : out STD_LOGIC_VECTOR (6 downto 0);
		DATA   : in  STD_LOGIC_VECTOR (3 downto 0)
	);
end led4digit;

architecture arch of led4digit is

	signal digit_signal : std_logic_vector(nDIGIT'range);

begin

	u_rotreg4bit : entity work.rotreg4bit
		port map (
			CLK => CLK,
			Q   => digit_signal
		);

	u_bin2led : entity work.bin2led
		port map (
			BIN    => DATA,
			DIGIT  => digit_signal,
			LED    => LED,
			nDIGIT => nDIGIT
		);

end arch;