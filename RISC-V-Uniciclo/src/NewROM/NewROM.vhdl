LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

ENTITY NewROM IS
  PORT (
    address  : IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
    data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END NewROM;

ARCHITECTURE bdf_type OF NewROM IS

  CONSTANT mem_depth : NATURAL := 4096;
  TYPE mem_type IS ARRAY (0 TO mem_depth - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL rom_memory : mem_type := (others => (others => '0'));

  FUNCTION string_to_std_logic_vector(str : STRING) RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(str'LENGTH-1 DOWNTO 0);
  BEGIN
    FOR i IN 1 TO str'LENGTH LOOP
      IF str(i) = '1' THEN
        result(i-1) := '1';
      ELSE
        result(i-1) := '0';
      END IF;
    END LOOP;
    RETURN result;
  END FUNCTION;

  IMPURE FUNCTION init_mem_data RETURN mem_type IS
    FILE text_file : TEXT OPEN READ_MODE IS "code.txt";
    VARIABLE line_value : LINE;
    VARIABLE bit_string : STRING(1 TO 32);
    VARIABLE mem_content : mem_type := (others => (others => '0'));
  BEGIN
    FOR i IN 0 TO mem_depth - 1 LOOP
      IF NOT ENDFILE(text_file) THEN
        READLINE(text_file, line_value);
        READ(line_value, bit_string);
        mem_content(i) := string_to_std_logic_vector(bit_string);
      ELSE
        EXIT;
      END IF;
    END LOOP;
    RETURN mem_content;
  END FUNCTION;

BEGIN

  rom_memory <= init_mem_data;

  PROCESS(address)
  BEGIN
    data_out <= rom_memory(TO_INTEGER(UNSIGNED(address)) / 4);
  END PROCESS;

END bdf_type;
