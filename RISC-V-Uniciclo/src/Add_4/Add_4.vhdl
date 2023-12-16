LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Add_4 IS
  PORT (
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END ENTITY Add_4;

ARCHITECTURE bdf_type OF Add_4 IS
BEGIN
  -- Process to add 4 to A and assign to Z
  PROCESS(A)
  BEGIN
    -- Convert A to UNSIGNED, add 4, and assign to Z
    -- Using UNSIGNED arithmetic ensures that the result wraps around at 2^32
    Z <= STD_LOGIC_VECTOR(UNSIGNED(A) + TO_UNSIGNED(4, A'LENGTH));
  END PROCESS;
END bdf_type;
