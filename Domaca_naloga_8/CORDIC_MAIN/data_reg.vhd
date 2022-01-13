LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY data_reg IS
   GENERIC( 
      WIDTH : integer := 32
   );
   PORT( clk, load : IN std_logic;
      X	: IN std_logic_vector (WIDTH-1 DOWNTO 0); -- load value (loads X when load = '1')
      Q	: OUT std_logic_vector (WIDTH-1 DOWNTO 0)	-- output value
   );
END data_reg;

ARCHITECTURE rtl OF data_reg IS
BEGIN
	process ( clk, load, X )
	 begin
	   if (rising_edge(clk)) then
		  if ( load = '1' ) then
				Q <= X;			-- load the input value
		  end if;
	  end if;   
	end process;
END rtl;
