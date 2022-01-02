library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm010 is
	Port (nY : out STD_LOGIC;
		state_code         : out STD_LOGIC_VECTOR (3 downto 0);
		nX, nRST, nTRIGGER : in  STD_LOGIC
	);
end fsm010;

architecture arch of fsm010 is
	type fsm_states is (IDLE, ZERO, ONE, DETECTED);
	signal state : fsm_states;

begin

	process(nRST, nTRIGGER)
	begin
		if nRST = '0' then
			state <= IDLE;
		elsif rising_edge(nTRIGGER) then
			case state is
				when IDLE =>
					if nX = '0' then
						state <= ZERO;
					else
						state <= IDLE;
					end if;
				when ZERO =>
					if nX = '0' then
						state <= ZERO;
					else
						state <= ONE;
					end if;
				when ONE =>
					if nX = '0' then
						state <= DETECTED;
					else
						state <= IDLE;
					end if;
				when DETECTED =>
					if nX = '0' then
						state <= ZERO;
					else
						state <= ONE;
					end if;
			end case;
		end if;
	end process;

	nY <= '0' when state = DETECTED else '1';

	with state select
	state_code <= "1000" when IDLE,
		"0100" when ZERO,
		"0010" when ONE,
		"0001" when others;

end arch;

