--------------------------------------------------------------------------------
-- Title       : tff_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : tff_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Sat Dec 11 16:44:37 2021
-- Last update : Sat Dec 11 16:54:00 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: smeti
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

entity tff_tb is

end entity tff_tb;

-----------------------------------------------------------

architecture testbench of tff_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal T, clk, nPRESET, nCLEAR : STD_LOGIC;
	signal Q                       : STD_LOGIC;

	-- Other constants
	constant C_CLK_PERIOD : time := 10 ns; -- NS

begin
	-----------------------------------------------------------
	-- Clocks and Reset
	-----------------------------------------------------------
	CLK_GEN : process
	begin
		clk <= '1';
		wait for C_CLK_PERIOD / 2.0;
		clk <= '0';
		wait for C_CLK_PERIOD / 2.0;
	end process CLK_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_Stim : process
	begin
		wait for C_CLK_PERIOD;
		T <= '0';
		nPRESET <= '1';
		nCLEAR <= '1';

		wait for C_CLK_PERIOD;
		T <= '1';
		wait for 3*C_CLK_PERIOD;
		wait for C_CLK_PERIOD/5;

		nPRESET <= '0';
		wait for C_CLK_PERIOD;
		nPRESET <= '1';
		wait for 4*C_CLK_PERIOD;
		T <= '0';
		nCLEAR <= '0';
		wait for C_CLK_PERIOD;
		nCLEAR <= '1';

		wait;

	end process p_Stim;


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.tff
		port map (
			T       => T,
			clk     => clk,
			nPRESET => nPRESET,
			nCLEAR  => nCLEAR,
			Q       => Q
		);

end architecture testbench;