library WORK;
use WORK.cordic_pkg.all;
library STD;
use STD.textio.all;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
USE IEEE.MATH_REAL.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY barrel_shifter_sra_tb IS
GENERIC(
		width : integer := 32;
		size : integer := 32
	);
END barrel_shifter_sra_tb;

ARCHITECTURE rtl OF barrel_shifter_sra_tb IS
	
	FILE RESULTS: TEXT OPEN WRITE_MODE IS "barrel_shifter_sra.csv";
	
	COMPONENT barrel_shifter_sra IS
	GENERIC(
		width : integer := 32;
		size : integer := 32
	);
	PORT( 
		input  : IN     std_logic_vector (WIDTH-1 DOWNTO 0);
		output : OUT    std_logic_vector (WIDTH-1 DOWNTO 0);
		n      : IN     std_logic_vector (sizeof(size - 1) - 1 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL clk : std_logic := '0';

	SIGNAL	input  : std_logic_vector (WIDTH-1 DOWNTO 0) := ((WIDTH-1) => '1', others => '0');
	SIGNAL	output : std_logic_vector (WIDTH-1 DOWNTO 0);
	SIGNAL	n      : std_logic_vector (sizeof(size - 1) - 1 DOWNTO 0) := (others => '0');

	constant PERIOD : time := 200 ns;
	constant DUTY_CYCLE : real := 0.5;
	constant OFFSET : time := 100 ns;

    BEGIN
      UUT : barrel_shifter_sra
		GENERIC MAP (
				width => width,
				size => size
		)		
        PORT MAP (
            input => input,
				output => output,
				n => n
        );

        PROCESS
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                clk <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                clk <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
		  
					PROCEDURE Log_variables(
						n : std_logic_vector (sizeof(size - 1) - 1 DOWNTO 0) := (others => '0');
						input : std_logic_vector (width - 1 DownTo 0);
						output : std_logic_vector (width - 1 DownTo 0)
					) IS
					VARIABLE RES_LINE : LINE;
					BEGIN
					  hwrite(RES_LINE, "000" & n, right, 2);
					  write(RES_LINE, string'(","));
					  hwrite(RES_LINE, input, right, 4);
					  write(RES_LINE, string'(","));
					  hwrite(RES_LINE, output, right, 4);					  		 
					  writeline(RESULTS, RES_LINE);
					END;
					
			variable HDR_line : LINE;
				
			BEGIN
				write(HDR_line, string'(" n, input, output"));
				writeline(RESULTS, HDR_line);
				
				WAIT FOR PERIOD;
				
				FOR i IN 0 TO width - 1 LOOP
					n <= std_logic_vector(to_unsigned(i, n'length));
					WAIT FOR PERIOD;
					Log_variables(n, input, output);
				END LOOP;					
												
			END PROCESS;

END rtl;

