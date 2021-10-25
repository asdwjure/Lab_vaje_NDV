library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Unary_Op_Bin_Tree IS
	generic (
		N : natural := 64
	);
	port (
		I     :     std_logic_vector(N - 1 downto 0);
		O_Xor : OUT std_logic
	);
END Unary_Op_Bin_Tree;

ARCHITECTURE t OF Unary_Op_Bin_Tree IS

	component XorTreeStage
		generic (
			N : natural
		);
		port(
			I : in  std_logic_vector(N - 1 downto 0);
			O : out std_logic
		);
	end component;

BEGIN
		--TE DATOTEKE NI POTREBNO SPREMINJATI
		U_Xor : XorTreeStage GENERIC MAP (I'length) PORT MAP( I, O_Xor);
END t;

