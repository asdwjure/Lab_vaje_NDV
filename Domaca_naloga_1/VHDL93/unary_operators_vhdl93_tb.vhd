library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity reduction_operators_tb is
	generic (
		N : natural := 3
	);
end reduction_operators_tb;

architecture test of reduction_operators_tb is

	signal A                                    : std_logic_vector(N-1 downto 0);
	signal reduced_OR, reduced_AND, reduced_XOR : std_logic;


begin

	uut : entity work.reduction_operators
		generic map (
			N => N
		)
		port map (
			A           => A,
			reduced_OR  => reduced_OR,
			reduced_AND => reduced_AND,
			reduced_XOR => reduced_XOR
		);

	p_sim : process
	begin

		A <= std_logic_vector(to_unsigned(0, N));
		wait for 150 ns;
		A <= std_logic_vector(to_unsigned(1, N));
		wait for 50 ns;
		A <= std_logic_vector(to_unsigned(2, N));
		wait for 100 ns;
		A <= std_logic_vector(to_unsigned(4, N));
		wait for 50 ns;
		A <= std_logic_vector(to_unsigned(5, N));
		wait for 50 ns;
		A <= std_logic_vector(to_unsigned(6, N));
		wait for 50 ns;
		A <= std_logic_vector(to_unsigned(7, N));

		wait; -- end of simulation
	end process;

end test;