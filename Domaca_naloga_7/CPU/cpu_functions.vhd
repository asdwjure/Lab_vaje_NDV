LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.reg_file_functions.all;
USE work.cpu_datapath_functions.all;

PACKAGE cpu_functions IS

	component rom is
		generic( 	n_addr	:	INTEGER := 2;
					bus_width:	INTEGER := 8 );				
		Port (		nRST		:	IN 	std_logic;
					addr 		:	IN 	std_logic_vector( n_addr - 1 downto 0);
					data		:	OUT	std_logic_vector( bus_width - 1 DOWNTO 0)
				);
	end component;

	component sram is
	generic( 	n_addr	:	INTEGER := 4;
				bus_width:	INTEGER := 16 );				
	Port (		nRST, 
				clk, 
				W_nR		:	IN 	std_logic;	--write/read control (write = '1')
				addr 		:	IN 	std_logic_vector( n_addr - 1 downto 0);
				data_in	:	IN		std_logic_vector( bus_width - 1 DOWNTO 0);
				data_out	:	OUT	std_logic_vector( bus_width - 1 DOWNTO 0)
			);
	end component;
	
--		branch controller operation summary
--		PL		JB		BC		Z		N		PC
--		0		X		X		X		X		PC + 1
--		1		0		0		1		X		branch taken (Z='1')
--		1		0		0		0		X		branch not taken (Z='0')	=> PC + 1
--		1		0		1		X		1		branch taken (N='1')
--		1		0		1		X		0		branch not taken (N='0')	=> PC + 1
--		1		1		X		X		X		jump
component branch_ctrl is
		generic( ctr_width	: natural := 16);
		PORT (clk,				-- clock input
				nRST,				-- reset input	(active '0')
				N,					-- negative bit from ALU operation
				C,					-- carry bit from ALU operation
				V,					-- overflow bit from ALU operation
				Z,					-- zero bit from ALU operation
				PL,				-- Increment (PC = PC + 1) when inactive, or load when active (PL = '1')
				JB,				-- jump/branch when PL='1' (jump => PL = '1', load counter with predefined value)
				BC				: in	std_logic; 	--branch control (when '0' -> check Z bit, when '1' check N bit)
				JB_address	: in	std_logic_vector(ctr_width - 1 downto 0);
				PC				: out	std_logic_vector(ctr_width - 1 downto 0)
			);
end component;

END cpu_functions;
