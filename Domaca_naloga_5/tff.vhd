LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tff IS
   PORT (
      T,                       -- vhod flip-flopa
      clk,                     -- signal ure
      nPRESET,                 -- asinhrono postavljanje izhoda (aktiven '0')
      nCLEAR : IN  STD_LOGIC;  -- asinhrono brisanje izhoda (aktiven '0')
      Q      : OUT STD_LOGIC); -- izhod flip-flopa
END tff;

ARCHITECTURE ndv OF tff IS

   signal D_sig : std_logic := '0';
   signal Q_sig : std_logic := '0';

BEGIN

   D_sig <= T xor Q_sig;

   u_dff : entity work.dff
      port map (
         D       => D_sig,
         clk     => clk,
         nPRESET => nPRESET,
         nCLEAR  => nCLEAR,
         Q       => Q_sig
      );

   Q <= Q_sig;


END ndv;
