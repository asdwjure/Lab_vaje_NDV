library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY CORDIC_FSM IS
   PORT(
      clk, nRST, start, rco : IN  std_logic;
      init, load, done      : OUT std_logic
   );
END CORDIC_FSM;

ARCHITECTURE rtl OF CORDIC_FSM IS

   TYPE STATE_TYPE IS ( IDLE, CALC, FINISHED );
   SIGNAL state, next_state : STATE_TYPE := IDLE;
BEGIN

   PROCESS(nRST, clk)
   BEGIN
      if nRST = '0' THEN
         STATE <= IDLE;
      ELSIF rising_edge(clk) then
         CASE state IS
            WHEN IDLE =>
               IF start = '0' then
                  state <= IDLE;
               ELSE
                  state <= CALC;
               END IF;
            WHEN CALC =>
               IF rco = '0' then
                  state <= CALC;
               ELSE
                  state <= FINISHED;
               END IF;
            WHEN FINISHED =>
               IF start ='1' then
                  state <= FINISHED;
               ELSE
                  state <= IDLE;
               END IF;
         END CASE;
      END IF;
   END PROCESS;
   
   init <= '1' when state = IDLE else '0';
   load <= '1' when state = CALC else '0';
   done <= '1' when state = FINISHED else '0';

END rtl;
