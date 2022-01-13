library IEEE;
use IEEE.numeric_std.all;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY CORDIC_FSM_tb IS
END CORDIC_FSM_tb;

ARCHITECTURE rtl OF CORDIC_FSM_tb IS
FILE RESULTS: TEXT OPEN WRITE_MODE IS "CORDIC_FSM.csv";

COMPONENT CORDIC_FSM
  PORT (
		clk : In std_logic;
		nRST : In std_logic;
		start : In std_logic;
		rco : In std_logic;
		init : Out std_logic;
		load : Out std_logic;
		done : Out std_logic
  );
END COMPONENT;

SIGNAL clk : std_logic := '0';
SIGNAL nRST : std_logic := '0';
SIGNAL start : std_logic := '0';
SIGNAL rco : std_logic := '0';
SIGNAL init : std_logic := '0';
SIGNAL load : std_logic := '0';
SIGNAL done : std_logic := '0';

constant PERIOD : time := 200 ns;
constant DUTY_CYCLE : real := 0.5;
constant OFFSET : time := 100 ns;

BEGIN
  UUT : CORDIC_FSM
  PORT MAP (
		clk => clk,
		nRST => nRST,
		start => start,
		rco => rco,
		init => init,
		load => load,
		done => done
  );

  PROCESS    -- clock process for clk
	  PROCEDURE Log_variables( clk, nRST, start, rco, init, load, done : std_logic ) IS
		VARIABLE RES_LINE : LINE;
		BEGIN
			write(RES_LINE, clk, right, 1);
			write(RES_LINE, string'(","));  
			
			write(RES_LINE, nRST, right, 1);
			write(RES_LINE, string'(","));
			
			write(RES_LINE, start, right, 1);
			write(RES_LINE, string'(","));

			write(RES_LINE, rco, right, 1);
			write(RES_LINE, string'(","));

			write(RES_LINE, init, right, 1);
			write(RES_LINE, string'(","));

			write(RES_LINE, load, right, 1);
			write(RES_LINE, string'(","));

			write(RES_LINE, done, right, 1);
			
		  writeline(RESULTS, RES_LINE);
		END;
  BEGIN
		WAIT for OFFSET;
		CLOCK_LOOP : LOOP
			 clk <= '0';
			 WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
			 clk <= '1';
			 WAIT FOR (PERIOD * DUTY_CYCLE);
			 Log_variables( clk, nRST, start, rco, init, load, done);
		END LOOP CLOCK_LOOP;
  END PROCESS;

 PROCESS		  
	variable HDR_line : LINE;		
	BEGIN
		write(HDR_line, string'(" clk, nRST, start, rco, init, load, done"));
		writeline(RESULTS, HDR_line);
		
		WAIT FOR 100 ns;		
		nRST <= '1';
		WAIT FOR 85 ns;
		nRST <= '0';
		WAIT FOR 200 ns;
		nRST <= '1';
		WAIT FOR 200 ns;
		start <= '1';
		WAIT FOR 200 ns;
		start <= '0';
		WAIT FOR 1400 ns;
		rco <= '1';
		WAIT FOR 200 ns;
		rco <= '0';
		WAIT FOR 2815 ns;
	END PROCESS;

END rtl;

