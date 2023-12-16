LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY Mux_2_5bits IS
  PORT (
    Sel : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    Result : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
END Mux_2_5bits;

ARCHITECTURE bdf_type OF Mux_2_5bits IS

BEGIN

  PROCESS (Sel, A, B)
  BEGIN
    IF Sel = '0' THEN
      Result <= A;
    ELSE
      Result <= B;
    END IF;
  END PROCESS;

END bdf_type;