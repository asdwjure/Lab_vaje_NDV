LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE Wallace_tree_functions IS

   -- @Type name: sizeof
   -- @Parameters:
   -- argument 1: x dimenzija polja
   -- argument 2: y dimenzija polja 
   -- @Description:
   -- definicija tipa splošnega dvodimenzionalnega polja (x, y) bitov tipa STD_LOGIC
   Type ArrayOfAddends is array (natural range <>, natural range <>) of STD_LOGIC;

   -- @Function name: sizeof
   -- @Parameters:
   -- a: vhodno število
   -- @Return:
   -- Vrne število bitov, potrebnih za zapis števila a
   FUNCTION sizeof (a : NATURAL) RETURN NATURAL; --

   -- @Function name: prev_lvl_carry_rect
   -- @Parameters:
   -- height: višina Wallaceove drevesne strukture na danem nivoju redukcije
   -- arg_width: velikost operanda Wallaceove drevesne strukture na danem nivoju redukcije
   -- this_weight: Utež (stolpec) Wallaceove drevesne strukture na danem nivoju redukcije
   -- this_lvl: nivo redukcije Wallaceove drevesne strukture
   -- @Return:
   -- Število bitov prenosa za dani stolpec podanega nivoja redukcije Wallaceove drevesne strukture (this_lvl)
   FUNCTION prev_lvl_carry_rect (height : NATURAL; arg_width : NATURAL; this_weight : NATURAL; this_lvl : NATURAL) RETURN NATURAL;

   -- @Function name: this_lvl_bits_rect
   -- @Parameters:
   -- height: višina Wallaceove drevesne strukture na danem nivoju redukcije
   -- arg_width: velikost operanda Wallaceove drevesne strukture na danem nivoju redukcije
   -- this_weight: Utež (stolpec) Wallaceove drevesne strukture na danem nivoju redukcije
   -- this_lvl: nivo redukcije Wallaceove drevesne strukture
   -- @Return:
   -- Število bitov v danem stolpcu podanega nivoja redukcije Wallaceove drevesne strukture (this_lvl)
   FUNCTION this_lvl_bits_rect (height : NATURAL; arg_width : NATURAL; this_weight : NATURAL; this_lvl : NATURAL) RETURN NATURAL;

   -- @Function name: num_full_adders_rect
   -- @Parameters:
   -- height: višina Wallaceove drevesne strukture na danem nivoju redukcije
   -- arg_width: velikost operanda Wallaceove drevesne strukture na danem nivoju redukcije
   -- this_weight: Utež (stolpec) Wallaceove drevesne strukture na danem nivoju redukcije
   -- this_lvl: nivo redukcije Wallaceove drevesne strukture
   -- @Return:
   -- Število polnih seštevalnikov v danem stolpcu podanega nivoja redukcije Wallaceove drevesne strukture (this_lvl)
   FUNCTION num_full_adders_rect (height : NATURAL; arg_width : NATURAL; this_weight : NATURAL; this_lvl : NATURAL) RETURN NATURAL;

   -- @Function name: num_half_adders_rect
   -- @Parameters:
   -- height: višina Wallaceove drevesne strukture na danem nivoju redukcije
   -- arg_width: velikost operanda Wallaceove drevesne strukture na danem nivoju redukcije
   -- this_weight: Utež (stolpec) Wallaceove drevesne strukture na danem nivoju redukcije
   -- this_lvl: nivo redukcije Wallaceove drevesne strukture
   -- @Return:
   -- Število polnih seštevalnikov v danem stolpcu podanega nivoja redukcije Wallaceove drevesne strukture (this_lvl)
   FUNCTION num_half_adders_rect (height : NATURAL; arg_width : NATURAL; this_weight : NATURAL; this_lvl : NATURAL) RETURN NATURAL;

END Wallace_tree_functions;

