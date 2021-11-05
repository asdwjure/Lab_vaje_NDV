library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY DIGIT_SELECTOR_tb IS
END DIGIT_SELECTOR_tb;

ARCHITECTURE behavior OF DIGIT_SELECTOR_tb IS

	-- Deklaracija spremenljivk za vezje, ki ga simuliramo (Unit Under Test - UUT)

	COMPONENT DIGIT_SELECTOR
		PORT(
			SELECTED_DIGIT : OUT std_logic_vector(3 downto 0);
			T              : IN  std_logic_vector(3 downto 0);
			S              : IN  std_logic_vector(3 downto 0);
			D              : IN  std_logic_vector(3 downto 0);
			E              : IN  std_logic_vector(3 downto 0);
			nDIGIT         : IN  std_logic_vector(3 downto 0)
		);
	END COMPONENT;


	--vhodi
	signal T      : std_logic_vector(3 downto 0) := (others => '0');
	signal S      : std_logic_vector(3 downto 0) := (others => '0');
	signal D      : std_logic_vector(3 downto 0) := (others => '0');
	signal E      : std_logic_vector(3 downto 0) := (others => '0');
	signal nDIGIT : std_logic_vector(3 downto 0) := (others => '0');

	--izhodi
	signal SELECTED_DIGIT : std_logic_vector(3 downto 0);

	-- Ker ure nimamo definirane, moramo spremeniti <clolck> v novo spremenljivko in jo definirati kot signal 

	constant clk_period : time := 10 ns;
	signal clk          : std_logic;

BEGIN

	uut : DIGIT_SELECTOR
		PORT MAP (
			SELECTED_DIGIT => SELECTED_DIGIT,
			T              => T,
			S              => S,
			D              => D,
			E              => E,
			nDIGIT         => nDIGIT
		);

	-- Definicija urinega impulza
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;


	-- Simulacijski procesni stavek
	stim_proc : process
	begin
		-- hold reset state for 100 ns.
		wait for 100 ns;

		wait for clk_period*10;

		-- simulacijski stavki 

		nDIGIT <= "0111";
		T      <= "0001";
		S      <= "1001";
		D      <= "0111";
		E      <= "1000";

		wait for clk_period*10;
		nDIGIT <= "1011";
		T      <= "0001";
		S      <= "1001";
		D      <= "0111";
		E      <= "1000";

		wait for clk_period*10;
		nDIGIT <= "1101";
		T      <= "0001";
		S      <= "1001";
		D      <= "0111";
		E      <= "1000";

		wait for clk_period*10;
		nDIGIT <= "1110";
		T      <= "0001";
		S      <= "1001";
		D      <= "0111";
		E      <= "1000";

		wait for clk_period*10;
		nDIGIT <= "1100"; -- Forbidden state
		T      <= "0001";
		S      <= "1001";
		D      <= "0111";
		E      <= "1000";

		wait;
	end process;

END;
