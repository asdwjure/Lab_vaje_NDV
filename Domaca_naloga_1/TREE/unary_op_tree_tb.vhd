library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Unary_Op_Bin_Tree_tb is
	generic (
		N : natural := 16
	);
end Unary_Op_Bin_Tree_tb;

architecture test of Unary_Op_Bin_Tree_tb is

	constant ZERO : std_logic_vector(N-1 DOWNTO 0) := (others => '0'); -- vsi elementi na 0

	signal I     : std_logic_vector (N-1 DOWNTO 0) := ZERO;
	signal O_Xor : STD_LOGIC;

begin

	uut : entity work.XorTreeStage
		generic map (
			N => N
		)
		port map (
			I => I,
			O => O_Xor
		);

	p_sim : process
		variable idx : natural := 0;
	begin

		sim_loop : for penis in 0 to 2**N loop
			I <= std_logic_vector(to_unsigned(penis, I'length));
			wait for 50 ns;
		end loop sim_loop;

		wait; -- end simulation

	end process p_sim;

end test;