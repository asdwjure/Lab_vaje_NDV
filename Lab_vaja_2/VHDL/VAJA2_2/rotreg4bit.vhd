library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rotreg4bit is
    Port (
        CLK : in  STD_LOGIC;
        Q   : out STD_LOGIC_VECTOR (3 downto 0)
    );
end rotreg4bit;

architecture arch of rotreg4bit is

    signal REG : STD_LOGIC_VECTOR(Q'range) := "1000";

begin

    p_Seq : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            REG <= REG(0) & REG(Q'high downto 1);
        end if;
    end process;
    
    Q <= REG;

end arch;