PACKAGE BODY Wallace_tree_functions IS

   --------------------------------------------------------------------------------

   function sizeof (a : natural) return natural is
      variable nr  : natural := a;
      variable idx : natural := 0;
   begin
      while nr > 0 loop
         nr  := nr/2;
         idx := idx + 1;
      end loop;

      return idx;
   end function sizeof;

   --------------------------------------------------------------------------------

   function this_lvl_bits_rect (height : natural; arg_width : NATURAL; this_weight : natural; this_lvl : natural) RETURN natural is

      variable prev_lvl_bits       : NATURAL := 0; -- stevilo bitov prejsnje stopnje redukcije na dani utezi
      variable full_adder_sum_bits : NATURAL := 0; -- stevilo FA na prejsnji stopnji na dani utezi
      variable half_adder_sum_bits : NATURAL := 0; -- stevilo HA na prejsnji stopnji na dani utezi
      variable this_num_bits       : NATURAL := 0; -- stevilo bitov na tej stopnji redukcije na dani utezi

   begin

      if this_lvl = 0 then

         if this_weight < arg_width then
            this_num_bits := height;
         else
            this_num_bits := 0;
         end if;

      else
         prev_lvl_bits       := this_lvl_bits_rect(height, arg_width, this_weight, this_lvl-1);
         full_adder_sum_bits := prev_lvl_bits/3;
         half_adder_sum_bits := (prev_lvl_bits - 3*full_adder_sum_bits)/2;

         this_num_bits := prev_lvl_bits - (3*full_adder_sum_bits) - (2*half_adder_sum_bits) + full_adder_sum_bits + half_adder_sum_bits + prev_lvl_carry_rect(height, arg_width, this_weight, this_lvl);

      end if;

      return this_num_bits;

   end function this_lvl_bits_rect;

   --------------------------------------------------------------------------------

   function prev_lvl_carry_rect (height : NATURAL; arg_width : NATURAL; this_weight : NATURAL; this_lvl : NATURAL) RETURN NATURAL IS

      variable prev_lvl_bits : NATURAL := 0;
      variable num_carry_FA  : NATURAL := 0;
      variable num_carry_HA  : NATURAL := 0;
      variable num_carry     : NATURAL := 0;

   begin

      if this_weight = 0 then
         num_carry := 0;
      else

         if this_lvl = 0 then
            prev_lvl_bits := height;
         else
            prev_lvl_bits := this_lvl_bits_rect(height, arg_width, this_weight-1, this_lvl-1);
         end if;

         num_carry_FA := prev_lvl_bits/3;                      -- num of FA on previous reduction
         num_carry_HA := (prev_lvl_bits - 3*num_carry_FA) / 2; -- num of HA on previous reduction

         num_carry := num_carry_FA + num_carry_HA;
      end if;

      return num_carry;

   end function prev_lvl_carry_rect;

   --------------------------------------------------------------------------------

   function num_full_adders_rect (height : NATURAL; arg_width : NATURAL; this_weight : NATURAL; this_lvl : NATURAL) RETURN NATURAL IS
      variable num_fa : natural := 0;
   begin

      num_fa := this_lvl_bits_rect(height, arg_width, this_weight, this_lvl) / 3;
      return num_fa;

   end function num_full_adders_rect;

   --------------------------------------------------------------------------------

   function num_half_adders_rect (height : NATURAL; arg_width : NATURAL; this_weight : NATURAL; this_lvl : NATURAL) RETURN NATURAL IS

      variable this_num_bits : natural := 0;
      variable num_full_adds : natural := 0;
      variable num_ha        : natural := 0;

   begin

      this_num_bits := this_lvl_bits_rect(height, arg_width, this_weight, this_lvl);
      num_full_adds := num_full_adders_rect(height, arg_width, this_weight, this_lvl);

      num_ha := (this_num_bits - 3*num_full_adds) / 2;

      return num_ha;

   end function num_half_adders_rect;

   --------------------------------------------------------------------------------

END Wallace_tree_functions;
