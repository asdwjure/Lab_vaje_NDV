library WORK;
use WORK.cordic_pkg.all;
library STD;
use STD.textio.all;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
USE IEEE.MATH_REAL.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY CORDIC_tb IS
GENERIC(
		width : integer := 32
	);
END CORDIC_tb;

ARCHITECTURE testbench_arch OF CORDIC_tb IS
	
	FILE RESULTS: TEXT OPEN WRITE_MODE IS "cordic.csv";
	
    COMPONENT cordic
        PORT (
            clk, nRST, start : In std_logic;
            angle : In std_logic_vector (width - 1 DownTo 0);
            sin, cos : Out std_logic_vector (width - 1 DownTo 0);
            done : Out std_logic
        );
    END COMPONENT;

    SIGNAL clk, nRST, start, done : std_logic := '0';
    SIGNAL angle, sinus, cosinus : std_logic_vector (width - 1 DownTo 0) := (others => '0');

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 100 ns;

    BEGIN
        UUT : cordic
        PORT MAP (
            clk => clk,
            nRST => nRST,
            start => start,
            angle => angle,
            sin => sinus,
            cos => cosinus,
            done => done
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
						nRST, start :  std_logic;
						angle : std_logic_vector (width - 1 DownTo 0);
						sinus, cosinus :  std_logic_vector (width - 1 DownTo 0);
						done :  std_logic
					) IS
					VARIABLE RES_LINE : LINE;
					variable fi : real := Conv2real( to_integer(unsigned(angle)), width); 
					variable actual_sinus : real := sin(fi);
					variable actual_cosinus : real := cos(fi);
					variable cordic_sinus : real := Conv2real( to_integer(unsigned(sinus)), width);
					variable cordic_cosinus : real := Conv2real( to_integer(unsigned(cosinus)), width);
					BEGIN
					  write(RES_LINE, nRST, right, 1);
					  write(RES_LINE, string'(","));
					  write(RES_LINE, start, right, 1);
					  write(RES_LINE, string'(","));
					  write(RES_LINE, done, right, 1);				  
					  write(RES_LINE, string'(","));
					  write(RES_LINE, real'(fi));
					  write(RES_LINE, string'(","));
					  write(RES_LINE, real'(cordic_sinus));
					  write(RES_LINE, string'(","));
					  write(RES_LINE, real'(cordic_cosinus));
					  write(RES_LINE, string'(","));
					  write(RES_LINE, real'(actual_sinus));
					  write(RES_LINE, string'(","));
					  write(RES_LINE, real'(actual_cosinus));
					  write(RES_LINE, string'(","));
					  write(RES_LINE, real'(abs(actual_sinus-cordic_sinus)));
					  write(RES_LINE, string'(","));
					  write(RES_LINE, real'(abs(actual_cosinus-cordic_cosinus)));					  
					  writeline(RESULTS, RES_LINE);
					END;
				variable HDR_line : LINE;
				
            BEGIN
					write(HDR_line, string'(" nRST, start, done, angle, CORDIC(sinus), CORDIC(cosinus), ACCURATE(sinus), ACCURATE(cosinus), ABSDELTA(sinus), ABSDELTA(cosinus)"));
					writeline(RESULTS, HDR_line);

					WAIT FOR PERIOD;
					nRST <= '1';
					WAIT FOR PERIOD;
					nRST <= '0';
					WAIT FOR PERIOD;
					nRST <= '1';
					WAIT FOR PERIOD;
					start <= '1';
					WAIT FOR ((width + 2) * PERIOD);
					Log_variables(nRST, start,angle, sinus, cosinus, done);
					
					angle <= Conv2fixedPt(PI / real(2.0), width );
					WAIT FOR PERIOD;
					nRST <= '0';
					WAIT FOR PERIOD;
					nRST <= '1';
					WAIT FOR PERIOD;
					start <= '1';
					WAIT FOR ((width + 2) * PERIOD);
					Log_variables(nRST, start,angle, sinus, cosinus, done);
					
					angle <= Conv2fixedPt(PI / real(3.0), width );
					WAIT FOR PERIOD;
					nRST <= '0';
					WAIT FOR PERIOD;
					nRST <= '1';
					WAIT FOR PERIOD;
					start <= '1';
					WAIT FOR ((width + 2) * PERIOD);
					
					angle <= Conv2fixedPt(PI / real(4.0), width );
					WAIT FOR PERIOD;
					nRST <= '0';
					WAIT FOR PERIOD;
					nRST <= '1';
					WAIT FOR PERIOD;
					start <= '1';
					WAIT FOR ((width + 2) * PERIOD);
					Log_variables(nRST, start,angle, sinus, cosinus, done);

					angle <= Conv2fixedPt(PI / real(6.0), width );
					WAIT FOR PERIOD;
					nRST <= '0';
					WAIT FOR PERIOD;
					nRST <= '1';
					WAIT FOR PERIOD;
					start <= '1';
					WAIT FOR ((width + 2) * PERIOD);
					Log_variables(nRST, start,angle, sinus, cosinus, done);
					
					WAIT FOR ((width + 2) * PERIOD); --this line to avoid repetition of simulation
            END PROCESS;

    END testbench_arch;

