library STD;
use STD.textio.all;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package cordic_pkg is	
	function sizeof (a: integer) return integer;
	function Conv2fixedPt (x : real; n : integer) return std_logic_vector;
	function Conv2real ( s, n : in integer) return real;
	procedure DispReg ( x, y, z, n, flag : in integer );
	procedure DispAng (angle, n : in integer);
	constant clk_period : time := 20 ns;
	constant half_period : time := clk_period / 2.0;
	constant pi : real := 3.141592653589793;
	constant K : real := 1.64676025812107;
	constant inverseK : real := 0.6072529350088;
	
	COMPONENT addsub IS
	   GENERIC( 
		  WIDTH : integer := 32
	   );
		PORT( 
			A , B		: IN     std_logic_vector (WIDTH-1 DOWNTO 0);
			S			: OUT    std_logic_vector (WIDTH-1 DOWNTO 0);
			add_nsub	: IN     std_logic	-- add_nsub = '0'->subtraction, '1'->addition
		);
	END COMPONENT;

	COMPONENT CORDIC_ROM is
		GENERIC(
			WIDTH : integer := 32;
			SIZE : integer := 24
		);
		PORT (	addr : in std_logic_vector(sizeof(SIZE - 1) - 1 downto 0);
					dout : out std_logic_vector(WIDTH - 1 DOWNTO 0)
			);
	end COMPONENT;
		
	COMPONENT CORDIC_FSM IS
		PORT(
			clk, nRST, start, rco	: IN     std_logic;
			init, load, done 			: OUT    std_logic
		);
	END COMPONENT;

	COMPONENT barrel_shifter_sra IS
		GENERIC(
			width : integer := 32;
			size : integer := 32
		);
		PORT( 
			input  : IN     std_logic_vector (WIDTH-1 DOWNTO 0);
			output : OUT    std_logic_vector (WIDTH-1 DOWNTO 0);
			n      : IN     std_logic_vector (sizeof(size - 1) - 1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT data_reg IS
		GENERIC( 
			WIDTH : integer := 32
		);
		PORT( clk, load : IN std_logic;
			X	: IN std_logic_vector (WIDTH-1 DOWNTO 0); -- load value (loads X when load = '1')
			Q	: OUT std_logic_vector (WIDTH-1 DOWNTO 0)	-- output value
		);
	END COMPONENT;

	COMPONENT up_counter IS
		GENERIC(
			MODULO : integer := 24
		);
		PORT(	clk, nRST, count_enable	: IN	std_logic;
				count		: OUT   std_logic_vector( sizeof(MODULO - 1) - 1 DOWNTO 0);
				rco 		: OUT	std_logic
		);
	END COMPONENT;
	
end cordic_pkg;

package body cordic_pkg is

--	@Function name: sizeof
-- @Parameters:
--	a: input number
--	@Return:
--	Number of bits required to encode a binary input number a	
FUNCTION sizeof (a: integer) RETURN integer IS
	VARIABLE aggregate	: integer := a;
	VARIABLE return_val	: integer := 0;
BEGIN
	compute_sizeof:
	FOR i IN a DOWNTO 0 LOOP
		IF aggregate > 0 THEN
			return_val := return_val + 1;	--increment number of encoding bits
		END IF;			
		aggregate := aggregate / 2;	-- divide by base	of 2
	END LOOP;			
	RETURN return_val;
END sizeof;
	
function Conv2fixedPt (x : real; n : integer) return std_logic_vector is
--constant fixedPt_fractional_bit : integer := (n - 3); --for general number fixpoint representation see format below; --X"2000_0000" for n=32;
--constant shft : std_logic_vector (n-1 downto 0) :=  ( fixedPt_fractional_bit=>'1', others => '0'); --X"2000_0000" for n=32; doesn't work in implementatation
variable s : std_logic_vector (n-1 downto 0);
variable z : real := 0.0;
begin
-- shft = 2^29 = 536870912
-- for n=32 bit fix point number:
-- bit 31 : msb - sign bit
-- bit 30,29 : integer part
-- bit 28 ~ 0 : fractional part
-- for the value of 0.5
-- first 4 msb bits [0, 0, 0, 1] --> X"1000_0000"
--
-- To obtain binary number representation of x,
-- where the implicit decimal point between bit 29 and bit 28,
-- multiply "integer converted shft"
--
	--z := x * real(to_integer(unsigned(shft)));
	z := x * real(2**(n-3));
	s := std_logic_vector(to_signed(integer(z), n));
	return s;
end Conv2fixedPt;

function Conv2real (s, n : in integer) return real is
variable z : real := 0.0;
begin
	z := real(s) / real(2**(n-3));
	return z;
end Conv2real;

procedure DispReg (	x, y, z, n, flag : in integer ) is
variable l : line;
begin
	if (flag = 0) then
		write(l, String'("--------------------------------------- "));
		writeline(output, l);
		write(l, String'(" xi = ")); write(l, real'(Conv2real( x, n)));
		write(l, String'(" yi = ")); write(l, real'(Conv2real( y, n)));
		write(l, String'(" zi = ")); write(l, real'(Conv2real( z, n)));
	elsif (flag = 1) then
		write(l, String'(" xo = ")); write(l, real'(Conv2real( x, n)));
		write(l, String'(" yo = ")); write(l, real'(Conv2real( y, n)));
		write(l, String'(" zo = ")); write(l, real'(Conv2real( z, n)));
	else
		write(l, String'(" xn = ")); write(l, real'(Conv2real( x, n)));
		write(l, String'(" yn = ")); write(l, real'(Conv2real( y, n)));
		write(l, String'(" zn = ")); write(l, real'(Conv2real( z, n)));
	end if;
	writeline(output, l);
end DispReg;

procedure DispAng (angle, n : in integer) is
variable l : line;
begin
	write(l, String'(" angle = ")); write(l, real'(Conv2real( angle, n)));
	writeline(output, l);
	write(l, String'("....................................... "));
	writeline(output, l);
end DispAng;

end cordic_pkg;
