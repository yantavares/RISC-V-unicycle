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
ARCHITECTURE behaviour OF Add_4 IS
  SIGNAL A_signal : UNSIGNED(31 DOWNTO 0) := (others => '0'); -- Signal to hold the unsigned value of A

BEGIN
  -- Convert A to unsigned, add 4 with modular arithmetic, then convert back to std_logic_vector
  A_signal <= UNSIGNED(A) + TO_UNSIGNED(4, A'LENGTH);
  Z <= STD_LOGIC_VECTOR(A_signal);

END behaviour;