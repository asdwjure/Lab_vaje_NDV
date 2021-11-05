library ieee;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity Dflipflop is
    Port (
        nRST : in  STD_LOGIC;
        clk  : in  STD_LOGIC;
        D    : in  STD_LOGIC;
        Q    : out STD_LOGIC
    );
end Dflipflop;

architecture Behavioral of Dflipflop is
begin

    p_DFlipFlop : process (clk, nRST)
    begin
        if (nRST = '0') then
            Q <= '0';
        else
            if rising_edge(clk) then
                Q <= D;
            end if;
        end if;
    end process p_DFlipFlop;

end Behavioral;
