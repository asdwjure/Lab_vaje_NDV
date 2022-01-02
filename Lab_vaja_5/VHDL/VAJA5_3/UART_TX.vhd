library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY UART_TX IS
   PORT(
      DATA                : in  STD_LOGIC_VECTOR (7 downto 0);
      nRST, TX_CLK, nSEND : in  STD_LOGIC;
      TX, nDONE           : OUT STD_LOGIC
   );
END UART_TX ;

ARCHITECTURE arch OF UART_TX IS

   type uart_states is (
         idle_state,
         start_bit_state,
         shift_contents_state,
         stop_bit_state,
         transmission_complete_state
      );

   signal state           : uart_states;
   signal tx_buffer_sig   : std_logic_vector(7 downto 0);
   signal tx_bit_position : natural range 0 to 7 := 0;

BEGIN

   process(nRST, TX_CLK)
   begin
      if nRST = '0' then
         state <= idle_state;

      elsif rising_edge(TX_CLK) then

         case state is
            when idle_state =>
               tx_buffer_sig   <= DATA;
               tx_bit_position <= 0;

               if nSEND = '0' then
                  state <= start_bit_state;
               end if;

            when start_bit_state =>
               state <= shift_contents_state;

            when shift_contents_state =>
               if tx_bit_position = 7 then
                  state <= stop_bit_state;
               else
                  tx_buffer_sig   <= '0' & tx_buffer_sig(7 downto 1);
                  tx_bit_position <= tx_bit_position + 1;
               end if;

            when stop_bit_state =>
               state <= transmission_complete_state;

            when transmission_complete_state =>
               state <= idle_state;
         end case;
      end if;

   end process;

   TX <=
      '0'              when state = start_bit_state else
      tx_buffer_sig(0) when state = shift_contents_state else
      '1';

   nDONE <= '0' when state = transmission_complete_state else '1';


END arch;	