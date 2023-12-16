LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY NewXREG IS
  PORT (
    clk      : IN STD_LOGIC;
    wren     : IN STD_LOGIC;
    rs1      : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    rs2      : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    rd       : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    data     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ro1      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    ro2      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END NewXREG;

ARCHITECTURE behavior OF NewXREG IS

  CONSTANT mem_depth : NATURAL := 32;
  TYPE mem_type IS ARRAY (0 TO mem_depth - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL registers : mem_type := (others => (others => '0'));
  SIGNAL address1_signal : INTEGER;
  SIGNAL address2_signal : INTEGER;
  SIGNAL write_address_signal : INTEGER;

BEGIN

  -- Convert addresses to integers
  address1_signal <= TO_INTEGER(UNSIGNED(rs1));
  address2_signal <= TO_INTEGER(UNSIGNED(rs2));
  write_address_signal <= TO_INTEGER(UNSIGNED(rd));

  -- Read data
  ro1 <= registers(address1_signal);
  ro2 <= registers(address2_signal);

  -- Write data process
  PROCESS (clk)
  BEGIN
    IF RISING_EDGE(clk) THEN
      IF wren = '1' AND write_address_signal >= 0 AND write_address_signal < mem_depth THEN
        registers(write_address_signal) <= data;
      END IF;
    END IF;
  END PROCESS;

END behavior;
