LIBRARY ieee;
USE ieee.numeric_std.all; -- Use numeric standard package
USE ieee.std_logic_1164.all; -- Use standard logic package

-- Entity declaration for memory register block
ENTITY Reg_Memory IS
  PORT (
    clock : IN STD_LOGIC; -- Clock signal
    we : IN STD_LOGIC; -- Write enable signal
    address1x : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Address for reading data1
    address2x : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Address for reading data2
    write_address : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Address for writing data
    data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data input for writing
    data1_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data output 1
    data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Data output 2
  );
END Reg_Memory;

ARCHITECTURE bdf_type OF Reg_Memory IS

  CONSTANT mem_depth : NATURAL := 32; -- Memory depth
  CONSTANT mem_width : NATURAL := 32; -- Memory width
  TYPE mem_type IS ARRAY (0 TO mem_depth - 1) -- Memory array type
    OF STD_LOGIC_VECTOR(mem_width - 1 DOWNTO 0);

  SIGNAL address1_signal : INTEGER := 0;
  SIGNAL address2_signal : INTEGER := 0;
  SIGNAL write_address_signal : INTEGER := 0;

  -- Initialize memory with zeros
  SIGNAL breg : mem_type := (x"00000000", others => (others => '0'));

BEGIN

  -- Convert addresses from STD_LOGIC_VECTOR to INTEGER
  address1_signal <= TO_INTEGER(UNSIGNED(address1x));
  address2_signal <= TO_INTEGER(UNSIGNED(address2x));
  write_address_signal <= TO_INTEGER(UNSIGNED(write_address));

  -- Read data from memory
  data1_out <= breg(address1_signal);
  data2_out <= breg(address2_signal);

  -- Memory write process
  PROCESS (clock, we, write_address_signal)
  BEGIN
    IF RISING_EDGE(clock) AND (we = '1') AND (write_address_signal /= 0) THEN
      breg(write_address_signal) <= data_in; -- Write data to memory
    END IF;
  END PROCESS;

END bdf_type;
