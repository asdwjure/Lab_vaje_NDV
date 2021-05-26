library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

entity sram is
	generic( n_addr	:	INTEGER := 4;
				bus_width:	INTEGER := 16 );				
	Port (	nRST, 
				clk, 
				W_nR		:	IN 	std_logic;	--write/read control (write = '1')
				addr 		:	IN 	std_logic_vector( n_addr - 1 downto 0);
				data_in	:	IN		std_logic_vector( bus_width - 1 DOWNTO 0);
				data_out	:	OUT	std_logic_vector( bus_width - 1 DOWNTO 0)
			);
end sram;

architecture ndv of sram is
--mind the RAM file organization: ***to*** means 0 address first in file!
--ram data organized from MSB (bus_width-1) to LSB (0)!
type Ram_data_type is array (0 TO  2**n_addr - 1) of std_logic_vector (bus_width - 1 DOWNTO 0);
	
impure function InitRamFRamFile (RamFileName : in string) return  Ram_data_type is 
	FILE RamFile : text is in RamFileName; 
	variable RamFileLine : line; 
	variable Ram : Ram_data_type; 
	variable val : std_logic_vector(bus_width - 1 DOWNTO 0);
 
begin 
		for i in Ram_data_type'range loop 
			readline (RamFile, RamFileLine);
			hread ( RamFileLine, val);
			Ram(i) := val;
		end loop;
	return Ram; 
end function; 

signal Ram_data : Ram_data_type := InitRamFRamFile("TEST_RAM.hex");

begin
	PROCESS( clk, addr, nRST )
	BEGIN
		IF nRST = '0' THEN
			Ram_data <= InitRamFRamFile("TEST_RAM.hex");
		ELSif rising_edge(clk) then
			if W_nR = '1' then			
				Ram_data(to_integer(unsigned(addr))) <= data_in;	--write
			end if;
		end if;
	END PROCESS;
	
	data_out <= Ram_data(to_integer(unsigned(addr)));	-- asynchronous read
	
end ndv;