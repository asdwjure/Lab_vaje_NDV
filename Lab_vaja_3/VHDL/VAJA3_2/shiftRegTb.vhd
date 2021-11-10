--------------------------------------------------------------------------------
-- Title       : shiftRegTb
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : leddriver_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Fri Nov  5 20:29:49 2021
-- Last update : Fri Nov  5 20:37:09 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: shiftReg Testbench
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

entity shiftRegTb is

end entity shiftRegTb;

-----------------------------------------------------------

architecture testbench of shiftRegTb is

	-- Testbench DUT generics
	constant PAR_BITS : natural := 8;

	-- Testbench DUT ports
	signal CLK, SERIAL_IN : STD_LOGIC;
	signal PARALLEL_OUT   : STD_LOGIC_VECTOR ((PAR_BITS-1) downto 0);	

	-- Other constants
	constant C_CLK_PERIOD : time := 10 ns; -- NS

begin
	-----------------------------------------------------------
	-- Clocks and Reset
	-----------------------------------------------------------
	CLK_GEN : process
	begin
		clk <= '1';
		wait for C_CLK_PERIOD / 2;
		clk <= '0';
		wait for C_CLK_PERIOD / 2;
	end process CLK_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_stim : process
	begin
		wait for C_CLK_PERIOD*5;
		SERIAL_IN <= '0';
		wait for C_CLK_PERIOD*9;
		SERIAL_IN <= '1';
		wait for C_CLK_PERIOD*2;
		SERIAL_IN <= '0';
		wait for C_CLK_PERIOD;

		wait; -- end simulation

	end process p_stim;
	
	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	uut : entity work.shiftReg
		generic map (
			PAR_BITS => PAR_BITS
		)
		port map (
			CLK          => CLK,
			SERIAL_IN    => SERIAL_IN,
			PARALLEL_OUT => PARALLEL_OUT
		);	

end architecture testbench;