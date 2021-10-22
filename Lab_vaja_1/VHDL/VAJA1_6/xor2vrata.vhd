library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor2vrata is
    Port (
        A : in  STD_LOGIC;
        B : in  STD_LOGIC;
        C : out STD_LOGIC
    );
end xor2vrata;

architecture arch of xor2vrata is
begin
    C <= A xor B;
end arch;
