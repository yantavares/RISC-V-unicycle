LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY Mux_8_1 IS
  PORT (
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    C : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    E : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    F : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    G : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    H : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END Mux_8_1;

ARCHITECTURE bdf_type OF Mux_8_1 IS

BEGIN

  PROCESS (Sel, A, B, C, D, E, F, G, H)
  BEGIN
    IF Sel = "000" THEN
      Result <= A;
    ELSIF Sel = "001" THEN
      Result <= B;
    ELSIF Sel = "010" THEN
      Result <= C;
    ELSIF Sel = "011" THEN
      Result <= D;
    ELSIF Sel = "100" THEN
      Result <= E;
    ELSIF Sel = "101" THEN
      Result <= F;
    ELSIF Sel = "110" THEN
      Result <= G;
    ELSE
      Result <= H;
    END IF;
  END PROCESS;

END bdf_type;