library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

entity rom is
	generic(	n_addr	:	INTEGER := 4;
				bus_width:	INTEGER := 16 );				
	Port (	nRST		:	IN 	std_logic;
				addr 		:	IN 	std_logic_vector( n_addr - 1 downto 0);
				data		:	OUT	std_logic_vector( bus_width - 1 DOWNTO 0)
			);
end rom;

architecture ndv of rom is
--mind the ROM file organization: ***to*** means 0 address first in file!
--command organized from MSB (bus_width-1) to LSB (0)!
type rom_data_type is array (0 TO  2**n_addr - 1) of std_logic_vector (bus_width - 1 DOWNTO 0);
	
impure function InitRomFromFile (RomFileName : in string) return  rom_data_type is 
	FILE RomFile : text is in RomFileName; 
	variable RomFileLine : line; 
	variable ROM : rom_data_type;	
	variable val : std_logic_vector(bus_width - 1 DOWNTO 0);
 
begin 
		for i in rom_data_type'range loop 
			readline (romFile, romFileLine);
			hread ( romFileLine, val);
			ROM(i) := val;
		end loop;
	return ROM; 
end function; 

signal rom_data : rom_data_type := InitRomFromFile("TEST_ROM.hex");

begin
	data <= rom_data(to_integer(unsigned(addr)));
end ndv;