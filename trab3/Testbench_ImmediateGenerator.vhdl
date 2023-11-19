-- Testbench_ImmediateGenerator.vhdl
-- This file contains the testbench for the ImmediateGenerator.
-- It tests various instruction types and prints the results in hexadecimal form.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Testbench_ImmediateGenerator is
end entity;

architecture Behavior of Testbench_ImmediateGenerator is
    component ImmediateGenerator
        port (
            instruction : in  std_logic_vector(31 downto 0);
            immediate   : out signed(31 downto 0)
        );
    end component;

    -- Test signals
    signal test_instruction : std_logic_vector(31 downto 0);
    signal test_immediate   : signed(31 downto 0);

begin
    -- Instance of ImmediateGenerator
    uut: ImmediateGenerator port map (instruction => test_instruction, immediate => test_immediate);

    -- Testbench process
    test_process: process
    begin
        -- Test case 1
        test_instruction <= X"000002B3"; wait for 10 ns;
        report "Test Case 1: Immediate = " & to_hstring(test_immediate);

        -- Test case 2
        test_instruction <= X"01002283"; wait for 10 ns;
        report "Test Case 2: Immediate = " & to_hstring(test_immediate);

        -- Test case 3
        test_instruction <= X"F9C00313"; wait for 10 ns;
        report "Test Case 3: Immediate = " & to_hstring(test_immediate);

        -- Test case 4
        test_instruction <= X"FFF2C293"; wait for 10 ns;
        report "Test Case 4: Immediate = " & to_hstring(test_immediate);

        -- Test case 5
        test_instruction <= X"16200313"; wait for 10 ns;
        report "Test Case 5: Immediate = " & to_hstring(test_immediate);

        -- Test case 6
        test_instruction <= X"01800067"; wait for 10 ns;
        report "Test Case 6: Immediate = " & to_hstring(test_immediate);

        -- Test case 7
        test_instruction <= X"00002437"; wait for 10 ns;
        report "Test Case 7: Immediate = " & to_hstring(test_immediate);

        -- Test case 8
        test_instruction <= X"02542E23"; wait for 10 ns;
        report "Test Case 8: Immediate = " & to_hstring(test_immediate);

        -- Test case 9
        test_instruction <= X"FE5290E3"; wait for 10 ns;
        report "Test Case 9: Immediate = " & to_hstring(test_immediate);

        -- Test case 10
        test_instruction <= X"00C000EF"; wait for 10 ns;
        report "Test Case 10: Immediate = " & to_hstring(test_immediate);

        wait; -- Terminate the process
    end process;
end Behavior;
