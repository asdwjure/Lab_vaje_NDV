LIBRARY ieee;
USE ieee.std_logic_1164.all;
Library UNISIM; use UNISIM.vcomponents.all;

ENTITY muxdff IS
   generic( n_addr : natural := 4 ); -- stevilo naslovov ULM strukture
   PORT (
      S : in std_logic_vector(n_addr - 1 downto 0);
      D : in std_logic_vector(2**n_addr - 1 downto 0); -- vektor vhodov ULM strukture
      clk,                                             -- signal ure (prožen na sprednjo fronto)
      nCLEAR : IN  std_logic;                          -- signal za asinhrono brisanje (nCLEAR = '0' se postavi Q=>'0')
      Q      : out std_logic                           -- izhod ULM strukture
   );
END muxdff;

ARCHITECTURE NDV OF muxdff IS
   
   signal muxout : std_logic;

BEGIN

   muxnto1 : entity work.muxnto1
      generic map (
         n_addr => n_addr
      )
      port map (
         s => s,
         w => d,
         f => muxout
      );

   u_fdc : entity work.dff(dff_fdc)
      port map (
         Q   => Q,      -- Data output
         clk   => clk,    -- Clock input
         nClear => nCLEAR, -- Asynchronous clear input
			nPRESET => '1',
         D   => muxout  -- Data input
      );


END NDV;

