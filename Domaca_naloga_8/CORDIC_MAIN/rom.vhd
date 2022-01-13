LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.cordic_pkg.all;

entity CORDIC_ROM is
	GENERIC(
		WIDTH : integer := 32;
		SIZE : integer := 24
	);
	port (	addr : in std_logic_vector(sizeof(SIZE - 1) - 1 downto 0);
				dout : out std_logic_vector(WIDTH - 1 DOWNTO 0)
		);
end CORDIC_ROM;

architecture ndv of CORDIC_ROM is
signal dout_sig : std_logic_vector(31 downto 0);
type rom_type is array (0 to 31) of std_logic_vector (31 downto 0);
-- coefficients generated from http://upload.wikimedia.org/wikiversity/en/7/7b/C1.rom.file.vhdl.20121114.pdf
constant ROM_array : rom_type := (	x"1921FB54", x"0ED63383", x"07D6DD7E", x"03FAB753", 
									x"01FF55BB", x"00FFEAAE", x"007FFD55", x"003FFFAB",
									x"001FFFF5", x"000FFFFF", x"00080000", x"00040000",
									x"00020000", x"00010000", x"00008000", x"00004000",
									x"00002000", x"00001000", x"00000800", x"00000400",
									x"00000200", x"00000100", x"00000080", x"00000040",
									x"00000020", x"00000010", x"00000008", x"00000004",
									x"00000002", x"00000001", x"00000001", x"00000000" );
-- coefficient number format:
-- bit 31 : msb - sign bit
-- bit 30,29 : integer part
-- bit 28 downto 0 : fractional part
-- for the value of 0.5 = X"10000000"
begin
	dout_sig <= ROM_array(to_integer(unsigned(addr)));
	dout <= dout_sig(31 downto 32-WIDTH);
end ndv;