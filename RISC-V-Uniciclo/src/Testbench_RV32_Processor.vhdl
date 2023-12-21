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
         clock : IN  std_logic;
         instruction : OUT  std_logic_vector(31 downto 0);
         rs1 : OUT  std_logic_vector(31 downto 0);
         rs2 : OUT  std_logic_vector(31 downto 0);
         rd : OUT  std_logic_vector(31 downto 0);
         immediate : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;

    -- End of simulation flag
    signal test_finished : boolean := false;
    
    --Inputs
    signal clock : std_logic := '1';

    --Outputs
    signal instruction : std_logic_vector(31 downto 0);
    signal rs1 : std_logic_vector(31 downto 0);
    signal rs2 : std_logic_vector(31 downto 0);
    signal rd : std_logic_vector(31 downto 0);
    signal immediate : std_logic_vector(31 downto 0);

    -- Clock period definition
    constant clock_period : time := 10 ns;

BEGIN 
    -- Instantiate the Unit Under Test (UUT)
    uut: RV32_Processor PORT MAP (
          clock => clock,
          instruction => instruction,
          rs1 => rs1,
          rs2 => rs2,
          rd => rd,
          immediate => immediate
        );

    -- Clock process
    clock_process: process
    begin
        wait for clock_period/2;
        while not test_finished loop
            clock <= '0';
            wait for clock_period/2;
            clock <= '1';
            wait for clock_period/2;
        end loop;
        wait;
    end process;
    
    -- Test stimulus process
    stimulus: process
    begin
        -- Add your test stimulus here
        -- For example, force some inputs and monitor the outputs
        -- wait for some time or clock cycles
        -- For now, let's just run it for some cycles and then stop

        wait for 2 * clock_period;  -- Wait for 100 clock cycles

        test_finished <= true;

        -- End of simulation
        wait;  -- will wait forever
    end process;

END behavior;
