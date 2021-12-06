library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- T -> tisocice (thousands)
-- S -> stotice (hundreds)
-- D -> desetice (tens)
-- E -> enice (ones)
entity DIGIT_SELECTOR is
	Port (
		SELECTED_DIGIT : out STD_LOGIC_VECTOR (3 downto 0);
		T, S, D, E     : in  STD_LOGIC_VECTOR (3 downto 0);
		nDIGIT         : in  STD_LOGIC_VECTOR (3 downto 0)
	);
end DIGIT_SELECTOR;

architecture arch of DIGIT_SELECTOR is
begin

	with nDIGIT select
	SELECTED_DIGIT <=
		T      when "0111",
		S      when "1011",
		D      when "1101",
		E      when "1110",
		"UUUU" when others;

end arch;

