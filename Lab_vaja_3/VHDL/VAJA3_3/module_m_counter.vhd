library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity module_m_counter is
	generic(
		M : natural := 60
	);
	Port (
		nRST, clk : in  STD_LOGIC;
		CTR       : out STD_LOGIC_VECTOR (15 downto 0);
		RCO       : out STD_LOGIC
	);
end module_m_counter;

architecture arch of module_m_counter is

	signal count : unsigned(ctr'range) := (others => '0');
	signal rco_signal : std_logic := '0';

begin

	p_counter : process(clk)
	begin
		if nRST = '0' then
			count <= (others => '0');
		else
			if rising_edge(clk) then
				--------------------------------------------------------------------
				if count = M-1 then
					count <= (others => '0') after 1 ns;
					rco_signal <= '1' after 1 ns;
				else
					count <= count + 1 after 1 ns;
					rco_signal <= '0' after 1 ns;
				end if;
				--------------------------------------------------------------------
			end if;
		end if;
	end process p_counter;

	CTR <= std_logic_vector(count);
	RCO <= rco_signal;

end arch;
