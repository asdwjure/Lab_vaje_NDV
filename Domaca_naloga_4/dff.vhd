LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dff IS
   PORT (
      D       : IN  STD_LOGIC; -- vhod D flip-flopa
      clk     : IN  STD_LOGIC; -- signal ure (prožen na sprednjo fronto)
      nPRESET : IN  STD_LOGIC; -- signal za postavljanje (nPRESET = '0' se postavi Q=>'1'). Ta signal komentirajte v entiteti, èe ga arhitektura ne zahteva.
      nCLEAR  : IN  STD_LOGIC; -- signal za brisanje (nCLEAR = '0' se postavi Q=>'0')
      Q       : OUT STD_LOGIC
   ); -- izhod D flip-flopa
END dff;

-- VHDL klice primitivov FDC, FDP, FDS, FDR si oglejte na:
-- https://www.xilinx.com/support/documentation/sw_manuals/xilinx14_7/7series_hdl.pdf
-- Opise primitivov FDC, FDP, FDS, FDR si oglejte na:
-- https://www.xilinx.com/support/documentation/sw_manuals/xilinx14_7/7series_scm.pdf

ARCHITECTURE dff_asyn_preset_clr OF dff IS
BEGIN
   --WARNING:Xst:3001 - This design contains one or more registers or latches with an active asynchronous set and asynchronous reset. 
   -- While this circuit can be built, it creates a sub-optimal implementation in terms of area, power and performance. 
   -- For a more optimal implementation Xilinx highly recommends one of the following:
   --1) Remove either the set or reset from all registers and latches if not needed for required functionality
   --2) Modify the code in order to produce a synchronous set and/or reset (both is preferred)
   --3) Use the -async_to_sync option to transform the asynchronous set/reset to synchronous operation 

   PROCESS ( clk, nPRESET, nCLEAR )
   BEGIN
      IF (nPRESET = '0') THEN
         Q <= '1'; --asinhrono postavljanje izhoda (preset)
      ELSIF (nCLEAR = '0') THEN
         Q <= '0'; --asinhrono brisanje izhoda (clear)
      ELSIF rising_edge(clk) THEN
         Q <= D;
      END IF;
   END PROCESS;
END dff_asyn_preset_clr;

ARCHITECTURE dff_fdp OF dff IS
BEGIN

   PROCESS ( clk, nPRESET )
   BEGIN
      IF (nPRESET = '0') THEN
         Q <= '1'; --asinhrono postavljanje izhoda (preset) - rezultat je primitiv FDP 
      ELSIF rising_edge(clk) THEN
         Q <= D;
      END IF;
   END PROCESS;
END dff_fdp;

ARCHITECTURE dff_fds OF dff IS
BEGIN
   PROCESS ( clk, nPRESET )
   BEGIN
      IF rising_edge(clk) THEN
         IF (nPRESET = '0') THEN
            Q <= '1'; --sinhrono postavljanje izhoda (set) - rezultat je primitiv FDS
         ELSE
            Q <= D;
         END IF;
      END IF;
   END PROCESS;
END dff_fds;

ARCHITECTURE dff_fdr OF dff IS
BEGIN

   PROCESS ( clk, nCLEAR )
   BEGIN
      IF rising_edge(clk) THEN
         IF (nCLEAR = '0') THEN
            Q <= '0'; --sinhrono brisanje izhoda (reset) - rezultat je primitiv FDR
         ELSE
            Q <= D;
         END IF;
      END IF;
   END PROCESS;
END dff_fdr;

ARCHITECTURE dff_syn_set_rst OF dff IS
BEGIN
   -- rezultat sinteze je FDR, vhod in reset prikljuèka sta izvedena and vrati z LUT2
   PROCESS ( clk, nPRESET, nCLEAR )
   BEGIN
      IF rising_edge(clk) THEN
         IF (nPRESET = '0') THEN
            Q <= '1'; --sinhrono postavljanje izhoda (preset)
         ELSIF (nCLEAR = '0') THEN
            Q <= '0'; --sinhrono brisanje izhoda (clear)
         ELSE
            Q <= D;
         END IF;
      END IF;
   END PROCESS;
END dff_syn_set_rst;

ARCHITECTURE dff_fdc OF dff IS
BEGIN
   PROCESS ( clk, nCLEAR )
   BEGIN
      IF (nCLEAR = '0') THEN
         Q <= '0'; --asinhrono brisanje izhoda (clear) - rezultat je primitiv FDC
      ELSIF rising_edge(clk) THEN
         Q <= D after 1 ns; -- simulate time delay
      END IF;
   END PROCESS;
END dff_fdc;