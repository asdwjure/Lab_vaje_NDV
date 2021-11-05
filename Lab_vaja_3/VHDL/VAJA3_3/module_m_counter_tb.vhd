--------------------------------------------------------------------------------
-- Title       : module_m_counter_tb
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : module_m_counter_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Fri Nov  5 20:49:41 2021
-- Last update : Fri Nov  5 21:04:11 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: 
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

entity module_m_counter_tb is

end entity module_m_counter_tb;

-----------------------------------------------------------

architecture testbench of module_m_counter_tb is

	-- Testbench DUT generics
	constant M : natural := 60;

	-- Testbench DUT ports
	signal nRST, clk : STD_LOGIC;
	signal CTR       : STD_LOGIC_VECTOR (15 downto 0);
	signal RCO       : STD_LOGIC;

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

	RESET_GEN : process
	begin
		nRST <= '0',
		         '1' after 5.0*C_CLK_PERIOD;
		wait;
	end process RESET_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.module_m_counter
		generic map (
			M => M
		)
		port map (
			nRST => nRST,
			clk  => clk,
			CTR  => CTR,
			RCO  => RCO
		);

end architecture testbench;