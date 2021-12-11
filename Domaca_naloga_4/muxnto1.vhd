LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY muxnto1 IS generic( n_addr : natural := 2 ); -- število naslovov izbiralnika 
   PORT (
      s : in  std_logic_vector(n_addr - 1 downto 0);    -- vektor naslovov 
      w : in  std_logic_vector(2**n_addr - 1 downto 0); --vektor podatkovnih vhodov 
      f : OUT STD_LOGIC                                 -- izhod izbiralnika
   );
END muxnto1;

ARCHITECTURE ideal OF muxnto1 IS
BEGIN
   f <= w(to_integer(unsigned(s)));
END ideal;