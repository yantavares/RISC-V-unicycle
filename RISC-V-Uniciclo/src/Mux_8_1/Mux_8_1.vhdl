LIBRARY ieee;
USE ieee.std_logic_1164.all; -- Use the standard logic package

-- Entity declaration for an 8-to-1, 32-bit multiplexer
ENTITY Mux_8_1 IS
  PORT (
    A, B, C, D, E, F, G, H : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- 32-bit inputs
    Sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3-bit select signal
    Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- 32-bit output result
  );
END Mux_8_1;

ARCHITECTURE behaviour OF Mux_8_1 IS
BEGIN
  -- Process to determine the output based on the select signal
  PROCESS (Sel, A, B, C, D, E, F, G, H)
  BEGIN
    CASE Sel IS
      WHEN "000" => Result <= A;
      WHEN "001" => Result <= B;
      WHEN "010" => Result <= C;
      WHEN "011" => Result <= D;
      WHEN "100" => Result <= E;
      WHEN "101" => Result <= F;
      WHEN "110" => Result <= G;
      WHEN OTHERS => Result <= H;
    END CASE;
  END PROCESS;
END behaviour;
