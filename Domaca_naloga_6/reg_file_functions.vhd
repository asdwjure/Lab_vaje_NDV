LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE reg_file_functions IS
	Type muxnto1_bus_type is array (natural range <>, natural range <>) of STD_LOGIC;
	Type t_int_array_of_regs is array (natural range <>) of integer;
	FUNCTION sizeof (a: NATURAL) RETURN NATURAL;
		
	COMPONENT dmuxnto1 IS
	generic( n_addr: natural := 2 );
	PORT (	s : in 	std_logic_vector(n_addr - 1 downto 0);
				w : in 	STD_LOGIC;
				f : out	std_logic_vector(2**n_addr - 1 downto 0)
		);
	END COMPONENT;

	-- S0 S1
	-- 1  1	: Vzporedno nalaganje x => Q
	-- 1  0	: Pomikanje levo 	(v smeri od LSB do MSB)
	-- 0  1	: Pomikanje desno (v smeri od MSB do LSB)
	-- 0  0	: Držanje vsebine
	COMPONENT shift_reg is
		generic( reg_size: natural := 4);
		PORT (clk, nCLR, sr_in, sl_in : IN std_logic;				
				s : in std_logic_vector(1 downto 0);
				x : in std_logic_vector(reg_size - 1 downto 0);
				Q : out std_logic_vector(reg_size - 1 downto 0)
			);
	end COMPONENT;

	COMPONENT muxnto1 IS
		generic( n_addr: natural := 2 );
		PORT (s	: in 	std_logic_vector(n_addr - 1 downto 0);
				w	: in 	std_logic_vector(2**n_addr - 1 downto 0);				
				f	: OUT	STD_LOGIC
				);
	END COMPONENT;

	COMPONENT muxnto1_bus IS
		generic( n_addr		: INTEGER := 2;
					bus_width	: INTEGER := 8 );
		PORT (	s :	IN 	std_logic_vector( n_addr - 1 downto 0);
					w :	IN		muxnto1_bus_type( 2**n_addr - 1 DOWNTO 0, bus_width - 1 DOWNTO 0);
					f :	OUT	std_logic_vector( bus_width - 1 downto 0)
				);
	END COMPONENT;

	component reg_file is
			generic( nr_regs		: natural := 4;
						reg_width	: natural := 8);
			PORT (clk,	-- clock input
					LE				: in std_logic;	-- load enable input	(active '1')
					nRST			: in std_logic;	-- reset input	(active '0')
					dest_select,					-- register number destination select input
					A_select, 						-- A, B bus destination select input
					B_select 	: in	std_logic_vector( sizeof(nr_regs - 1) - 1 downto 0);
					D 				: in	std_logic_vector(reg_width - 1 downto 0);	--data input bus input
					A, B 			: out	std_logic_vector(reg_width - 1 downto 0)	-- A, B bus output
				);
	end component;

END reg_file_functions;

PACKAGE BODY reg_file_functions IS

--	@Function name: sizeof
	-- @Parameters:
	--	a: input number
	--	@Return:
	--	Number of bits required to encode a binary input number a	
	FUNCTION sizeof (a: NATURAL) RETURN NATURAL IS
		VARIABLE aggregate	: NATURAL := a;
		VARIABLE return_val	: NATURAL := 0;
	BEGIN
		compute_sizeof:
		FOR i IN a DOWNTO 0 LOOP
			IF aggregate > 0 THEN
				return_val := return_val + 1;	--increment number of encoding bits
			END IF;			
			aggregate := aggregate / 2;	-- divide by base	of 2
		END LOOP;			
		RETURN return_val;
	END sizeof;

END reg_file_functions;
