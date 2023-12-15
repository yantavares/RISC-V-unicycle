LIBRARY ieee;
USE ieee.std_logic_1164.all; -- Use standard logic package

-- Entity declaration for a 2-to-1, 32-bit multiplexer
ENTITY Mux_2_1
 IS
  PORT (
    Sel : IN STD_LOGIC; -- Select signal
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input A
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input B
    Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Output result
  );
END Mux_2_1
;

ARCHITECTURE behaviour OF Mux_2_1
 IS
BEGIN
  -- Process to determine the output based on the select signal
  PROCESS (Sel, A, B)
  BEGIN
    IF Sel = '0' THEN
      Result <= A; -- Output A if Sel is 0
    ELSE
      Result <= B; -- Output B otherwise
    END IF;
  END PROCESS;
END behaviour;
