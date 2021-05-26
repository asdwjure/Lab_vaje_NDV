library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
library work;
use work.reg_file_functions.all;
use work.cpu_datapath_functions.all;
use work.cpu_functions.all;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY cpu_tb IS
		generic( nr_regs		: natural := 8;
					reg_width	: natural := 16;
					ram_nr_addr	: natural := 4;
					rom_nr_addr	: natural := 4
					);
END cpu_tb;

ARCHITECTURE testbench_arch OF cpu_tb IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT cpu
	 		generic( nr_regs		: natural := 8;
						reg_width	: natural := 16;
						ram_nr_addr	: natural := 4;
						rom_nr_addr	: natural := 4
						);
        	PORT (clk,										-- clock input
					nRST				: in	std_logic;	-- reset input	(active '0')
					IOBUS_WnR		: out std_logic;	-- io bus write input	(active '1')
					IOBUS_Data_in 	: in	std_logic_vector(reg_width - 1 downto 0);	-- io bus data input
					IOBUS_Address	: out	std_logic_vector(reg_width - 1 downto 0);	-- io address bus 
					IOBUS_Data_out	: out	std_logic_vector(reg_width - 1 downto 0);	-- io bus data output
					ProgMem_Addr	: out	std_logic_vector(reg_width - 1 downto 0);	-- program memory address
					IR 				: in	std_logic_vector(reg_width - 1 downto 0)	-- program memory data input 
			);
    END COMPONENT;

    SIGNAL clk : std_logic := '0';
	 SIGNAL nRST : std_logic := '0';
    SIGNAL IOBUS_WnR : std_logic := '0';
    SIGNAL IOBUS_Data_in : std_logic_vector (reg_width - 1 DownTo 0) := (others => '0');
    SIGNAL IOBUS_Address : std_logic_vector (reg_width - 1 DownTo 0) := (others => '0');
    SIGNAL IOBUS_Data_out : std_logic_vector (reg_width - 1 DownTo 0) := (others => '0');
    SIGNAL ProgMem_Addr : std_logic_vector (reg_width - 1 DownTo 0) := (others => '0');
    SIGNAL IR 	: std_logic_vector (reg_width - 1 DownTo 0) := (others => '0');

    constant PERIOD : time := 400 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 100 ns;

    BEGIN
        UUT : cpu
		  generic MAP ( nr_regs	=> nr_regs,
							reg_width	=> reg_width,
							ram_nr_addr	=> ram_nr_addr,
							rom_nr_addr	=> rom_nr_addr
							)
        PORT MAP (
            clk => clk,
            nRST => nRST,
            IOBUS_WnR => IOBUS_WnR,
            IOBUS_Data_in => IOBUS_Data_in,
            IOBUS_Address => IOBUS_Address,
            IOBUS_Data_out => IOBUS_Data_out,
            ProgMem_Addr => ProgMem_Addr,
            IR => IR
        );

			PROGMEM :  rom 
			generic map (	n_addr => rom_nr_addr, bus_width => reg_width)
			Port map (	nRST => nRST,
							clk => clk, 
							addr	=>	ProgMem_Addr(rom_nr_addr - 1 downto 0), --use only rom_nr_addr bits of PC
							data => IR
						);

			DATAMEM : sram
			generic map ( n_addr	=> ram_nr_addr, bus_width => reg_width)			
			Port map (	clk 	=> clk,		-- clock input, 				
							nRST => nRST,
							W_nR		=> IOBUS_WnR,	--write/read control (write = '1')
							addr	=> IOBUS_Address(ram_nr_addr - 1 downto 0),	-- register number destination select input
							data_in	=> IOBUS_Data_out,	--data input bus input
							data_out => IOBUS_Data_in 	-- A, B bus output				
					);
			
        PROCESS    -- clock process for clk
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
            BEGIN
					WAIT FOR PERIOD;
					nRST <= '1';
               WAIT FOR PERIOD;

            END PROCESS;

    END testbench_arch;

