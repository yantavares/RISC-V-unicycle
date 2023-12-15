LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;  -- For numeric conversions
USE std.textio.ALL; -- For file I/O operations

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
    
    --Inputs
    signal clock : std_logic := '0';

    --End of simulation flag
    signal test_finished : boolean := false;

    --Outputs
    signal instruction : std_logic_vector(31 downto 0) := (others => '0');
    signal rs1 : std_logic_vector(31 downto 0) := (others => '0');
    signal rs2 : std_logic_vector(31 downto 0) := (others => '0');
    signal rd : std_logic_vector(31 downto 0) := (others => '0');
    signal immediate : std_logic_vector(31 downto 0) := (others => '0');

    -- Clock period definition
    constant clock_period : time := 10 ns;
    
    -- File reading variables
    file code_file : text open read_mode is "code.txt";
    file data_file : text open read_mode is "data.txt";

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
        while not test_finished loop
            clock <= '0';
            wait for clock_period/2;
            clock <= '1';
            wait for clock_period/2;
        end loop;
        wait;
    end process;
    
    stimulus: process
        variable my_line : line;
        variable instruction_string : string(1 to 32);
        variable data_string : string(1 to 32);
        variable instruction_value, data_value : std_logic_vector(31 downto 0);
    begin
        -- Read from code.txt and simulate
        while not endfile(code_file) loop
            readline(code_file, my_line);
            read(my_line, instruction_string);
            -- Convert string to std_logic_vector
            instruction_value := std_logic_vector'("00000000000000000000000000000000"); -- Reset to zeros
            for i in 1 to 32 loop
                if instruction_string(i) = '1' then
                    instruction_value(i-1) := '1';
                else
                    instruction_value(i-1) := '0';
                end if;
            end loop;
            instruction <= instruction_value;
            wait for clock_period; -- Wait for a clock cycle
        end loop;
    
        -- Read from data.txt and process
        while not endfile(data_file) loop
            readline(data_file, my_line);
            read(my_line, data_string);
            -- Convert string to std_logic_vector
            data_value := std_logic_vector'("00000000000000000000000000000000"); -- Reset to zeros
            for i in 1 to 32 loop
                if data_string(i) = '1' then
                    data_value(i-1) := '1';
                else
                    data_value(i-1) := '0';
                end if;
            end loop;
            -- Process the data read from data.txt
            -- This part will depend on how your processor handles data input
            -- For example, you might load it into a data memory component
            -- or use it as part of a test case
            wait for clock_period;
        end loop;
    
        -- Add additional logic here to verify the outputs of the processor
        -- after the instructions and data have been processed

        -- End of simulation
        test_finished <= true;
    
        wait; -- will wait forever
    end process;

END behavior;