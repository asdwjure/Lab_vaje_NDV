-- *********************************************************************** 
-- **** STUDENT: ideal 
-- ***********************************************************************
-- KOMENTARJI K OCENI NALOGE
-- Matej Mozek: Predloga vaje 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.reg_file_functions.all;
use ieee.math_real.all;

entity reg_file is
		generic( nr_regs		: natural := 4;
					reg_width	: natural := 8);
		PORT (clk,	-- clock input
				LE				: in std_logic;	-- load enable input	(active '1')
				nRST			: in std_logic;	-- reset input	(active '0')
				dest_select,					-- register number destination select input
				A_select, 						-- A, B bus destination select input
				B_select 	: in	std_logic_vector( sizeof(nr_regs - 1) - 1 downto 0);
				D 				: in	std_logic_vector(reg_width - 1 downto 0);	--data input bus input
				A, B 			: out	std_logic_vector(reg_width - 1 downto 0)	-- A, B bus output
			);
end reg_file;

architecture ideal of reg_file is

constant nr_regs_size	: integer := integer(ceil(log2(real(nr_regs - 1))));
signal load_enable_sig 	: std_logic_vector( nr_regs - 1 DOWNTO 0) := (others => '0');
SIGNAL reg_file			: muxnto1_bus_type( nr_regs - 1 DOWNTO 0, reg_width - 1 DOWNTO 0) := (others => (others => '0'));

type reg_file_array_type is array (nr_regs - 1 downto 0) of std_logic_vector(reg_width - 1 downto 0);
signal reg_file_array : reg_file_array_type := (others => (others => '0'));

type reg_mode_array_type is array (nr_regs - 1 downto 0) of std_logic_vector(1 downto 0);
signal reg_mode_sig		: reg_mode_array_type := (others => (others => '0'));

begin

REG_DMUX: dmuxnto1
				generic map	(	n_addr => nr_regs_size)
				port map		(	s => dest_select,
									w => LE,
									f => load_enable_sig
									);

A_BUS_MUX: muxnto1_bus 
				generic map (	n_addr=> nr_regs_size,
									bus_width => reg_width)
				PORT MAP (		s =>  A_select,
									w => reg_file,
									f => A
									);

B_BUS_MUX: muxnto1_bus 
				generic map (	n_addr=> nr_regs_size,
									bus_width => reg_width)
				PORT MAP (		s =>  B_select,
									w => reg_file,
									f => B
									);

reg_file_process: PROCESS( reg_file_array, reg_file )
variable reg_file_col : std_logic_vector(reg_width - 1 downto 0);
BEGIN
	FOR i IN 0 TO nr_regs - 1 LOOP
			reg_file_col := reg_file_array(i);
			FOR j IN 0 TO reg_width - 1 LOOP			
					reg_file(i, j) <= reg_file_col(j);
			END LOOP;			
			
	END LOOP;
END PROCESS;

reg_mode_process: PROCESS( load_enable_sig )
BEGIN
	FOR r in nr_regs - 1 downto 0 LOOP	
			-- S0 S1 |	load_enable_sig(r)	Operation
			-- 1  1	|	1							: Load x => Q
			-- 0  0	|	0							: Hold contents
			reg_mode_sig(r) <= (others => load_enable_sig(r));			
	END LOOP;
END PROCESS;

--loop through all registers in register file
regloop : for r in nr_regs - 1 downto 0 generate

	Regi: shift_reg	generic map ( reg_size => reg_width)
							PORT map (	clk => clk,
											nCLR => nRST, 
											sr_in => '0', 
											sl_in => '0',
											s => reg_mode_sig(r),
											x => D,
											Q => reg_file_array(r)
											);
end generate;

end ideal;