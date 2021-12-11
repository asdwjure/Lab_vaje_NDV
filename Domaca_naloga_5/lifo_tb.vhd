--------------------------------------------------------------------------------
-- Title       : lifo_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : lifo_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Sat Dec 11 18:16:15 2021
-- Last update : Sat Dec 11 20:02:43 2021
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

entity lifo_tb is

end entity lifo_tb;

-----------------------------------------------------------

architecture testbench of lifo_tb is

	-- Testbench DUT generics
	constant lifo_width : natural := 4;
	constant lifo_size  : natural := 8;

	-- Testbench DUT ports
	signal clk, nCLR, nEnable, PUSH, POP : std_logic;
	signal data                          : std_logic_vector(lifo_width - 1 downto 0);
	signal FULL, EMPTY                   : std_logic;

	-- Other constants
	constant C_CLK_PERIOD :time := 10 ns; -- NS

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
		nCLR <= '0';
		PUSH <= '0';
		POP <= '0';
		wait for C_CLK_PERIOD;
		nCLR <= '1';
		nEnable <= '0';
		wait for C_CLK_PERIOD;
		PUSH <= '1';

		
		for i in 0 to 10 loop
			data <= std_logic_vector(to_unsigned(i, data'length));
			wait for C_CLK_PERIOD;
		end loop;
		data <= "ZZZZ";
		PUSH <= '0';
		wait for C_CLK_PERIOD;
		POP <= '1';
		wait for C_CLK_PERIOD*10;

		wait;

	end process p_Stim;


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.lifo
		generic map (
			lifo_width => lifo_width,
			lifo_size  => lifo_size
		)
		port map (
			clk     => clk,
			nCLR    => nCLR,
			nEnable => nEnable,
			PUSH    => PUSH,
			POP     => POP,
			data    => data,
			FULL    => FULL,
			EMPTY   => EMPTY
		);

end architecture testbench;