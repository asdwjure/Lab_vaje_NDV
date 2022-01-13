LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.cordic_pkg.all;

ENTITY cordic IS
   GENERIC(
      WIDTH : integer := 32
   );
   PORT(
      clk, nRST, start : IN  std_logic;
      angle            : IN  std_logic_vector ( WIDTH - 1 DOWNTO 0); -- angle(radians)!!!
      sin , cos        : OUT std_logic_vector ( WIDTH - 1 DOWNTO 0);
      done             : OUT std_logic
   );
END cordic;

ARCHITECTURE rtl OF cordic IS

   SIGNAL count : std_logic_vector(sizeof(WIDTH - 1) - 1 DOWNTO 0); -- if width=32, count goes from 0 to 31
   SIGNAL x_load, y_load, z_load,
   x_reg, y_reg, z_reg,
   x_result, y_result, z_result,
   cordic_coefficient,
   shifted_y_reg, shifted_x_reg : std_logic_vector(WIDTH-1 DOWNTO 0) := (others => '0');
   SIGNAL init, load, add_nsub, nadd_sub, rco, regs_load : std_logic;

   constant x0 : std_logic_vector(WIDTH - 1 downto 0) := Conv2fixedPt ( inverseK, WIDTH); -- 1/1.64676025812107
   constant y0 : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');

BEGIN

   -- BUS_MUX
   x_load <= x0    when INIT = '1' else x_result;
   y_load <= y0    when INIT = '1' else y_result;
   z_load <= angle when INIT = '1' else z_result;

      -- Registers
      COS_X_REG : data_reg generic map(WIDTH => WIDTH)
      port map( clk => clk, load => REGS_LOAD, X => x_load, Q => x_reg);
      SIN_Y_REG : data_reg generic map( WIDTH => WIDTH)
      port map( clk => clk, load => REGS_LOAD, X => y_load, Q => y_reg);
      ANGLE_Z_REG : data_reg generic map( WIDTH => WIDTH)
      port map( clk => clk, load => REGS_LOAD, X => z_load, Q => z_reg);

      -- barrel shifter
      BARREL_SHIFT_Y : barrel_shifter_sra generic map( width => width, size => width)
      port map( input => y_reg, output => shifted_y_reg, n => COUNT );
      BARREL_SHIFT_X : barrel_shifter_sra generic map( width => width, size => width)
      port map( input => x_reg, output => shifted_x_reg, n => COUNT );

      --ROM
      CORDICROM : CORDIC_ROM generic map( WIDTH => width, SIZE => width)
      port map ( addr => count, dout => cordic_coefficient);

      --addsub
      A_addsub_Bx : addsub generic map( WIDTH => width)
      port map( A => x_reg, B => shifted_y_reg, S => x_result, add_nsub => add_nsub);
      A_addsub_By : addsub generic map( WIDTH => width)
      port map( A => y_reg, B => shifted_x_reg, S => y_result, add_nsub => nadd_sub);
      A_addsub_Bz : addsub generic map( WIDTH => width)
      port map( A => z_reg, B => cordic_coefficient, S => z_result, add_nsub => add_nsub);

      --UP_COUNTER
      upcntr : up_counter generic map(MODULO => width)
      port map(clk => clk, nRST => nRST, count_enable => LOAD, count => COUNT, rco => RCO);

      --FSM
      FSM : CORDIC_FSM port map(clk => clk, nRST => nRST, start => start, rco => RCO, init => init, load => load, done => done );


   add_nsub  <= z_reg(width-1);
   nadd_sub  <= NOT(add_nsub);
   REGS_LOAD <= INIT or LOAD;
   sin       <= y_reg;
   cos       <= x_reg;


END rtl;
