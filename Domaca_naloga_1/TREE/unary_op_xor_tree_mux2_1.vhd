library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XorTreeStage is
	generic (N : natural);
	port(	I: in std_logic_vector(N - 1 downto 0);	-- vhodni vektor redukcije ima N vhodov
			O: out std_logic);	-- izhodni bit redukcije
end XorTreeStage;

architecture tree_of_xor2 of XorTreeStage is

component XorTreeStage
	generic (N : natural);
	port(	I: in std_logic_vector(N - 1 downto 0);	-- vhodni vektor redukcije ima N vhodov
			O: out std_logic);	-- izhodni bit redukcije
end component;

begin
--TE DATOTEKE NI POTREBNO SPREMINJATI
Stage_xor_1:
	if I'length = 1 generate		
		O <= I(0);	--xor enega bita je kar ta bit (x xor 0) = x
	end generate;
	
Stage_xor_2:
	if I'length = 2 generate
		begin
		O <= I(I'right) xor I(I'left);	-- xor dvobitnega vektorja std_logic_vector: desni bit xor levi bit
	end generate Stage_xor_2;

Stages: if I'length > 2 generate
	signal Lo_Xor, Hi_Xor: std_logic;
	signal Lo_Half : std_logic_vector(I'length/2 - 1 downto 0);
	signal Hi_Half : std_logic_vector(I'length - 1 downto I'length/2);	
	begin
		-- razdelimo vhodni vektor na polovici (l - spodnja, u - zgornja)
		Lo_Half <= I(I'length/2 - 1 downto 0);		
		-- pri lihih vrednostih dolžine dodatni element pripišemo zg. polovici
		Hi_Half <= I(I'length - 1 downto I'length/2);
		
		-- povežemo polovici
		Lo_Tree: XorTreeStage generic map (Lo_Half'length) port map (Lo_Half, Lo_Xor);
		Hi_Tree: XorTreeStage generic map (Hi_Half'length) port map (Hi_Half, Hi_Xor);
				
		O <= Lo_Xor xor Hi_Xor;	-- polovici združimo z 2-vhodnimi xor vrati 

	end generate Stages;
		
end tree_of_xor2;