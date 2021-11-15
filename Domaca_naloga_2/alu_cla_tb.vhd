--------------------------------------------------------------------------------
-- Title       : alu_cla_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : alu_cla_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Mon Nov 15 18:45:13 2021
-- Last update : Mon Nov 15 20:02:13 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: Testbench for all modes of operation of ALU CLA.
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

entity alu_cla_tb is

end entity alu_cla_tb;

-----------------------------------------------------------

architecture testbench of alu_cla_tb is

	-- Testbench DUT generics
	constant n : natural := 8;

	-- Testbench DUT ports
	signal M                                          : std_logic;
	signal F                                          : std_logic_vector(2 downto 0);
	signal X, Y                                       : std_logic_vector(n-1 downto 0);
	signal S                                          : std_logic_vector(n-1 downto 0);
	signal Negative, Cout, Overflow, Zero, Gout, Pout : std_logic;

	signal aluOperationSig : std_logic_vector(3 downto 0);

begin
	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------

	M <= aluOperationSig(3);
	F <= aluOperationSig(2 downto 0);

	p_Stim : process
	begin
		wait for 10 ns;

		aluOperationSig <= "0000"; -- X+Y
		X               <= std_logic_vector(to_signed(0,n));
		Y               <= std_logic_vector(to_signed(0,n));
		wait for 10 ns;

		aluOperationSig <= "1001"; -- nand
		X               <= std_logic_vector(to_signed(0,n));
		Y               <= std_logic_vector(to_signed(0,n));
		wait for 10 ns;

		aluOperationSig <= "1000"; -- and
		X               <= std_logic_vector(to_signed(0,n));
		Y               <= std_logic_vector(to_signed(0,n));
		wait for 10 ns;

		aluOperationSig <= "1010"; -- or
		X               <= std_logic_vector(to_signed(0,n));
		Y               <= std_logic_vector(to_signed(0,n));
		wait for 10 ns;

		aluOperationSig <= "1011"; -- xor
		X               <= std_logic_vector(to_signed(-86,n));
		Y               <= std_logic_vector(to_signed(85,n));
		wait for 10 ns;

		aluOperationSig <= "1101"; -- xnor
		X               <= std_logic_vector(to_signed(-86,n));
		Y               <= std_logic_vector(to_signed(85,n));
		wait for 10 ns;

		aluOperationSig <= "1110"; -- S=X
		X               <= std_logic_vector(to_signed(-86,n));
		Y               <= std_logic_vector(to_signed(85,n));
		wait for 10 ns;

		aluOperationSig <= "1111"; -- S=Y
		X               <= std_logic_vector(to_signed(-86,n));
		Y               <= std_logic_vector(to_signed(85,n));
		wait for 10 ns;

		aluOperationSig <= "0000"; -- X+Y
		X               <= std_logic_vector(to_signed(-81,n));
		Y               <= std_logic_vector(to_signed(87,n));
		wait for 10 ns;

		aluOperationSig <= "0000"; -- X+Y
		X               <= std_logic_vector(to_signed(-86,n));
		Y               <= std_logic_vector(to_signed(81,n));
		wait for 10 ns;

		aluOperationSig <= "0001"; -- X-Y
		X               <= std_logic_vector(to_signed(-65,n));
		Y               <= std_logic_vector(to_signed(-48,n));
		wait for 10 ns;

		aluOperationSig <= "0001"; -- X-Y
		X               <= std_logic_vector(to_signed(-127,n));
		Y               <= std_logic_vector(to_signed(-48,n));
		wait for 10 ns;

		aluOperationSig <= "0010"; -- X+1
		X               <= std_logic_vector(to_signed(-127,n));
		Y               <= std_logic_vector(to_signed(-48,n));
		wait for 10 ns;

		aluOperationSig <= "0011"; -- X-1
		X               <= std_logic_vector(to_signed(-127,n));
		Y               <= std_logic_vector(to_signed(-48,n));
		wait for 10 ns;

		aluOperationSig <= "0100"; -- X+X
		X               <= std_logic_vector(to_signed(-127,n));
		Y               <= std_logic_vector(to_signed(-48,n));
		wait for 10 ns;

		aluOperationSig <= "0101"; -- S = -1
		X               <= std_logic_vector(to_signed(-127,n));
		Y               <= std_logic_vector(to_signed(-48,n));
		wait for 10 ns;

		aluOperationSig <= "0000"; -- X+Y
		X               <= std_logic_vector(to_signed(14,n));
		Y               <= std_logic_vector(to_signed(127,n));
		wait for 10 ns;

		aluOperationSig <= "0000"; -- X+Y
		X               <= std_logic_vector(to_signed(-14,n));
		Y               <= std_logic_vector(to_signed(-127,n));
		wait for 10 ns;

		aluOperationSig <= "0001"; -- X-Y
		X               <= std_logic_vector(to_signed(14,n));
		Y               <= std_logic_vector(to_signed(-127,n));
		wait for 10 ns;

		aluOperationSig <= "0001"; -- X-Y
		X               <= std_logic_vector(to_signed(-14,n));
		Y               <= std_logic_vector(to_signed(127,n));
		wait for 10 ns;

		aluOperationSig <= "0010"; -- X+1
		X               <= std_logic_vector(to_signed(127,n));
		Y               <= std_logic_vector(to_signed(127,n));
		wait for 10 ns;

		aluOperationSig <= "0011"; -- X-1
		X               <= std_logic_vector(to_signed(-128,n));
		Y               <= std_logic_vector(to_signed(127,n));
		wait for 10 ns;

		aluOperationSig <= "0100"; -- X+X
		X               <= std_logic_vector(to_signed(127,n));
		Y               <= std_logic_vector(to_signed(127,n));
		wait for 10 ns;

		aluOperationSig <= "0100"; -- X+X
		X               <= std_logic_vector(to_signed(-128,n));
		Y               <= std_logic_vector(to_signed(127,n));
		wait for 10 ns;

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