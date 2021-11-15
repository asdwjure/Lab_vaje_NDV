--------------------------------------------------------------------------------
-- Title       : alu_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : alu_cla_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Mon Nov 15 18:28:27 2021
-- Last update : Mon Nov 15 18:46:47 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: Testbench for alu_cla.vhd. Testing addition of two numers
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

entity alu_tb is

end entity alu_tb;

-----------------------------------------------------------

architecture testbench of alu_tb is

	-- Testbench DUT generics
	constant n : natural := 8;

	-- Testbench DUT ports
	signal M                                          : std_logic;
	signal F                                          : std_logic_vector(2 downto 0);
	signal X, Y                                       : std_logic_vector(n-1 downto 0);
	signal S                                          : std_logic_vector(n-1 downto 0);
	signal Negative, Cout, Overflow, Zero, Gout, Pout : std_logic;

begin
	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_Stim : process
	begin
		wait for 10 ns;
		M <= '0';
		F <= "000";
		X <= (others => '0');
		Y <= (others => '0');

		for i in 0 to 2**n - 1 loop
			for j in 0 to 2**n - 1 loop

			X <= std_logic_vector(to_unsigned(i,n));
			Y <= std_logic_vector(to_unsigned(j,n));
			wait for 10 ns;

			end loop;
		end loop;
		
		wait;

	end process p_Stim;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.alu_cla
		generic map (
			n => n
		)
		port map (
			M        => M,
			F        => F,
			X        => X,
			Y        => Y,
			S        => S,
			Negative => Negative,
			Cout     => Cout,
			Overflow => Overflow,
			Zero     => Zero,
			Gout     => Gout,
			Pout     => Pout
		);

end architecture testbench;