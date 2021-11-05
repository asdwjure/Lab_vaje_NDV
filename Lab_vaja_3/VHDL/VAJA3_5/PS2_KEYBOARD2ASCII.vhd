
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PS2_KEYBOARD2ASCII is
port(
	clk        : in  STD_LOGIC;                     --system clock
   PS2_CLK    : in  STD_LOGIC;                     --clock signal from PS/2 keyboard
   PS2_DATA   : in  STD_LOGIC;                     --data signal from PS/2 keyboard
	ASCII_NEW  : out STD_LOGIC;  --output flag indicating new ASCII value
	ASCII_CODE : out STD_LOGIC_VECTOR(6 downto 0)); --ASCII value
end PS2_KEYBOARD2ASCII;

architecture Behavioral of PS2_KEYBOARD2ASCII is

  type machine is(ready, new_code, translate, output);              --needed states
  signal state             : machine;                               --state machine
  signal PS2_CODE_NEW      : STD_LOGIC;                             --new PS2 code flag from ps2_keyboard component
  signal PS2_CODE          : STD_LOGIC_VECTOR(7 downto 0);          --PS2 code input form ps2_keyboard component
  signal PREV_PS2_CODE_NEW : STD_LOGIC := '1';                      --value of PS2_CODE_new flag on previous clock
  signal BREAK             : STD_LOGIC := '0';                      --'1' for break code, '0' for make code
  signal E0_CODE           : STD_LOGIC := '0';                      --'1' for multi-code commands, '0' for single code commands
  signal CAPS_LOCK         : STD_LOGIC := '0';                      --'1' if caps lock is active, '0' if caps lock is inactive
  signal CONTROL_R         : STD_LOGIC := '0';                      --'1' if right control key is held down, else '0'
  signal CONTROL_L         : STD_LOGIC := '0';                      --'1' if left control key is held down, else '0'
  signal SHIFT_R           : STD_LOGIC := '0';                      --'1' if right SHIFT is held down, else '0'
  signal SHIFT_L           : STD_LOGIC := '0';                      --'1' if left SHIFT is held down, else '0'
  signal ASCII             : STD_LOGIC_VECTOR(7 downto 0) := x"FF"; --internal value of ASCII translation

component PS2_KEYBOARD is
  port(
    clk          : in  STD_LOGIC;                     --system clock
    PS2_CLK      : in  STD_LOGIC;                     --clock signal from PS/2 keyboard
    PS2_DATA     : in  STD_LOGIC;                     --data signal from PS/2 keyboard
    PS2_code_new : out STD_LOGIC;                     --flag that new PS/2 code is available on ps2_code bus
    PS2_code     : out STD_LOGIC_VECTOR(7 downto 0)); --code received from PS/2
end component;

begin

  --instantiate PS2 keyboard interface logic
