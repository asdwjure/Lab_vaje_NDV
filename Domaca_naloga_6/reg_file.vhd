library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.reg_file_functions.all;
use ieee.math_real.all;

entity reg_file is
	generic(	nr_regs		: natural := 4;
				reg_width	: natural := 8);
	PORT (clk,	-- clock input
			LE				: in std_logic;	-- load enable input	(active '1')
			nRST			: in std_logic;	-- reset input	(active '0')
			dest_select,					-- register number destination select input
			A_select, 						-- A, B bus destination select input
			B_select 		: in	std_logic_vector( sizeof(nr_regs - 1) - 1 downto 0);
			D 				: in	std_logic_vector(reg_width - 1 downto 0);	--data input bus input
			A, B 			: out	std_logic_vector(reg_width - 1 downto 0)	-- A, B bus output
		);
end reg_file;

architecture NDV of reg_file is

constant nr_regs_size	: integer := integer(ceil(log2(real(nr_regs - 1))));
signal load_enable_sig 	: std_logic_vector( nr_regs - 1 DOWNTO 0) := (others => '0');
SIGNAL reg_file			: muxnto1_bus_type( nr_regs - 1 DOWNTO 0, reg_width - 1 DOWNTO 0) := (others => (others => '0'));

type reg_file_array_type is array (nr_regs - 1 downto 0) of std_logic_vector(reg_width - 1 downto 0);
signal reg_file_array : reg_file_array_type := (others => (others => '0'));

type reg_mode_array_type is array (nr_regs - 1 downto 0) of std_logic_vector(1 downto 0);
signal reg_mode_sig		: reg_mode_array_type := (others => (others => '0'));

begin

end NDV;