LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.reg_file_functions.all;

PACKAGE cpu_datapath_functions IS

	component cpu_datapath is
			generic( nr_regs		: natural := 4;
						reg_width	: natural := 8);
			PORT (clk,	-- clock input
					RW					: in std_logic;	-- register write input	(active '1')
					nRST				: in std_logic;	-- reset input	(active '0')
					DA,						-- destination register number select input
					AA, 						-- A, B bus register number select input
					BA 				: in	std_logic_vector( sizeof(nr_regs - 1) - 1 downto 0);
					MB 				: in std_logic;	-- constant/operand bus B bus multiplexer control signal
					MD 				: in std_logic;	-- external data/alu result multiplexer control signal
					-- ALU operation summary:
					-- M F	     	 operation
					-- 0 0 0 0 S = X plus Y
					-- 0 0 0 1 S = X minus Y
					-- 0 0 1 0 S = X plus 1
					-- 0 0 1 1 S = X minus 1
					-- 0 1 0 0 S = X plus X
					-- 0 1 0 1 S = minus 1 (dvojiški komplement)
					-- 1 0 0 0 S = X and Y	
					-- 1 0 0 1 S = X nand Y
					-- 1 0 1 0 S = X or Y
					-- 1 0 1 1 S = X nor Y
					-- 1 1 0 0 S = X xor Y
					-- 1 1 0 1 S = X xnor Y
					-- 1 1 1 0 S = X
					-- 1 1 1 1 S = Y
					ALU_mode 		: in std_logic;	--mode of alu operation (M in upper table)
					ALU_function 	: in std_logic_vector(2 downto 0); -- function of ALU (F in upper table)
					ALU_N_bit		: out std_logic;	-- Negative bit of alu operation
					ALU_C_bit 		: out std_logic;	-- Carry bit of alu operation
					ALU_V_bit 		: out std_logic;	-- Overflow bit of alu operation
					ALU_Z_bit 		: out std_logic;	-- Zero bit of alu operation
					Const_in			: in	std_logic_vector(reg_width - 1 downto 0);	--constant input bus
					Data_in 			: in	std_logic_vector(reg_width - 1 downto 0);	--data input bus input
					Address_out		: out	std_logic_vector(reg_width - 1 downto 0);	--address bus output
					Data_out			: out	std_logic_vector(reg_width - 1 downto 0)	--data bus output
				);
	end component;

	component ndn_alu is
		generic( n: natural := 8 );
		port(	M			:	in 	std_logic;	
				--naèin delovanja ('0' => aritmetièni, '1' => logièni)			
				F			: 	in 	std_logic_vector(2 downto 0);	
				-- funkcijski vhod za operacije
				X, Y		:	in 	std_logic_vector(n-1 downto 0);
				S			:	out std_logic_vector(n-1 downto 0);
				Negative, 
				Cout, 
				Overflow, 
				Zero,
				Gout, 
				Pout		:	out	std_logic );
	end component;

END cpu_datapath_functions;
