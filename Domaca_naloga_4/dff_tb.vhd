--------------------------------------------------------------------------------
-- Title       : dff_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : dff_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Fri Dec 10 18:37:55 2021
-- Last update : Fri Dec 10 19:11:52 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: dff_tb.vhd
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

entity dff_tb is

end entity dff_tb;

-----------------------------------------------------------

architecture testbench of dff_tb is

	-- Testbench DUT ports
	signal D       : STD_LOGIC;
	signal clk     : STD_LOGIC;
	signal nPRESET : STD_LOGIC;
	signal nCLEAR  : STD_LOGIC;
	signal Q       : STD_LOGIC;

	-- Other constants
	constant C_CLK_PERIOD : time := 10 ns;


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


	p_Stim : process
	begin
		wait for 1 ns;
		D       <= '0';
		nPRESET <= '1';
		nCLEAR  <= '1';
		wait for C_CLK_PERIOD*5;
		D       <= '0';
		nPRESET <= '0';
		nCLEAR  <= '1';
		wait for C_CLK_PERIOD;
		D       <= '0';
		nPRESET <= '1';
		nCLEAR  <= '1';
		wait for C_CLK_PERIOD;
		D       <= '1';
		nPRESET <= '1';
		nCLEAR  <= '1';
		wait for C_CLK_PERIOD;
		D       <= '1';
		nPRESET <= '1';
		nCLEAR  <= '0';
		wait for C_CLK_PERIOD;
		D       <= '0';
		nPRESET <= '1';
		nCLEAR  <= '1';
		wait for C_CLK_PERIOD;
		D       <= '1';
		nPRESET <= '1';
		nCLEAR  <= '1';
		wait for C_CLK_PERIOD;

		wait;


	end process p_Stim;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.dff(dff_fdc)
		port map (
			D       => D,
			clk     => clk,
			nPRESET => nPRESET,
			nCLEAR  => nCLEAR,
			Q       => Q
		);

end architecture testbench;