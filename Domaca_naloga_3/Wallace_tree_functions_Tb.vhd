--------------------------------------------------------------------------------
-- Title       : Wallace_tree_functions_Tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : Wallace_tree_functions_Tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Fri Nov 26 17:13:11 2021
-- Last update : Sun Nov 28 12:41:21 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: Testbench for Wallace tree functions
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
USE work.Wallace_tree_functions.all;

-----------------------------------------------------------

entity Wallace_tree_functions_Tb is

end entity Wallace_tree_functions_Tb;

-----------------------------------------------------------

architecture testbench of Wallace_tree_functions_Tb is

	-- Testbench DUT generics

	-- Testbench DUT ports
	signal size : natural;
	signal x    : natural := 3;

	signal prev_lvl_carry_bits : natural;
	signal this_lvl_bits       : natural;
	signal num_full_adds       : natural;
	signal num_half_adds       : natural;


	-- Other constants
	constant C_CLK_PERIOD : real := 10.0e-9; -- NS

	constant WIDTH_C  : natural := 5;
	constant NRARGS_C : natural := 5;

begin

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_Stim : process
	begin

		------------------------------------------------------------------------
		-- Sizeof
		wait for 10 ns;
		size <= sizeof(x);
		wait for 10 ns;

		------------------------------------------------------------------------
		-- prev level carry bits
		prev_lvl_carry_bits <= prev_lvl_carry_rect(NRARGS_C, WIDTH_C, 0,0);
		wait for 10 ns;
		prev_lvl_carry_bits <= prev_lvl_carry_rect(NRARGS_C, WIDTH_C, 1,0);
		wait for 10 ns;
		prev_lvl_carry_bits <= prev_lvl_carry_rect(NRARGS_C, WIDTH_C, 1,1);
		wait for 10 ns;

		------------------------------------------------------------------------
		-- this level bits
		this_lvl_bits <= this_lvl_bits_rect(NRARGS_C, WIDTH_C, 0,0);
		wait for 10 ns;
		this_lvl_bits <= this_lvl_bits_rect(NRARGS_C, WIDTH_C, 1,0);
		wait for 10 ns;
		this_lvl_bits <= this_lvl_bits_rect(NRARGS_C, WIDTH_C, 1,1);
		wait for 10 ns;
		this_lvl_bits <= this_lvl_bits_rect(NRARGS_C, WIDTH_C, 5,1);
		wait for 10 ns;
		this_lvl_bits <= this_lvl_bits_rect(NRARGS_C, WIDTH_C, 6,1);
		wait for 10 ns;

		------------------------------------------------------------------------
		-- number of full adders
		num_full_adds <= num_full_adders_rect(NRARGS_C, WIDTH_C, 0, 0);
		wait for 10 ns;
		num_full_adds <= num_full_adders_rect(NRARGS_C, WIDTH_C, 0, 1);
		wait for 10 ns;
		num_full_adds <= num_full_adders_rect(NRARGS_C, WIDTH_C, 1, 1);
		wait for 10 ns;
		num_full_adds <= num_full_adders_rect(NRARGS_C, WIDTH_C, 1, 2);
		wait for 10 ns;
      num_full_adds <= num_full_adders_rect(NRARGS_C, WIDTH_C, 5, 2);
      wait for 10 ns;

		------------------------------------------------------------------------
		-- number of half addres
		num_half_adds <= num_half_adders_rect(NRARGS_C, WIDTH_C, 0, 0);
		wait for 10 ns;
		num_half_adds <= num_half_adders_rect(NRARGS_C, WIDTH_C, 0, 1);
		wait for 10 ns;
		num_half_adds <= num_half_adders_rect(NRARGS_C, WIDTH_C, 0, 2);
		wait for 10 ns;

		wait;

	end process p_Stim;

end architecture testbench;