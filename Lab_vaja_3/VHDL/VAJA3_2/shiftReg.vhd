library ieee;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity shiftReg is
	generic(
		PAR_BITS : natural := 8
	);
	Port (
		CLK, SERIAL_IN : in  STD_LOGIC;
		PARALLEL_OUT   : out STD_LOGIC_VECTOR ((PAR_BITS-1) downto 0)
	);
end shiftReg;

architecture Behavioral of shiftReg is

	signal shiftReg : std_logic_vector(PAR_BITS-1 downto 0) := (others => '0');

begin

	p_Seq : process(clk)
	begin
		if rising_edge(clk) then
			shiftReg <= SERIAL_IN & shiftReg(shiftReg'left downto 1) after 1 ns; -- Added TPD for sumulation purpuses
		end if;
	end process p_Seq;

	PARALLEL_OUT <= shiftReg;

end Behavioral;