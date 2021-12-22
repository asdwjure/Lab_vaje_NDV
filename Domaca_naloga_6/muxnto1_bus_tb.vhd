--------------------------------------------------------------------------------
-- Title       : muxnto1_bus_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : muxnto1_bus_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Wed Dec 22 08:57:27 2021
-- Last update : Wed Dec 22 09:30:11 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: muxnto1_bus_tb.vhd
--------------------------------------------------------------------------------
-- Revisions:  Revisions and documentation are controlled by
-- the revision control system (RCS).  The RCS should be consulted
-- on revision history.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
USE work.reg_file_functions.all;

-----------------------------------------------------------

entity muxnto1_bus_tb is

end entity muxnto1_bus_tb;

-----------------------------------------------------------

architecture testbench of muxnto1_bus_tb is

	-- Testbench DUT generics
	constant n_addr    : INTEGER := 2;
	constant bus_width : INTEGER := 8;

	-- Testbench DUT ports
	signal s : std_logic_vector( n_addr - 1 downto 0);
	signal w : muxnto1_bus_type( 2**n_addr - 1 DOWNTO 0, bus_width - 1 DOWNTO 0);
	signal f : std_logic_vector( bus_width - 1 downto 0);

	-- Other constants

begin
	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_Stim : process
	begin
		wait for 10 ns;
		w <= (x"11", x"22", x"33", x"44"); -- 3 2 1 0


		for i in 0 to 2**n_addr-1 loop
			s <= std_logic_vector(to_unsigned(i, n_addr));
			wait for 10 ns;
		end loop;

		wait;
	end process p_Stim;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.muxnto1_bus
		generic map (
			n_addr    => n_addr,
			bus_width => bus_width
		)
		port map (
			s => s,
			w => w,
			f => f
		);

end architecture testbench;