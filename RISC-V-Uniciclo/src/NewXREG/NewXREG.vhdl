LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;

ENTITY NewXREG IS
  PORT (
    clk   : IN STD_LOGIC;  -- Clock signal
    wren  : IN STD_LOGIC;  -- Write enable
    rs1   : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Source register 1
    rs2   : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Source register 2
    rd    : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Destination register
    data  : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data to write
    ro1   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- Read output 1
    ro2   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Read output 2
  );
END NewXREG;

ARCHITECTURE behavior OF NewXREG IS

  CONSTANT mem_depth : NATURAL := 32;
  CONSTANT mem_width : NATURAL := 32;
  TYPE mem_type IS ARRAY (0 TO mem_depth - 1) OF STD_LOGIC_VECTOR(mem_width - 1 DOWNTO 0);

  SIGNAL address1_signal, address2_signal, write_address_signal : INTEGER := 0;
  SIGNAL breg : mem_type := (x"00000000", others => (others => '0')); -- Register bank initialization

BEGIN

  -- Address conversion
  address1_signal <= TO_INTEGER(UNSIGNED(rs1));
  address2_signal <= TO_INTEGER(UNSIGNED(rs2));
  write_address_signal <= TO_INTEGER(UNSIGNED(rd));

  -- Read operations
  ro1 <= breg(address1_signal);
  ro2 <= breg(address2_signal);

  -- Write operation (synchronous)
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF (wren = '1') AND (write_address_signal /= 0) THEN
        breg(write_address_signal) <= data;
      END IF;
    END IF;
  END PROCESS;

END behavior;
