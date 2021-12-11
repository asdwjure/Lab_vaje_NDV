--------------------------------------------------------------------------------
-- Title       : shift_reg_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : shift_reg_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Fri Dec 10 19:40:49 2021
-- Last update : Sat Dec 11 16:09:14 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: shift_reg_tb.vhd
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

entity shift_reg_tb is

end entity shift_reg_tb;

-----------------------------------------------------------

architecture testbench of shift_reg_tb is

	-- Testbench DUT generics
	constant reg_size : natural := 4;

	-- Testbench DUT ports
	signal clk, nCLR, sr_in, sl_in : std_logic;
	signal s                       : std_logic_vector(1 downto 0);
	signal x                       : std_logic_vector(reg_size - 1 downto 0);
	signal Q                       : std_logic_vector(reg_size - 1 downto 0);

	-- Other constants
	constant C_CLK_PERIOD : time := 10ns;

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
		nCLR <= '0',
		         '1' after 5*C_CLK_PERIOD;
		wait;
	end process RESET_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	p_Stim : process
	begin

	wait for C_CLK_PERIOD;
	s <= "00";
	x <= "1010";
	sr_in <= '1';
	sl_in <= '1';

	wait until nCLR = '1';
	wait for 5*C_CLK_PERIOD;

	s <= "11"; -- load
	wait for C_CLK_PERIOD;
	s <= "01"; -- shift right
	x <= "0000";
	wait for 3*C_CLK_PERIOD;
	s <= "11"; -- load
	wait for C_CLK_PERIOD;
	s <= "10"; -- shift left
	wait for 2*C_CLK_PERIOD;
	s <= "00"; -- hold

	wait;

	end process p_Stim;


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.shift_reg
		generic map (
			reg_size => reg_size
		)
		port map (
			clk   => clk,
			nCLR  => nCLR,
			sr_in => sr_in,
			sl_in => sl_in,
			s     => s,
			x     => x,
			Q     => Q
		);

end architecture testbench;