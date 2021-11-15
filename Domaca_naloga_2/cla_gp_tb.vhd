--------------------------------------------------------------------------------
-- Title       : cla_gp_tb
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : cla_gp_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Wed Nov 10 22:32:28 2021
-- Last update : Sat Nov 13 12:30:22 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: Testbench for cla_gp_tb
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

-----------------------------------------------------------

entity cla_gp_tb is

end entity cla_gp_tb;

-----------------------------------------------------------

architecture testbench of cla_gp_tb is

	-- Testbench DUT generics

	-- Testbench DUT ports
	signal Cin, x, y     : STD_LOGIC;
	signal S, Cout, g, p : STD_LOGIC;

	signal testSig : std_logic_vector(2 downto 0);

begin
	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_Stim : process
	begin

		for i in 0 to 7 loop
			testSig <= std_logic_vector(to_unsigned(i, testSig'length));
			wait for 10 ns;
		end loop;

		wait;

	end process p_Stim;

	x   <= testSig(0);
	y   <= testSig(1);
	Cin <= testSig(2);

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.cla_gp
		port map (
			Cin  => Cin,
			x    => x,
			y    => y,
			S    => S,
			Cout => Cout,
			g    => g,
			p    => p
		);

end architecture testbench;