library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vaja1_5 is
    Port (
        x1,x2,x3,x4 : in  STD_LOGIC;
        f           : out STD_LOGIC
    );
end vaja1_5;
--prva spremenljivka je x1, zadnja je x4
architecture arch of vaja1_5 is
begin

    f <= (not(x1) and x2) or (x3 and not(x4));

end arch;
