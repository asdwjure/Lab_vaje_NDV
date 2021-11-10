--------------------------------------------------------------------------------
-- Title       : ps2_keyboard Testbench
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : PS2_KEYBOARD_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Tue Nov  9 22:13:35 2021
-- Last update : Wed Nov 10 21:25:11 2021
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2021 User Company Name
-------------------------------------------------------------------------------
-- Description:   Testbench for ps2 keyboard VHDL file.
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

entity PS2_KEYBOARD_tb is

end entity PS2_KEYBOARD_tb;

-----------------------------------------------------------

architecture testbench of PS2_KEYBOARD_tb is


   -- Testbench DUT ports
   signal clk          : STD_LOGIC := '0';
   signal PS2_CLK      : STD_LOGIC := '1';
   signal PS2_DATA     : STD_LOGIC := '1';
   signal PS2_code_new : STD_LOGIC;
   signal PS2_code     : STD_LOGIC_VECTOR(7 downto 0);

   -- Other constants
   constant C_CLK_PERIOD     : time                          := 10 ns;
   constant PS2_CLK_PERIOD_C : time                          := 55 us;
   constant DATA_C           : std_logic_vector(10 downto 0) := "01100010101";

   --variable idx : natural := 0;

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

      PS2_CLK <= '1';
      wait for PS2_CLK_PERIOD_C * 2;
      PS2_DATA <= DATA_C(10); -- start bit
      wait for PS2_CLK_PERIOD_C / 2;

      for i in 9 downto 0 loop
         PS2_CLK <= '0';
         wait for PS2_CLK_PERIOD_C / 2;
         PS2_DATA <= DATA_C(i);
         PS2_CLK  <= '1';
         wait for PS2_CLK_PERIOD_C / 2;
      end loop;

      -- One extra clock to latch the last data in
      PS2_CLK <= '0';
      wait for PS2_CLK_PERIOD_C / 2;
      PS2_CLK <= '1';
      wait for PS2_CLK_PERIOD_C / 2;

      wait;

   end process p_Stim;


   -----------------------------------------------------------
   -- Entity Under Test
   -----------------------------------------------------------
   DUT : entity work.PS2_KEYBOARD
      port map (
         clk          => clk,
         PS2_CLK      => PS2_CLK,
         PS2_DATA     => PS2_DATA,
         PS2_code_new => PS2_code_new,
         PS2_code     => PS2_code
      );

end testbench;