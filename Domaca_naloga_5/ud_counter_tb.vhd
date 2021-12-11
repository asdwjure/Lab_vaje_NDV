--------------------------------------------------------------------------------
-- Title       : ud_counter_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : ud_counter_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Sat Dec 11 17:09:22 2021
-- Last update : Sat Dec 11 17:24:43 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: penis
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

entity ud_counter_tb is

end entity ud_counter_tb;

-----------------------------------------------------------

architecture testbench of ud_counter_tb is

	-- Testbench DUT generics
	constant ctr_size : natural := 3;
	constant TPD_G    : time    := 1 ns;

	-- Testbench DUT ports
	signal clk, nCLR, D_nU, EN : std_logic;
	signal RCO                 : std_logic;
	signal Q                   : std_logic_vector(ctr_size - 1 downto 0);

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
		nCLR <= '0';
		D_nU <= '0';
		EN <= '0';
		wait for C_CLK_PERIOD;

		nCLR <= '1';
		wait for C_CLK_PERIOD;
		EN <= '1';
		wait for 12*C_CLK_PERIOD;
		D_nU <= '1';
		wait for 10*C_CLK_PERIOD;

		wait;


	end process p_Stim;


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.ud_counter
		generic map (
			ctr_size => ctr_size,
			TPD_G    => TPD_G
		)
		port map (
			clk  => clk,
			nCLR => nCLR,
			D_nU => D_nU,
			EN   => EN,
			RCO  => RCO,
			Q    => Q
		);

end architecture testbench;