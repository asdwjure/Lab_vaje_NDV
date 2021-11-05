--------------------------------------------------------------------------------
-- Title       : led4digitTb
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : led4digit_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Fri Nov  5 18:44:53 2021
-- Last update : Fri Nov  5 19:04:43 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: Testbench for led4digit
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

entity led4digit_tb is

end entity led4digit_tb;

-----------------------------------------------------------

architecture testbench of led4digit_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal CLK    : STD_LOGIC;
	signal nDIGIT : STD_LOGIC_VECTOR (3 downto 0);
	signal LED    : STD_LOGIC_VECTOR (6 downto 0);
	signal DATA   : STD_LOGIC_VECTOR (3 downto 0);

	-- Other constants
	constant CLK_PERIOD_C : time := 10 ns;

begin
	-----------------------------------------------------------
	-- Clocks and Reset
	-----------------------------------------------------------
	CLK_GEN : process
	begin
		clk <= '1';
		wait for CLK_PERIOD_C / 2.0;
		clk <= '0';
		wait for CLK_PERIOD_C / 2.0;
	end process CLK_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_stim : process
		variable idx : natural := 0;
	begin
		wait for 10*CLK_PERIOD_C;
		DATA <= (others => '0');
		wait for 3*CLK_PERIOD_C;

		for idx in 0 to 16 loop
			DATA <= std_logic_vector( to_unsigned(idx, DATA'length) );
			wait for 3*CLK_PERIOD_C;
		end loop;

	end process p_stim;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.led4digit
		port map (
			CLK    => CLK,
			nDIGIT => nDIGIT,
			LED    => LED,
			DATA   => DATA
		);

end architecture testbench;