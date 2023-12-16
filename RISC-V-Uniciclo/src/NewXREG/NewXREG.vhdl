LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY NewXREG IS
  PORT (
    clk : IN STD_LOGIC;
    wren : IN STD_LOGIC;
    rs1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    rs2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ro1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    ro2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END NewXREG;

ARCHITECTURE bdf_type OF NewXREG IS

CONSTANT mem_depth : NATURAL := 32;
CONSTANT mem_width : NATURAL := 32;
TYPE mem_type IS ARRAY (0 TO mem_depth - 1)
    OF STD_LOGIC_VECTOR(mem_width - 1 DOWNTO 0);

SIGNAL address1_signal : INTEGER := 0;
SIGNAL address2_signal : INTEGER := 0;
SIGNAL write_address_signal : INTEGER := 0;

SIGNAL breg : mem_type := (x"00000000",
                           others => (others => '0'));

BEGIN

  address1_signal <= TO_INTEGER(UNSIGNED(rs1));
  address2_signal <= TO_INTEGER(UNSIGNED(rs2));
  write_address_signal <= TO_INTEGER(UNSIGNED(rd));
  ro1 <= breg(address1_signal);
  ro2 <= breg(address2_signal);

  PROCESS (clk, wren, write_address_signal)
  BEGIN
    IF RISING_EDGE(clk) AND (wren = '1') AND (write_address_signal /= 0) THEN
      breg(write_address_signal) <= data;
    END IF;
  END PROCESS;

END bdf_type;