LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Testbench_RV32_Processor IS
    -- Testbench has no ports.
END Testbench_RV32_Processor;

ARCHITECTURE behavior OF Testbench_RV32_Processor IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT RV32_Processor
    PORT(
         clock      : IN  std_logic;
         instruction: OUT std_logic_vector(31 downto 0);
         rs1        : OUT std_logic_vector(31 downto 0);
         rs2        : OUT std_logic_vector(31 downto 0);
         rd         : OUT std_logic_vector(31 downto 0);
         immediate  : OUT std_logic_vector(31 downto 0)
    );
    END COMPONENT;
    
    -- Inputs
    signal clock : std_logic := '0';

    -- End of simulation flag
    signal test_finished : boolean := false;

    -- Clock period definition
    constant clock_period : time := 10 ns;

BEGIN 
    -- Instantiate the Unit Under Test (UUT)
    uut: RV32_Processor PORT MAP (
          clock       => clock,
          instruction => open,  -- Not connected in this testbench
          rs1         => open,  -- Not connected in this testbench
          rs2         => open,  -- Not connected in this testbench
          rd          => open,  -- Not connected in this testbench
          immediate   => open   -- Not connected in this testbench
        );

    -- Clock process
    clock_process: process
    begin
        while not test_finished loop
            clock <= '0';
            wait for clock_period/2;
            clock <= '1';
            wait for clock_period/2;
        end loop;
        wait;
    end process;

    -- Testbench control process
    control_process: process
    begin
        -- Wait for a specific amount of time to simulate
        wait for 100 * clock_period;

        -- Set the flag to finish the simulation
        test_finished <= true;

        wait;

    end process;

END behavior;
