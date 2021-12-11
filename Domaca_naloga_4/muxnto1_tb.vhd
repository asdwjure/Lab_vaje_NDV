--------------------------------------------------------------------------------
-- Title       : muxnto1_tb.vhd
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : muxnto1_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Fri Dec 10 18:52:35 2021
-- Last update : Fri Dec 10 19:03:58 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description: muxnto1_tb.vhd
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

entity muxnto1_tb is

end entity muxnto1_tb;

-----------------------------------------------------------

architecture testbench of muxnto1_tb is

	-- Testbench DUT generics
	constant n_addr : natural := 4;

	-- Testbench DUT ports
	signal s : std_logic_vector(n_addr - 1 downto 0);
	signal w : std_logic_vector(2**n_addr - 1 downto 0);
	signal f : STD_LOGIC;

	-- Other constants
	constant C_CLK_PERIOD : time := 10 ns ;

begin

	p_Stim : process
	begin

	w <= "0001001000110100";

	for i in 0 to 2**n_addr - 1 loop
		s <= std_logic_vector(to_unsigned(i, s'length));
		wait for C_CLK_PERIOD;
	end loop;

	end process p_Stim;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.muxnto1
		generic map (
			n_addr => n_addr
		)
		port map (
			s => s,
			w => w,
			f => f
		);

end architecture testbench;