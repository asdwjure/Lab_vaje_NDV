LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.reg_file_functions.all;

PACKAGE branch_ctrl_functions IS
		
	COMPONENT cla_add_n_bit IS
		generic(n: natural := 8);
		PORT (	Cin	:	in 	std_logic ;
					X, Y	:	in 	std_logic_vector(n-1 downto 0);
					S		:	out	std_logic_vector(n-1 downto 0);
					Gout, 
					Pout, 
					Cout	:	out	std_logic);
	END COMPONENT;

	COMPONENT cla_gp IS
		PORT (	Cin, x, y : IN STD_LOGIC;
					S, Cout, g, p : OUT STD_LOGIC );
	END COMPONENT;
	
	COMPONENT counter is
		generic( ctr_size: natural := 4);
		PORT (	clk, 						-- signal ure
				nCLR, 						-- signal za brisanje števca (aktiven '0')
				nLOAD, 						-- signal za nalaganje števca (aktiven '0')
				ENP, ENT : IN std_logic;	-- signala za omogoèanje štetja (aktiven '1')
				RCO : out std_logic;		-- izhodni prenos na naslednjo stopnjo (rco)
				x : in std_logic_vector(ctr_size - 1 downto 0);	-- vhod za vzporedno nalaganje
				Q : out std_logic_vector(ctr_size - 1 downto 0)	-- izhodno štetje 
			);
	end COMPONENT;
	
END branch_ctrl_functions;

PACKAGE BODY branch_ctrl_functions IS

END branch_ctrl_functions;
