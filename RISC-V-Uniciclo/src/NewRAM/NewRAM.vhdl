LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;  -- For numeric conversions
USE std.textio.all;       -- For file I/O operations

LIBRARY work;

ENTITY NewRAM IS
  PORT (
    clock    : IN STD_LOGIC;
    we       : IN STD_LOGIC;
    re       : IN STD_LOGIC;
    address  : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    datain   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    dataout  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0')
  );
END NewRAM;

ARCHITECTURE RTL OF NewRAM IS

  CONSTANT mem_depth : NATURAL := 4096;
  TYPE mem_type IS ARRAY (0 TO mem_depth - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL NewRAMSignal : mem_type;
  SIGNAL address_signal : INTEGER := 0;

  IMPURE FUNCTION init_NewRAM RETURN mem_type IS
    FILE text_file : TEXT OPEN READ_MODE IS "data.txt";
    VARIABLE text_line : LINE;
    VARIABLE mem_content : mem_type := (others => (others => '0'));
    VARIABLE mem_content_bit_vector : BIT_VECTOR(31 DOWNTO 0);
  BEGIN
    FOR i IN 0 TO mem_depth - 1 LOOP
      IF NOT ENDFILE(text_file) THEN
        READLINE(text_file, text_line);
        BREAD(text_line, mem_content_bit_vector);
        mem_content(i) := TO_STDLOGICVECTOR(mem_content_bit_vector);
      END IF;
    END LOOP;
    RETURN mem_content;
  END FUNCTION;

BEGIN

  -- Initialize memory data
  NewRAMSignal <= init_NewRAM;

  -- Convert address to integer
  address_signal <= TO_INTEGER(UNSIGNED(address)) / 4;

  -- Data read process
  PROCESS (clock)
  BEGIN
    IF RISING_EDGE(clock) THEN
      IF we = '1' THEN
        -- Write data to memory
        NewRAMSignal(address_signal) <= datain;
      ELSIF re = '1' THEN
        -- Read data from memory
        dataout <= NewRAMSignal(address_signal);
      ELSE
        dataout <= (others => '0');
      END IF;
    END IF;
  END PROCESS;

END RTL;
