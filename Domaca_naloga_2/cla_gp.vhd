LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY cla_gp IS PORT (
      Cin, x, y     : IN  STD_LOGIC;
      S, Cout, g, p : OUT STD_LOGIC
   );
END cla_gp ;

ARCHITECTURE NDV OF cla_gp IS
   SIGNAL g_sig, p_sig : STD_LOGIC;
BEGIN
   g_sig <= x and y; -- funkcija tvorjenja (generate)
   p_sig <= x xor y; -- funkcija sirjenja (propagate)
   g     <= g_sig;
   p     <= p_sig;
   S     <= x xor y xor cin;            -- vsota
   Cout  <= g_sig or ( p_sig and Cin ); -- izhodni prenos stopnje
END NDV;