library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ADC2LED is
	Port ( nDIGIT : out STD_LOGIC_VECTOR (3 downto 0);
		LED       : out STD_LOGIC_VECTOR (6 downto 0);
		clk       : in  STD_LOGIC;
		PS2_CLK   : in  STD_LOGIC;
		PS2_DATA  : in  STD_LOGIC;
		ASCII_NEW : out STD_LOGIC);
end ADC2LED;

architecture arch of ADC2LED is

	-- signals
	signal LED_CLOCK  : STD_LOGIC                     := '0';
	signal ADC_SIGNAL : STD_LOGIC_VECTOR(6 downto 0)  := (others => '0');
	signal BIN_SIGNAL : STD_LOGIC_VECTOR(13 downto 0) := (others => '0');

	signal T_SIGNAL, S_SIGNAL, D_SIGNAL, E_SIGNAL : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin

	u_CLOCK_DIVIDER : entity work.CLOCK_DIVIDER
		generic map (
			Clock_divisor => 208333
		)
		port map (
			nRST    => '1',
			CLK_IN  => clk,
			CLK_OUT => LED_CLOCK
		);

	u_PS2_KEYBOARD2ASCII_2 : entity work.PS2_KEYBOARD2ASCII
		port map (
			clk        => clk,
			PS2_CLK    => PS2_CLK,
			PS2_DATA   => PS2_DATA,
			ASCII_NEW  => ASCII_NEW,
			ASCII_CODE => ADC_SIGNAL
		);

	u_BIN2BCD : entity work.BIN2BCD
		port map (
			BIN => BIN_SIGNAL,
			T   => T_SIGNAL,
			S   => S_SIGNAL,
			D   => D_SIGNAL,
			E   => E_SIGNAL
		);

	u_leddriver : entity work.leddriver
		port map (
			LED         => LED,
			nDIGIT      => nDIGIT,
			T           => T_SIGNAL,
			S           => S_SIGNAL,
			D           => D_SIGNAL,
			E           => E_SIGNAL,
			DIGIT_SHIFT => LED_CLOCK
		);

	BIN_SIGNAL <= "0000000" & ADC_SIGNAL;

end arch; 