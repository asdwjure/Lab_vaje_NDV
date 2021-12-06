LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY bin2bcd_tb IS
END bin2bcd_tb;

ARCHITECTURE behavior OF bin2bcd_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT BIN2BCD
        PORT(
            BIN : IN  std_logic_vector(13 downto 0);
            T   : OUT std_logic_vector(3 downto 0);
            S   : OUT std_logic_vector(3 downto 0);
            D   : OUT std_logic_vector(3 downto 0);
            E   : OUT std_logic_vector(3 downto 0)
        );
    END COMPONENT;

    --Inputs
    signal BIN : std_logic_vector(13 downto 0) := (others => '0');

    --Outputs
    signal T : std_logic_vector(3 downto 0);
    signal S : std_logic_vector(3 downto 0);
    signal D : std_logic_vector(3 downto 0);
    signal E : std_logic_vector(3 downto 0);

BEGIN

        -- Instantiate the Unit Under Test (UUT)
        uut : BIN2BCD PORT MAP (
            BIN => BIN,
            T   => T,
            S   => S,
            D   => D,
            E   => E
        );

    -- Stimulus process
    stim_proc : process
    begin
        wait for 100 ns;

        BIN <= "00011111100101"; -- 2021 desetisko

        wait;
    end process;

END;
