LIBRARY ieee;
USE ieee.std_logic_1164.all; -- Use standard logic package
USE ieee.numeric_std.all; -- Use numeric standard package

-- Entity declaration for the program counter
ENTITY PC IS
  PORT (
    addr_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input address
    rst : IN STD_LOGIC; -- Reset signal
    clk : IN STD_LOGIC; -- Clock signal
    addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000" -- Output address, initialized to 0
  );
END ENTITY PC;

ARCHITECTURE behaviour OF PC IS
BEGIN
  -- Process triggered by the clock signal
  PROCESS(clk)
  BEGIN
    IF RISING_EDGE(clk) THEN -- Check for the rising edge of the clock
      IF rst = '1' THEN
        addr_out <= x"00000000"; -- Reset address to 0 if reset signal is high
      ELSE
        addr_out <= addr_in; -- Update address to the input address
      END IF;
    END IF;
  END PROCESS;
END behaviour;
