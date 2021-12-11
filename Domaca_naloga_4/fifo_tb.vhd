--------------------------------------------------------------------------------
-- Title       : fifo_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : fifo_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Sat Dec 11 16:22:53 2021
-- Last update : Sat Dec 11 16:27:56 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: fifo_tb.vhd
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

entity fifo_tb is

end entity fifo_tb;

-----------------------------------------------------------

architecture testbench of fifo_tb is

	-- Testbench DUT generics
	constant fifo_width : natural := 4;
	constant fifo_size  : natural := 8;

	-- Testbench DUT ports
	signal clk, nCLR, nEnable, LOAD : std_logic;
	signal fifo_in                  : std_logic_vector(fifo_width - 1 downto 0);
	signal fifo_out                 : std_logic_vector(fifo_width - 1 downto 0);

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
      nEnable <= '1';
      LOAD <= '0';
      fifo_in <= "1010";
		nCLR <= '1';
		
		wait for 5*C_CLK_PERIOD;
      nEnable <= '0';
		wait for 5*C_CLK_PERIOD;

      LOAD <= '1';
      wait for 10*C_CLK_PERIOD;

      LOAD <= '1';
      nCLR <= '0';
      wait for 5*C_CLK_PERIOD;

      wait;

	end process p_Stim;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.fifo
		generic map (
			fifo_width => fifo_width,
			fifo_size  => fifo_size
		)
		port map (
			clk      => clk,
			nCLR     => nCLR,
			nEnable  => nEnable,
			LOAD     => LOAD,
			fifo_in  => fifo_in,
			fifo_out => fifo_out
		);

end architecture testbench;