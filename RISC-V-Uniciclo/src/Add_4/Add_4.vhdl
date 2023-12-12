-- Library declaration
LIBRARY ieee;
USE ieee.std_logic_1164.all; -- Use the standard logic package
USE ieee.numeric_std.all; -- Use the numeric standard package

-- Entity declaration for Add_4
ENTITY Add_4 IS
  PORT (
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- 32-bit input A
    Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- 32-bit output Z
  );
END ENTITY Add_4;

-- Architecture of Add_4
ARCHITECTURE bdf_type OF Add_4 IS
  SIGNAL A_signal : INTEGER; -- Signal to hold the integer value of A

BEGIN
  -- Convert A to integer, add 4, then convert back to std_logic_vector
  A_signal <= TO_INTEGER(UNSIGNED(A)) + 4;
  Z <= STD_LOGIC_VECTOR(TO_UNSIGNED(A_signal, Z'LENGTH));
END bdf_type;
