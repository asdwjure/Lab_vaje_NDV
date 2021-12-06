library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CLOCK_DIVIDER is
	generic( Clock_divisor : natural := 125000000
	);
	Port ( nRST, CLK_IN : in STD_LOGIC;
		CLK_OUT : out STD_LOGIC);
end CLOCK_DIVIDER;

architecture arch of CLOCK_DIVIDER is

	signal COUNTER : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin

	process (nRST, CLK_IN, COUNTER)

	begin
		if (nRST = '0') then
			COUNTER <= (others => '0');
		elsif ( rising_edge(CLK_IN) ) then
			if( COUNTER = Clock_divisor ) then
				COUNTER <= (others => '0'); -- set COUNTER to 0
			else
				COUNTER <= COUNTER + 1; -- add '1'
			end if;
		end if;
	end process;

	CLK_OUT <= '0' when (COUNTER < (Clock_divisor / 2)) else '1'; -- duty cycle

end arch;