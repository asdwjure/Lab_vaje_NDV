LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY addsub IS
	GENERIC( 
		WIDTH : integer := 32
	);
	PORT( 
		A , B		: IN     std_logic_vector (WIDTH-1 DOWNTO 0);
		S			: OUT    std_logic_vector (WIDTH-1 DOWNTO 0);
		add_nsub	: IN     std_logic	-- add_nsub = '0'->subtraction, '1'->addition
	);
END addsub;

architecture ndv of addsub is

signal B_sig : std_logic_vector (WIDTH-1 DOWNTO 0) := (others =>'0');
signal nadd_sub : std_logic; 

COMPONENT cla_add_n_bit IS
	generic(n: natural := 8);
	PORT (	Cin	:	in 	std_logic;
				X, Y	:	in 	std_logic_vector(n-1 downto 0);
				S		:	out	std_logic_vector(n-1 downto 0);
				Gout, 
				Pout, 
				Cout	:	out	std_logic);
END COMPONENT;

for CLA_ADDER : cla_add_n_bit use entity work.cla_add_n_bit(for_generate_arch2);

begin
	--	S <= (A + B) when ( add_nsub = '1') else (A - B);	--this translates to RC adder!
	B_sig <= B when ( add_nsub = '1') else not(B);	-- ones complement	
	nadd_sub <= not(add_nsub);
	CLA_ADDER 	:	cla_add_n_bit	GENERIC MAP( n => WIDTH)
									PORT MAP (	Cin => nadd_sub,
												X => A, 
												Y => B_sig,
												S => S
												);
end ndv;


