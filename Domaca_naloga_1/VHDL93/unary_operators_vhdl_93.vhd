library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reduction_operators is
	generic (
		N : Natural := 4096
	);
	port (
		A                                    : in  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		reduced_OR, reduced_AND, reduced_XOR : out STD_LOGIC
	);
end reduction_operators;

architecture vhdl_93_process of reduction_operators is
begin

	or_reduction : process (A)
		variable temp_or : std_logic := '0';
	begin
		temp_or := '0';
		for i in A'range loop
			temp_or := temp_or or A(i); -- ce je v A samo en element, je rezultat ta element (or 0)
			exit when temp_or = '1';
		end loop;
		reduced_OR <= temp_or;
	end process;

	and_reduction : process (A)
		variable temp_and : std_logic := '1';
	begin
		temp_and := '1';
		for i in A'range loop
			temp_and := temp_and and A(i); -- if any bit is zero, the whole and is zero, exit
			exit when temp_and = '0';
		end loop;
		reduced_AND <= temp_and;
	end process;

	xor_reduction : process (A)
		variable temp_xor : std_logic := '0';
	begin
		temp_xor := '0';
		for i in A'range loop
			temp_xor := temp_xor xor A(i); -- no other way than to check all bits
		end loop;
		reduced_XOR <= temp_xor;
	end process;

end vhdl_93_process;