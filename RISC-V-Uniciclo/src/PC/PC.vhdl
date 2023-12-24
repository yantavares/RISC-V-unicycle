LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;

ENTITY pc IS
  PORT (
    addr_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    rst : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000");
END ENTITY pc;

ARCHITECTURE bdf_type OF pc IS

BEGIN

  IF rst = '1' THEN
    addr_out <= x"00000000";
  ELSE
    addr_out <= addr_in;
  END IF;   

END bdf_type;