-- Library declaration
LIBRARY ieee;
USE ieee.std_logic_1164.all; -- Use standard logic package
USE ieee.numeric_std.all; -- Use numeric standard package


-- Entity declaration for the Adder
ENTITY Adder IS
  PORT (
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- 32-bit input A
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- 32-bit input B
    Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- 32-bit output Z
  );
END ENTITY Adder;

-- Architecture of the Adder
ARCHITECTURE behaviour OF Adder IS
BEGIN
  -- Add inputs A and B and assign the result to Z
  Z <= STD_LOGIC_VECTOR(UNSIGNED(A) + UNSIGNED(B));
END behaviour;