PS2_KEYBOARD_0: PS2_KEYBOARD port map(clk => clk, PS2_CLK => PS2_CLK, PS2_DATA => PS2_DATA, PS2_CODE_NEW => PS2_CODE_NEW, PS2_CODE => PS2_CODE);

  process(clk)
  begin
    if(clk'EVENT and clk = '1') then
      PREV_PS2_CODE_NEW <= PS2_CODE_NEW; --keep track of previous PS2_CODE_new values to determine low-to-high transitions
      case state is
      
        --ready state: wait for a new PS2 code to be received
        when ready =>
          if(PREV_PS2_CODE_NEW = '0' and PS2_CODE_NEW = '1') then --new PS2 code received
            ASCII_NEW <= '0';                                       --reset new ASCII code indicator
            state <= new_code;                                      --proceed to new_code state
          else                                                    --no new PS2 code received yet
            state <= ready;                                         --remain in ready state
          end if;
          
        --new_code state: determine what to do with the new PS2 code  
        when new_code =>
          if(PS2_CODE = x"F0") then    --code indicates that next command is break
            break <= '1';                --set break flag
            state <= ready;              --return to ready state to await next PS2 code
          elsif(PS2_CODE = x"E0") then --code indicates multi-key command
            e0_code <= '1';              --set multi-code command flag
            state <= ready;              --return to ready state to await next PS2 code
          else                         --code is the last PS2 code in the make/break code
            ASCII(7) <= '1';             --set internal ascii value to unsupported code (for verification)
            state <= translate;          --proceed to translate state
          end if;

        --translate state: translate PS2 code to ASCII value
        when translate =>
            break <= '0';    --reset break flag
            e0_code <= '0';  --reset multi-code command flag
            
            --handle codes for control, SHIFT, and caps lock
            case PS2_CODE is
              when x"58" =>                   --caps lock code
                if(break = '0') then            --if make command
                  CAPS_LOCK <= not CAPS_LOCK;     --toggle caps lock
                end if;
              when x"14" =>                   --code for the control keys
                if(E0_CODE = '1') then          --code for right control
                  CONTROL_R <= not break;         --update right control flag
                else                            --code for left control
                  CONTROL_L <= not break;         --update left control flag
                end if;
              when x"12" =>                   --left SHIFT code
                SHIFT_L <= not break;           --update left SHIFT flag
              when x"59" =>                   --right SHIFT code
                SHIFT_R <= not break;           --update right SHIFT flag
              when others => null;
            end case;
        
            --translate control codes (these do not depend on SHIFT or caps lock)
            if(CONTROL_L = '1' or CONTROL_R = '1') then
              case PS2_CODE is
                when x"1E" => ASCII <= x"00"; --^@  NUL
                when x"1C" => ASCII <= x"01"; --^A  SOH
                when x"32" => ASCII <= x"02"; --^B  STX
                when x"21" => ASCII <= x"03"; --^C  ETX
                when x"23" => ASCII <= x"04"; --^D  EOT
                when x"24" => ASCII <= x"05"; --^E  ENQ
                when x"2B" => ASCII <= x"06"; --^F  ACK
                when x"34" => ASCII <= x"07"; --^G  BEL
                when x"33" => ASCII <= x"08"; --^H  BS
                when x"43" => ASCII <= x"09"; --^I  HT
                when x"3B" => ASCII <= x"0A"; --^J  LF
                when x"42" => ASCII <= x"0B"; --^K  VT
                when x"4B" => ASCII <= x"0C"; --^L  FF
                when x"3A" => ASCII <= x"0D"; --^M  CR
                when x"31" => ASCII <= x"0E"; --^N  SO
                when x"44" => ASCII <= x"0F"; --^O  SI
                when x"4D" => ASCII <= x"10"; --^P  DLE
                when x"15" => ASCII <= x"11"; --^Q  DC1
                when x"2D" => ASCII <= x"12"; --^R  DC2
                when x"1B" => ASCII <= x"13"; --^S  DC3
                when x"2C" => ASCII <= x"14"; --^T  DC4
                when x"3C" => ASCII <= x"15"; --^U  NAK
                when x"2A" => ASCII <= x"16"; --^V  SYN
                when x"1D" => ASCII <= x"17"; --^W  ETB
                when x"22" => ASCII <= x"18"; --^X  CAN
                when x"35" => ASCII <= x"19"; --^Y  EM
                when x"1A" => ASCII <= x"1A"; --^Z  SUB
                when x"54" => ASCII <= x"1B"; --^[  ESC
                when x"5D" => ASCII <= x"1C"; --^\  FS
                when x"5B" => ASCII <= x"1D"; --^]  GS
                when x"36" => ASCII <= x"1E"; --^^  RS
                when x"4E" => ASCII <= x"1F"; --^_  US
                when x"4A" => ASCII <= x"7F"; --^?  DEL
                when others => null;
              end case;
            else --if control keys are not pressed  
            
              --translate characters that do not depend on SHIFT, or caps lock
              case PS2_CODE IS
                when x"29" => ASCII <= x"20"; --space
                when x"66" => ASCII <= x"08"; --backspace (BS control code)
                when x"0D" => ASCII <= x"09"; --tab (HT control code)
                when x"5A" => ASCII <= x"0D"; --enter (CR control code)
                when x"76" => ASCII <= x"1B"; --escape (ESC control code)
                when x"71" => 
                  if(E0_CODE = '1') then      --ps2 code for delete is a multi-key code
                    ASCII <= x"7F";             --delete
                  end if;
                when others => null;
              end case;
              
              --translate letters (these depend on both SHIFT and caps lock)
              if((SHIFT_R = '0' and SHIFT_L = '0' and CAPS_LOCK = '0') or
                ((SHIFT_R = '1' or SHIFT_L = '1') and CAPS_LOCK = '1')) then  --letter is lowercase
                case PS2_CODE is              
                  when x"1C" => ASCII <= x"61"; --a
                  when x"32" => ASCII <= x"62"; --b
                  when x"21" => ASCII <= x"63"; --c
                  when x"23" => ASCII <= x"64"; --d
                  when x"24" => ASCII <= x"65"; --e
                  when x"2B" => ASCII <= x"66"; --f
                  when x"34" => ASCII <= x"67"; --g
                  when x"33" => ASCII <= x"68"; --h
                  when x"43" => ASCII <= x"69"; --i
                  when x"3B" => ASCII <= x"6A"; --j
                  when x"42" => ASCII <= x"6B"; --k
                  when x"4B" => ASCII <= x"6C"; --l
                  when x"3A" => ASCII <= x"6D"; --m
                  when x"31" => ASCII <= x"6E"; --n
                  when x"44" => ASCII <= x"6F"; --o
                  when x"4D" => ASCII <= x"70"; --p
                  when x"15" => ASCII <= x"71"; --q
                  when x"2D" => ASCII <= x"72"; --r
                  when x"1B" => ASCII <= x"73"; --s
                  when x"2C" => ASCII <= x"74"; --t
                  when x"3C" => ASCII <= x"75"; --u
                  when x"2A" => ASCII <= x"76"; --v
                  when x"1D" => ASCII <= x"77"; --w
                  when x"22" => ASCII <= x"78"; --x
                  when x"35" => ASCII <= x"79"; --y
                  when x"1A" => ASCII <= x"7A"; --z
                  when others => null;
                end case;
              else                                     --letter is uppercase
                case PS2_CODE is            
                  when x"1C" => ASCII <= x"41"; --A
                  when x"32" => ASCII <= x"42"; --B
                  when x"21" => ASCII <= x"43"; --C
                  when x"23" => ASCII <= x"44"; --D
                  when x"24" => ASCII <= x"45"; --E
                  when x"2B" => ASCII <= x"46"; --F
                  when x"34" => ASCII <= x"47"; --G
                  when x"33" => ASCII <= x"48"; --H
                  when x"43" => ASCII <= x"49"; --I
                  when x"3B" => ASCII <= x"4A"; --J
                  when x"42" => ASCII <= x"4B"; --K
                  when x"4B" => ASCII <= x"4C"; --L
                  when x"3A" => ASCII <= x"4D"; --M
                  when x"31" => ASCII <= x"4E"; --N
                  when x"44" => ASCII <= x"4F"; --O
                  when x"4D" => ASCII <= x"50"; --P
                  when x"15" => ASCII <= x"51"; --Q
                  when x"2D" => ASCII <= x"52"; --R
                  when x"1B" => ASCII <= x"53"; --S
                  when x"2C" => ASCII <= x"54"; --T
                  when x"3C" => ASCII <= x"55"; --U
                  when x"2A" => ASCII <= x"56"; --V
                  when x"1D" => ASCII <= x"57"; --W
                  when x"22" => ASCII <= x"58"; --X
                  when x"35" => ASCII <= x"59"; --Y
                  when x"1A" => ASCII <= x"5A"; --Z
                  when others => null;
                end case;
              end if;
              
              --translate numbers and symbols (these depend on SHIFT but not caps lock)
              if(SHIFT_L = '1' or SHIFT_R = '1') then  --key's secondary character is desired
                CASE PS2_CODE IS              
                  when x"16" => ASCII <= x"21"; --!
                  when x"52" => ASCII <= x"22"; --"
                  when x"26" => ASCII <= x"23"; --#
                  when x"25" => ASCII <= x"24"; --$
                  when x"2E" => ASCII <= x"25"; --%
                  when x"3D" => ASCII <= x"26"; --&              
                  when x"46" => ASCII <= x"28"; --(
                  when x"45" => ASCII <= x"29"; --)
                  when x"3E" => ASCII <= x"2A"; --*
                  when x"55" => ASCII <= x"2B"; --+
                  when x"4C" => ASCII <= x"3A"; --:
                  when x"41" => ASCII <= x"3C"; --<
                  when x"49" => ASCII <= x"3E"; -->
                  when x"4A" => ASCII <= x"3F"; --?
                  when x"1E" => ASCII <= x"40"; --@
                  when x"36" => ASCII <= x"5E"; --^
                  when x"4E" => ASCII <= x"5F"; --_
                  when x"54" => ASCII <= x"7B"; --{
                  when x"5D" => ASCII <= x"7C"; --|
                  when x"5B" => ASCII <= x"7D"; --}
                  when x"0E" => ASCII <= x"7E"; --~
                  when others => null;
                end case;
              else                                     --key's primary character is desired
                case PS2_CODE is  
                  when x"45" => ASCII <= x"30"; --0
                  when x"16" => ASCII <= x"31"; --1
                  when x"1E" => ASCII <= x"32"; --2
                  when x"26" => ASCII <= x"33"; --3
                  when x"25" => ASCII <= x"34"; --4
                  when x"2E" => ASCII <= x"35"; --5
                  when x"36" => ASCII <= x"36"; --6
                  when x"3D" => ASCII <= x"37"; --7
                  when x"3E" => ASCII <= x"38"; --8
                  when x"46" => ASCII <= x"39"; --9
                  when x"52" => ASCII <= x"27"; --'
                  when x"41" => ASCII <= x"2C"; --,
                  when x"4E" => ASCII <= x"2D"; ---
                  when x"49" => ASCII <= x"2E"; --.
                  when x"4A" => ASCII <= x"2F"; --/
                  when x"4C" => ASCII <= x"3B"; --;
                  when x"55" => ASCII <= x"3D"; --=
                  when x"54" => ASCII <= x"5B"; --[
                  when x"5D" => ASCII <= x"5C"; --\
                  when x"5B" => ASCII <= x"5D"; --]
                  when x"0E" => ASCII <= x"60"; --`
                  when others => null;
                end case;
              end if;
              
            end if;
          
          if(break = '0') then  --the code is a make
            state <= output;      --proceed to output state
          else                  --code is a break
            state <= ready;       --return to ready state to await next PS2 code
          end if;
        
        --output state: verify the code is valid and output the ASCII value
        when output =>
          if(ascii(7) = '0') then            --the PS2 code has an ASCII output
            ASCII_NEW <= '1';                  --set flag indicating new ASCII output
            ASCII_CODE <= ASCII(6 downto 0);   --output the ASCII value
          end if;
          state <= ready;                    --return to ready state to await next PS2 code

      end CASE;
    end if;
  end process;


end Behavioral;

