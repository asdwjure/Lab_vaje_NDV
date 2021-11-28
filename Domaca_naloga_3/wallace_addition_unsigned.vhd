LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.Wallace_tree_functions.all;

ENTITY wallace_addition IS
   GENERIC (
      width  : INTEGER := 4; --širina operanda
      nrargs : INTEGER := 4  --število operandov
   );
   PORT (
      x   : IN  ArrayOfAddends(width - 1 DOWNTO 0, nrargs - 1 DOWNTO 0);         -- polje bitov operandov
      sum : OUT STD_LOGIC_VECTOR(sizeof( nrargs * ( 2**width - 1)) - 1 DOWNTO 0) -- vsota
   );
END wallace_addition;

ARCHITECTURE Wallace_unsigned_addition OF wallace_addition IS

   -----------------------------------------------------------------------------
   -- Constants and types
   -----------------------------------------------------------------------------
   -- Koliko redukcij rabimo za posamezno visino drevesa
   type nr_stages_type is array (32 downto 3) of natural;
   constant nr_stages : nr_stages_type := (32 downto 29 => 8, 28 downto 20 => 7, 19 downto 14 => 6, 13 downto 10 => 5, 9|8|7 => 4, 6|5 => 3, 4 => 2, others => 1);

   -- Koliko redukcij potrebujemo za nas konkreten sestevelnik
   constant stages : integer := nr_stages( nrargs );

   -- Dolzina sestetega rezultata
   constant max_sum_size : integer := sizeof( nrargs * (2**width - 1));

   -- 2D polje bitov za posamezno stopnjo redukcije velikosti max_sum_size * nrargs
   type cell_type is array (max_sum_size - 1 downto 0, nrargs - 1 downto 0) of STD_LOGIC;

   -- 3D polje STD_LOGIC - redukcije, vrstica, stolpec
   type W_type is array (stages + 1 downto 0) of cell_type;

   -----------------------------------------------------------------------------
   -- Signals
   -----------------------------------------------------------------------------
   -- Wallace tree bit field
   signal W : W_type := (others => (others => (others => '0')));

   -- Finall addition signals
   signal add_a   : std_logic_vector(max_sum_size-1 downto 0) := (others => '0');
   signal add_b   : std_logic_vector(max_sum_size-1 downto 0) := (others => '0');
   signal add_sum : std_logic_vector(max_sum_size-1 downto 0);


BEGIN

   -----------------------------------------------------------------------------

   p_Wallace : process(x, W)

      variable this_carry_bits : NATURAL := 0; -- st. prenosov stolpca trenutne stopnje redukcije drevesa
      variable this_stage_bits : NATURAL := 0; -- st. bitov stolpca trenutne stopnje redukcije drevesa
      variable num_full_adds   : NATURAL := 0; -- st. FA stolpca trenutne stopnje redukcije drevesa
      variable num_half_adds   : NATURAL := 0; -- st. HA stolpca trenutne stopnje redukije drevesa
      variable num_wires       : NATURAL := 0; -- st. prostih bitov stolpca trenutne stopnje redukcije drevesa

   begin

      -- povezovanje vhodnih operandov na redukciji 0
      for i in 0 to (width - 1) loop     -- utezi
         for j in 0 to (nrargs - 1) loop -- operandi
            W(0)(i,j) <= x(i,j);
         end loop;
      end loop;

      -- Povezovanje FA in HA in zic
      for k in 0 to stages loop                                                         -- trenutna stopnja redukcije
         for i in 0 to (max_sum_size - 1) loop                                          -- trenutna utez (od 0 do max_sum_size-1)
            this_carry_bits := prev_lvl_carry_rect(nrargs, width, i, k+1);              -- st. prenosov na naslednjo stopnjo
            num_full_adds   := num_full_adders_rect(nrargs, width, i, k);               -- st. FA na tej stopnji
            num_half_adds   := num_half_adders_rect(nrargs, width, i, k);               -- st. HA na tej stopnji
            this_stage_bits := this_lvl_bits_rect(nrargs, width, i, k);                 -- st. bitov na tej stopnji redukcije
            num_wires       := this_stage_bits - (3*num_full_adds) - (2*num_half_adds); -- st. povezav na naslednjo stopnjo

            -- Connect proper bits to FA
            for j in 0 to (num_full_adds - 1) loop
               W(k+1)(i, this_carry_bits+j) <= W(k)(i, 3*j) xor W(k)(i, 3*j+1) xor W(k)(i, 3*j+2);                                                            -- vsota (xor operandov)
               W(k+1)(i+1, j)               <= (W(k)(i, 3*j) and W(k)(i, 3*j+1)) or (W(k)(i, 3*j) and W(k)(i, 3*j+2)) or (W(k)(i, 3*j+1) and W(k)(i, 3*j+2)); -- carry (ko sta vsaj dva izmed bitov 1)
            end loop;

            -- Connect proper bits to HA
            for j in 0 to (num_half_adds - 1) loop
               -- report "k, i, j: " & integer'image(k) & " " & integer'image(i) & " " & integer'image(j);
               -- report "this_carry_bits, num_full_adds, num_half_adds: " & integer'image(this_carry_bits) & " " & integer'image(num_full_adds) & " " & integer'image(num_half_adds);
               W(k+1)(i, this_carry_bits+num_full_adds+j) <= W(k)(i, (3*num_full_adds) + 2*j) xor W(k)(i, (3*num_full_adds) + 2*j + 1); -- vsota
               W(k+1)(i+1, num_full_adds+j)               <= W(k)(i, (3*num_full_adds) + 2*j) and W(k)(i, (3*num_full_adds) + 2*j + 1); -- carry
            end loop;

            -- Connect wires to next stage
            for j in 0 to (num_wires - 1) loop -- absolutna lega prostega bita v stolpcu na tej stopnji
               W(k+1)(i, this_carry_bits+num_full_adds+num_half_adds+j) <= W(k)(i, (3*num_full_adds) + (2*num_half_adds) + j);
            end loop;

            -- Debug info
            report "Bit#/Total " & integer'image(i) & "/"
            & integer'image(this_stage_bits) & HT &
            "FA" & integer'image(num_full_adds) & HT &
            "HA" & integer'image(num_half_adds) & HT &
            "C" & integer'image(this_carry_bits) & HT &
            "W" & integer'image(num_wires);
         end loop;
      end loop;

   end process p_Wallace;

   -----------------------------------------------------------------------------

   p_FinalStage : process(W)
   begin

      for i in 0 to (max_sum_size - 1) loop -- utezi
         add_a(i) <= W(stages)(i, 0);       -- operand a
         add_b(i) <= W(stages)(i, 1);       -- operand b
      end loop;

   end process p_FinalStage;

   u_cla_add_n_bit : entity work.cla_add_n_bit
      generic map (
         n => max_sum_size
      )
      port map (
         Cin  => '0',
         X    => add_a,
         Y    => add_b,
         S    => add_sum,
         Gout => open,
         Pout => open,
         Cout => open
      );

   sum <= add_sum; -- Izhod

END Wallace_unsigned_addition;
