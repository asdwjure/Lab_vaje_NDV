library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity vaja1_2 is
    Port (
        A : in  STD_LOGIC_VECTOR (2 downto 0);
        B : in  STD_LOGIC;
        S : out STD_LOGIC_VECTOR (1 downto 0);
        C : out STD_LOGIC
    );
end vaja1_2;

architecture arch of vaja1_2 is

    signal D : std_logic; -- Signal for feedback loop

begin

    S(0) <= A(0) nand A(2);
    C    <= A(1) and B;
    D    <= C; -- Auxillary signal
    S(1) <= D or A(0);

end arch;

