LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE std.textio.all;

LIBRARY work;

ENTITY NewROM IS
  PORT (
    address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END NewROM;

ARCHITECTURE behavior OF NewROM IS

CONSTANT mem_depth : NATURAL := 4096;
CONSTANT mem_width : NATURAL := 32;
TYPE mem_type IS ARRAY (0 TO mem_depth - 1) OF STD_LOGIC_VECTOR(mem_width - 1 DOWNTO 0);

SIGNAL address_signal : INTEGER := 0;

IMPURE FUNCTION init_mem_instr RETURN mem_type IS
  FILE text_file : TEXT OPEN READ_MODE IS "code2.txt";
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

SIGNAL NewRomSignal : mem_type := init_mem_instr;

BEGIN

  address_signal <= TO_INTEGER(UNSIGNED(address)) / 4;
  dataout <= NewRomSignal(address_signal);

END behavior;