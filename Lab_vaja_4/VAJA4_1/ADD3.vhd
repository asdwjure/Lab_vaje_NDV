library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ADD3 is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
        S : out STD_LOGIC_VECTOR (3 downto 0));
end ADD3;

architecture arch of ADD3 is
begin
    S <= A when (A < "0101") else
        (A+3) when (A < "1010") else
        "XXXX";
end arch;
