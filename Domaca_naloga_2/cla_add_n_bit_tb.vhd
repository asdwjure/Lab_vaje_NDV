--------------------------------------------------------------------------------
-- Title       : cla_add_n_bit_tb
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : cla_add_n_bit_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Fri Nov 12 19:38:11 2021
-- Last update : Mon Nov 15 19:47:28 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: Test bench for N-bit CLA adder
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

entity cla_add_n_bit_tb is

end entity cla_add_n_bit_tb;

-----------------------------------------------------------

architecture testbench of cla_add_n_bit_tb is

	-- Testbench DUT generics
	constant n : natural := 4;

	-- Testbench DUT ports
	signal Cin              : std_logic;
	signal X, Y             : std_logic_vector(n-1 downto 0);
	signal S                : std_logic_vector(n-1 downto 0);
	signal Gout, Pout, Cout : std_logic;

begin

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_Stim : process
	begin
		wait for 10 ns;

		Cin <= '0';

		for i in 0 to 2**n - 1 loop
			for j in 0 to 2**n - 1 loop
				X <= std_logic_vector(to_unsigned(i, n));
				Y <= std_logic_vector(to_unsigned(j, n));
				wait for 10 ns;
			end loop;
		end loop;

		Cin <= '1';

		for i in 0 to 2**n - 1 loop
			for j in 0 to 2**n - 1 loop
				X <= std_logic_vector(to_unsigned(i, n));
				Y <= std_logic_vector(to_unsigned(j, n));
				wait for 10 ns;
			end loop;
		end loop;
		
		wait;

	end process p_Stim;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.cla_add_n_bit
		generic map (
			n => n
		)
		port map (
			Cin  => Cin,
			X    => X,
			Y    => Y,
			S    => S,
			Gout => Gout,
			Pout => Pout,
			Cout => Cout
		);

end architecture testbench;