
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity PS2_KEYBOARD is
  port(
    clk          : in  STD_LOGIC;                     --sistemska ura
    PS2_CLK      : in  STD_LOGIC;                     --ura iz PS/2 tipkovnice
    PS2_DATA     : in  STD_LOGIC;                     --podatek iz PS/2 tipkovnice
    PS2_code_new : out STD_LOGIC;                     --zastavica da je nov podatek pripravljen na ps2_code vodilu
    PS2_code     : out STD_LOGIC_VECTOR(7 downto 0)); --podatkovno vodilo PS/2 
end PS2_KEYBOARD;

architecture arch of PS2_KEYBOARD is
begin


end arch;
