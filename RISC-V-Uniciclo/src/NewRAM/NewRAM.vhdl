LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE std.textio.all;

LIBRARY work;

ENTITY NewRAM IS
  PORT (
    clock : IN STD_LOGIC;
    we : IN STD_LOGIC;
    re : IN STD_LOGIC;
    address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END NewRAM;

ARCHITECTURE behavior OF NewRAM IS

CONSTANT mem_depth : INTEGER := 4096;
CONSTANT mem_width : INTEGER := 32;
TYPE mem_type IS ARRAY (0 TO mem_depth - 1)
    OF STD_LOGIC_VECTOR(mem_width - 1 DOWNTO 0);

SIGNAL address_signal : INTEGER := 0;

IMPURE FUNCTION init_mem_data RETURN mem_type IS
  FILE text_file : TEXT OPEN READ_MODE IS "data.txt";
  VARIABLE text_line : LINE;
  VARIABLE mem_content : mem_type;
  VARIABLE mem_content_bit_vector : BIT_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  BEGIN
    FOR i IN 0 TO mem_depth - 1 LOOP
      IF (NOT ENDFILE(text_file)) THEN
        READLINE(text_file, text_line);
        BREAD(text_line, mem_content_bit_vector);
        mem_content(i) := TO_STDLOGICVECTOR(mem_content_bit_vector);
      END IF;
    END LOOP;
    RETURN mem_content;
END FUNCTION;

SIGNAL NewRAMSignal : mem_type := init_mem_data;

BEGIN

  address_signal <= (TO_INTEGER(UNSIGNED(address)) / 4);

  dataout <= NewRAMSignal(address_signal) WHEN re = '1' ELSE x"00000000";

  PROCESS (clock)
  BEGIN
    IF RISING_EDGE(clock) THEN
      IF we = '1' THEN
        NewRAMSignal(address_signal) <= datain;
      END IF;
    END IF;
  END PROCESS;

END behavior;