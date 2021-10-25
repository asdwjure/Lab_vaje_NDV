library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vaja1_3 is
    Port (
        A : in  STD_LOGIC_VECTOR (2 downto 0);
        S : out STD_LOGIC_VECTOR (3 downto 0)
    );
end vaja1_3;

architecture arch of vaja1_3 is

    signal p0, p1, p2 : std_logic;

begin

    p0 <= not( A(0) );
    p1 <= p0 or A(2);
    p2 <= p0 and A(1);

    S(3) <= p2 or p1;
    S(2) <= p2;
    S(1) <= p1;
    S(0) <= p0;

end arch;
