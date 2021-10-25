library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XorTreeStage is
	generic (
		N : natural
	);
	port(
		I : in  std_logic_vector(N - 1 downto 0); -- vhodni vektor redukcije ima N vhodov
		O : out std_logic
	); -- izhodni bit redukcije
end XorTreeStage;

library unisim;
use unisim.vcomponents.all;

architecture tree_of_xor_lut6 of XorTreeStage is

	component XorTreeStage
		generic (
			N : natural
		);
		port(
			I : in  std_logic_vector(N - 1 downto 0); -- vhodni vektor redukcije ima N vhodov
			O : out std_logic
		); -- izhodni bit redukcije
	end component;

begin

	-- Dodat kaksen if generate pa da sam sebe refrencira
	-- Z vpoglednimi tabelami realiziramo XOR vrata 3, 4, 5 in 6 operandov.

	stage_xor_1 : if I'length = 1 generate
	begin
		O <= I(0);
	end generate stage_xor_1;

	stage_xor_2 : if I'length = 2 generate
	begin
		O <= I(I'right) xor I(I'left);
	end generate stage_xor_2;

	stage_xor_3 : if I'length = 3 generate
	begin
		u_xor3_lut : LUT3
			generic map(
				INIT => X"69"
			)
			port map(
				O  => O,
				I0 => I(0),
				I1 => I(1),
				I2 => I(2)
			);
	end generate stage_xor_3;

	stage_xor_4 : if I'length = 4 generate
	begin
		u_xor4_lut : LUT4
			generic map(
				INIT => X"6996"
			)
			port map(
				O  => O,
				I0 => I(0),
				I1 => I(1),
				I2 => I(2),
				I3 => I(3)
			);
	end generate stage_xor_4;

	stage_xor_5 : if I'length = 5 generate
	begin
		u_xor5_lut : LUT5
			generic map(
				INIT => X"6996_9669"
			)
			port map(
				O  => O,
				I0 => I(0),
				I1 => I(1),
				I2 => I(2),
				I3 => I(3),
				I4 => I(4)
			);
	end generate stage_xor_5;

	stage_xor_6 : if I'length = 6 generate
	begin
		u_xor6_lut : LUT6
			generic map(
				INIT => X"6996_9669_9669_6996"
			)
			port map(
				O  => O,
				I0 => I(0),
				I1 => I(1),
				I2 => I(2),
				I3 => I(3),
				I4 => I(4),
				I5 => I(5)
			);
	end generate stage_xor_6;

	stage_xor_n : if I'length > 6 generate
		signal sixth0, sixth1, sixth2, sixth3, sixth4, sixth5                         : std_logic_vector(I'length/6 - 1 downto 0);
		signal sixth0_xor, sixth1_xor, sixth2_xor, sixth3_xor, sixth4_xor, sixth5_xor : std_logic;
	begin

		-- Divide input signal in sixths and connect so corresponding signal
		sixth0 <= I(I'length/6 - 1 + 0*sixth0'length downto 0);
		sixth1 <= I(I'length/6 - 1 + 1*sixth0'length downto 1*sixth0'length);
		sixth2 <= I(I'length/6 - 1 + 2*sixth0'length downto 2*sixth0'length);
		sixth3 <= I(I'length/6 - 1 + 3*sixth0'length downto 3*sixth0'length);
		sixth4 <= I(I'length/6 - 1 + 4*sixth0'length downto 4*sixth0'length);
		sixth5 <= I(I'length/6 - 1 + 5*sixth0'length downto 5*sixth0'length);

			sixth0_tree : XorTreeStage generic map (sixth0'length) port map (sixth0, sixth0_xor);
			sixth1_tree : XorTreeStage generic map (sixth1'length) port map (sixth1, sixth1_xor);
			sixth2_tree : XorTreeStage generic map (sixth2'length) port map (sixth2, sixth2_xor);
			sixth3_tree : XorTreeStage generic map (sixth3'length) port map (sixth3, sixth3_xor);
			sixth4_tree : XorTreeStage generic map (sixth4'length) port map (sixth4, sixth4_xor);
			sixth5_tree : XorTreeStage generic map (sixth5'length) port map (sixth5, sixth5_xor);

		-- Evaluate sixths in LUT6 xor table and output the result
		u_xor6_stages_lut : LUT6
			generic map(
				INIT => X"6996_9669_9669_6996"
			)
			port map(
				O  => O,
				I0 => sixth0_xor,
				I1 => sixth1_xor,
				I2 => sixth2_xor,
				I3 => sixth3_xor,
				I4 => sixth4_xor,
				I5 => sixth5_xor
			);

	end generate stage_xor_n;

end tree_of_xor_lut6;