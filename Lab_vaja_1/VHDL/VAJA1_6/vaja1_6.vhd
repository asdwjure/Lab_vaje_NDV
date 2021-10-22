library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vaja1_6 is
    Port (
        X : in  STD_LOGIC_VECTOR (3 downto 0);
        S : out STD_LOGIC_VECTOR(2 downto 0)
    );
end vaja1_6;

architecture arch of vaja1_6 is

    signal p0, p1 : std_logic;

begin

    u_xor2vrata_0 : entity work.xor2vrata
        port map (
            A => X(0),
            B => X(1),
            C => p0
        );

    u_xor2vrata_1 : entity work.xor2vrata
        port map (
            A => p1,
            B => X(2),
            C => p1
        );

    u_xor2vrata_2 : entity work.xor2vrata
        port map (
            A => p1,
            B => X(3),
            C => S(2)
        );

    S(0) <= p0;
    S(1) <= p1;

end arch;

