library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vaja1_4 is
    Port (
        a, b, c : in  STD_LOGIC;
        f       : out STD_LOGIC
    );
end vaja1_4;

architecture arch of vaja1_4 is
begin

    f <= (c xor (a nand b)) or (b or c);

end arch;
